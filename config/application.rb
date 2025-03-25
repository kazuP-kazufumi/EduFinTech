# Railsアプリケーションの起動に必要な基本設定ファイルを読み込み
require_relative "boot"

# Railsの全機能を読み込む
# Active Record、Action Controller、Action View、Action Mailerなどすべてのフレームワークを含む
require "rails/all"

# Gemfileに記載された全てのgemを環境ごとに読み込む
# test、development、productionの各環境で必要なgemを自動的に判別
Bundler.require(*Rails.groups)

# アプリケーションの名前空間を定義
module App
  # Railsアプリケーションの設定クラス
  class Application < Rails::Application
    # Rails 7.1の初期設定を読み込む
    # フレームワークのデフォルト値や新機能を有効化
    config.load_defaults 7.1

    # 国際化(i18n)の設定
    # デフォルトのロケールを日本語(:ja)に設定
    config.i18n.default_locale = :ja
    # アプリケーションで使用可能な言語を日本語と英語に制限
    config.i18n.available_locales = [:ja, :en]
    # 翻訳ファイルの配置場所を指定
    # config/locales以下の全サブディレクトリから.rbと.ymlファイルを読み込む
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # libディレクトリの自動読み込み設定
    # assets、tasksディレクトリは自動読み込みから除外
    # これらのディレクトリには通常.rbファイルが含まれないため
    config.autoload_lib(ignore: %w[assets tasks])

    # アプリケーション、エンジン、railtiesの追加設定はここに記述
    #
    # これらの設定は環境固有の設定ファイル(config/environments/*)で
    # 上書きすることが可能
    #
    # タイムゾーンの設定例（コメントアウト中）
    # config.time_zone = "Central Time (US & Canada)"
    # 追加のautoload pathの設定例（コメントアウト中）
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
