# 通知機能のシステムテスト
RSpec.describe 'Notifications', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post) { create(:post, user: other_user) }

  # 通知一覧のテスト
  describe '通知一覧' do
    let!(:notifications) { create_list(:notification, 5, user: user) }

    context 'ログインしている場合' do
      before do
        sign_in user
        visit notifications_path
      end

      it '通知一覧が表示されること' do
        notifications.each do |notification|
          expect(page).to have_content(notification.title)
          expect(page).to have_content(notification.content)
          expect(page).to have_content(notification.created_at.strftime('%Y/%m/%d %H:%M'))
        end
      end

      it '既読/未読の表示が正しいこと' do
        notifications.each do |notification|
          if notification.read?
            expect(page).to have_selector('.notification.read')
          else
            expect(page).to have_selector('.notification.unread')
          end
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit notifications_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  # 通知の既読/未読管理のテスト
  describe '通知の既読/未読管理' do
    let!(:unread_notification) { create(:notification, user: user, read: false) }
    let!(:read_notification) { create(:notification, user: user, read: true) }

    context 'ログインしている場合' do
      before do
        sign_in user
        visit notifications_path
      end

      it '未読通知を既読にできること' do
        click_link '既読にする', href: read_notification_path(unread_notification)
        expect(page).to have_content('通知を既読にしました')
        expect(unread_notification.reload).to be_read
      end

      it '既読通知を未読にできること' do
        click_link '未読にする', href: unread_notification_path(read_notification)
        expect(page).to have_content('通知を未読にしました')
        expect(read_notification.reload).not_to be_read
      end

      it 'すべての通知を既読にできること' do
        click_button 'すべて既読にする'
        expect(page).to have_content('すべての通知を既読にしました')
        expect(user.notifications.unread.count).to eq 0
      end
    end

    context 'ログインしていない場合' do
      it '既読/未読の操作ができないこと' do
        visit notifications_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  # 通知の削除のテスト
  describe '通知の削除' do
    let!(:notification) { create(:notification, user: user) }

    context 'ログインしている場合' do
      before do
        sign_in user
        visit notifications_path
      end

      it '通知を削除できること' do
        expect {
          click_button '削除'
        }.to change(Notification, :count).by(-1)

        expect(page).to have_content('通知を削除しました')
        expect(page).not_to have_content(notification.title)
      end

      it 'すべての通知を削除できること' do
        expect {
          click_button 'すべて削除'
        }.to change(Notification, :count).by(-1)

        expect(page).to have_content('すべての通知を削除しました')
        expect(page).to have_content('通知はありません')
      end
    end

    context 'ログインしていない場合' do
      it '削除操作ができないこと' do
        visit notifications_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  # 通知の表示制御のテスト
  describe '通知の表示制御' do
    let!(:notifications) { create_list(:notification, 5, user: user) }

    context 'ログインしている場合' do
      before do
        sign_in user
        visit notifications_path
      end

      it '未読通知のみ表示できること' do
        click_link '未読のみ'
        notifications.each do |notification|
          if notification.read?
            expect(page).not_to have_content(notification.title)
          else
            expect(page).to have_content(notification.title)
          end
        end
      end

      it '既読通知のみ表示できること' do
        click_link '既読のみ'
        notifications.each do |notification|
          if notification.read?
            expect(page).to have_content(notification.title)
          else
            expect(page).not_to have_content(notification.title)
          end
        end
      end

      it 'すべての通知を表示できること' do
        click_link 'すべて'
        notifications.each do |notification|
          expect(page).to have_content(notification.title)
        end
      end
    end

    context 'ログインしていない場合' do
      it '表示制御ができないこと' do
        visit notifications_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  # 通知の自動生成のテスト
  describe '通知の自動生成' do
    context 'コメントが投稿された場合' do
      it '投稿者に通知が生成されること' do
        sign_in other_user
        visit post_path(post)
        fill_in 'コメント', with: 'テストコメント'
        click_button 'コメントを投稿'

        sign_in post.user
        visit notifications_path
        expect(page).to have_content('新しいコメントが投稿されました')
      end
    end

    context 'チャットメッセージが送信された場合' do
      let(:chat_room) { create(:chat_room, owner: user) }

      it 'チャットルームの参加者に通知が生成されること' do
        sign_in other_user
        visit chat_room_path(chat_room)
        fill_in 'メッセージ', with: 'テストメッセージ'
        click_button '送信'

        sign_in user
        visit notifications_path
        expect(page).to have_content('新しいメッセージが送信されました')
      end
    end
  end
end 