Rails.application.routes.draw do
  # Deviseを使用したユーザー認証のルーティング設定
  # - path: ''でURLからdeviseを除去 (例: /users/sign_in → /login)
  # - path_namesで各アクションのパス名をカスタマイズ
  devise_for :users, path: '', path_names: {
    sign_up: 'signup',     # 新規登録
    sign_in: 'login',      # ログイン
    sign_out: 'logout',    # ログアウト
    password: 'password',  # パスワード変更/リセット
    confirmation: 'verification', # メール確認
    unlock: 'unblock'      # アカウントロック解除
  }

  # ヘルスチェックエンドポイント
  # - /up へのGETリクエストでアプリケーションの状態を確認
  # - rails_health_checkという名前付きルートを生成
  # - Railsが提供する組み込みのヘルスチェック機能を使用
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA関連のルーティング(現在は無効)
  # Progressive Web App用のマニフェストとサービスワーカーを提供するためのルート
  # 必要に応じてコメントを解除して有効化可能
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # ダッシュボードページのルーティング
  # - /dashboard へのGETリクエストをDashboardController#indexにルーティング
  # - dashboard_pathというヘルパーメソッドが生成される
  # - 例: <%= link_to 'ダッシュボード', dashboard_path %>
  get 'dashboard', to: 'dashboard#index', as: :dashboard

  # Sidekiqの管理画面のマウント
  # - /sidekiq にSidekiq::Webをマウント
  # - バックグラウンドジョブの状態確認、再実行、削除などが可能
  # - 本番環境では適切なアクセス制限が必要
  mount Sidekiq::Web => '/sidekiq'

  # ルートパス(/)の設定
  # - アプリケーションのトップページとしてHomeController#indexを使用
  # - root_pathというヘルパーメソッドが生成される
  root 'home#index'
end
