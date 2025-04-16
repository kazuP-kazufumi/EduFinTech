require 'rails_helper'

RSpec.describe 'Chat Flow', type: :system do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let(:user_c) { create(:user) }

  describe 'チャットルーム作成からメッセージ交換までのフロー' do
    before do
      sign_in user_a
      visit root_path
    end

    it 'チャットルームを作成し、メッセージを交換する' do
      # チャットルーム作成
      click_link 'チャットルーム一覧'
      click_link '新規チャットルーム作成'
      fill_in 'チャットルーム名', with: 'テストルーム'
      fill_in '説明', with: 'テスト用のチャットルームです'
      click_button '作成'

      # チャットルーム詳細の確認
      expect(page).to have_content('テストルーム')
      expect(page).to have_content('テスト用のチャットルームです')
      expect(page).to have_content(user_a.name)

      # メッセージ送信
      fill_in 'メッセージ', with: 'こんにちは！'
      click_button '送信'

      # メッセージの表示確認
      expect(page).to have_content('こんにちは！')
      expect(page).to have_content(user_a.name)

      # 別のユーザーでログイン
      sign_out user_a
      sign_in user_b
      visit current_path

      # メッセージ送信
      fill_in 'メッセージ', with: 'はじめまして！'
      click_button '送信'

      # メッセージの表示確認
      expect(page).to have_content('はじめまして！')
      expect(page).to have_content(user_b.name)
    end
  end

  describe 'チャットルームへの参加・退出のフロー' do
    let!(:chat_room) { create(:chat_room, user: user_a) }

    before do
      sign_in user_b
      visit chat_rooms_path
    end

    it 'チャットルームに参加し、退出する' do
      # チャットルームへの参加
      click_link chat_room.name
      expect(page).to have_content('参加しました')

      # チャットルーム一覧での表示確認
      visit chat_rooms_path
      expect(page).to have_content(chat_room.name)
      expect(page).to have_content('参加中')

      # チャットルームからの退出
      click_link chat_room.name
      click_button '退出'
      expect(page).to have_content('退出しました')

      # チャットルーム一覧での表示確認
      visit chat_rooms_path
      expect(page).to have_content(chat_room.name)
      expect(page).not_to have_content('参加中')
    end
  end

  describe '複数ユーザーによるチャットのフロー' do
    let!(:chat_room) { create(:chat_room, user: user_a) }

    before do
      sign_in user_a
      visit chat_room_path(chat_room)
    end

    it '複数ユーザーでチャットを行う' do
      # ユーザーAがメッセージを送信
      fill_in 'メッセージ', with: 'こんにちは！'
      click_button '送信'

      # ユーザーBでログインして参加
      sign_out user_a
      sign_in user_b
      visit chat_room_path(chat_room)
      fill_in 'メッセージ', with: 'はじめまして！'
      click_button '送信'

      # ユーザーCでログインして参加
      sign_out user_b
      sign_in user_c
      visit chat_room_path(chat_room)
      fill_in 'メッセージ', with: 'よろしくお願いします！'
      click_button '送信'

      # メッセージの表示確認
      expect(page).to have_content('こんにちは！')
      expect(page).to have_content('はじめまして！')
      expect(page).to have_content('よろしくお願いします！')
      expect(page).to have_content(user_a.name)
      expect(page).to have_content(user_b.name)
      expect(page).to have_content(user_c.name)
    end
  end
end
