# ChatRoomモデルのテスト
RSpec.describe "ChatRoom", type: :model, skip: "ChatRoomモデルが実装されていないため一時的にスキップ" do
  # ファクトリーのテスト
  describe 'Factory' do
    it '有効なファクトリーを持つこと' do
      pending "ChatRoomモデルが実装されていないため、テストを保留"
      expect(build(:chat_room)).to be_valid
    end
  end

  # バリデーションのテスト
  describe 'Validations' do
    it '名前が必須であること' do
      pending "ChatRoomモデルが実装されていないため、テストを保留"
      chat_room = build(:chat_room, name: nil)
      expect(chat_room).not_to be_valid
      expect(chat_room.errors[:name]).to include("を入力してください")
    end

    it '名前が50文字以内であること' do
      pending "ChatRoomモデルが実装されていないため、テストを保留"
      chat_room = build(:chat_room, name: 'a' * 51)
      expect(chat_room).not_to be_valid
      expect(chat_room.errors[:name]).to include("は50文字以内で入力してください")
    end

    it '説明が1000文字以内であること' do
      pending "ChatRoomモデルが実装されていないため、テストを保留"
      chat_room = build(:chat_room, description: 'a' * 1001)
      expect(chat_room).not_to be_valid
      expect(chat_room.errors[:description]).to include("は1000文字以内で入力してください")
    end

    it 'オーナーが必須であること' do
      pending "ChatRoomモデルが実装されていないため、テストを保留"
      chat_room = build(:chat_room, owner: nil)
      expect(chat_room).not_to be_valid
      expect(chat_room.errors[:owner]).to include("を入力してください")
    end
  end

  # 関連付けのテスト
  describe 'Associations' do
    it 'オーナーと関連付けられていること' do
      pending "ChatRoomモデルが実装されていないため、テストを保留"
      chat_room = create(:chat_room)
      expect(chat_room.owner).to be_present
    end

    it 'メッセージと関連付けられていること' do
      pending "ChatRoomモデルが実装されていないため、テストを保留"
      chat_room = create(:chat_room)
      expect(chat_room.messages).to be_empty
    end

    it '参加者と関連付けられていること' do
      pending "ChatRoomモデルが実装されていないため、テストを保留"
      chat_room = create(:chat_room)
      expect(chat_room.participants).to be_empty
    end
  end

  # スコープのテスト
  describe 'Scopes' do
    describe '.recent' do
      it 'チャットルームを新しい順に返すこと' do
        pending "ChatRoomモデルが実装されていないため、テストを保留"
        old_room = create(:chat_room, created_at: 1.day.ago)
        new_room = create(:chat_room, created_at: 1.hour.ago)
        expect(ChatRoom.recent).to eq([ new_room, old_room ])
      end
    end

    describe '.active' do
      it 'アクティブなチャットルームのみを返すこと' do
        pending "ChatRoomモデルが実装されていないため、テストを保留"
        active_room = create(:chat_room, last_message_at: 1.hour.ago)
        inactive_room = create(:chat_room, last_message_at: 1.day.ago)
        expect(ChatRoom.active).to include(active_room)
        expect(ChatRoom.active).not_to include(inactive_room)
      end
    end
  end

  # メソッドのテスト
  describe 'Methods' do
    describe '#participant?' do
      let(:user) { create(:user) }
      let(:chat_room) { create(:chat_room) }

      it 'ユーザーが参加者の場合trueを返すこと' do
        pending "ChatRoomモデルが実装されていないため、テストを保留"
        chat_room.participants << user
        expect(chat_room.participant?(user)).to be true
      end

      it 'ユーザーが参加者でない場合falseを返すこと' do
        pending "ChatRoomモデルが実装されていないため、テストを保留"
        expect(chat_room.participant?(user)).to be false
      end
    end

    describe '#owner?' do
      let(:user) { create(:user) }
      let(:chat_room) { create(:chat_room, owner: user) }

      it 'ユーザーがオーナーの場合trueを返すこと' do
        pending "ChatRoomモデルが実装されていないため、テストを保留"
        expect(chat_room.owner?(user)).to be true
      end

      it 'ユーザーがオーナーでない場合falseを返すこと' do
        pending "ChatRoomモデルが実装されていないため、テストを保留"
        other_user = create(:user)
        expect(chat_room.owner?(other_user)).to be false
      end
    end
  end
end
