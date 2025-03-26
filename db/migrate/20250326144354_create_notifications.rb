class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :post, null: false, foreign_key: true
      t.integer :notification_type, null: false, default: 0
      t.boolean :read, null: false, default: false

      t.timestamps
    end
  end
end
