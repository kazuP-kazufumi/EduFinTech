require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    pending 'HomeControllerのテストを実装する' do
      it 'インデックスページを表示すること' do
        get :index
        expect(response).to be_successful
      end

      it '最新の投稿を取得すること' do
        posts = create_list(:post, 6)
        get :index
        expect(assigns(:posts)).to match_array(posts.sort_by(&:created_at).reverse)
      end

      it '6件以上の投稿がある場合は6件のみ表示すること' do
        create_list(:post, 10)
        get :index
        expect(assigns(:posts).count).to eq(6)
      end
    end
  end
end 