# ProfilesControllerのテスト
RSpec.describe ProfilesController, type: :controller do
  # 認証・認可のテスト
  describe '認証・認可' do
    context '未ログインユーザーの場合' do
      it 'プロフィールページにアクセスできないこと' do
        get :show
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'プロフィール編集ページにアクセスできないこと' do
        get :edit
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'プロフィールを更新できないこと' do
        patch :update, params: { user: attributes_for(:user) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインユーザーの場合' do
      before do
        sign_in_test_user
      end

      it '自分のプロフィールページにアクセスできること' do
        get :show
        expect(response).to be_successful
      end

      it '自分のプロフィール編集ページにアクセスできること' do
        get :edit
        expect(response).to be_successful
      end

      it '自分のプロフィールを更新できること' do
        patch :update, params: { user: attributes_for(:user, name: '新しい名前') }
        expect(@user.reload.name).to eq('新しい名前')
      end
    end
  end

  # アクションのテスト
  describe 'GET #show' do
    before do
      sign_in_test_user
      @posts = create_list(:post, 3, user: @user)
      @comments = create_list(:comment, 2, user: @user)
    end

    it 'プロフィール情報を表示すること' do
      get :show
      expect(assigns(:user)).to eq(@user)
    end

    it 'ユーザーの投稿一覧を表示すること' do
      get :show
      expect(assigns(:posts)).to match_array(@posts)
    end

    it 'ユーザーのコメント一覧を表示すること' do
      get :show
      expect(assigns(:comments)).to match_array(@comments)
    end

    it 'showテンプレートをレンダリングすること' do
      get :show
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    before do
      sign_in_test_user
    end

    it '編集対象のユーザーを取得すること' do
      get :edit
      expect(assigns(:user)).to eq(@user)
    end

    it 'editテンプレートをレンダリングすること' do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    before do
      sign_in_test_user
    end

    context '有効なパラメータの場合' do
      let(:valid_attributes) do
        {
          name: '新しい名前',
          email: 'new@example.com',
          profile: '新しいプロフィール',
          avatar: fixture_file_upload('spec/fixtures/files/test_avatar.jpg', 'image/jpeg')
        }
      end

      it 'ユーザー情報を更新すること' do
        patch :update, params: { user: valid_attributes }
        @user.reload
        expect(@user.name).to eq('新しい名前')
        expect(@user.email).to eq('new@example.com')
        expect(@user.profile).to eq('新しいプロフィール')
        expect(@user.avatar).to be_attached
      end

      it 'プロフィールページにリダイレクトすること' do
        patch :update, params: { user: valid_attributes }
        expect(response).to redirect_to(profile_path)
      end

      it '成功メッセージを表示すること' do
        patch :update, params: { user: valid_attributes }
        expect(flash[:notice]).to eq('プロフィールを更新しました')
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_attributes) { { name: nil, email: 'invalid_email' } }

      it 'ユーザー情報を更新しないこと' do
        expect {
          patch :update, params: { user: invalid_attributes }
        }.not_to change { @user.reload.name }
      end

      it 'editテンプレートを再レンダリングすること' do
        patch :update, params: { user: invalid_attributes }
        expect(response).to render_template(:edit)
      end

      it 'エラーメッセージを表示すること' do
        patch :update, params: { user: invalid_attributes }
        expect(flash[:alert]).to eq('プロフィールの更新に失敗しました')
      end
    end

    context 'パスワードの更新を含む場合' do
      let(:password_attributes) do
        {
          current_password: 'password123',
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }
      end

      it 'パスワードを更新できること' do
        patch :update, params: { user: password_attributes }
        expect(@user.reload.valid_password?('newpassword123')).to be true
      end

      it '現在のパスワードが間違っている場合は更新できないこと' do
        patch :update, params: { user: password_attributes.merge(current_password: 'wrong_password') }
        expect(@user.reload.valid_password?('newpassword123')).to be false
        expect(flash[:alert]).to eq('現在のパスワードが正しくありません')
      end
    end
  end
end 