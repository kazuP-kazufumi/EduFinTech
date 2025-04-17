FactoryBot.define do
  factory :chat_room do
    sequence(:name) { |n| "チャットルーム #{n}" }
    description { "テストチャットルームの説明" }
    status { :active }
    association :owner, factory: :user
  end
end
