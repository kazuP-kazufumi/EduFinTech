class AddNotifiableToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_column :notifications, :notifiable_type, :string
    add_column :notifications, :notifiable_id, :integer
  end
end
