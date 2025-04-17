FactoryBot.define do
  factory :notification do
    association :user
    association :sender, factory: :user
    association :post
    notification_type { :support_request }
    read { false }

    trait :with_different_sender do
      association :sender, factory: :user
    end
  end
end
