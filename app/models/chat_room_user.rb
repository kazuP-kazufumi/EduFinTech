# チャットルームユーザーモデル
# チャットルームとユーザーの中間テーブルとして機能するモデル
class ChatRoomUser < ApplicationRecord
  # 関連付け
  # chat_room: 所属するチャットルーム
  #   - belongs_toで1対多の関係を定義
  belongs_to :chat_room

  # user: チャットルームに参加しているユーザー
  #   - belongs_toで1対多の関係を定義
  belongs_to :user

  # バリデーション
  # chat_room_id: チャットルームID
  #   - ユーザーIDとの組み合わせでユニークであることを保証
  #   - 同じユーザーが同じチャットルームに複数回参加することを防ぐ
  validates :chat_room_id, uniqueness: { scope: :user_id }
end 