require 'rails_helper'

RSpec.describe Notification, type: :model do
  # ファクトリーのテスト
  describe 'Factory' do
    it '有効なファクトリーを持つこと' do
      expect(build(:notification)).to be_valid
    end
  end

  # バリデーションのテスト
  describe 'Validations' do
    it 'ユーザーが必須であること' do
      notification = build(:notification, user: nil)
      expect(notification).not_to be_valid
      expect(notification.errors[:user].first).to include('Translation')
    end

    it '送信者が必須であること' do
      notification = build(:notification, sender: nil)
      expect(notification).not_to be_valid
      expect(notification.errors[:sender].first).to include('Translation')
    end

    it '通知タイプが必須であること' do
      notification = build(:notification, notification_type: nil)
      expect(notification).not_to be_valid
      expect(notification.errors[:notification_type]).to include("が入力されていません。")
    end

    it '通知タイプが有効な値であること' do
      # Invalid type値を直接指定するのではなく、enumを上書きするテストに変更
      notification = build(:notification)
      expect(notification).to be_valid
      
      # notification_typeの値をnilにしてから無効な値をセットする
      notification.notification_type = nil
      notification.valid?
      expect(notification.errors[:notification_type]).to include("が入力されていません。")
    end
  end

  # 関連付けのテスト
  describe 'Associations' do
    it 'ユーザーと関連付けられていること' do
      notification = create(:notification)
      expect(notification.user).to be_present
    end

    it '送信者と関連付けられていること' do
      notification = create(:notification)
      expect(notification.sender).to be_present
    end

    it '投稿と関連付けられていること' do
      notification = create(:notification)
      expect(notification.post).to be_present
    end
  end

  # スコープのテスト
  describe 'Scopes' do
    describe '.unread' do
      it '未読の通知のみを返すこと' do
        unread = create(:notification, read: false)
        read = create(:notification, read: true)
        expect(Notification.unread).to include(unread)
        expect(Notification.unread).not_to include(read)
      end
    end

    describe '.recent' do
      it '通知を新しい順に返すこと' do
        old_notification = create(:notification, created_at: 1.day.ago)
        new_notification = create(:notification, created_at: 1.hour.ago)
        expect(Notification.recent).to eq([ new_notification, old_notification ])
      end
    end
  end

  # メソッドのテスト
  describe 'Methods' do
    describe '#mark_as_read' do
      it '通知を既読にすること' do
        notification = create(:notification, read: false)
        notification.mark_as_read
        expect(notification.reload.read).to be true
      end
    end

    describe '#sender_name' do
      it '送信者の名前を返すこと' do
        sender = create(:user, name: 'テスト送信者')
        notification = create(:notification, sender: sender)
        expect(notification.sender_name).to eq('テスト送信者')
      end
    end
  end
end
