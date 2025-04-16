# チャットルームモデル
# 学生と投資家のコミュニケーションの場を管理するモデル
class ChatRoom < ApplicationRecord
  # ステータス定義
  # チャットルームの状態を管理するenum
  # active: 0 - アクティブな（利用可能な）チャットルーム
  # inactive: 1 - 非アクティブな（利用停止中の）チャットルーム
  enum :status, {
    active: 0,
    inactive: 1
  }

  # バリデーション
  # name: チャットルーム名
  #   - 必須項目
  #   - 最大50文字まで
  validates :name, presence: true, length: { maximum: 50 }

  # description: チャットルームの説明文
  #   - 任意項目
  #   - 最大500文字まで
  validates :description, length: { maximum: 500 }

  # status: チャットルームの状態
  #   - 必須項目
  #   - enumで定義された値のみ許可
  validates :status, presence: true, inclusion: { in: statuses.keys }

  # 関連付け
  # chat_room_users: 中間テーブル
  #   - チャットルームとユーザーの多対多の関係を管理
  #   - チャットルームが削除された場合、関連するレコードも削除
  has_many :chat_room_users, dependent: :destroy

  # users: チャットルームに参加しているユーザー
  #   - chat_room_usersを介して関連付け
  has_many :users, through: :chat_room_users

  # messages: チャットルーム内のメッセージ
  #   - チャットルームが削除された場合、関連するメッセージも削除
  has_many :messages, dependent: :destroy

  # スコープ
  # active: アクティブなチャットルームのみを取得
  scope :active, -> { where(status: :active) }
  # inactive: 非アクティブなチャットルームのみを取得
  scope :inactive, -> { where(status: :inactive) }

  #-----------------
  # メッセージ関連のインスタンスメソッド
  #-----------------

  # チャットルーム内の最新のメッセージを取得するメソッド
  # @return [Message, nil] 最新のメッセージ。メッセージが存在しない場合はnil
  # @note messages.recentスコープを使用して最新順に並び替え、最初の1件を取得
  def latest_message
    messages.recent.first
  end

  # 特定のユーザーに対する未読メッセージの数を取得するメソッド
  # @param user [User] 未読メッセージをカウントする対象のユーザー
  # @return [Integer] 未読メッセージの数
  # @note
  #   - messages.unreadスコープで未読メッセージをフィルタリング
  #   - where.not(user: user)で指定ユーザー以外が送信したメッセージに限定
  #   - countメソッドで該当するメッセージの数を取得
  def unread_messages_count(user)
    messages.unread.where.not(user: user).count
  end
end
