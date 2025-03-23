# frozen_string_literal: true

# このファイルはDeviseの設定ファイルです。
# 各設定オプションはデフォルト値が設定されており、一部はコメントアウトされています。
# コメントアウトされていない設定は、将来のDeviseのバージョンアップで
# デフォルト値が変更された場合でも、現在の設定を保護するためのものです。

# Deviseのメーラー、Wardenフック、その他の機能を設定するためのフックです。
# 多くの設定オプションはモデルファイル内で直接設定することもできます。
Devise.setup do |config|
  # Deviseが使用する秘密鍵の設定
  # この鍵は、ランダムトークンの生成に使用されます。
  # この鍵を変更すると、データベース内の既存の確認トークン、
  # パスワードリセットトークン、ロック解除トークンが無効になります。
  # デフォルトでは`secret_key_base`が使用されます。
  # config.secret_key = 'a9a9937cf8e35d66c3daa993f1569c020054b512dc0fd7f945b3b4c9ee6f98914c8102dd0486737a58f312fa6e15de2672f5820a49d979151ccd8372dc2b509d'

  # ==> コントローラーの設定
  # Deviseコントローラーの親クラスを設定
  config.parent_controller = 'ApplicationController'

  # ==> メーラーの設定
  # Devise::Mailerで使用される送信元メールアドレスを設定
  # 独自のメーラークラスで上書きすることも可能です
  config.mailer_sender = 'noreply@edufintech.com'

  # メール送信を担当するクラスの設定
  # config.mailer = 'Devise::Mailer'

  # メール送信の親クラスの設定
  # config.parent_mailer = 'ActionMailer::Base'

  # ==> ORMの設定
  # ORMの読み込みと設定。デフォルトではactive_recordをサポート
  # mongoidも利用可能（bson_ext推奨）
  require 'devise/orm/active_record'

  # ==> 認証メカニズムの設定
  # ユーザー認証に使用するキーの設定
  # デフォルトでは:emailのみ使用
  # [:username, :subdomain]のように複数のパラメータを要求することも可能
  # config.authentication_keys = [:email]

  # リクエストオブジェクトから認証に使用するパラメータの設定
  # config.request_keys = []

  # 大文字小文字を区別しないキーの設定
  # ユーザー作成・更新時に小文字化されます
  config.case_insensitive_keys = [:email]

  # 空白を除去するキーの設定
  # ユーザー作成・更新時に前後の空白が除去されます
  config.strip_whitespace_keys = [:email]

  # パラメータによる認証の有効化設定
  # config.params_authenticatable = true

  # HTTP認証の有効化設定
  # config.http_authenticatable = false

  # AJAXリクエストに対する401ステータスコードの返却設定
  # config.http_authenticatable_on_xhr = true

  # HTTP Basic認証で使用するレルムの設定
  # config.http_authentication_realm = 'Application'

  # パラノイドモードの設定
  # 正しいメールアドレスか間違ったメールアドレスかに関わらず
  # 同じ動作をするようになります
  # config.paranoid = true

  # セッションストレージのスキップ設定
  config.skip_session_storage = [:http_auth]

  # 認証時のCSRFトークンクリーンアップ設定
  # config.clean_up_csrf_token_on_authentication = true

  # ルートの再読み込み設定
  # config.reload_routes = true

  # ==> データベース認証の設定
  # パスワードハッシュのストレッチ回数設定
  # テスト環境では1回、その他の環境では12回
  config.stretches = Rails.env.test? ? 1 : 12

  # パスワードハッシュ生成用のペッパー設定
  # config.pepper = '87afa489ec8bbe24201af92d0f5b435d1c8d3f609467a401f8e5601d4399b2035a8ef6acf38135c8d3a026e6812e2a3fa87e83748ad702ec01c86130ecde10d1'

  # メールアドレス変更通知の設定
  # config.send_email_changed_notification = false

  # パスワード変更通知の設定
  # config.send_password_change_notification = false

  # ==> アカウント確認の設定
  # アカウント未確認でもアクセスを許可する期間
  # nilの場合は無期限にアクセス可能
  config.allow_unconfirmed_access_for = 2.days

  # アカウント確認トークンの有効期限
  config.confirm_within = 3.days

  # メールアドレス変更時の再確認要求設定
  config.reconfirmable = true

  # アカウント確認時に使用するキーの設定
  # config.confirmation_keys = [:email]

  # ==> 記憶機能の設定
  # ログイン状態を記憶する期間
  # config.remember_for = 2.weeks

  # ログアウト時に全ての記憶トークンを無効化
  config.expire_all_remember_me_on_sign_out = true

  # クッキーによる記憶期間の延長設定
  # config.extend_remember_period = false

  # 記憶用クッキーのオプション設定
  # config.rememberable_options = {}

  # ==> バリデーションの設定
  # パスワードの長さ制限
  config.password_length = 8..128

  # メールアドレスの形式チェック用正規表現
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> タイムアウトの設定
  # セッションタイムアウトまでの時間
  config.timeout_in = 30.minutes

  # ==> アカウントロックの設定
  # アカウントロックの方式
  config.lock_strategy = :failed_attempts

  # アカウントロック解除に使用するキー
  # config.unlock_keys = [:email]

  # ロック解除の方式
  config.unlock_strategy = :time

  # ロックまでの最大試行回数
  config.maximum_attempts = 5

  # 時間ベースのロック解除までの時間
  config.unlock_in = 1.hour

  # 最後の試行時の警告表示設定
  # config.last_attempt_warning = true

  # ==> パスワード回復の設定
  # パスワードリセットキーの有効期限
  config.reset_password_within = 6.hours

  # パスワードリセット後の自動サインイン設定
  # config.sign_in_after_reset_password = true

  # ==> 暗号化の設定
  # bcrypt以外の暗号化アルゴリズムを使用する場合の設定
  # config.encryptor = :sha512

  # ==> スコープの設定
  # スコープ付きビューの有効化
  config.scoped_views = true

  # デフォルトスコープの設定
  # config.default_scope = :user

  # サインアウト時の全スコープサインアウト設定
  # config.sign_out_all_scopes = true

  # ==> ナビゲーションの設定
  # ナビゲーション形式の設定
  # config.navigational_formats = ['*/*', :html, :turbo_stream]

  # サインアウト時のHTTPメソッド設定
  config.sign_out_via = :delete

  # ==> OmniAuth設定
  # 外部認証プロバイダーの設定
  # config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'

  # ==> Warden設定
  # Wardenの詳細設定用ブロック
  #
  # config.warden do |manager|
  #   manager.intercept_401 = false
  #   manager.default_strategies(scope: :user).unshift :some_external_strategy
  # end

  # ==> マウント可能エンジンの設定
  # ルーター名の設定
  config.router_name = :edufintech

  # OmniAuthパスプレフィックスの設定
  # config.omniauth_path_prefix = '/my_engine/users/auth'

  # ==> Hotwire/Turbo設定
  # エラーレスポンスとリダイレクトのHTTPステータス設定
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  # ==> 登録機能の設定
  # パスワード変更後の自動サインイン設定
  # config.sign_in_after_change_password = true
end
