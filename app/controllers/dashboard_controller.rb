# ダッシュボードコントローラー
# ユーザーのダッシュボード画面に関する処理を担当
class DashboardController < ApplicationController
  # Deviseの認証機能を使用
  # ログインしていないユーザーはログインページにリダイレクト
  before_action :authenticate_user!

  # ダッシュボードのトップページを表示するアクション
  # GET /dashboard
  # @return [void]
  def index
    # 現在ログインしているユーザーの情報を取得
    # @user [User] - ログインユーザーのインスタンス
    # current_userはDeviseが提供するヘルパーメソッド
    @user = current_user
  end
end 