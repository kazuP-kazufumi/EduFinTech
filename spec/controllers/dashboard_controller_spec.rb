require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe '認証・認可', skip: 'DashboardControllerの認証テストを実装する' do
    context '未ログインユーザーの場合' do
      it 'ダッシュボードページにアクセスできないこと' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインユーザーの場合' do
      before do
        sign_in_test_user
      end

      it 'ダッシュボードページにアクセスできること' do
        get :index
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #index', skip: 'DashboardControllerのindexアクションテストを実装する' do
    before do
      sign_in_test_user
    end

    it 'ユーザー情報を取得すること' do
      get :index
      expect(assigns(:user)).to eq(@user)
    end

    it 'indexテンプレートをレンダリングすること' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
