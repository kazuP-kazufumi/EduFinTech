# 通知機能を制御するコントローラー
# ユーザー間の通知の作成と管理を担当
class NotificationsController < ApplicationController
  # ログインユーザーのみアクセス可能にする
  before_action :authenticate_user!
  # createアクションの前に投稿を取得
  before_action :set_post, only: [:create]

  # 通知を作成するアクション
  # @param notification_type [String] 通知の種類('support_request'または'support_accepted')
  # @param post_id [Integer] 関連する投稿のID
  def create
    # 通知タイプに応じて処理を分岐
    case params[:notification_type]
    when 'support_request'
      # 支援申し出の通知を作成
      # current_userが送信者、@postの投稿者が受信者となる
      Notification.create_support_request(sender: current_user, post: @post)
      flash[:notice] = '支援を申し出ました'
    when 'support_accepted'
      # 支援承諾の通知を作成
      # current_userが送信者、元の支援申し出者が受信者となる
      Notification.create_support_accepted(sender: current_user, post: @post)
      flash[:notice] = '支援を承諾しました'
    end

    # 通知作成後、投稿詳細ページにリダイレクト
    redirect_to @post, notice: flash[:notice]
  end

  private

  # パラメータから投稿を取得するメソッド
  # @raise [ActiveRecord::RecordNotFound] 指定されたIDの投稿が存在しない場合
  def set_post
    @post = Post.find(params[:post_id])
  end
end
