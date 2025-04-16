# メッセージモデルクラス
# チャットルーム内でのメッセージのやり取りを管理するモデル
# ApplicationRecordを継承して基本的なモデル機能を利用
class Message < ApplicationRecord
  #-----------------
  # 関連付けの定義
  #-----------------
  # チャットルームに所属する (1対多の関係)
  belongs_to :chat_room
  # ユーザー(送信者)に所属する (1対多の関係)
  belongs_to :user

  #-----------------
  # バリデーション
  #-----------------
  # メッセージ本文は必須で、1000文字以内に制限
  validates :content, presence: true, length: { maximum: 1000 }
  # 既読フラグは真偽値のみ許可
  validates :is_read, inclusion: { in: [ true, false ] }
  # 削除フラグは真偽値のみ許可
  validates :is_deleted, inclusion: { in: [ true, false ] }

  #-----------------
  # スコープの定義
  #-----------------
  # 既読メッセージのみを取得
  scope :read, -> { where(is_read: true) }
  # 未読メッセージのみを取得
  scope :unread, -> { where(is_read: false) }
  # 削除されていないメッセージのみを取得
  scope :not_deleted, -> { where(is_deleted: false) }
  # 削除済みメッセージのみを取得
  scope :deleted, -> { where(is_deleted: true) }
  # メッセージを作成日時の降順で取得
  scope :recent, -> { order(created_at: :desc) }

  #-----------------
  # インスタンスメソッド
  #-----------------
  # メッセージを既読状態に更新するメソッド
  # @return [Boolean] 更新の成功/失敗
  def mark_as_read!
    update!(is_read: true)
  end

  # メッセージを論理削除するメソッド
  # 物理的な削除は行わず、削除フラグを立てる
  # @return [Boolean] 更新の成功/失敗
  def soft_delete!
    update!(is_deleted: true)
  end
end
