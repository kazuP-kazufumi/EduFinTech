# アプリケーション全体のコントローラー
# 全てのコントローラーの基底クラスとなり、共通の機能を提供する
# このクラスで定義されたメソッドは全てのコントローラーで使用可能
class ApplicationController < ActionController::Base
  # モダンブラウザのみを許可する設定
  # 以下の機能をサポートするブラウザのみアクセスを許可:
  # - WebP画像フォーマット: 高圧縮・高品質な画像形式
  # - Web Push通知: ブラウザ経由でプッシュ通知を送信可能
  # - ブラウザバッジ: タブやアイコンにバッジを表示可能
  # - Import Maps: JavaScriptモジュールを直接インポート可能
  # - CSSネスティング: CSSのネスト記法をサポート
  # - CSS :has()セレクタ: 親要素に基づく選択が可能
  # この設定により、古いブラウザでのアクセスを制限し、最新の機能を活用可能
  allow_browser versions: :modern

  # CSRFトークンの検証を有効化
  # Cross-Site Request Forgery(CSRF)攻撃から保護
  # フォーム送信時にトークンを検証し、不正なリクエストを防止
  # :exceptionオプションにより、トークンが無効な場合は例外を発生
  protect_from_forgery with: :exception

  # Deviseの認証関連のリダイレクト設定
  # protectedメソッドとして定義することで、このクラスとそのサブクラスからのみアクセス可能
  # 外部からの直接呼び出しを防ぎ、セキュリティを向上
  protected

  # ユーザー新規登録後のリダイレクト先を指定するメソッド
  # Deviseのデフォルト動作をオーバーライドして、カスタムのリダイレクト先を設定
  # @param resource [User] 新規登録されたユーザーオブジェクト
  # @return [String] リダイレクト先のパス（ここではルートパス）
  # 新規登録完了後、ユーザーをトップページへ誘導
  def after_sign_up_path_for(resource)
    root_path
  end

  # ユーザーログイン後のリダイレクト先を指定するメソッド
  # Deviseのデフォルト動作をオーバーライドして、カスタムのリダイレクト先を設定
  # @param resource [User] ログインしたユーザーオブジェクト
  # @return [String] リダイレクト先のパス（ここではダッシュボード）
  # ログイン完了後、ユーザーをダッシュボードページへ誘導
  # ダッシュボードでは、ユーザー固有の情報や機能にアクセス可能
  def after_sign_in_path_for(resource)
    dashboard_path
  end
end
