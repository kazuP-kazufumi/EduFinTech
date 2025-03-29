# Railsアプリケーションの起動に必要な基本設定ファイルを読み込み
# config/boot.rbには、Bundlerの設定やGemfileの読み込みなどの基本設定が含まれる
require_relative "boot"

# Railsの全機能を読み込む
# rails/allには以下のような主要なフレームワークが含まれる:
# - Active Record: データベースとのやり取りを担当するORM
# - Action Controller: リクエスト処理とルーティングを制御
# - Action View: ビューテンプレートの描画を担当
# - Action Mailer: メール送信機能を提供
# - Active Storage: ファイルアップロード機能を提供
# - Action Cable: WebSocketによるリアルタイム通信を実現
require "rails/all"

# Gemfileに記載された全てのgemを環境ごとに読み込む
# Rails.groupsは現在の実行環境(development/test/production)を返す
# *演算子で配列を展開し、各環境に必要なgemのみを読み込む
Bundler.require(*Rails.groups)

# アプリケーションの名前空間を定義
# モジュール名はアプリケーション名と一致させる
module App
  # Railsアプリケーションの主要な設定を行うクラス
  # Rails::Applicationを継承し、フレームワークの機能を利用可能にする
  class Application < Rails::Application
    # Rails 7.1の初期設定を読み込む
    # 新しいバージョンで追加された機能や設定を有効化
    # 互換性を保ちながら新機能を利用可能にする
    config.load_defaults 7.1

    # 国際化(i18n)の設定
    # アプリケーション全体の言語設定を管理
    
    # デフォルトのロケールを日本語(:ja)に設定
    # ユーザーが言語を選択していない場合のデフォルト値となる
    config.i18n.default_locale = :ja
    
    # アプリケーションで使用可能な言語を日本語と英語に制限
    # システムがサポートする言語を明示的に指定
    config.i18n.available_locales = [ :ja, :en ]
    
    # 翻訳ファイルの配置場所を指定
    # config/locales以下の全サブディレクトリから.rbと.ymlファイルを読み込む
    # 言語ファイルを階層的に整理可能にする
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]

    # libディレクトリの自動読み込み設定
    # アプリケーション固有のライブラリコードを管理
    # assets: アセットパイプライン関連のファイル
    # tasks: Rakeタスク
    # templates: ジェネレータのテンプレート
    # これらのディレクトリは.rbファイルを含まないため、自動読み込みから除外
    config.autoload_lib(ignore: %w[assets tasks templates])

    # タイムゾーンを東京に設定
    # 日時の表示や保存を日本時間で行う
    config.time_zone = 'Tokyo'

    # タイムゾーンの保持方法を設定
    # Rails 8.1での非推奨警告に対応
    config.active_support.to_time_preserves_timezone = :zone

    # Active Storageの設定
    # ファイルアップロード機能のカスタマイズ
    
    # 画像処理にmini_magickを使用
    # ImageMagickを使用して画像のリサイズなどの処理を行う
    config.active_storage.variant_processor = :mini_magick
    
    # ストレージへのルーティングをプロキシ経由に設定
    # セキュアなファイルアクセスを実現
    config.active_storage.resolve_model_to_route = :rails_storage_proxy
  end
end
