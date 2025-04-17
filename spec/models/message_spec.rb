# Messageモデルのテスト
RSpec.describe "Message", type: :model, skip: "Messageモデルが実装されていないため一時的にスキップ" do
  # ファクトリーのテスト
  describe 'Factory' do
    it '有効なファクトリーを持つこと' do
      pending "Messageモデルが実装されていないため、テストを保留"
      expect(build(:message)).to be_valid
    end
  end

  # バリデーションのテスト
  describe 'Validations' do
    it '内容が必須であること' do
      pending "Messageモデルが実装されていないため、テストを保留"
      message = build(:message, content: nil)
      expect(message).not_to be_valid
      expect(message.errors[:content]).to include("を入力してください")
    end

    it '内容が1000文字以内であること' do
      pending "Messageモデルが実装されていないため、テストを保留"
      message = build(:message, content: 'a' * 1001)
      expect(message).not_to be_valid
      expect(message.errors[:content]).to include("は1000文字以内で入力してください")
    end

    it 'ユーザーが必須であること' do
      pending "Messageモデルが実装されていないため、テストを保留"
      message = build(:message, user: nil)
      expect(message).not_to be_valid
      expect(message.errors[:user]).to include("を入力してください")
    end

    it 'チャットルームが必須であること' do
      pending "Messageモデルが実装されていないため、テストを保留"
      message = build(:message, chat_room: nil)
      expect(message).not_to be_valid
      expect(message.errors[:chat_room]).to include("を入力してください")
    end
  end

  # 関連付けのテスト
  describe 'Associations' do
    it 'ユーザーと関連付けられていること' do
      pending "Messageモデルが実装されていないため、テストを保留"
      message = create(:message)
      expect(message.user).to be_present
    end

    it 'チャットルームと関連付けられていること' do
      pending "Messageモデルが実装されていないため、テストを保留"
      message = create(:message)
      expect(message.chat_room).to be_present
    end
  end

  # スコープのテスト
  describe 'Scopes' do
    describe '.recent' do
      it 'メッセージを新しい順に返すこと' do
        pending "Messageモデルが実装されていないため、テストを保留"
        old_message = create(:message, created_at: 1.day.ago)
        new_message = create(:message, created_at: 1.hour.ago)
        expect(Message.recent).to eq([ new_message, old_message ])
      end
    end
  end

  # コールバックのテスト
  describe 'Callbacks' do
    describe 'after_create' do
      it 'チャットルームのlast_message_atを更新すること' do
        pending "Messageモデルが実装されていないため、テストを保留"
        chat_room = create(:chat_room)
        old_time = chat_room.last_message_at
        create(:message, chat_room: chat_room)
        expect(chat_room.reload.last_message_at).to be > old_time
      end
    end
  end

  # メソッドのテスト
  describe 'Methods' do
    describe '#sender_name' do
      it '送信者の名前を返すこと' do
        pending "Messageモデルが実装されていないため、テストを保留"
        user = create(:user, name: 'テスト送信者')
        message = create(:message, user: user)
        expect(message.sender_name).to eq('テスト送信者')
      end
    end
  end
end
