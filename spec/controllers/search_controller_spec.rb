require 'rails_helper'

# SearchControllerのテスト
RSpec.describe SearchController, type: :controller do
  # テストケースごとにデータベースをクリーンアップ
  before(:each) do
    DatabaseCleaner.clean
  end

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
        @user = create(:user)
        sign_in @user
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
      @user = create(:user)
      sign_in @user
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
      end

      it '本文で検索できること' do
        post1 = create(:post, content: 'テスト内容1')
        post2 = create(:post, content: '別の内容')
        get :index, params: { q: 'テスト' }
        expect(assigns(:posts)).to include(post1)
      end

      it 'カテゴリーで検索できること' do
        post1 = create(:post, category: 'education')
        post2 = create(:post, category: 'other')
        get :index, params: { category: 'education' }
        expect(assigns(:posts)).to include(post1)
      end
    end

    context 'ユーザーの検索' do
      it '名前で検索できること' do
        user1 = create(:user, name: 'テストユーザー1')
        user2 = create(:user, name: '別のユーザー')
        get :index, params: { q: 'テスト' }
        expect(assigns(:users)).to include(user1)
      end

      it '自己紹介で検索できること' do
        user1 = create(:user, bio: 'テスト自己紹介1')
        user2 = create(:user, bio: '別の自己紹介')
        get :index, params: { q: 'テスト' }
        expect(assigns(:users)).to include(user1)
      end
    end

    context '検索結果の表示' do
      it '検索結果をソートできること' do
        # 検索クエリに一致する投稿を作成
        post1 = create(:post, title: 'テスト投稿1', content: 'テスト内容1', created_at: 1.day.ago)
        post2 = create(:post, title: 'テスト投稿2', content: 'テスト内容2', created_at: 2.days.ago)
        # 検索クエリに一致しない投稿を作成
        create(:post, title: '別の投稿', content: '別の内容', created_at: 3.days.ago)

        # 新しい順でソート
        get :index, params: { q: 'テスト', sort: 'newest' }
        expect(assigns(:posts).to_a).to eq([ post1, post2 ])

        # 古い順でソート
        get :index, params: { q: 'テスト', sort: 'oldest' }
        expect(assigns(:posts).to_a).to eq([ post2, post1 ])
      end
    end
  end
end
