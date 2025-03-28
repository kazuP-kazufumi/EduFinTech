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
      expect(user.errors[:email]).to include("を入力してください")
    end

    it 'メールアドレスが一意であること' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    it 'パスワードが必須であること' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("を入力してください")
    end

    it 'パスワードが6文字以上であること' do
      user = build(:user, password: '12345')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end

    it 'パスワードとパスワード確認が一致すること' do
      user = build(:user, password: 'password123', password_confirmation: 'different')
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
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
        admin = create(:user, :admin)
        regular_user = create(:user)
        expect(User.admins).to include(admin)
        expect(User.admins).not_to include(regular_user)
      end
    end
  end

  # メソッドのテスト
  describe 'Methods' do
    describe '#admin?' do
      it '管理者ユーザーの場合trueを返すこと' do
        admin = create(:user, :admin)
        expect(admin.admin?).to be true
      end

      it '一般ユーザーの場合falseを返すこと' do
        user = create(:user)
        expect(user.admin?).to be false
      end
    end
  end
end 