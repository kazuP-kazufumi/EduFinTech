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

  # 支援申し出時の通知を作成するクラスメソッド
  # @param sender [User] 支援を申し出たユーザー（通知の送信者）
  # @param post [Post] 支援対象の投稿
  # @return [Notification] 作成された通知オブジェクト
  def self.create_support_request(sender:, post:)
    # 新しい通知レコードを作成して保存
    create!(
      user: post.user,      # 通知の受信者は投稿者
      sender: sender,       # 通知の送信者は支援申し出者
      post: post,          # 関連する投稿
      notification_type: :support_request,  # 通知タイプは支援申し出
      read: false          # 未読状態で作成
    )
  end

  # 支援受諾時の通知を作成するクラスメソッド
  # @param sender [User] 支援を受諾した投稿者（通知の送信者）
  # @param post [Post] 支援が受諾された投稿
  # @return [Notification] 作成された通知オブジェクト
  def self.create_support_accepted(sender:, post:)
    # 新しい通知レコードを作成して保存
    create!(
      user: sender,        # 通知の受信者は元の支援申し出者
      sender: post.user,   # 通知の送信者は投稿者
      post: post,          # 関連する投稿
      notification_type: :support_accepted,  # 通知タイプは支援受諾
      read: false          # 未読状態で作成
    )
  end
end
