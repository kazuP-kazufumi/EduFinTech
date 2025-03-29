# ユーザー認証フローのシステムテスト
RSpec.describe 'Authentication', type: :system do
  # ユーザー登録のテスト
  describe 'ユーザー登録' do
    context '有効な情報で登録する場合' do
      it 'ユーザー登録が成功すること' do
        visit new_user_registration_path

        fill_in '名前', with: 'テストユーザー'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認）', with: 'password123'
        fill_in 'プロフィール', with: 'テスト用のプロフィールです'

        expect {
          click_button '登録'
        }.to change(User, :count).by(1)

        expect(page).to have_content('アカウント登録が完了しました')
        expect(page).to have_current_path(root_path)
      end
    end

    context '無効な情報で登録する場合' do
      it 'バリデーションエラーが表示されること' do
        visit new_user_registration_path

        fill_in '名前', with: ''
        fill_in 'メールアドレス', with: 'invalid_email'
        fill_in 'パスワード', with: 'short'
        fill_in 'パスワード（確認）', with: 'different'

        click_button '登録'

        expect(page).to have_content('エラーが発生したため ユーザー は保存されませんでした')
        expect(page).to have_content('名前を入力してください')
        expect(page).to have_content('メールアドレスは有効でありません')
        expect(page).to have_content('パスワードは6文字以上で入力してください')
        expect(page).to have_content('パスワード（確認）とパスワードの入力が一致しません')
      end
    end
  end

  # ログインのテスト
  describe 'ログイン' do
    let(:user) { create(:user) }

    context '有効な情報でログインする場合' do
      it 'ログインが成功すること' do
        visit new_user_session_path

        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password

        click_button 'ログイン'

        expect(page).to have_content('ログインしました')
        expect(page).to have_current_path(root_path)
      end
    end

    context '無効な情報でログインする場合' do
      it 'エラーメッセージが表示されること' do
        visit new_user_session_path

        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'wrong_password'

        click_button 'ログイン'

        expect(page).to have_content('メールアドレスまたはパスワードが違います')
      end
    end
  end

  # ログアウトのテスト
  describe 'ログアウト' do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit root_path
    end

    it 'ログアウトが成功すること' do
      click_link 'ログアウト'

      expect(page).to have_content('ログアウトしました')
      expect(page).to have_current_path(root_path)
    end
  end

  # パスワードリセットのテスト
  describe 'パスワードリセット' do
    let(:user) { create(:user) }

    context 'パスワードリセットメールの送信' do
      it 'リセットメールが送信されること' do
        visit new_user_password_path

        fill_in 'メールアドレス', with: user.email

        expect {
          click_button 'パスワードの再設定方法を送信する'
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(page).to have_content('パスワードの再設定方法を数分以内にメールで送信しました')
      end
    end

    context 'パスワードの再設定' do
      let(:token) { user.send_reset_password_instructions }

      it 'パスワードが更新されること' do
        visit edit_user_password_path(reset_password_token: token)

        fill_in '新しいパスワード', with: 'new_password123'
        fill_in '新しいパスワード（確認）', with: 'new_password123'

        click_button 'パスワードを変更する'

        expect(page).to have_content('パスワードが正しく変更されました')
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end
end 