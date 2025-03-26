# 通知モデル - ユーザー間の通知を管理するモデル
class Notification < ApplicationRecord
  # アソシエーション
  belongs_to :user  # 通知の受信者
  belongs_to :sender, class_name: 'User'  # 通知の送信者（Userモデルとの関連付け）
  belongs_to :post  # 関連する投稿

  # 通知タイプの列挙型定義
  enum notification_type: {
    support_request: 0,  # サポート依頼通知
    support_accepted: 1  # サポート承認通知
  }

  # バリデーション
  validates :notification_type, presence: true  # 通知タイプは必須
  validates :read, inclusion: { in: [true, false] }  # 既読状態は true/false のみ許可

  # スコープ定義
  scope :unread, -> { where(read: false) }  # 未読の通知を取得
  scope :recent, -> { order(created_at: :desc) }  # 新しい順に通知を取得
end
