# メッセージ関連の機能を提供するコントローラー
# チャットルーム内でのメッセージの作成と既読管理を担当
class MessagesController < ApplicationController
  # ユーザー認証を必須とする
  before_action :authenticate_user!
  # 各アクションの前にチャットルームを設定
  before_action :set_chat_room
  # チャットルームへのアクセス権限を確認
  before_action :check_chat_room_access

  # POST /chat_rooms/:chat_room_id/messages
  # メッセージを作成するアクション
  def create
    # チャットルームに紐づく新しいメッセージを作成
    @message = @chat_room.messages.build(message_params)
    # メッセージの送信者を現在のユーザーに設定
    @message.user = current_user

    if @message.save
      # メッセージ送信後に既存のメッセージを既読にする
      mark_previous_messages_as_read
      
      # Action Cableを使用してメッセージをブロードキャスト
      # Action Cableを使用してチャットルームにメッセージをブロードキャスト
      # @param @chat_room [ChatRoom] ブロードキャスト先のチャットルーム
      # @param type [String] メッセージの種類を示す識別子('new_message')
      # @param message [String] レンダリングされたメッセージのHTML
      ChatRoomChannel.broadcast_to(
        @chat_room,  # ブロードキャスト先のチャットルーム
        {
          type: 'new_message',  # クライアント側でメッセージ追加処理を識別するためのタイプ
          message: render_message(@message)  # メッセージをHTMLとしてレンダリング
        }
      )
      
      # レスポンスフォーマットに応じて処理を分岐
      respond_to do |format|
        # HTML形式のリクエストの場合、チャットルームページにリダイレクト
        format.html { redirect_to @chat_room, notice: 'メッセージを送信しました' }
        # Turbo Stream形式の場合、非同期更新用のレスポンスを返す
        format.turbo_stream
      end
    else
      # メッセージの保存に失敗した場合、エラーメッセージとともにリダイレクト
      redirect_to @chat_room, alert: 'メッセージの送信に失敗しました'
    end
  end

  private

  # URLパラメータからチャットルームを取得し、インスタンス変数に設定
  def set_chat_room
    @chat_room = ChatRoom.find(params[:chat_room_id])
  end

  # 現在のユーザーがチャットルームにアクセスする権限があるか確認
  # チャットルームのメンバーでない場合、ルートページにリダイレクト
  def check_chat_room_access
    unless @chat_room.users.include?(current_user)
      redirect_to root_path, alert: 'このチャットルームにアクセスする権限がありません'
    end
  end

  # 許可されたパラメータのみを抽出
  # @return [ActionController::Parameters] contentパラメータのみを含むパラメータハッシュ
  def message_params
    params.require(:message).permit(:content)
  end

  # 他のユーザーからの未読メッセージを既読に更新
  # @note 現在のユーザーが送信したメッセージは対象外
  def mark_previous_messages_as_read
    @chat_room.messages
             .unread                        # 未読メッセージのみを対象
             .where.not(user: current_user) # 自分以外のユーザーのメッセージ
             .update_all(is_read: true)     # 一括で既読に更新
  end

  def render_message(message)
    ApplicationController.renderer.render(
      partial: 'messages/message',
      locals: { message: message, chat_room: @chat_room }
    )
  end
end
