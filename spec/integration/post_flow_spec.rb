# 投稿関連の統合フロー
RSpec.describe 'Post Flow', type: :system do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let(:user_c) { create(:user) }

  describe '投稿からコメント、通知までのフロー' do
    it '投稿、コメント、通知の一連の流れが正常に動作すること' do
      # ユーザーAがログインして投稿を作成
      sign_in user_a
      visit new_post_path
      fill_in 'タイトル', with: 'テスト投稿'
      fill_in '内容', with: 'テスト内容です'
      select '質問', from: 'カテゴリー'
      click_button '投稿する'

      expect(page).to have_content('投稿を作成しました')
      expect(page).to have_content('テスト投稿')
      expect(page).to have_content('テスト内容です')

      # ユーザーAがログアウト
      click_link 'ログアウト'

      # ユーザーBがログインしてコメントを投稿
      sign_in user_b
      visit posts_path
      click_link 'テスト投稿'
      fill_in 'コメント', with: 'テストコメント'
      click_button 'コメントを投稿'

      expect(page).to have_content('コメントを投稿しました')
      expect(page).to have_content('テストコメント')
      expect(page).to have_content(user_b.name)

      # ユーザーBがログアウト
      click_link 'ログアウト'

      # ユーザーAが通知を確認
      sign_in user_a
      visit notifications_path
      expect(page).to have_content('新しいコメントが投稿されました')
      expect(page).to have_content('テスト投稿')

      # ユーザーAが通知を既読にする
      click_link '既読にする'
      expect(page).to have_content('通知を既読にしました')
    end
  end

  describe '投稿の編集と削除のフロー' do
    let!(:post) { create(:post, user: user_a) }

    it '投稿の編集と削除が正常に動作すること' do
      # ユーザーAがログインして投稿を編集
      sign_in user_a
      visit post_path(post)
      click_link '編集'
      fill_in 'タイトル', with: '更新後のタイトル'
      fill_in '内容', with: '更新後の内容'
      click_button '更新する'

      expect(page).to have_content('投稿を更新しました')
      expect(page).to have_content('更新後のタイトル')
      expect(page).to have_content('更新後の内容')

      # ユーザーAがログアウト
      click_link 'ログアウト'

      # ユーザーBがログインして投稿を編集しようとする
      sign_in user_b
      visit post_path(post)
      expect(page).not_to have_link('編集')
      expect(page).not_to have_button('削除')

      # ユーザーBがログアウト
      click_link 'ログアウト'

      # ユーザーAがログインして投稿を削除
      sign_in user_a
      visit post_path(post)
      expect {
        click_button '削除'
      }.to change(Post, :count).by(-1)

      expect(page).to have_content('投稿を削除しました')
      expect(page).to have_current_path(posts_path)
    end
  end

  describe '投稿への複数ユーザーによるコメントのフロー' do
    let!(:post) { create(:post, user: user_a) }

    it '複数ユーザーによるコメントの投稿と通知が正常に動作すること' do
      # ユーザーBがログインしてコメントを投稿
      sign_in user_b
      visit post_path(post)
      fill_in 'コメント', with: 'ユーザーBからのコメント'
      click_button 'コメントを投稿'

      # ユーザーBがログアウト
      click_link 'ログアウト'

      # ユーザーCがログインしてコメントを投稿
      sign_in user_c
      visit post_path(post)
      fill_in 'コメント', with: 'ユーザーCからのコメント'
      click_button 'コメントを投稿'

      # ユーザーCがログアウト
      click_link 'ログアウト'

      # ユーザーAがログインして通知を確認
      sign_in user_a
      visit notifications_path
      expect(page).to have_content('新しいコメントが投稿されました')
      expect(page).to have_content('ユーザーBからのコメント')
      expect(page).to have_content('ユーザーCからのコメント')

      # ユーザーAが投稿詳細を確認
      visit post_path(post)
      expect(page).to have_content('ユーザーBからのコメント')
      expect(page).to have_content('ユーザーCからのコメント')
    end
  end
end
