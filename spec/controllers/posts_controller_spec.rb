# PostsControllerのテスト
RSpec.describe PostsController, type: :controller do
  # 認証・認可のテスト
  describe '認証・認可' do
    context '未ログインユーザーの場合' do
      it '一覧ページにアクセスできないこと' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end

      it '詳細ページにアクセスできないこと' do
        post = create(:post)
        get :show, params: { id: post.id }
        expect(response).to redirect_to(new_user_session_path)
      end

      it '新規作成ページにアクセスできないこと' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end

      it '投稿を作成できないこと' do
        post :create, params: { post: attributes_for(:post) }
        expect(response).to redirect_to(new_user_session_path)
      end

      it '編集ページにアクセスできないこと' do
        post = create(:post)
        get :edit, params: { id: post.id }
        expect(response).to redirect_to(new_user_session_path)
      end

      it '投稿を更新できないこと' do
        post = create(:post)
        patch :update, params: { id: post.id, post: attributes_for(:post) }
        expect(response).to redirect_to(new_user_session_path)
      end

      it '投稿を削除できないこと' do
        post = create(:post)
        delete :destroy, params: { id: post.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインユーザーの場合' do
      before do
        sign_in_test_user
      end

      it '一覧ページにアクセスできること' do
        get :index
        expect(response).to be_successful
      end

      it '詳細ページにアクセスできること' do
        post = create(:post)
        get :show, params: { id: post.id }
        expect(response).to be_successful
      end

      it '新規作成ページにアクセスできること' do
        get :new
        expect(response).to be_successful
      end

      it '投稿を作成できること' do
        expect {
          post :create, params: { post: attributes_for(:post) }
        }.to change(Post, :count).by(1)
      end

      context '自分の投稿の場合' do
        let(:post) { create(:post, user: @user) }

        it '編集ページにアクセスできること' do
          get :edit, params: { id: post.id }
          expect(response).to be_successful
        end

        it '投稿を更新できること' do
          patch :update, params: { id: post.id, post: attributes_for(:post, title: '更新後のタイトル') }
          expect(response).to redirect_to(post_path(post))
          expect(post.reload.title).to eq('更新後のタイトル')
        end

        it '投稿を削除できること' do
          expect {
            delete :destroy, params: { id: post.id }
          }.to change(Post, :count).by(-1)
          expect(response).to redirect_to(posts_path)
        end
      end

      context '他のユーザーの投稿の場合' do
        let(:other_user) { create(:user) }
        let(:post) { create(:post, user: other_user) }

        it '編集ページにアクセスできないこと' do
          get :edit, params: { id: post.id }
          expect(response).to redirect_to(posts_path)
        end

        it '投稿を更新できないこと' do
          patch :update, params: { id: post.id, post: attributes_for(:post) }
          expect(response).to redirect_to(posts_path)
        end

        it '投稿を削除できないこと' do
          expect {
            delete :destroy, params: { id: post.id }
          }.not_to change(Post, :count)
          expect(response).to redirect_to(posts_path)
        end
      end
    end
  end

  # アクションのテスト
  describe 'GET #index' do
    before do
      sign_in_test_user
      @posts = create_list(:post, 3)
    end

    it '投稿一覧を表示すること' do
      get :index
      expect(assigns(:posts)).to match_array(@posts)
    end

    it 'indexテンプレートをレンダリングすること' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'カテゴリーでフィルタリングできること' do
      post1 = create(:post, category: '進学')
      post2 = create(:post, category: '夢')
      get :index, params: { category: '進学' }
      expect(assigns(:posts)).to include(post1)
      expect(assigns(:posts)).not_to include(post2)
    end

    it '検索キーワードでフィルタリングできること' do
      post1 = create(:post, title: 'テスト投稿1')
      post2 = create(:post, title: '別の投稿')
      get :index, params: { search: 'テスト' }
      expect(assigns(:posts)).to include(post1)
      expect(assigns(:posts)).not_to include(post2)
    end
  end

  describe 'GET #show' do
    before do
      sign_in_test_user
      @post = create(:post)
    end

    it '投稿の詳細を表示すること' do
      get :show, params: { id: @post.id }
      expect(assigns(:post)).to eq(@post)
    end

    it 'showテンプレートをレンダリングすること' do
      get :show, params: { id: @post.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before do
      sign_in_test_user
    end

    it '新しい投稿オブジェクトを生成すること' do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end

    it 'newテンプレートをレンダリングすること' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    before do
      sign_in_test_user
    end

    context '有効なパラメータの場合' do
      let(:valid_attributes) { attributes_for(:post) }

      it '新しい投稿を作成すること' do
        expect {
          post :create, params: { post: valid_attributes }
        }.to change(Post, :count).by(1)
      end

      it '作成した投稿のページにリダイレクトすること' do
        post :create, params: { post: valid_attributes }
        expect(response).to redirect_to(post_path(Post.last))
      end

      it '成功メッセージを表示すること' do
        post :create, params: { post: valid_attributes }
        expect(flash[:notice]).to eq('投稿を作成しました')
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_attributes) { attributes_for(:post, title: nil) }

      it '新しい投稿を作成しないこと' do
        expect {
          post :create, params: { post: invalid_attributes }
        }.not_to change(Post, :count)
      end

      it 'newテンプレートを再レンダリングすること' do
        post :create, params: { post: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'エラーメッセージを表示すること' do
        post :create, params: { post: invalid_attributes }
        expect(flash[:alert]).to eq('投稿の作成に失敗しました')
      end
    end
  end

  describe 'GET #edit' do
    before do
      sign_in_test_user
      @post = create(:post, user: @user)
    end

    it '編集対象の投稿を取得すること' do
      get :edit, params: { id: @post.id }
      expect(assigns(:post)).to eq(@post)
    end

    it 'editテンプレートをレンダリングすること' do
      get :edit, params: { id: @post.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    before do
      sign_in_test_user
      @post = create(:post, user: @user)
    end

    context '有効なパラメータの場合' do
      let(:new_attributes) { attributes_for(:post, title: '更新後のタイトル') }

      it '投稿を更新すること' do
        patch :update, params: { id: @post.id, post: new_attributes }
        @post.reload
        expect(@post.title).to eq('更新後のタイトル')
      end

      it '更新した投稿のページにリダイレクトすること' do
        patch :update, params: { id: @post.id, post: new_attributes }
        expect(response).to redirect_to(post_path(@post))
      end

      it '成功メッセージを表示すること' do
        patch :update, params: { id: @post.id, post: new_attributes }
        expect(flash[:notice]).to eq('投稿を更新しました')
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_attributes) { attributes_for(:post, title: nil) }

      it '投稿を更新しないこと' do
        expect {
          patch :update, params: { id: @post.id, post: invalid_attributes }
        }.not_to change { @post.reload.title }
      end

      it 'editテンプレートを再レンダリングすること' do
        patch :update, params: { id: @post.id, post: invalid_attributes }
        expect(response).to render_template(:edit)
      end

      it 'エラーメッセージを表示すること' do
        patch :update, params: { id: @post.id, post: invalid_attributes }
        expect(flash[:alert]).to eq('投稿の更新に失敗しました')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in_test_user
      @post = create(:post, user: @user)
    end

    it '投稿を削除すること' do
      expect {
        delete :destroy, params: { id: @post.id }
      }.to change(Post, :count).by(-1)
    end

    it '投稿一覧ページにリダイレクトすること' do
      delete :destroy, params: { id: @post.id }
      expect(response).to redirect_to(posts_path)
    end

    it '成功メッセージを表示すること' do
      delete :destroy, params: { id: @post.id }
      expect(flash[:notice]).to eq('投稿を削除しました')
    end
  end
end
