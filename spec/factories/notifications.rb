FactoryBot.define do
  factory :notification do
    user { nil }
    sender { nil }
    post { nil }
    notification_type { 1 }
    read { false }
  end
end
