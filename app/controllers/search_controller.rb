class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @query = params[:q]
    @category = params[:category]
    @sort = params[:sort] || "newest"
    @page = params[:page] || 1

    if @query.present? || @category.present?
      @posts = search_posts
      @users = search_users if @query.present?
    else
      @posts = []
      @users = []
    end
  end

  private

  def search_posts
    posts = Post.all

    if @query.present?
      posts = posts.where("title LIKE ? OR content LIKE ?", "%#{@query}%", "%#{@query}%")
    end

    if @category.present?
      posts = posts.where(category: @category)
    end

    posts = case @sort
    when "newest"
      posts.newest
    when "oldest"
      posts.oldest
    else
      posts.newest
    end

    posts.page(@page).per(10)
  end

  def search_users
    users = User.where("name LIKE ? OR bio LIKE ?", "%#{@query}%", "%#{@query}%")
    users.page(@page).per(10)
  end
end
