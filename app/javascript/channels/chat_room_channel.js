// Action Cableのconsumerをインポート
// これによりWebSocket接続の管理が可能になる
import consumer from "./consumer"

// Turboによるページ読み込み完了時のイベントリスナーを設定
document.addEventListener('turbo:load', () => {
  // data-chat-room-id属性を持つ要素を探す
  // この要素にはチャットルームの識別子が含まれている
  const chatRoomElement = document.querySelector('[data-chat-room-id]')
  
  if (chatRoomElement) {
    // チャットルームのIDを取得
    const chatRoomId = chatRoomElement.dataset.chatRoomId

    // ChatRoomChannelへの購読を作成
    // chat_room_idパラメータを指定してチャンネルを特定
    consumer.subscriptions.create({ channel: "ChatRoomChannel", chat_room_id: chatRoomId }, {
      // WebSocket接続が確立された時の処理
      connected() {
        console.log("Connected to chat room channel")
      },

      // WebSocket接続が切断された時の処理
      disconnected() {
        console.log("Disconnected from chat room channel")
      },

      // サーバーからデータを受信した時の処理
      received(data) {
        if (data.type === 'message_read') {
          // メッセージが既読になった場合の処理
          // 該当するメッセージ要素を探して既読表示に更新
          const messageElement = document.querySelector(`[data-message-id="${data.message_id}"]`)
          if (messageElement) {
            messageElement.classList.add('message--read')
          }
        } else if (data.type === 'new_message') {
          // 新しいメッセージを受信した場合の処理
          // メッセージコンテナに新規メッセージを追加
          const messagesContainer = document.getElementById('messages')
          if (messagesContainer) {
            messagesContainer.insertAdjacentHTML('beforeend', data.message)
          }
        }
      },

      // メッセージを既読にするメソッド
      // サーバーサイドのmark_as_readアクションを呼び出す
      markAsRead(messageId) {
        this.perform('mark_as_read', { message_id: messageId })
      }
    })
  }
})
