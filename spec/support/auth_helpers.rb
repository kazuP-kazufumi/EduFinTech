# 認証関連のヘルパーメソッド
module AuthHelpers
  # テストユーザーを作成してログインする
  def sign_in_test_user
    @user = create(:user)
    sign_in @user
  end

  # 管理者ユーザーを作成してログインする
  def sign_in_admin
    @admin = create(:user, :admin)
    sign_in @admin
  end

  # ログアウトする
  def sign_out_user
    sign_out :user
  end
end

# リクエストスペック用のヘルパー
RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end

# システムスペック用のヘルパー
RSpec.configure do |config|
  config.include AuthHelpers, type: :system
end

# コントローラースペック用のヘルパー
RSpec.configure do |config|
  config.include AuthHelpers, type: :controller
end
