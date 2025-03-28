# ChatMessagesControllerのテスト
RSpec.describe ChatMessagesController, type: :controller do
  # 認証・認可のテスト
  describe '認証・認可' do
    context '未ログインユーザーの場合' do
      let(:chat_room) { create(:chat_room) }

      it 'メッセージ一覧にアクセスできないこと' do
        get :index, params: { chat_room_id: chat_room.id }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'メッセージを作成できないこと' do
        post :create, params: { chat_room_id: chat_room.id, chat_message: attributes_for(:chat_message) }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'メッセージを削除できないこと' do
        chat_message = create(:chat_message)
        delete :destroy, params: { chat_room_id: chat_message.chat_room_id, id: chat_message.id }
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
          post :create, params: { chat_room_id: @chat_room.id, chat_message: attributes_for(:chat_message) }
        }.to change(ChatMessage, :count).by(1)
      end

      context '自分のメッセージの場合' do
        let(:chat_message) { create(:chat_message, user: @user, chat_room: @chat_room) }

        it 'メッセージを削除できること' do
          expect {
            delete :destroy, params: { chat_room_id: @chat_room.id, id: chat_message.id }
          }.to change(ChatMessage, :count).by(-1)
        end
      end

      context '他のユーザーのメッセージの場合' do
        let(:other_user) { create(:user) }
        let(:chat_message) { create(:chat_message, user: other_user, chat_room: @chat_room) }

        it 'メッセージを削除できないこと' do
          expect {
            delete :destroy, params: { chat_room_id: @chat_room.id, id: chat_message.id }
          }.not_to change(ChatMessage, :count)
        end
      end
    end
  end

  # アクションのテスト
  describe 'GET #index' do
    before do
      sign_in_test_user
      @chat_room = create(:chat_room)
      @chat_messages = create_list(:chat_message, 3, chat_room: @chat_room)
    end

    it 'チャットメッセージ一覧を表示すること' do
      get :index, params: { chat_room_id: @chat_room.id }
      expect(assigns(:chat_messages)).to match_array(@chat_messages)
    end

    it 'indexテンプレートをレンダリングすること' do
      get :index, params: { chat_room_id: @chat_room.id }
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    before do
      sign_in_test_user
      @chat_room = create(:chat_room)
    end

    context '有効なパラメータの場合' do
      let(:valid_attributes) { attributes_for(:chat_message, content: 'テストメッセージ') }

      it '新しいチャットメッセージを作成すること' do
        expect {
          post :create, params: { chat_room_id: @chat_room.id, chat_message: valid_attributes }
        }.to change(ChatMessage, :count).by(1)
      end

      it '作成したメッセージが正しい属性を持つこと' do
        post :create, params: { chat_room_id: @chat_room.id, chat_message: valid_attributes }
        expect(ChatMessage.last.content).to eq('テストメッセージ')
        expect(ChatMessage.last.user).to eq(@user)
        expect(ChatMessage.last.chat_room).to eq(@chat_room)
      end

      it 'チャットルームのページにリダイレクトすること' do
        post :create, params: { chat_room_id: @chat_room.id, chat_message: valid_attributes }
        expect(response).to redirect_to(chat_room_path(@chat_room))
      end

      it '成功メッセージを表示すること' do
        post :create, params: { chat_room_id: @chat_room.id, chat_message: valid_attributes }
        expect(flash[:notice]).to eq('メッセージを送信しました')
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_attributes) { attributes_for(:chat_message, content: nil) }

      it '新しいチャットメッセージを作成しないこと' do
        expect {
          post :create, params: { chat_room_id: @chat_room.id, chat_message: invalid_attributes }
        }.not_to change(ChatMessage, :count)
      end

      it 'チャットルームのページにリダイレクトすること' do
        post :create, params: { chat_room_id: @chat_room.id, chat_message: invalid_attributes }
        expect(response).to redirect_to(chat_room_path(@chat_room))
      end

      it 'エラーメッセージを表示すること' do
        post :create, params: { chat_room_id: @chat_room.id, chat_message: invalid_attributes }
        expect(flash[:alert]).to eq('メッセージの送信に失敗しました')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in_test_user
      @chat_room = create(:chat_room)
      @chat_message = create(:chat_message, user: @user, chat_room: @chat_room)
    end

    it 'チャットメッセージを削除すること' do
      expect {
        delete :destroy, params: { chat_room_id: @chat_room.id, id: @chat_message.id }
      }.to change(ChatMessage, :count).by(-1)
    end

    it 'チャットルームのページにリダイレクトすること' do
      delete :destroy, params: { chat_room_id: @chat_room.id, id: @chat_message.id }
      expect(response).to redirect_to(chat_room_path(@chat_room))
    end

    it '成功メッセージを表示すること' do
      delete :destroy, params: { chat_room_id: @chat_room.id, id: @chat_message.id }
      expect(flash[:notice]).to eq('メッセージを削除しました')
    end
  end
end 