# 投稿管理フローのシステムテスト
RSpec.describe 'Posts', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  # 投稿一覧のテスト
  describe '投稿一覧' do
    let!(:posts) { create_list(:post, 5, user: user) }

    context 'ログインしている場合' do
      before do
        sign_in user
        visit posts_path
      end

      it '投稿一覧が表示されること' do
        posts.each do |post|
          expect(page).to have_content(post.title)
          expect(page).to have_content(post.content)
          expect(page).to have_content(post.user.name)
        end
      end

      it '新規投稿ボタンが表示されること' do
        expect(page).to have_link('新規投稿', href: new_post_path)
      end
    end

    context 'ログインしていない場合' do
      before { visit posts_path }

      it '投稿一覧が表示されること' do
        posts.each do |post|
          expect(page).to have_content(post.title)
          expect(page).to have_content(post.content)
          expect(page).to have_content(post.user.name)
        end
      end

      it '新規投稿ボタンが表示されないこと' do
        expect(page).not_to have_link('新規投稿')
      end
    end
  end

  # 投稿詳細のテスト
  describe '投稿詳細' do
    let(:post) { create(:post, user: user) }
    let!(:comments) { create_list(:comment, 3, post: post) }

    context 'ログインしている場合' do
      before do
        sign_in user
        visit post_path(post)
      end

      it '投稿の詳細が表示されること' do
        expect(page).to have_content(post.title)
        expect(page).to have_content(post.content)
        expect(page).to have_content(post.user.name)
      end

      it 'コメント一覧が表示されること' do
        comments.each do |comment|
          expect(page).to have_content(comment.content)
          expect(page).to have_content(comment.user.name)
        end
      end

      it 'コメントフォームが表示されること' do
        expect(page).to have_selector('form')
      end

      context '自分の投稿の場合' do
        it '編集・削除ボタンが表示されること' do
          expect(page).to have_link('編集', href: edit_post_path(post))
          expect(page).to have_button('削除')
        end
      end

      context '他のユーザーの投稿の場合' do
        let(:post) { create(:post, user: other_user) }

        it '編集・削除ボタンが表示されないこと' do
          expect(page).not_to have_link('編集')
          expect(page).not_to have_button('削除')
        end
      end
    end

    context 'ログインしていない場合' do
      before { visit post_path(post) }

      it '投稿の詳細が表示されること' do
        expect(page).to have_content(post.title)
        expect(page).to have_content(post.content)
        expect(page).to have_content(post.user.name)
      end

      it 'コメント一覧が表示されること' do
        comments.each do |comment|
          expect(page).to have_content(comment.content)
          expect(page).to have_content(comment.user.name)
        end
      end

      it 'コメントフォームが表示されないこと' do
        expect(page).not_to have_selector('form')
      end

      it '編集・削除ボタンが表示されないこと' do
        expect(page).not_to have_link('編集')
        expect(page).not_to have_button('削除')
      end
    end
  end

  # 投稿作成のテスト
  describe '投稿作成' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit new_post_path
      end

      context '有効な情報で投稿する場合' do
        it '投稿が作成されること' do
          fill_in 'タイトル', with: 'テスト投稿'
          fill_in '内容', with: 'テスト内容'
          select '質問', from: 'カテゴリー'

          expect {
            click_button '投稿する'
          }.to change(Post, :count).by(1)

          expect(page).to have_content('投稿を作成しました')
          expect(page).to have_current_path(post_path(Post.last))
        end
      end

      context '無効な情報で投稿する場合' do
        it 'バリデーションエラーが表示されること' do
          fill_in 'タイトル', with: ''
          fill_in '内容', with: ''
          select '質問', from: 'カテゴリー'

          click_button '投稿する'

          expect(page).to have_content('エラーが発生したため 投稿 は保存されませんでした')
          expect(page).to have_content('タイトルを入力してください')
          expect(page).to have_content('内容を入力してください')
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit new_post_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  # 投稿編集のテスト
  describe '投稿編集' do
    let(:post) { create(:post, user: user) }

    context 'ログインしている場合' do
      context '自分の投稿の場合' do
        before do
          sign_in user
          visit edit_post_path(post)
        end

        it '投稿が更新されること' do
          fill_in 'タイトル', with: '更新後のタイトル'
          fill_in '内容', with: '更新後の内容'
          select '情報', from: 'カテゴリー'

          click_button '更新する'

          expect(page).to have_content('投稿を更新しました')
          expect(page).to have_content('更新後のタイトル')
          expect(page).to have_content('更新後の内容')
          expect(page).to have_content('情報')
        end

        it '無効な情報で更新するとエラーが表示されること' do
          fill_in 'タイトル', with: ''
          fill_in '内容', with: ''

          click_button '更新する'

          expect(page).to have_content('エラーが発生したため 投稿 は保存されませんでした')
          expect(page).to have_content('タイトルを入力してください')
          expect(page).to have_content('内容を入力してください')
        end
      end

      context '他のユーザーの投稿の場合' do
        let(:post) { create(:post, user: other_user) }

        it '編集ページにアクセスできないこと' do
          sign_in user
          visit edit_post_path(post)
          expect(page).to have_current_path(root_path)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit edit_post_path(post)
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  # 投稿削除のテスト
  describe '投稿削除' do
    let!(:post) { create(:post, user: user) }

    context 'ログインしている場合' do
      context '自分の投稿の場合' do
        before do
          sign_in user
          visit post_path(post)
        end

        it '投稿が削除されること' do
          expect {
            click_button '削除'
          }.to change(Post, :count).by(-1)

          expect(page).to have_content('投稿を削除しました')
          expect(page).to have_current_path(posts_path)
        end
      end

      context '他のユーザーの投稿の場合' do
        let!(:post) { create(:post, user: other_user) }

        it '削除ボタンが表示されないこと' do
          sign_in user
          visit post_path(post)
          expect(page).not_to have_button('削除')
        end
      end
    end

    context 'ログインしていない場合' do
      it '削除ボタンが表示されないこと' do
        visit post_path(post)
        expect(page).not_to have_button('削除')
      end
    end
  end
end 