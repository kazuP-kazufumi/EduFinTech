# RSpecのテストに必要な設定を読み込む
require 'rails_helper'

# ユーザー登録機能のシステムスペック
RSpec.describe 'Registrations', type: :system do
  # 新規登録機能についてのテスト群
  describe '新規登録' do
    # 正常系のテストケース
    context '有効な情報を入力した場合' do
      it '新規登録が成功し、ダッシュボードにリダイレクトされる' do
        # 新規登録ページへアクセス
        visit new_user_registration_path
        
        # 有効な情報を入力
        fill_in 'user[email]', with: 'test@example.com'     # 正しい形式のメールアドレス
        fill_in 'user[password]', with: 'password123'       # 十分な長さのパスワード
        fill_in 'user[password_confirmation]', with: 'password123'  # パスワードと同じ値
        
        # 新規登録ボタンをクリック
        click_button '新規登録'
        
        # 期待する結果の検証
        expect(page).to have_current_path(dashboard_path)  # ダッシュボードページへリダイレクト
        expect(page).to have_content('アカウント登録が完了しました')  # 成功メッセージの表示
      end
    end

    # 異常系のテストケース
    context '無効な情報を入力した場合' do
      it 'エラーメッセージが表示される' do
        # 新規登録ページへアクセス
        visit new_user_registration_path
        
        # 無効な情報を入力
        fill_in 'user[email]', with: 'invalid_email'      # 不正な形式のメールアドレス
        fill_in 'user[password]', with: 'short'           # 短すぎるパスワード
        fill_in 'user[password_confirmation]', with: 'different'  # パスワードと異なる値
        
        # 新規登録ボタンをクリック
        click_button '新規登録'
        
        # エラーメッセージの検証
        expect(page).to have_content('メールアドレスは有効でありません')  # メールアドレスのバリデーションエラー
        expect(page).to have_content('パスワードは6文字以上で入力してください')  # パスワード長のバリデーションエラー
        expect(page).to have_content('パスワード（確認）とパスワードの入力が一致しません')  # パスワード一致のバリデーションエラー
      end
    end
  end
end 