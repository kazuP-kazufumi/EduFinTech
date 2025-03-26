# 通知関連のビューヘルパーを提供するモジュール
# このモジュールは通知メッセージの生成や表示に関する共通機能を定義します
module NotificationsHelper
  # 通知の種類に応じて適切なメッセージを生成するヘルパーメソッド
  # @param notification [Notification] メッセージを生成する対象の通知オブジェクト
  # @return [String] 通知の種類に応じて生成されたメッセージ
  def notification_message(notification)
    # 通知タイプに基づいて異なるメッセージを返す
    case notification.notification_type
    when 'support_request'
      # 支援リクエストの場合のメッセージ
      # 送信者のメールアドレスを含めて支援申し出のメッセージを生成
      "#{notification.sender.email}さんがあなたへの支援を申し出ています"
    when 'support_accepted'
      # 支援承認の場合のメッセージ
      # 承認者のメールアドレスを含めて支援承認のメッセージを生成
      "あなたが申し出た支援を#{notification.sender.email}さんが受け入れました"
    end
  end
end
