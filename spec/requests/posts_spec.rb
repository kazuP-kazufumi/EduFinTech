require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /posts" do
    it "returns http success" do
      get posts_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /posts/new" do
    it "returns http success" do
      get new_post_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /posts" do
    let(:valid_attributes) { { title: "テスト投稿", content: "テスト内容" } }

    it "creates a new post" do
      expect {
        post posts_path, params: { post: valid_attributes }
      }.to change(Post, :count).by(1)

      expect(response).to redirect_to(post_path(Post.last))
    end
  end

  describe "GET /posts/:id" do
    let(:post) { create(:post, user: user) }

    it "returns http success" do
      get post_path(post)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /posts/:id/edit" do
    let(:post) { create(:post, user: user) }

    it "returns http success" do
      get edit_post_path(post)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /posts/:id" do
    let(:post) { create(:post, user: user) }
    let(:new_attributes) { { title: "更新された投稿", content: "更新された内容" } }

    it "updates the post" do
      patch post_path(post), params: { post: new_attributes }
      post.reload
      expect(post.title).to eq("更新された投稿")
      expect(post.content).to eq("更新された内容")
      expect(response).to redirect_to(post_path(post))
    end
  end

  describe "DELETE /posts/:id" do
    let!(:post) { create(:post, user: user) }

    it "destroys the post" do
      expect {
        delete post_path(post)
      }.to change(Post, :count).by(-1)

      expect(response).to redirect_to(posts_path)
    end
  end
end
