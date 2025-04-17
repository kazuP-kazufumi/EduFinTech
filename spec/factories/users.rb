FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    name { "テストユーザー" }
    bio { "テストの自己紹介" }
    
    # ユーザーを確認済みにする
    confirmed_at { Time.current }
    
    # Deviseの確認メール送信をスキップするための設定
    after(:build) do |user|
      user.skip_confirmation!
      user.skip_confirmation_notification!
    end
  end
end
