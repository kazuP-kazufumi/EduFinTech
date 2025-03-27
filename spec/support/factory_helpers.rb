# テストデータ生成用のヘルパーメソッド
module FactoryHelpers
  # テスト用の投稿を作成する
  def create_test_post(user: nil, title: 'テスト投稿', content: 'テスト内容')
    user ||= create(:user)
    create(:post, user: user, title: title, content: content)
  end

  # テスト用のチャットルームを作成する
  def create_test_chat_room(owner: nil, name: 'テストチャットルーム')
    owner ||= create(:user)
    create(:chat_room, owner: owner, name: name)
  end

  # テスト用のメッセージを作成する
  def create_test_message(user: nil, chat_room: nil, content: 'テストメッセージ')
    user ||= create(:user)
    chat_room ||= create(:chat_room)
    create(:message, user: user, chat_room: chat_room, content: content)
  end

  # テスト用の通知を作成する
  def create_test_notification(user: nil, sender: nil, post: nil, notification_type: :like)
    user ||= create(:user)
    sender ||= create(:user)
    post ||= create(:post)
    create(:notification, user: user, sender: sender, post: post, notification_type: notification_type)
  end
end

# リクエストスペック用のヘルパー
RSpec.configure do |config|
  config.include FactoryHelpers, type: :request
end

# システムスペック用のヘルパー
RSpec.configure do |config|
  config.include FactoryHelpers, type: :system
end 