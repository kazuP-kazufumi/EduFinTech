# プロフィール機能のシステムテスト
RSpec.describe 'Profiles', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  # プロフィール表示のテスト
  describe 'プロフィール表示' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit profile_path(user)
      end

      it 'プロフィール情報が表示されること' do
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.email)
        expect(page).to have_content(user.profile)
      end

      it 'ユーザーの投稿一覧が表示されること' do
        user.posts.each do |post|
          expect(page).to have_content(post.title)
          expect(page).to have_content(post.content)
        end
      end

      it 'ユーザーのコメント一覧が表示されること' do
        user.comments.each do |comment|
          expect(page).to have_content(comment.content)
          expect(page).to have_content(comment.post.title)
        end
      end

      context '自分のプロフィールの場合' do
        it '編集ボタンが表示されること' do
          expect(page).to have_link('プロフィールを編集', href: edit_profile_path)
        end
      end

      context '他のユーザーのプロフィールの場合' do
        before { visit profile_path(other_user) }

        it '編集ボタンが表示されないこと' do
          expect(page).not_to have_link('プロフィールを編集')
        end
      end
    end

    context 'ログインしていない場合' do
      it 'プロフィール情報が表示されること' do
        visit profile_path(user)
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.email)
        expect(page).to have_content(user.profile)
      end

      it '編集ボタンが表示されないこと' do
        expect(page).not_to have_link('プロフィールを編集')
      end
    end
  end

  # プロフィール編集のテスト
  describe 'プロフィール編集' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit edit_profile_path
      end

      context '有効な情報で更新する場合' do
        it 'プロフィールが更新されること' do
          fill_in '名前', with: '更新後の名前'
          fill_in 'プロフィール', with: '更新後のプロフィール'

          click_button '更新する'

          expect(page).to have_content('プロフィールを更新しました')
          expect(page).to have_content('更新後の名前')
          expect(page).to have_content('更新後のプロフィール')
        end

        it 'アバター画像をアップロードできること' do
          attach_file 'アバター', Rails.root.join('spec', 'fixtures', 'files', 'test_avatar.jpg')

          click_button '更新する'

          expect(page).to have_content('プロフィールを更新しました')
          expect(page).to have_selector('img.avatar')
        end
      end

      context '無効な情報で更新する場合' do
        it 'バリデーションエラーが表示されること' do
          fill_in '名前', with: ''
          fill_in 'プロフィール', with: ''

          click_button '更新する'

          expect(page).to have_content('エラーが発生したため ユーザー は保存されませんでした')
          expect(page).to have_content('名前を入力してください')
        end
      end

      context 'パスワードを変更する場合' do
        it 'パスワードが更新されること' do
          fill_in '現在のパスワード', with: user.password
          fill_in '新しいパスワード', with: 'new_password123'
          fill_in '新しいパスワード（確認）', with: 'new_password123'

          click_button '更新する'

          expect(page).to have_content('プロフィールを更新しました')

          # 新しいパスワードでログインできることを確認
          click_link 'ログアウト'
          visit new_user_session_path
          fill_in 'メールアドレス', with: user.email
          fill_in 'パスワード', with: 'new_password123'
          click_button 'ログイン'
          expect(page).to have_content('ログインしました')
        end

        it '現在のパスワードが間違っている場合エラーが表示されること' do
          fill_in '現在のパスワード', with: 'wrong_password'
          fill_in '新しいパスワード', with: 'new_password123'
          fill_in '新しいパスワード（確認）', with: 'new_password123'

          click_button '更新する'

          expect(page).to have_content('現在のパスワードが正しくありません')
        end

        it '新しいパスワードが一致しない場合エラーが表示されること' do
          fill_in '現在のパスワード', with: user.password
          fill_in '新しいパスワード', with: 'new_password123'
          fill_in '新しいパスワード（確認）', with: 'different_password'

          click_button '更新する'

          expect(page).to have_content('パスワード（確認）とパスワードの入力が一致しません')
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit edit_profile_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end
end
