# ChatRoomsControllerのテスト
RSpec.describe ChatRoomsController, type: :controller do
  # 認証・認可のテスト
  describe '認証・認可' do
    context '未ログインユーザーの場合' do
      it '一覧ページにアクセスできないこと' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end

      it '詳細ページにアクセスできないこと' do
        chat_room = create(:chat_room)
        get :show, params: { id: chat_room.id }
        expect(response).to redirect_to(new_user_session_path)
      end

      it '新規作成ページにアクセスできないこと' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'チャットルームを作成できないこと' do
        post :create, params: { chat_room: attributes_for(:chat_room) }
        expect(response).to redirect_to(new_user_session_path)
      end

      it '編集ページにアクセスできないこと' do
        chat_room = create(:chat_room)
        get :edit, params: { id: chat_room.id }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'チャットルームを更新できないこと' do
        chat_room = create(:chat_room)
        patch :update, params: { id: chat_room.id, chat_room: attributes_for(:chat_room) }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'チャットルームを削除できないこと' do
        chat_room = create(:chat_room)
        delete :destroy, params: { id: chat_room.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインユーザーの場合' do
      before do
        sign_in_test_user
      end

      it '一覧ページにアクセスできること' do
        get :index
        expect(response).to be_successful
      end

      it '詳細ページにアクセスできること' do
        chat_room = create(:chat_room)
        get :show, params: { id: chat_room.id }
        expect(response).to be_successful
      end

      it '新規作成ページにアクセスできること' do
        get :new
        expect(response).to be_successful
      end

      it 'チャットルームを作成できること' do
        expect {
          post :create, params: { chat_room: attributes_for(:chat_room) }
        }.to change(ChatRoom, :count).by(1)
        expect(response).to redirect_to(chat_room_path(ChatRoom.last))
      end

      context '自分のチャットルームの場合' do
        let(:chat_room) { create(:chat_room, owner: @user) }

        it '編集ページにアクセスできること' do
          get :edit, params: { id: chat_room.id }
          expect(response).to be_successful
        end

        it 'チャットルームを更新できること' do
          patch :update, params: { id: chat_room.id, chat_room: attributes_for(:chat_room, name: '更新後の名前') }
          expect(response).to redirect_to(chat_room_path(chat_room))
          expect(chat_room.reload.name).to eq('更新後の名前')
        end

        it 'チャットルームを削除できること' do
          expect {
            delete :destroy, params: { id: chat_room.id }
          }.to change(ChatRoom, :count).by(-1)
          expect(response).to redirect_to(chat_rooms_path)
        end
      end

      context '他のユーザーのチャットルームの場合' do
        let(:other_user) { create(:user) }
        let(:chat_room) { create(:chat_room, owner: other_user) }

        it '編集ページにアクセスできないこと' do
          get :edit, params: { id: chat_room.id }
          expect(response).to redirect_to(chat_rooms_path)
        end

        it 'チャットルームを更新できないこと' do
          patch :update, params: { id: chat_room.id, chat_room: attributes_for(:chat_room) }
          expect(response).to redirect_to(chat_rooms_path)
        end

        it 'チャットルームを削除できないこと' do
          delete :destroy, params: { id: chat_room.id }
          expect(response).to redirect_to(chat_rooms_path)
        end
      end
    end
  end

  # アクションのテスト
  describe 'GET #index' do
    before do
      sign_in_test_user
      @chat_rooms = create_list(:chat_room, 3)
    end

    it 'チャットルーム一覧を表示すること' do
      get :index
      expect(assigns(:chat_rooms)).to match_array(@chat_rooms)
    end

    it 'indexテンプレートをレンダリングすること' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before do
      sign_in_test_user
      @chat_room = create(:chat_room)
    end

    it 'チャットルームの詳細を表示すること' do
      get :show, params: { id: @chat_room.id }
      expect(assigns(:chat_room)).to eq(@chat_room)
    end

    it 'showテンプレートをレンダリングすること' do
      get :show, params: { id: @chat_room.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before do
      sign_in_test_user
    end

    it '新しいチャットルームオブジェクトを生成すること' do
      get :new
      expect(assigns(:chat_room)).to be_a_new(ChatRoom)
    end

    it 'newテンプレートをレンダリングすること' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    before do
      sign_in_test_user
    end

    context '有効なパラメータの場合' do
      let(:valid_attributes) { attributes_for(:chat_room) }

      it '新しいチャットルームを作成すること' do
        expect {
          post :create, params: { chat_room: valid_attributes }
        }.to change(ChatRoom, :count).by(1)
      end

      it '作成したチャットルームのページにリダイレクトすること' do
        post :create, params: { chat_room: valid_attributes }
        expect(response).to redirect_to(chat_room_path(ChatRoom.last))
      end

      it '成功メッセージを表示すること' do
        post :create, params: { chat_room: valid_attributes }
        expect(flash[:notice]).to eq('チャットルームを作成しました')
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_attributes) { attributes_for(:chat_room, name: nil) }

      it '新しいチャットルームを作成しないこと' do
        expect {
          post :create, params: { chat_room: invalid_attributes }
        }.not_to change(ChatRoom, :count)
      end

      it 'newテンプレートを再レンダリングすること' do
        post :create, params: { chat_room: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'エラーメッセージを表示すること' do
        post :create, params: { chat_room: invalid_attributes }
        expect(flash[:alert]).to eq('チャットルームの作成に失敗しました')
      end
    end
  end

  describe 'GET #edit' do
    before do
      sign_in_test_user
      @chat_room = create(:chat_room, owner: @user)
    end

    it '編集対象のチャットルームを取得すること' do
      get :edit, params: { id: @chat_room.id }
      expect(assigns(:chat_room)).to eq(@chat_room)
    end

    it 'editテンプレートをレンダリングすること' do
      get :edit, params: { id: @chat_room.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    before do
      sign_in_test_user
      @chat_room = create(:chat_room, owner: @user)
    end

    context '有効なパラメータの場合' do
      let(:new_attributes) { attributes_for(:chat_room, name: '更新後の名前') }

      it 'チャットルームを更新すること' do
        patch :update, params: { id: @chat_room.id, chat_room: new_attributes }
        @chat_room.reload
        expect(@chat_room.name).to eq('更新後の名前')
      end

      it '更新したチャットルームのページにリダイレクトすること' do
        patch :update, params: { id: @chat_room.id, chat_room: new_attributes }
        expect(response).to redirect_to(chat_room_path(@chat_room))
      end

      it '成功メッセージを表示すること' do
        patch :update, params: { id: @chat_room.id, chat_room: new_attributes }
        expect(flash[:notice]).to eq('チャットルームを更新しました')
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_attributes) { attributes_for(:chat_room, name: nil) }

      it 'チャットルームを更新しないこと' do
        expect {
          patch :update, params: { id: @chat_room.id, chat_room: invalid_attributes }
        }.not_to change { @chat_room.reload.name }
      end

      it 'editテンプレートを再レンダリングすること' do
        patch :update, params: { id: @chat_room.id, chat_room: invalid_attributes }
        expect(response).to render_template(:edit)
      end

      it 'エラーメッセージを表示すること' do
        patch :update, params: { id: @chat_room.id, chat_room: invalid_attributes }
        expect(flash[:alert]).to eq('チャットルームの更新に失敗しました')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in_test_user
      @chat_room = create(:chat_room, owner: @user)
    end

    it 'チャットルームを削除すること' do
      expect {
        delete :destroy, params: { id: @chat_room.id }
      }.to change(ChatRoom, :count).by(-1)
    end

    it 'チャットルーム一覧ページにリダイレクトすること' do
      delete :destroy, params: { id: @chat_room.id }
      expect(response).to redirect_to(chat_rooms_path)
    end

    it '成功メッセージを表示すること' do
      delete :destroy, params: { id: @chat_room.id }
      expect(flash[:notice]).to eq('チャットルームを削除しました')
    end
  end

  # 参加者管理のテスト
  describe '参加者管理' do
    before do
      sign_in_test_user
      @chat_room = create(:chat_room)
      @other_user = create(:user)
    end

    describe 'POST #join' do
      it 'チャットルームに参加できること' do
        expect {
          post :join, params: { id: @chat_room.id }
        }.to change { @chat_room.participants.count }.by(1)
        expect(@chat_room.participants).to include(@user)
      end

      it '既に参加している場合は参加できないこと' do
        @chat_room.participants << @user
        expect {
          post :join, params: { id: @chat_room.id }
        }.not_to change { @chat_room.participants.count }
      end
    end

    describe 'DELETE #leave' do
      it 'チャットルームから退出できること' do
        @chat_room.participants << @user
        expect {
          delete :leave, params: { id: @chat_room.id }
        }.to change { @chat_room.participants.count }.by(-1)
        expect(@chat_room.participants).not_to include(@user)
      end

      it '参加していない場合は退出できないこと' do
        expect {
          delete :leave, params: { id: @chat_room.id }
        }.not_to change { @chat_room.participants.count }
      end
    end
  end
end
