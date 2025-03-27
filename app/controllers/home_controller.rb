class HomeController < ApplicationController
  def index
    # ログインしている場合は投稿一覧を表示
    if user_signed_in?
      @posts = Post.includes(:user).order(created_at: :desc)
    end
  end
end 