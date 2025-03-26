// Action Cableのconsumerをインポート - WebSocket接続の基本設定を提供
import consumer from "./consumer"

// NotificationsChannelの購読を作成
// サーバーサイドのNotificationsChannelと対応する
consumer.subscriptions.create("NotificationsChannel", {
  // WebSocket接続が確立された時に実行
  connected() {
    console.log("NotificationsChannel connected")
  },

  // WebSocket接続が切断された時に実行
  disconnected() {
    console.log("NotificationsChannel disconnected")
  },

  // サーバーからデータを受信した時に実行
  // @param {Object} data - サーバーから送信されたデータ
  received(data) {
    // 通知タイプのデータを受信した場合の処理
    if (data.type === 'notification') {
      // 未読通知バッジの表示を更新
      this.updateNotificationBadge()
      
      // 通知一覧ページにいる場合のみ、新しい通知を画面に追加
      if (document.querySelector('.notifications-list')) {
        this.appendNotification(data.notification)
      }
    }
  },

  // 未読通知バッジの表示を制御するメソッド
  updateNotificationBadge() {
    const badge = document.querySelector('.notification-badge')
    if (badge) {
      // バッジの非表示状態を解除
      badge.classList.remove('hidden')
    }
  },

  // 通知一覧に新しい通知を追加するメソッド
  // @param {Object} notification - 追加する通知データ
  appendNotification(notification) {
    const notificationsList = document.querySelector('.notifications-list')
    if (notificationsList) {
      // 通知要素のHTMLを生成して一覧の先頭に挿入
      const notificationElement = this.createNotificationElement(notification)
      notificationsList.insertAdjacentHTML('afterbegin', notificationElement)
    }
  },

  // 通知のHTML要素を生成するメソッド
  // @param {Object} notification - 通知データ
  // @return {string} 通知のHTML文字列
  createNotificationElement(notification) {
    return `
      <!-- 通知アイテム - 未読状態を示す背景色付き -->
      <li class="notification-item bg-gray-50" data-notification-id="${notification.id}">
        <div class="px-4 py-4 sm:px-6">
          <!-- 通知メッセージと操作ボタンのコンテナ -->
          <div class="flex items-center justify-between">
            <!-- 通知メッセージ -->
            <p class="text-sm font-medium text-gray-900">
              ${notification.message}
            </p>
            <!-- 支援リクエストの場合のみ表示する操作ボタン -->
            <div class="ml-2 flex-shrink-0 flex">
              ${notification.type === 'support_request' ? `
                <button type="button" class="inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                  交渉を開始する
                </button>
              ` : ''}
            </div>
          </div>
          <!-- 通知のメタ情報（作成日時など） -->
          <div class="mt-2 sm:flex sm:justify-between">
            <div class="sm:flex">
              <p class="flex items-center text-sm text-gray-500">
                ${new Date(notification.created_at).toLocaleString('ja-JP')}
              </p>
            </div>
          </div>
        </div>
      </li>
    `
  }
}) 