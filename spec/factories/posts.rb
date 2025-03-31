FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "テスト投稿#{n}" }
    sequence(:content) { |n| "テスト内容#{n}" }
    category { "education" }
    association :user
  end
end
