# チャットルーム機能のためのActionCableチャンネルクラス
# WebSocketを使用してリアルタイムな双方向通信を実現する
class ChatRoomChannel < ApplicationCable::Channel
  # クライアントがチャンネルを購読した時に呼ばれるメソッド
  # @param [Hash] params クライアントから送られてきたパラメータ
  # @option params [Integer] :chat_room_id 購読するチャットルームのID
  def subscribed
    # パラメータで指定されたIDのチャットルームを取得
    @chat_room = ChatRoom.find(params[:chat_room_id])
    # 指定されたチャットルームの通信ストリームを開始
    # このチャットルームに関連するメッセージをブロードキャストできるようになる
    stream_for @chat_room
  end

  # クライアントがチャンネルの購読を解除した時に呼ばれるメソッド
  # チャットルームから退出する際などに実行される
  def unsubscribed
    # 全ての通信ストリームを停止
    # メモリリークを防ぎ、不要な通信を避けるため
    stop_all_streams
  end

  # メッセージを既読状態にするメソッド
  # クライアントからメッセージIDを受け取り、該当メッセージを既読にする
  # @param [Hash] data クライアントから送られてきたデータ
  # @option data [Integer] 'message_id' 既読にするメッセージのID
  def mark_as_read(data)
    # 指定されたIDのメッセージを取得
    message = Message.find(data["message_id"])

    # メッセージが現在のチャットルームに属していて、
    # かつメッセージの送信者が現在のユーザーでない場合のみ処理を実行
    if message.chat_room == @chat_room && message.user != current_user
      # メッセージを既読状態にマーク
      message.mark_as_read!

      # チャットルーム内の全クライアントに既読状態の変更を通知
      # type: 'message_read' - クライアント側で既読表示を更新するために使用
      # message_id: - 既読になったメッセージを特定するためのID
      broadcast_to @chat_room, {
        type: "message_read",
        message_id: message.id
      }
    end
  end
end
