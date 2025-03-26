# 通知機能のためのActionCableチャンネルクラス
# WebSocketを使用してリアルタイムな通知配信を実現します
class NotificationsChannel < ApplicationCable::Channel
  # クライアントが購読を開始した時に呼ばれるメソッド
  # @return [void]
  def subscribed
    # 現在のユーザーに対してストリームを設定
    # これにより、このユーザーに対して個別に通知を送信できるようになります
    stream_for current_user
  end

  # クライアントが購読を解除した時に呼ばれるメソッド
  # 例: ページを離れた時やWebSocket接続が切断された時
  # @return [void] 
  def unsubscribed
    # 全てのストリームを停止し、リソースを解放します
    stop_all_streams
  end
end
