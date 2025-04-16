FactoryBot.define do
  factory :chat_room do
    sequence(:title) { |n| "チャットルーム #{n}" }
    association :user
  end
end
