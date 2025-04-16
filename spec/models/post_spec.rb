require 'rails_helper'

RSpec.describe Post, type: :model do
  # ファクトリーのテスト
  describe 'Factory' do
    it '有効なファクトリーを持つこと' do
      expect(build(:post)).to be_valid
    end
  end

  # バリデーションのテスト
  describe 'バリデーション' do
    # タイトルのバリデーション
    describe 'タイトル' do
      it 'タイトルが空の場合は無効であること' do
        post = build(:post, title: nil)
        expect(post).not_to be_valid
        expect(post.errors[:title]).to include("を入力してください")
      end

      it 'タイトルが100文字を超える場合は無効であること' do
        post = build(:post, title: 'a' * 101)
        expect(post).not_to be_valid
        expect(post.errors[:title]).to include("は100文字以内で入力してください")
      end

      it 'タイトルが100文字以内の場合は有効であること' do
        post = build(:post, title: 'a' * 100)
        expect(post).to be_valid
      end
    end

    # 本文のバリデーション
    describe '本文' do
      it '本文が空の場合は無効であること' do
        post = build(:post, content: nil)
        expect(post).not_to be_valid
        expect(post.errors[:content]).to include("を入力してください")
      end

      it '本文が1000文字を超える場合は無効であること' do
        post = build(:post, content: 'a' * 1001)
        expect(post).not_to be_valid
        expect(post.errors[:content]).to include("は1000文字以内で入力してください")
      end

      it '本文が1000文字以内の場合は有効であること' do
        post = build(:post, content: 'a' * 1000)
        expect(post).to be_valid
      end
    end

    # カテゴリーのバリデーション
    describe 'カテゴリー' do
      it 'カテゴリーが空の場合は無効であること' do
        post = build(:post, category: nil)
        expect(post).not_to be_valid
        expect(post.errors[:category]).to include("を入力してください")
      end

      it 'カテゴリーが不正な値の場合は無効であること' do
        post = build(:post, category: '不正なカテゴリー')
        expect(post).not_to be_valid
        expect(post.errors[:category]).to include("は一覧にありません")
      end

      it 'カテゴリーが正しい値の場合は有効であること' do
        Post::CATEGORIES.each do |category|
          post = build(:post, category: category)
          expect(post).to be_valid
        end
      end
    end
  end

  # 関連付けのテスト
  describe '関連付け' do
    it 'ユーザーに属していること' do
      post = create(:post)
      expect(post.user).to be_present
    end

    it '通知と関連付けられていること' do
      post = create(:post)
      notification = create(:notification, post: post)
      expect(post.notifications).to include(notification)
    end
  end

  # スコープのテスト
  describe 'スコープ' do
    describe 'recent' do
      it '投稿を新しい順に取得すること' do
        old_post = create(:post, created_at: 1.day.ago)
        new_post = create(:post, created_at: 1.hour.ago)
        expect(Post.recent).to eq([ new_post, old_post ])
      end
    end

    describe 'by_category' do
      it 'カテゴリーで投稿をフィルタリングすること' do
        post1 = create(:post, category: '進学')
        post2 = create(:post, category: '夢')
        expect(Post.by_category('進学')).to include(post1)
        expect(Post.by_category('進学')).not_to include(post2)
      end
    end

    describe 'search' do
      it 'タイトルで検索できること' do
        post1 = create(:post, title: 'テスト投稿1')
        post2 = create(:post, title: '別の投稿')
        expect(Post.search('テスト')).to include(post1)
        expect(Post.search('テスト')).not_to include(post2)
      end

      it '本文で検索できること' do
        post1 = create(:post, content: 'テスト内容1')
        post2 = create(:post, content: '別の内容')
        expect(Post.search('テスト')).to include(post1)
        expect(Post.search('テスト')).not_to include(post2)
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
