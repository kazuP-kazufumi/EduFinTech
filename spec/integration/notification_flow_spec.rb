require 'rails_helper'

RSpec.describe 'Notification Flow', type: :system do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let(:user_c) { create(:user) }

  describe 'コメントによる通知のフロー' do
    let!(:post) { create(:post, user: user_a) }

    before do
      sign_in user_b
      visit post_path(post)
    end

    it 'コメントを投稿し、通知が届く' do
      # コメントを投稿
      fill_in 'コメント', with: 'テストコメント'
      click_button 'コメントする'

      # ユーザーAでログインして通知を確認
      sign_out user_b
      sign_in user_a
      visit notifications_path

      # 通知の表示確認
      expect(page).to have_content('新しいコメントが投稿されました')
      expect(page).to have_content(user_b.name)
      expect(page).to have_content('テストコメント')

      # 通知を既読にする
      click_button '既読にする'
      expect(page).to have_content('通知を既読にしました')
    end
  end

  describe 'いいねによる通知のフロー' do
    let!(:post) { create(:post, user: user_a) }

    before do
      sign_in user_b
      visit post_path(post)
    end

    it 'いいねをして、通知が届く' do
      # いいねをする
      click_button 'いいね'

      # ユーザーAでログインして通知を確認
      sign_out user_b
      sign_in user_a
      visit notifications_path

      # 通知の表示確認
      expect(page).to have_content('いいねされました')
      expect(page).to have_content(user_b.name)

      # 通知を削除
      click_button '削除'
      expect(page).to have_content('通知を削除しました')
    end
  end

  describe 'チャットメッセージによる通知のフロー' do
    let!(:chat_room) { create(:chat_room, user: user_a) }

    before do
      sign_in user_b
      visit chat_room_path(chat_room)
    end

    it 'チャットメッセージを送信し、通知が届く' do
      # チャットルームに参加
      click_button '参加'

      # メッセージを送信
      fill_in 'メッセージ', with: 'テストメッセージ'
      click_button '送信'

      # ユーザーAでログインして通知を確認
      sign_out user_b
      sign_in user_a
      visit notifications_path

      # 通知の表示確認
      expect(page).to have_content('新しいメッセージが届きました')
      expect(page).to have_content(user_b.name)
      expect(page).to have_content('テストメッセージ')

      # 通知を既読にする
      click_button '既読にする'
      expect(page).to have_content('通知を既読にしました')
    end
  end
end 