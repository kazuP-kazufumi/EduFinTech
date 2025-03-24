# アプリケーション全体のコントローラー
# 全てのコントローラーの基底クラスとなり、共通の機能を提供する
class ApplicationController < ActionController::Base
  # モダンブラウザのみを許可する設定
  # 以下の機能をサポートするブラウザのみアクセスを許可:
  # - WebP画像フォーマット
  # - Web Push通知
  # - ブラウザバッジ
  # - Import Maps
  # - CSSネスティング
  # - CSS :has()セレクタ
  allow_browser versions: :modern

  # Deviseの認証関連のリダイレクト設定
  # protectedメソッドとして定義することで、このクラスとそのサブクラスからのみアクセス可能
  protected

  # ユーザー新規登録後のリダイレクト先を指定するメソッド
  # @param resource [User] 新規登録されたユーザーオブジェクト
  # @return [String] リダイレクト先のパス
  def after_sign_up_path_for(resource)
    # 新規登録完了後はダッシュボードページへリダイレクト
    # dashboard_pathヘルパーメソッドを使用してパスを生成
    dashboard_path
  end

  # ユーザーログイン後のリダイレクト先を指定するメソッド
  # @param resource [User] ログインしたユーザーオブジェクト
  # @return [String] リダイレクト先のパス
  def after_sign_in_path_for(resource)
    # ログイン完了後はダッシュボードページへリダイレクト
    # dashboard_pathヘルパーメソッドを使用してパスを生成
    dashboard_path
  end
end
