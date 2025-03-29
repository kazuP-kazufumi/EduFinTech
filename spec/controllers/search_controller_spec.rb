# SearchControllerのテスト
RSpec.describe SearchController, type: :controller do
  # 認証・認可のテスト
  describe '認証・認可' do
    context '未ログインユーザーの場合' do
      it '検索ページにアクセスできないこと' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインユーザーの場合' do
      before do
        sign_in_test_user
      end

      it '検索ページにアクセスできること' do
        get :index
        expect(response).to be_successful
      end
    end
  end

  # アクションのテスト
  describe 'GET #index' do
    before do
      sign_in_test_user
      @posts = create_list(:post, 3)
      @users = create_list(:user, 2)
    end

    context '検索クエリが空の場合' do
      it '検索結果を表示しないこと' do
        get :index
        expect(assigns(:posts)).to be_empty
        expect(assigns(:users)).to be_empty
      end

      it 'indexテンプレートをレンダリングすること' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context '投稿の検索' do
      it 'タイトルで検索できること' do
        post1 = create(:post, title: 'テスト投稿1')
        post2 = create(:post, title: '別の投稿')
        get :index, params: { q: 'テスト' }
        expect(assigns(:posts)).to include(post1)
        expect(assigns(:posts)).not_to include(post2)
      end

      it '本文で検索できること' do
        post1 = create(:post, content: 'テスト内容1')
        post2 = create(:post, content: '別の内容')
        get :index, params: { q: 'テスト' }
        expect(assigns(:posts)).to include(post1)
        expect(assigns(:posts)).not_to include(post2)
      end

      it 'カテゴリーで検索できること' do
        post1 = create(:post, category: '進学')
        post2 = create(:post, category: '夢')
        get :index, params: { q: '進学' }
        expect(assigns(:posts)).to include(post1)
        expect(assigns(:posts)).not_to include(post2)
      end
    end

    context 'ユーザーの検索' do
      it '名前で検索できること' do
        user1 = create(:user, name: 'テストユーザー1')
        user2 = create(:user, name: '別のユーザー')
        get :index, params: { q: 'テスト' }
        expect(assigns(:users)).to include(user1)
        expect(assigns(:users)).not_to include(user2)
      end

      it 'メールアドレスで検索できること' do
        user1 = create(:user, email: 'test1@example.com')
        user2 = create(:user, email: 'other@example.com')
        get :index, params: { q: 'test1' }
        expect(assigns(:users)).to include(user1)
        expect(assigns(:users)).not_to include(user2)
      end
    end

    context '検索結果の表示' do
      it '検索結果を新しい順に表示すること' do
        old_post = create(:post, title: 'テスト投稿', created_at: 1.day.ago)
        new_post = create(:post, title: 'テスト投稿', created_at: 1.hour.ago)
        get :index, params: { q: 'テスト' }
        expect(assigns(:posts)).to eq([new_post, old_post])
      end

      it '検索結果が存在しない場合のメッセージを表示すること' do
        get :index, params: { q: '存在しないキーワード' }
        expect(flash[:notice]).to eq('検索結果が見つかりませんでした')
      end
    end

    context '検索オプション' do
      it '投稿のみを検索できること' do
        post = create(:post, title: 'テスト投稿')
        user = create(:user, name: 'テストユーザー')
        get :index, params: { q: 'テスト', type: 'posts' }
        expect(assigns(:posts)).to include(post)
        expect(assigns(:users)).to be_empty
      end

      it 'ユーザーのみを検索できること' do
        post = create(:post, title: 'テスト投稿')
        user = create(:user, name: 'テストユーザー')
        get :index, params: { q: 'テスト', type: 'users' }
        expect(assigns(:posts)).to be_empty
        expect(assigns(:users)).to include(user)
      end
    end
  end
end 