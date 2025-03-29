FactoryBot.define do
  factory :message do
    sequence(:content) { |n| "メッセージ #{n}" }
    association :user
    association :chat_room
  end
end 