# Userモデルは認証機能を持つユーザーを表現するクラスです
# ApplicationRecordを継承することで、Active Recordの機能を利用できます
class User < ApplicationRecord
  # Deviseの認証モジュールを組み込みます
  # 以下のモジュールを有効化:
  #
  # :database_authenticatable - データベースを使用したパスワード認証
  #   - パスワードの暗号化と認証機能を提供
  #   - サインイン時にメールアドレスとパスワードで認証
  #
  # :registerable - ユーザー登録機能
  #   - ユーザーがアカウントを作成・編集・削除可能
  #
  # :recoverable - パスワードリセット機能
  #   - パスワードを忘れた場合のリセット機能を提供
  #
  # :rememberable - ログイン状態の記憶機能
  #   - 「ログインを記憶する」機能を提供
  #
  # :validatable - バリデーション機能
  #   - メールアドレスとパスワードの基本的な検証を提供
  #
  # :confirmable - メール確認機能
  #   - ユーザー登録時のメール確認機能を提供
  #
  # :lockable - アカウントロック機能
  #   - ログイン失敗が続いた場合にアカウントをロック
  #
  # :timeoutable - セッションタイムアウト機能
  #   - 一定時間操作がない場合にセッションを終了
  #
  # :trackable - ログイン追跡機能
  #   - ログイン回数、時刻、IPアドレスなどを記録
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  # プロフィール画像の関連付け
  has_one_attached :avatar

  # 投稿との関連付け
  # has_many :posts - ユーザーは複数の投稿を持つことができる1対多の関係を定義
  # dependent: :destroy - ユーザーが削除された場合、関連する投稿も自動的に削除される
  #   - これによりデータの整合性を保ち、孤立したデータの発生を防ぐ
  #   - 例: ユーザーAが削除された場合、ユーザーAの全ての投稿も削除される
  has_many :posts, dependent: :destroy
end
