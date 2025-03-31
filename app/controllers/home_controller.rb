class HomeController < ApplicationController
  def index
    # 最新の投稿を取得（ログイン状態に関わらず）
    @posts = Post.includes(:user).order(created_at: :desc).limit(6)
  end
end 