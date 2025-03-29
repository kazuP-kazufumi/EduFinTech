class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true

  after_create :create_notification

  private

  def create_notification
    return if user == post.user
    Notification.create(
      user: post.user,
      notifiable: self,
      action: 'commented'
    )
  end
end 