# Postモデルは投稿を表現するクラスです
# ApplicationRecordを継承することで、Active Recordの機能を利用できます
class Post < ApplicationRecord
  # ユーザーとの関連付け
  # belongs_toで1対多の関係を表現し、各投稿は1人のユーザーに属します
  belongs_to :user

  has_many :notifications, dependent: :destroy

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
  CATEGORIES = ['進学', '夢', '野望', 'その他'].freeze

  # カテゴリーのバリデーション
  validates :category, presence: true, inclusion: { in: CATEGORIES }
end
