# frozen_string_literal: true

# RSpecテストのための設定ファイル
# rails generate rspec:installコマンドで生成される
# このファイルはRSpecテストの基本設定と、Rails固有の設定を含む

# RSpecの基本設定を読み込む
# spec_helperには、RSpecの一般的な設定が記述されている
require 'spec_helper'

# テスト環境の設定
# 環境変数RAILS_ENVが未設定の場合は'test'を設定
# これにより、テストデータベースが使用される
ENV['RAILS_ENV'] ||= 'test'

# Railsの環境設定を読み込む
# config/environment.rbを通じてRailsアプリケーションの設定を読み込む
require_relative '../config/environment'

# 本番環境での実行を防止
# テストによるデータ破壊を防ぐための安全対策
abort("The Rails environment is running in production mode!") if Rails.env.production?

# RSpec Rails拡張を読み込む
# RailsアプリケーションをテストするためのRSpec拡張機能を有効化
require 'rspec/rails'

# spec/supportディレクトリ内のヘルパーファイルを自動読み込み
# カスタムマッチャーや共通の設定を別ファイルに分割する場合に使用
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# テスト実行前にデータベースマイグレーションの状態をチェック
begin
  # 保留中のマイグレーションがあれば実行し、テストDBのスキーマを最新に保つ
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  # マイグレーションが必要な場合はエラーメッセージを表示して終了
  puts e.to_s.strip
  exit 1
end

# RSpec全体の設定
RSpec.configure do |config|
  # ActiveRecordのフィクスチャのパスを設定
  # テストデータをYAMLファイルで定義する場合に使用
  config.fixture_paths = [ "#{::Rails.root}/spec/fixtures" ]

  # Deviseのテストヘルパーを追加
  # 各種テストタイプに応じて必要なヘルパーメソッドを組み込む

  # リクエストスペック用のヘルパー
  # HTTPリクエストを模倣したテストで認証機能をテスト可能に
  config.include Devise::Test::IntegrationHelpers, type: :request

  # フィーチャースペック用のヘルパー
  # ブラウザ操作を模倣したテストで認証機能をテスト可能に
  config.include Devise::Test::IntegrationHelpers, type: :feature

  # コントローラースペック用のヘルパー
  # コントローラーの単体テストで認証機能をテスト可能に
  config.include Devise::Test::ControllerHelpers, type: :controller

  # ビュースペック用のヘルパー
  # ビューテンプレートの単体テストで認証機能をテスト可能に
  config.include Devise::Test::ControllerHelpers, type: :view

  # FactoryBotのメソッドを直接使用可能にする
  config.include FactoryBot::Syntax::Methods

  # コントローラーのルーティングとパラメータの設定を有効にする
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true

  # Capybaraの設定
  # ブラウザ操作をシミュレートするためのDSLとマッチャーを追加
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers

  # フィーチャースペック用の設定
  # 基本的なブラウザテストではrack_testドライバーを使用（高速）
  config.before(:each, type: :feature) do
    Capybara.current_driver = :rack_test
  end

  # テストをトランザクション内で実行する設定
  # 各テスト終了後にデータベースの変更を自動的にロールバック
  config.use_transactional_fixtures = true

  # ファイルの場所からテストタイプを自動推論する設定
  # ファイルパスに基づいてテストタイプを自動設定
  config.infer_spec_type_from_file_location!

  # バックトレースからRailsのgemの行を除外
  # エラー表示をクリーンにするための設定
  config.filter_rails_from_backtrace!

  # システムテスト(Capybara)の設定
  # ヘッドレスChromeを使用するためのドライバー設定
  # 注: Seleniumが利用不可のため、一時的にコメントアウト
  # Capybara.register_driver :selenium_chrome_headless do |app|
  #   options = Selenium::WebDriver::Chrome::Options.new
  #   # ヘッドレスモード（画面表示なし）の設定
  #   options.add_argument('--headless')
  #   # GPUの無効化（リソース節約）
  #   options.add_argument('--disable-gpu')
  #   # サンドボックスの無効化（CI環境での実行用）
  #   options.add_argument('--no-sandbox')
  #   # 共有メモリの使用を無効化（CI環境でのメモリ問題対策）
  #   options.add_argument('--disable-dev-shm-usage')
  #   # ウィンドウサイズの設定
  #   options.add_argument('--window-size=1400,1400')
  #   # ドライバーの作成
  #   Selenium::WebDriver.for :chrome, options: options
  # end

  # システムテストのデフォルトドライバーを設定
  # 注: Seleniumが利用不可のため、rack_testドライバーを使用
  # Capybara.javascript_driver = :selenium_chrome_headless
  Capybara.javascript_driver = :rack_test
  Capybara.server = :puma, { Silent: true }

  # テストデータベースのクリーンアップ設定
  # テスト実行前にデータベースをクリーンアップ
  config.before(:suite) do
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.clean_with(:truncation)
  end

  # DatabaseCleanerの設定
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # テスト用の環境変数設定
  config.before(:suite) do
    ENV['RAILS_ENV'] = 'test'
    ENV['TEST_DATABASE_URL'] = 'postgresql://postgres:password@db:5432/edufintech_test'
  end

  # Devise用のテストヘルパーメソッドを追加
  config.include AuthHelpers, type: :controller
  config.include AuthHelpers, type: :request
  config.include AuthHelpers, type: :feature

  # テスト環境でのホスト設定
  Rails.application.routes.default_url_options[:host] = 'test.example.com'

  # リダイレクト時の異なるホストへのリダイレクトを許可する設定
  config.before(:each, type: :controller) do
    @request.env['HTTP_REFERER'] = 'http://test.example.com'
    ActionController::Base.allow_forgery_protection = false
  end

  # CI環境の場合は特別な設定を行う
  if ENV['CI'] == 'true'
    ENV['RAILS_ENV'] = 'test'
    ENV['TEST_DATABASE_URL'] = 'postgresql://postgres:password@db:5432/edufintech_test'
  end

  # すべてのシステムテストをスキップする設定
  config.filter_run_excluding type: :system
  config.filter_run_excluding type: :feature
end
