require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /notifications" do
    it "returns http success" do
      get notifications_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /notifications/:id/mark_as_read" do
    let(:notification) { create(:notification, user: user) }

    it "marks the notification as read" do
      patch mark_as_read_notification_path(notification)
      notification.reload
      expect(notification.read).to be true
      expect(response).to redirect_to(notifications_path)
    end
  end
end
