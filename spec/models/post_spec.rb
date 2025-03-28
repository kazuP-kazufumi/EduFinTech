require 'rails_helper'

RSpec.describe Post, type: :model do
  # ファクトリーのテスト
  describe 'Factory' do
    it '有効なファクトリーを持つこと' do
      expect(build(:post)).to be_valid
    end
  end

  # バリデーションのテスト
  describe 'Validations' do
    it 'タイトルが必須であること' do
      post = build(:post, title: nil)
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("を入力してください")
    end

    it 'タイトルが50文字以内であること' do
      post = build(:post, title: 'a' * 51)
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("は50文字以内で入力してください")
    end

    it '内容が必須であること' do
      post = build(:post, content: nil)
      expect(post).not_to be_valid
      expect(post.errors[:content]).to include("を入力してください")
    end

    it '内容が1000文字以内であること' do
      post = build(:post, content: 'a' * 1001)
      expect(post).not_to be_valid
      expect(post.errors[:content]).to include("は1000文字以内で入力してください")
    end

    it 'ユーザーが必須であること' do
      post = build(:post, user: nil)
      expect(post).not_to be_valid
      expect(post.errors[:user]).to include("を入力してください")
    end
  end

  # 関連付けのテスト
  describe 'Associations' do
    it 'ユーザーと関連付けられていること' do
      post = create(:post)
      expect(post.user).to be_present
    end

    it '通知と関連付けられていること' do
      post = create(:post)
      expect(post.notifications).to be_empty
    end
  end

  # スコープのテスト
  describe 'Scopes' do
    describe '.recent' do
      it '投稿を新しい順に返すこと' do
        old_post = create(:post, created_at: 1.day.ago)
        new_post = create(:post, created_at: 1.hour.ago)
        expect(Post.recent).to eq([new_post, old_post])
      end
    end

    describe '.popular' do
      it 'いいね数が多い順に返すこと' do
        post1 = create(:post, likes_count: 10)
        post2 = create(:post, likes_count: 20)
        post3 = create(:post, likes_count: 15)
        expect(Post.popular).to eq([post2, post3, post1])
      end
    end
  end

  # メソッドのテスト
  describe 'Methods' do
    describe '#liked_by?' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }

      it 'ユーザーがいいねしている場合trueを返すこと' do
        create(:like, user: user, post: post)
        expect(post.liked_by?(user)).to be true
      end

      it 'ユーザーがいいねしていない場合falseを返すこと' do
        expect(post.liked_by?(user)).to be false
      end
    end
  end
end
