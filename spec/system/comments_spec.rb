# コメント機能のシステムテスト
RSpec.describe 'Comments', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post) { create(:post, user: other_user) }

  # コメント作成のテスト
  describe 'コメント作成' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit post_path(post)
      end

      context '有効な情報でコメントを投稿する場合' do
        it 'コメントが作成されること' do
          fill_in 'コメント', with: 'テストコメント'

          expect {
            click_button 'コメントを投稿'
          }.to change(Comment, :count).by(1)

          expect(page).to have_content('コメントを投稿しました')
          expect(page).to have_content('テストコメント')
          expect(page).to have_content(user.name)
        end
      end

      context '無効な情報でコメントを投稿する場合' do
        it 'バリデーションエラーが表示されること' do
          fill_in 'コメント', with: ''

          click_button 'コメントを投稿'

          expect(page).to have_content('エラーが発生したため コメント は保存されませんでした')
          expect(page).to have_content('コメントを入力してください')
        end
      end
    end

    context 'ログインしていない場合' do
      before { visit post_path(post) }

      it 'コメントフォームが表示されないこと' do
        expect(page).not_to have_selector('form')
      end
    end
  end

  # コメント編集のテスト
  describe 'コメント編集' do
    let!(:comment) { create(:comment, user: user, post: post) }

    context 'ログインしている場合' do
      context '自分のコメントの場合' do
        before do
          sign_in user
          visit post_path(post)
        end

        it 'コメントが更新されること' do
          click_link '編集'
          fill_in 'コメント', with: '更新後のコメント'
          click_button '更新する'

          expect(page).to have_content('コメントを更新しました')
          expect(page).to have_content('更新後のコメント')
        end

        it '無効な情報で更新するとエラーが表示されること' do
          click_link '編集'
          fill_in 'コメント', with: ''
          click_button '更新する'

          expect(page).to have_content('エラーが発生したため コメント は保存されませんでした')
          expect(page).to have_content('コメントを入力してください')
        end
      end

      context '他のユーザーのコメントの場合' do
        let!(:comment) { create(:comment, user: other_user, post: post) }

        it '編集リンクが表示されないこと' do
          sign_in user
          visit post_path(post)
          expect(page).not_to have_link('編集')
        end
      end
    end

    context 'ログインしていない場合' do
      before { visit post_path(post) }

      it '編集リンクが表示されないこと' do
        expect(page).not_to have_link('編集')
      end
    end
  end

  # コメント削除のテスト
  describe 'コメント削除' do
    let!(:comment) { create(:comment, user: user, post: post) }

    context 'ログインしている場合' do
      context '自分のコメントの場合' do
        before do
          sign_in user
          visit post_path(post)
        end

        it 'コメントが削除されること' do
          expect {
            click_button '削除'
          }.to change(Comment, :count).by(-1)

          expect(page).to have_content('コメントを削除しました')
          expect(page).not_to have_content(comment.content)
        end
      end

      context '他のユーザーのコメントの場合' do
        let!(:comment) { create(:comment, user: other_user, post: post) }

        it '削除ボタンが表示されないこと' do
          sign_in user
          visit post_path(post)
          expect(page).not_to have_button('削除')
        end
      end
    end

    context 'ログインしていない場合' do
      before { visit post_path(post) }

      it '削除ボタンが表示されないこと' do
        expect(page).not_to have_button('削除')
      end
    end
  end

  # コメント一覧のテスト
  describe 'コメント一覧' do
    let!(:comments) { create_list(:comment, 5, post: post) }

    context 'ログインしている場合' do
      before do
        sign_in user
        visit post_path(post)
      end

      it 'コメント一覧が表示されること' do
        comments.each do |comment|
          expect(page).to have_content(comment.content)
          expect(page).to have_content(comment.user.name)
        end
      end

      context '自分のコメントの場合' do
        let!(:my_comment) { create(:comment, user: user, post: post) }

        it '編集・削除ボタンが表示されること' do
          expect(page).to have_link('編集')
          expect(page).to have_button('削除')
        end
      end

      context '他のユーザーのコメントの場合' do
        it '編集・削除ボタンが表示されないこと' do
          expect(page).not_to have_link('編集')
          expect(page).not_to have_button('削除')
        end
      end
    end

    context 'ログインしていない場合' do
      before { visit post_path(post) }

      it 'コメント一覧が表示されること' do
        comments.each do |comment|
          expect(page).to have_content(comment.content)
          expect(page).to have_content(comment.user.name)
        end
      end

      it '編集・削除ボタンが表示されないこと' do
        expect(page).not_to have_link('編集')
        expect(page).not_to have_button('削除')
      end
    end
  end
end 