# 通知機能を制御するコントローラー
# ユーザー間の通知の作成と管理を担当
class NotificationsController < ApplicationController
  # ログインユーザーのみアクセス可能にする
  before_action :authenticate_user!
  # createアクションの前に投稿を取得
  before_action :set_post, only: [ :create ]
  before_action :set_notification, only: [ :mark_as_read, :destroy ]

  # 通知を作成するアクション
  # @param notification_type [String] 通知の種類('support_request'または'support_accepted')
  # @param post_id [Integer] 関連する投稿のID
  def create
    # 通知タイプに応じて処理を分岐
    case params[:notification_type]
    when "support_request"
      # 支援申し出の通知を作成
      # current_userが送信者、@postの投稿者が受信者となる
      Notification.create_support_request(sender: current_user, post: @post)
      flash[:notice] = "支援を申し出ました"
    when "support_accepted"
      # 支援承諾の通知を作成
      # current_userが送信者、元の支援申し出者が受信者となる
      Notification.create_support_accepted(sender: current_user, post: @post)
      flash[:notice] = "支援を承諾しました"
    end

    # 通知作成後、投稿詳細ページにリダイレクト
    redirect_to @post, notice: flash[:notice]
  end

  # 通知一覧を表示するアクション
  # @return [void]
  def index
    # ログインユーザーの通知を取得
    # current_user.notifications - ログインユーザーに紐づく通知を取得
    # .recent - 最近の通知から順に取得(scopeで定義された並び順を適用)
    # @notifications - ビューで表示するための通知コレクションをインスタンス変数に格納
    @notifications = current_user.notifications.recent
  end

  # 通知を既読状態にするアクション
  # @notification (set_notificationで設定) に対して既読フラグを設定します
  # @return [void]
  def mark_as_read
    # 通知のread属性をtrueに更新して既読状態にする
    @notification.update(read: true)

    # リクエストのフォーマットに応じてレスポンスを返す
    respond_to do |format|
      # JSON形式のリクエストの場合
      format.json { render json: { success: true } }
      # HTML形式のリクエストの場合
      format.html { redirect_to notifications_path, notice: "通知を既読にしました" }
      # その他のフォーマットの場合
      format.any { redirect_to notifications_path, notice: "通知を既読にしました" }
    end
  end

  # 通知を削除するアクション
  def destroy
    @notification.destroy
    redirect_to notifications_path, notice: "通知を削除しました"
  end

  # すべての通知を既読にするアクション
  def mark_all_as_read
    current_user.notifications.update_all(read: true)
    redirect_to notifications_path, notice: "すべての通知を既読にしました"
  end

  # すべての通知を削除するアクション
  def destroy_all
    current_user.notifications.destroy_all
    redirect_to notifications_path, notice: "すべての通知を削除しました"
  end

  private

  # パラメータから投稿を取得するメソッド
  # @raise [ActiveRecord::RecordNotFound] 指定されたIDの投稿が存在しない場合
  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
end
