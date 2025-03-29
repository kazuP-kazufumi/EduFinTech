class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:update, :destroy]
  before_action :authorize_comment, only: [:update, :destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: 'コメントを投稿しました'
    else
      redirect_to @post, alert: 'コメントの投稿に失敗しました'
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @post, notice: 'コメントを更新しました'
    else
      redirect_to @post, alert: 'コメントの更新に失敗しました'
    end
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: 'コメントを削除しました'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def authorize_comment
    unless @comment.user == current_user
      redirect_to @post, alert: 'このコメントを編集する権限がありません'
    end
  end
end 