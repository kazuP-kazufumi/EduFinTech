Rails.application.routes.draw do
  get "messages/create"
  get "chat_rooms/create"
  get "notifications/create"
  # 投稿のリソースルーティング
  # resources :postsは以下の7つのRESTfulなルートを自動生成します:
  #
  # HTTPメソッド | パス           | コントローラ#アクション | 用途
  # GET         | /posts        | posts#index           | 投稿一覧の表示
  # GET         | /posts/new    | posts#new             | 新規投稿フォームの表示
  # POST        | /posts        | posts#create          | 新規投稿の作成
  # GET         | /posts/:id    | posts#show            | 個別投稿の表示
  # GET         | /posts/:id/edit| posts#edit           | 投稿編集フォームの表示
  # PATCH/PUT   | /posts/:id    | posts#update          | 投稿の更新
  # DELETE      | /posts/:id    | posts#destroy         | 投稿の削除
  #
  # また、以下のような便利なヘルパーメソッドも自動生成されます:
  # - posts_path          -> /posts へのパス
  # - new_post_path       -> /posts/new へのパス
  # - edit_post_path(id)  -> /posts/:id/edit へのパス
  # - post_path(id)       -> /posts/:id へのパス
  #
  # このルーティングはapp/controllers/posts_controller.rbと連携して動作し、
  # Post モデル（app/models/post.rb）のCRUD操作を実現します。
  resources :posts do
    resources :notifications, only: [:create]
  end

  # 通知機能に関するルーティング設定
  # - indexアクションのみを有効化し、通知一覧の表示機能を提供
  # - /notifications へのGETリクエストで通知一覧を表示
  resources :notifications, only: [:index] do
    # memberブロックで個別の通知に対するカスタムルートを定義
    member do
      # 通知を既読状態にするためのルート
      # - /notifications/:id/mark_as_read へのPATCHリクエストで
      # - 指定されたIDの通知を既読状態に更新
      # - NotificationsController#mark_as_readアクションにルーティング
      patch :mark_as_read
    end
  end

  # Deviseを使用したユーザー認証のルーティング設定
  # - path: ''でURLからdeviseを除去 (例: /users/sign_in → /login)
  # - path_namesで各アクションのパス名をカスタマイズ
  devise_for :users, path: "", path_names: {
    sign_up: "signup",     # 新規登録
    sign_in: "login",      # ログイン
    sign_out: "logout",    # ログアウト
    password: "password",  # パスワード変更/リセット
    confirmation: "verification", # メール確認
    unlock: "unblock"      # アカウントロック解除
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
  get "dashboard", to: "dashboard#index", as: :dashboard

  # Sidekiqの管理画面のマウント
  # - /sidekiq にSidekiq::Webをマウント
  # - バックグラウンドジョブの状態確認、再実行、削除などが可能
  # - 本番環境では適切なアクセス制限が必要
  mount Sidekiq::Web => "/sidekiq"

  # チャットルームのルーティング
  # チャットルーム関連のルーティング設定
  resources :chat_rooms, only: [:index, :create, :show] do
    # - indexアクション: チャットルーム一覧の表示 (GET /chat_rooms)
    # - createアクション: 新規チャットルームの作成 (POST /chat_rooms)
    # - showアクション: 個別のチャットルームの表示 (GET /chat_rooms/:id)
    
    # チャットルーム内のメッセージ関連のルーティング
    # - ネストされたリソースとして定義
    # - /chat_rooms/:chat_room_id/messages の形式のURLを生成
    resources :messages, only: [:create] do
      # - createアクションのみを有効化
      # - チャットルーム内でのメッセージ作成機能を提供
      # - POST /chat_rooms/:chat_room_id/messages へのリクエストで
      #   MessagesController#createアクションを実行
    end
  end

  # ルートパス(/)の設定
  # - アプリケーションのトップページとしてHomeController#indexを使用
  # - root_pathというヘルパーメソッドが生成される
  root "home#index"
end
