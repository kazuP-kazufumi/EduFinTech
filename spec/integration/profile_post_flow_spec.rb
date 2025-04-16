require 'rails_helper'

RSpec.describe 'Profile and Post Integration Flow', type: :system do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }

  describe 'プロフィール表示から投稿作成までのフロー' do
    before do
      sign_in user_a
      visit profile_path(user_a)
    end

    it 'プロフィールページから投稿を作成し、表示される' do
      # プロフィールページから投稿一覧へ
      click_link '投稿一覧'
      expect(page).to have_content('投稿一覧')

      # 新規投稿作成
      click_link '新規投稿'
      fill_in 'タイトル', with: 'プロフィール統合テスト投稿'
      fill_in '内容', with: 'プロフィールページからの投稿テストです'
      select '質問', from: 'カテゴリー'
      click_button '投稿する'

      # 投稿の表示確認
      expect(page).to have_content('プロフィール統合テスト投稿')
      expect(page).to have_content('プロフィールページからの投稿テストです')

      # プロフィールページに戻って投稿の表示確認
      visit profile_path(user_a)
      expect(page).to have_content('プロフィール統合テスト投稿')
    end
  end

  describe 'プロフィール更新と投稿への影響のフロー' do
    let!(:post) { create(:post, user: user_a) }

    before do
      sign_in user_a
      visit profile_path(user_a)
    end

    it 'プロフィールを更新し、投稿への影響を確認する' do
      # プロフィール編集
      click_link 'プロフィール編集'
      fill_in '名前', with: '更新された名前'
      fill_in '自己紹介', with: '更新された自己紹介'
      click_button '更新'

      # プロフィール更新の確認
      expect(page).to have_content('更新された名前')
      expect(page).to have_content('更新された自己紹介')

      # 投稿詳細で更新された名前が表示されることを確認
      visit post_path(post)
      expect(page).to have_content('更新された名前')
    end
  end

  describe 'プロフィールページでの投稿・コメント管理のフロー' do
    let!(:post) { create(:post, user: user_a) }
    let!(:comment) { create(:comment, post: post, user: user_b) }

    before do
      sign_in user_a
      visit profile_path(user_a)
    end

    it 'プロフィールページから投稿とコメントを管理する' do
      # 投稿一覧の表示確認
      click_link '投稿一覧'
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.content)

      # 投稿の編集
      click_link '編集'
      fill_in 'タイトル', with: '更新された投稿タイトル'
      click_button '更新'
      expect(page).to have_content('更新された投稿タイトル')

      # 投稿の削除
      click_button '削除'
      expect(page).to have_content('投稿を削除しました')

      # コメント一覧の表示確認
      visit profile_path(user_a)
      click_link 'コメント一覧'
      expect(page).to have_content(comment.content)
      expect(page).to have_content(user_b.name)

      # コメントの削除
      click_button '削除'
      expect(page).to have_content('コメントを削除しました')
    end
  end
end
