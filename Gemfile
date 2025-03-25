# アプリケーションの依存gemを管理するGemfile
# RubyGemsからgemをダウンロードする設定
source "https://rubygems.org"

# Railsフレームワーク本体
# ~> 8.0.2は8.0.2以上8.1.0未満のバージョンを許容
gem "rails", "~> 8.0.2"

# アセットパイプライン - JavaScriptやCSSの管理・配信を担当
gem "propshaft"

# PostgreSQLデータベースアダプター
gem "pg", "~> 1.1"

# Rubyベースの軽量・高速なWebサーバー
gem "puma", ">= 5.0"

# JavaScriptモジュールをインポートマップで管理
gem "importmap-rails"

# Hotwireフレームワークの構成要素:
# Turbo - ページ遷移を高速化するSPA風フレームワーク
gem "turbo-rails"
# Stimulus - 軽量なJavaScriptフレームワーク
gem "stimulus-rails"

# JSON APIを簡単に構築するためのビルダー
gem "jbuilder"

# 認証機能
gem "devise"

# 認可(権限)管理
gem "pundit"

# 非同期処理関連:
gem "sidekiq"     # バックグラウンドジョブ処理
gem "redis"       # KVSデータストア
gem "redis-session-store" # セッション管理にRedisを使用

# Windows環境用のタイムゾーンデータ
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Rails機能のキャッシュ管理:
gem "solid_cache"   # キャッシュストア
gem "solid_queue"   # ジョブキュー
gem "solid_cable"   # Action Cable

# 起動時間を短縮するブートローダー
gem "bootsnap", require: false

# Dockerデプロイメント管理ツール
gem "kamal", require: false

# Pumaサーバーのパフォーマンス最適化
gem "thruster", require: false

# 開発環境とテスト環境でのみ使用するgem
group :development, :test do
  # デバッグツール
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # セキュリティ脆弱性スキャナー
  gem "brakeman", require: false

  # Rubyコードスタイルチェッカー
  gem "rubocop-rails-omakase", require: false

  # テスト関連:
  gem "rspec-rails"          # RSpecテストフレームワーク
  gem "factory_bot_rails"    # テストデータ作成
  gem "faker"                # ダミーデータ生成
end

# 開発環境でのみ使用するgem
group :development do
  # エラーページでのデバッグコンソール
  gem "web-console"
end

# テスト環境でのみ使用するgem
group :test do
  # システムテスト用:
  gem "capybara"            # ブラウザシミュレーション
  gem "selenium-webdriver"  # ブラウザ制御
  gem "shoulda-matchers"    # テストマッチャー拡張
end
