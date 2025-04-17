# Postモデルは投稿を表現するクラスです
# ApplicationRecordを継承することで、Active Recordの機能を利用できます
class Post < ApplicationRecord
  # ユーザーとの関連付け
  # belongs_toで1対多の関係を表現し、各投稿は1人のユーザーに属します
  belongs_to :user

  has_many :notifications, dependent: :destroy
  has_many :comments, dependent: :destroy

  # バリデーション設定
  # 投稿のデータ整合性を確保するためのルールを定義します

  # タイトルのバリデーション
  # presence: true - タイトルは必須項目
  # length: { maximum: 100 } - タイトルは最大100文字まで
  validates :title, presence: true, length: { maximum: 100 }

  # 本文のバリデーション
  # presence: true - 本文は必須項目
  # length: { maximum: 1000 } - 本文は最大1000文字まで
  validates :content, presence: true, length: { maximum: 1000 }

  # カテゴリーの選択肢を定義
  CATEGORIES = [ "education", "finance", "other" ].freeze

  # カテゴリーのバリデーション
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  # スコープ
  scope :newest, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }
  scope :recent, -> { newest }
  scope :by_category, ->(category) { where(category: category) }
  scope :search, ->(query) {
    where('title LIKE :query OR content LIKE :query', query: "%#{query}%")
  }
end
