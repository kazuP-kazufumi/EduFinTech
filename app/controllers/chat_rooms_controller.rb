# チャットルームの作成・表示などの機能を提供するコントローラー
# ApplicationControllerを継承して基本的なコントローラー機能を利用
class ChatRoomsController < ApplicationController
  # ユーザー認証が必要なアクションを制限
  # 未ログインユーザーはアクセス不可
  before_action :authenticate_user!
  
  # 特定のチャットルームを取得する共通処理
  # showアクションの前に実行される
  before_action :set_chat_room, only: [:show]

  # POST /chat_rooms
  # チャットルームを新規作成するアクション
  def create
    # 送信されたパラメータを使用して新しいチャットルームを作成
    @chat_room = ChatRoom.new(chat_room_params)
    # チャットルームのステータスをアクティブに設定
    @chat_room.status = :active

    # マッチング済みユーザー間でのみチャットルームを作成可能
    # 作成しようとしているチャットルームの最初のユーザーが、
    # 現在のユーザーとマッチング済みかどうかを確認
    if current_user.matched_users.include?(@chat_room.users.first)
      if @chat_room.save
        # チャットルーム作成者を参加者として追加
        # chat_room_usersテーブルに現在のユーザーを関連付け
        @chat_room.chat_room_users.create(user: current_user)
        
        # 作成成功時は作成されたチャットルームページにリダイレクト
        redirect_to @chat_room, notice: 'チャットルームが作成されました'
      else
        # 保存失敗時はルートページにリダイレクト
        redirect_to root_path, alert: 'チャットルームの作成に失敗しました'
      end
    else
      # マッチングしていないユーザーとのチャットルーム作成は不可
      redirect_to root_path, alert: 'マッチング済みユーザー間でのみチャットルームを作成できます'
    end
  end

  # GET /chat_rooms/:id
  # 特定のチャットルームを表示するアクション
  def show
    # チャットルームの参加者のみアクセス可能
    # 現在のユーザーがチャットルームのメンバーでない場合はアクセス拒否
    unless @chat_room.users.include?(current_user)
      redirect_to root_path, alert: 'このチャットルームにアクセスする権限がありません'
    end
  end

  private

  # パラメータからチャットルームを取得する共通メソッド
  # @chat_roomインスタンス変数にチャットルームを設定
  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  # Strong Parametersを使用して安全なパラメータを定義
  # name: チャットルーム名
  # description: チャットルームの説明
  # user_ids: 参加ユーザーのID配列
  def chat_room_params
    params.require(:chat_room).permit(:name, :description, user_ids: [])
  end
end
