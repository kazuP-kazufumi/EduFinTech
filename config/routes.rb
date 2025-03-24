Rails.application.routes.draw do
  # Deviseを使用したユーザー認証のルーティング設定
  # - サインアップ、ログイン、ログアウト、パスワードリセットなどのルートを自動生成
  devise_for :users

  # アプリケーションのルーティングをDSLで定義
  # 詳細は https://guides.rubyonrails.org/routing.html を参照

  # ヘルスチェック用のエンドポイント
  # - /up にGETリクエストを送ると、アプリケーションの状態を確認できる
  # - 正常起動時は200、エラー時は500を返す
  # - ロードバランサーやアップタイムモニターで使用可能
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA(Progressive Web App)関連のルーティング
  # app/views/pwa/* から動的にPWAファイルを生成
  # - マニフェストファイルとサービスワーカーのルートを提供
  # - 注意: application.html.erbでマニフェストのリンクが必要
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # ダッシュボードページへのルーティング
  # - URLパス: /dashboard
  # - コントローラー: DashboardController
  # - アクション: index
  # - パス名: dashboard_path
  get 'dashboard', to: 'dashboard#index', as: :dashboard

  # ルートパス("/")のルーティング設定
  # 現在はコメントアウトされており、未設定
  # root "posts#index"

  # Sidekiqの管理画面(Web UI)のマウント
  # - Rackベースの管理インターフェースをRailsアプリに統合
  # - URLパス: /sidekiq
  # - Sidekiq::Web: バックグラウンドジョブの監視・管理用インターフェース
  # - アクセス例: http://アプリのドメイン/sidekiq
  mount Sidekiq::Web => '/sidekiq'
end
