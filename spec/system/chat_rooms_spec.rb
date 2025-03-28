# チャット機能のシステムテスト
RSpec.describe 'ChatRooms', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  # チャットルーム一覧のテスト
  describe 'チャットルーム一覧' do
    let!(:chat_rooms) { create_list(:chat_room, 5, owner: user) }

    context 'ログインしている場合' do
      before do
        sign_in user
        visit chat_rooms_path
      end

      it 'チャットルーム一覧が表示されること' do
        chat_rooms.each do |chat_room|
          expect(page).to have_content(chat_room.name)
          expect(page).to have_content(chat_room.description)
          expect(page).to have_content(chat_room.owner.name)
        end
      end

      it '新規チャットルーム作成ボタンが表示されること' do
        expect(page).to have_link('新規チャットルーム作成', href: new_chat_room_path)
      end
    end

    context 'ログインしていない場合' do
      before { visit chat_rooms_path }

      it 'ログインページにリダイレクトされること' do
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  # チャットルーム作成のテスト
  describe 'チャットルーム作成' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit new_chat_room_path
      end

      context '有効な情報でチャットルームを作成する場合' do
        it 'チャットルームが作成されること' do
          fill_in 'ルーム名', with: 'テストチャットルーム'
          fill_in '説明', with: 'テスト用のチャットルームです'

          expect {
            click_button '作成する'
          }.to change(ChatRoom, :count).by(1)

          expect(page).to have_content('チャットルームを作成しました')
          expect(page).to have_current_path(chat_room_path(ChatRoom.last))
        end
      end

      context '無効な情報でチャットルームを作成する場合' do
        it 'バリデーションエラーが表示されること' do
          fill_in 'ルーム名', with: ''
          fill_in '説明', with: ''

          click_button '作成する'

          expect(page).to have_content('エラーが発生したため チャットルーム は保存されませんでした')
          expect(page).to have_content('ルーム名を入力してください')
          expect(page).to have_content('説明を入力してください')
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit new_chat_room_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  # チャットルーム詳細のテスト
  describe 'チャットルーム詳細' do
    let(:chat_room) { create(:chat_room, owner: user) }
    let!(:chat_messages) { create_list(:chat_message, 5, chat_room: chat_room) }

    context 'ログインしている場合' do
      before do
        sign_in user
        visit chat_room_path(chat_room)
      end

      it 'チャットルームの詳細が表示されること' do
        expect(page).to have_content(chat_room.name)
        expect(page).to have_content(chat_room.description)
        expect(page).to have_content(chat_room.owner.name)
      end

      it 'メッセージ一覧が表示されること' do
        chat_messages.each do |message|
          expect(page).to have_content(message.content)
          expect(page).to have_content(message.user.name)
        end
      end

      it 'メッセージ送信フォームが表示されること' do
        expect(page).to have_selector('form')
      end

      context 'チャットルームのオーナーの場合' do
        it '編集・削除ボタンが表示されること' do
          expect(page).to have_link('編集', href: edit_chat_room_path(chat_room))
          expect(page).to have_button('削除')
        end
      end

      context 'チャットルームの参加者の場合' do
        let(:chat_room) { create(:chat_room, owner: other_user) }

        it '編集・削除ボタンが表示されないこと' do
          expect(page).not_to have_link('編集')
          expect(page).not_to have_button('削除')
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit chat_room_path(chat_room)
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  # チャットルーム編集のテスト
  describe 'チャットルーム編集' do
    let(:chat_room) { create(:chat_room, owner: user) }

    context 'ログインしている場合' do
      context 'チャットルームのオーナーの場合' do
        before do
          sign_in user
          visit edit_chat_room_path(chat_room)
        end

        it 'チャットルームが更新されること' do
          fill_in 'ルーム名', with: '更新後のルーム名'
          fill_in '説明', with: '更新後の説明'

          click_button '更新する'

          expect(page).to have_content('チャットルームを更新しました')
          expect(page).to have_content('更新後のルーム名')
          expect(page).to have_content('更新後の説明')
        end

        it '無効な情報で更新するとエラーが表示されること' do
          fill_in 'ルーム名', with: ''
          fill_in '説明', with: ''

          click_button '更新する'

          expect(page).to have_content('エラーが発生したため チャットルーム は保存されませんでした')
          expect(page).to have_content('ルーム名を入力してください')
          expect(page).to have_content('説明を入力してください')
        end
      end

      context 'チャットルームの参加者の場合' do
        let(:chat_room) { create(:chat_room, owner: other_user) }

        it '編集ページにアクセスできないこと' do
          sign_in user
          visit edit_chat_room_path(chat_room)
          expect(page).to have_current_path(root_path)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit edit_chat_room_path(chat_room)
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  # チャットルーム削除のテスト
  describe 'チャットルーム削除' do
    let!(:chat_room) { create(:chat_room, owner: user) }

    context 'ログインしている場合' do
      context 'チャットルームのオーナーの場合' do
        before do
          sign_in user
          visit chat_room_path(chat_room)
        end

        it 'チャットルームが削除されること' do
          expect {
            click_button '削除'
          }.to change(ChatRoom, :count).by(-1)

          expect(page).to have_content('チャットルームを削除しました')
          expect(page).to have_current_path(chat_rooms_path)
        end
      end

      context 'チャットルームの参加者の場合' do
        let!(:chat_room) { create(:chat_room, owner: other_user) }

        it '削除ボタンが表示されないこと' do
          sign_in user
          visit chat_room_path(chat_room)
          expect(page).not_to have_button('削除')
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit chat_room_path(chat_room)
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  # チャットメッセージのテスト
  describe 'チャットメッセージ' do
    let(:chat_room) { create(:chat_room, owner: user) }

    context 'ログインしている場合' do
      before do
        sign_in user
        visit chat_room_path(chat_room)
      end

      context 'メッセージを送信する場合' do
        it 'メッセージが送信されること' do
          fill_in 'メッセージ', with: 'テストメッセージ'

          expect {
            click_button '送信'
          }.to change(ChatMessage, :count).by(1)

          expect(page).to have_content('テストメッセージ')
          expect(page).to have_content(user.name)
        end

        it '空のメッセージは送信できないこと' do
          fill_in 'メッセージ', with: ''

          expect {
            click_button '送信'
          }.not_to change(ChatMessage, :count)

          expect(page).to have_content('メッセージを入力してください')
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit chat_room_path(chat_room)
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end
end 