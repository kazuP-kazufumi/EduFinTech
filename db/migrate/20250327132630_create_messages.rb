# メッセージテーブルを作成するためのマイグレーションファイル
# チャットルーム内でのメッセージのやり取りを管理するためのテーブル定義
class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    # messagesテーブルの作成
    create_table :messages do |t|
      # メッセージの本文 (必須項目)
      t.text :content, null: false
      
      # チャットルームへの参照 (必須項目)
      # chat_roomsテーブルへの外部キー制約あり
      t.references :chat_room, null: false, foreign_key: true
      
      # メッセージ送信者(ユーザー)への参照 (必須項目)
      # usersテーブルへの外部キー制約あり
      t.references :user, null: false, foreign_key: true
      
      # メッセージが既読かどうかのフラグ
      # デフォルトは未読(false)
      t.boolean :is_read, default: false, null: false
      
      # メッセージが削除されているかどうかのフラグ
      # 論理削除用のフラグで、デフォルトはfalse
      t.boolean :is_deleted, default: false, null: false

      # created_at, updated_atのタイムスタンプを自動生成
      t.timestamps
    end

    # パフォーマンス向上のためのインデックス
    # チャットルーム単位でのメッセージ取得を高速化
    add_index :messages, [:chat_room_id, :created_at]
    
    # ユーザー単位でのメッセージ取得を高速化
    add_index :messages, [:user_id, :created_at]
  end
end
