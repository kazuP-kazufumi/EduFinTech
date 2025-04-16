# チャットルームテーブルを作成するマイグレーションファイル
# チャットルームは学生と投資家のコミュニケーションの場として使用される
class CreateChatRooms < ActiveRecord::Migration[8.0]
  def change
    # chat_roomsテーブルの作成
    create_table :chat_rooms do |t|
      # チャットルーム名（必須項目）
      t.string :name, null: false

      # チャットルームの説明文（任意項目）
      t.text :description

      # チャットルームのステータス
      # デフォルト値は0（例：0=開始前、1=進行中、2=終了など）
      # null: falseで必須項目として設定
      t.integer :status, default: 0, null: false

      # created_atとupdated_atカラムを自動生成
      t.timestamps
    end

    # statusカラムにインデックスを追加し、検索パフォーマンスを向上
    add_index :chat_rooms, :status
  end
end
