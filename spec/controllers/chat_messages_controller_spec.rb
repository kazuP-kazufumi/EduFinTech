# MessagesControllerのテスト
RSpec.describe MessagesController, type: :controller do
  # 認証・認可のテスト
  describe '認証・認可' do
    context '未ログインユーザーの場合' do
      let(:chat_room) { create(:chat_room) }

      it 'メッセージ一覧にアクセスできないこと' do
        get :index, params: { chat_room_id: chat_room.id }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'メッセージを作成できないこと' do
        post :create, params: { chat_room_id: chat_room.id, message: attributes_for(:message) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインユーザーの場合' do
      before do
        sign_in_test_user
        @chat_room = create(:chat_room)
      end

      it 'メッセージ一覧にアクセスできること' do
        get :index, params: { chat_room_id: @chat_room.id }
        expect(response).to be_successful
      end

      it 'メッセージを作成できること' do
        expect {
          post :create, params: { chat_room_id: @chat_room.id, message: attributes_for(:message) }
        }.to change(Message, :count).by(1)
      end

      context 'チャットルームのメンバーでない場合' do
        let(:other_chat_room) { create(:chat_room) }

        it 'メッセージ一覧にアクセスできないこと' do
          get :index, params: { chat_room_id: other_chat_room.id }
          expect(response).to redirect_to(root_path)
        end

        it 'メッセージを作成できないこと' do
          post :create, params: { chat_room_id: other_chat_room.id, message: attributes_for(:message) }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  # アクションのテスト
  describe 'POST #create' do
    before do
      sign_in_test_user
      @chat_room = create(:chat_room)
    end

    context '有効なパラメータの場合' do
      it 'メッセージを作成すること' do
        expect {
          post :create, params: { chat_room_id: @chat_room.id, message: attributes_for(:message) }
        }.to change(Message, :count).by(1)
      end

      it 'チャットルームページにリダイレクトすること' do
        post :create, params: { chat_room_id: @chat_room.id, message: attributes_for(:message) }
        expect(response).to redirect_to(@chat_room)
      end
    end

    context '無効なパラメータの場合' do
      it 'メッセージを作成しないこと' do
        expect {
          post :create, params: { chat_room_id: @chat_room.id, message: attributes_for(:message, content: nil) }
        }.not_to change(Message, :count)
      end

      it 'チャットルームページにリダイレクトすること' do
        post :create, params: { chat_room_id: @chat_room.id, message: attributes_for(:message, content: nil) }
        expect(response).to redirect_to(@chat_room)
      end
    end
  end
end
