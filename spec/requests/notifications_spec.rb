require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/notifications/create"
      expect(response).to have_http_status(:success)
    end
  end

end
