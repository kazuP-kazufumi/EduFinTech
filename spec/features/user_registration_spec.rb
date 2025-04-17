# ユーザー登録機能のフィーチャースペック
# Deviseを使用したユーザー登録フローをテストする
require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :feature do
  scenario '新規ユーザーが正常に登録できる' do
    # ユーザー登録ページにアクセス
    visit new_user_registration_path

    # フォームに有効な値を入力
    fill_in 'ユーザー名', with: 'テストユーザー'
    fill_in 'メールアドレス', with: 'test@example.com'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認）', with: 'password123'
    fill_in '自己紹介', with: 'テストユーザーの自己紹介です。'

    # 登録ボタンをクリックした後にユーザー数が1増えることを確認
    expect {
      click_button '登録'
    }.to change(User, :count).by(1)

    # 登録成功後の確認
    # - フラッシュメッセージが表示されること
    expect(page).to have_content('アカウント登録が完了しました')
    # - ダッシュボードにリダイレクトされること
    expect(current_path).to eq dashboard_path
  end

  scenario 'バリデーションエラーが表示される' do
    # ユーザー登録ページにアクセス
    visit new_user_registration_path

    # フォームに無効な値を入力
    # - 不正なメールアドレスフォーマット
    fill_in 'メールアドレス', with: 'invalid-email'
    # - 短すぎるパスワード
    fill_in 'パスワード', with: 'short'
    # - パスワード確認が一致しない
    fill_in 'パスワード（確認）', with: 'different'

    # フォーム送信
    click_button '登録'

    # バリデーションエラーメッセージの確認
    expect(page).to have_content('Email は有効でありません')
    expect(page).to have_content('Password は8文字以上で入力してください')
    expect(page).to have_content('Password confirmation が一致しません')
  end
end
