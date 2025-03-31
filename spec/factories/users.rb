FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    name { "テストユーザー" }
    bio { "テストの自己紹介" }
  end
end 