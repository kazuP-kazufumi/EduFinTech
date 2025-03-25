# Sidekiqの基本機能とWeb UIを読み込み
require "sidekiq"
require "sidekiq/web"

# Sidekiqサーバー（ワーカー）の設定
Sidekiq.configure_server do |config|
  # Redisの接続設定
  # REDIS_URLが設定されていない場合は、デフォルトのURLを使用
  # docker-compose.ymlで設定されたRedisコンテナに接続
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://redis:6379/1") }
end

# Sidekiqクライアント（ジョブのエンキュー側）の設定
Sidekiq.configure_client do |config|
  # サーバーと同じRedis接続設定を使用
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://redis:6379/1") }
end

# SidekiqのWeb UIのセキュリティ設定
# 本番環境でのみ基本認証を有効化
Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  # ユーザー名とパスワードの安全な比較
  # タイミング攻撃を防ぐためにsecure_compareを使用
  # SHA256でハッシュ化して比較
  ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(user),
    ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])
  ) &
  ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(password),
    ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"])
  )
end if Rails.env.production?
