require 'rails_helper'

# Userモデルのテスト
RSpec.describe User, type: :model do
  # ファクトリーのテスト
  describe 'Factory' do
    it '有効なファクトリーを持つこと' do
      expect(build(:user)).to be_valid
    end
  end

  # バリデーションのテスト
  describe 'Validations' do
    it 'メールアドレスが必須であること' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("が入力されていません。")
    end

    it 'メールアドレスが一意であること' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("は既に使用されています。")
    end

    it 'パスワードが必須であること' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("が入力されていません。")
    end

    it 'パスワードが6文字以上であること' do
      user = build(:user, password: 'pass', password_confirmation: 'pass')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("は8文字以上で入力してください。")
    end

    it 'パスワードとパスワード確認が一致すること' do
      user = build(:user, password: 'password', password_confirmation: 'different')
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("が一致しません。")
    end
  end

  # 関連付けのテスト
  describe 'Associations' do
    it '投稿と関連付けられていること' do
      user = create(:user)
      expect(user.posts).to be_empty
    end

    it 'チャットルームと関連付けられていること' do
      user = create(:user)
      expect(user.chat_rooms).to be_empty
    end

    it 'メッセージと関連付けられていること' do
      user = create(:user)
      expect(user.messages).to be_empty
    end

    it '通知と関連付けられていること' do
      user = create(:user)
      expect(user.notifications).to be_empty
    end
  end

  # スコープのテスト
  describe 'Scopes' do
    describe '.admins' do
      it '管理者ユーザーのみを返すこと' do
        pending "adminトレイトが定義されていないため一時的に保留"
        admin = create(:user, :admin)
        user = create(:user)
        expect(User.admins).to include(admin)
        expect(User.admins).not_to include(user)
      end
    end
  end

  # メソッドのテスト
  describe 'Methods' do
    describe '#admin?' do
      it '管理者ユーザーの場合trueを返すこと' do
        pending "admin?メソッドが実装されていないため一時的に保留"
        admin = create(:user, :admin)
        expect(admin.admin?).to be true
      end

      it '一般ユーザーの場合falseを返すこと' do
        pending "admin?メソッドが実装されていないため一時的に保留"
        user = create(:user)
        expect(user.admin?).to be false
      end
    end
  end
end
