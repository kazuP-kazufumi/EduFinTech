require 'rails_helper'

RSpec.describe "ChatRooms", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /chat_rooms" do
    it "returns http success" do
      get chat_rooms_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /chat_rooms" do
    let(:valid_attributes) { { title: "テストチャットルーム" } }

    it "creates a new chat room" do
      expect {
        post chat_rooms_path, params: { chat_room: valid_attributes }
      }.to change(ChatRoom, :count).by(1)

      expect(response).to redirect_to(chat_room_path(ChatRoom.last))
    end
  end

  describe "GET /chat_rooms/:id" do
    let(:chat_room) { create(:chat_room) }

    it "returns http success" do
      get chat_room_path(chat_room)
      expect(response).to have_http_status(:success)
    end
  end
end
