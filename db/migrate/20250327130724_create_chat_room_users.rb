# チャットルームユーザーテーブルを作成するマイグレーションファイル
# チャットルームとユーザーの中間テーブルとして機能し、多対多の関係を管理する
class CreateChatRoomUsers < ActiveRecord::Migration[8.0]
  def change
    # chat_room_usersテーブルの作成
    create_table :chat_room_users do |t|
      # チャットルームの外部キー
      # null: falseで必須項目として設定
      # foreign_key: trueで参照整合性を保証
      t.references :chat_room, null: false, foreign_key: true

      # ユーザーの外部キー
      # null: falseで必須項目として設定
      # foreign_key: trueで参照整合性を保証
      t.references :user, null: false, foreign_key: true

      # created_atとupdated_atカラムを自動生成
      t.timestamps
    end

    # chat_room_idとuser_idの組み合わせにユニーク制約を追加
    # 同じユーザーが同じチャットルームに複数回参加することを防ぐ
    add_index :chat_room_users, [ :chat_room_id, :user_id ], unique: true
  end
end
