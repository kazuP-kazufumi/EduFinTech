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
    describe 'タイトル' do
      it 'タイトルが空の場合は無効であること' do
        post = build(:post, title: nil)
        expect(post).not_to be_valid
        expect(post.errors[:title]).to include("が入力されていません。")
      end

      it 'タイトルが100文字を超える場合は無効であること' do
        post = build(:post, title: 'a' * 101)
        expect(post).not_to be_valid
        expect(post.errors[:title]).to include("は100文字以下で入力してください。")
      end

      it 'タイトルが100文字以内の場合は有効であること' do
        post = build(:post, title: 'a' * 100)
        post.valid?
        expect(post.errors[:title]).to be_empty
      end
    end

    describe '本文' do
      it '本文が空の場合は無効であること' do
        post = build(:post, content: nil)
        expect(post).not_to be_valid
        expect(post.errors[:content]).to include("が入力されていません。")
      end

      it '本文が1000文字を超える場合は無効であること' do
        post = build(:post, content: 'a' * 1001)
        expect(post).not_to be_valid
        expect(post.errors[:content]).to include("は1000文字以下で入力してください。")
      end

      it '本文が1000文字以内の場合は有効であること' do
        post = build(:post, content: 'a' * 1000)
        post.valid?
        expect(post.errors[:content]).to be_empty
      end
    end

    describe 'カテゴリー' do
      it 'カテゴリーが空の場合は無効であること' do
        post = build(:post, category: nil)
        expect(post).not_to be_valid
        expect(post.errors[:category]).to include("が入力されていません。")
      end

      it 'カテゴリーが不正な値の場合は無効であること' do
        pending "カテゴリーの検証メッセージが正確に定義されていないため保留"
        post = build(:post, category: '不正な値')
        expect(post).not_to be_valid
        expect(post.errors[:category]).to include("Translation missing")
      end

      it 'カテゴリーが正しい値の場合は有効であること' do
        post = build(:post, category: 'education')
        post.valid?
        expect(post.errors[:category]).to be_empty
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
      expect(post.notifications).to be_empty
    end
  end

  # スコープのテスト
  describe 'スコープ' do
    describe 'recent' do
      it '投稿を新しい順に取得すること' do
        pending "recentスコープが実装されていないため保留"
        old_post = create(:post, created_at: 1.day.ago)
        new_post = create(:post, created_at: 1.hour.ago)
        expect(Post.recent).to eq([ new_post, old_post ])
      end
    end

    describe 'by_category' do
      it 'カテゴリーで投稿をフィルタリングすること' do
        pending "by_categoryスコープが実装されていないため保留"
        post1 = create(:post, category: 'education')
        post2 = create(:post, category: 'finance')
        expect(Post.by_category('education')).to include(post1)
        expect(Post.by_category('education')).not_to include(post2)
      end
    end

    describe 'search' do
      it 'タイトルで検索できること' do
        pending "searchスコープが実装されていないため保留"
        post1 = create(:post, title: 'テスト投稿')
        post2 = create(:post, title: '別の投稿')
        expect(Post.search('テスト')).to include(post1)
        expect(Post.search('テスト')).not_to include(post2)
      end

      it '本文で検索できること' do
        pending "searchスコープが実装されていないため保留"
        post1 = create(:post, content: 'これはテスト内容です')
        post2 = create(:post, content: '別の内容です')
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
        pending "likeファクトリーとliked_by?メソッドが実装されていないため保留"
        create(:like, user: user, post: post)
        expect(post.liked_by?(user)).to be true
      end

      it 'ユーザーがいいねしていない場合falseを返すこと' do
        pending "liked_by?メソッドが実装されていないため保留"
        expect(post.liked_by?(user)).to be false
      end
    end
  end
end
