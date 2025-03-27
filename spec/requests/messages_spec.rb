require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let(:user) { create(:user) }
  let(:chat_room) { create(:chat_room) }

  before do
    sign_in user
  end

  describe "POST /chat_rooms/:chat_room_id/messages" do
    let(:valid_attributes) { { content: "テストメッセージ" } }

    it "creates a new message" do
      expect {
        post chat_room_messages_path(chat_room), params: { message: valid_attributes }
      }.to change(Message, :count).by(1)

      expect(response).to redirect_to(chat_room_path(chat_room))
    end
  end
end
