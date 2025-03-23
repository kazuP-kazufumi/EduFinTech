# Redisの設定
# 環境変数REDIS_URLが設定されていない場合は、デフォルトのURLを使用します
# redis://redis:6379/1 の内訳:
# - redis:// : Redisプロトコル
# - redis : ホスト名（docker-compose.ymlで定義されたRedisコンテナ名）
# - 6379 : デフォルトのRedisポート番号
# - /1 : データベース番号（0-15の範囲で選択可能）
redis_url = ENV.fetch('REDIS_URL', 'redis://redis:6379/1')

# Redis接続の設定
# アプリケーション全体で使用するRedisインスタンスを設定
# config.redisに保存することで、他の場所からRails.application.config.redisでアクセス可能
Rails.application.config.redis = Redis.new(url: redis_url)

# セッションストアとしてRedisを使用
# :redis_store - Redisをセッションストアとして使用するための設定
# servers: 接続先のRedisサーバー（複数指定可能）
# expire_after: セッションの有効期限（1日）
# key: セッションを識別するためのキープレフィックス
Rails.application.config.session_store :redis_store,
  servers: [redis_url],
  expire_after: 1.day,
  key: '_edufintech_session'

# キャッシュストアとしてRedisを使用
# :redis_cache_store - Rails.cacheのバックエンドとしてRedisを使用
# url: 接続先のRedisサーバー
# namespace: キャッシュキーの名前空間（アプリケーション名で区別）
# expires_in: キャッシュの有効期限（1日）
Rails.application.config.cache_store = :redis_cache_store, {
  url: redis_url,
  namespace: 'edufintech:cache',
  expires_in: 1.day
} 