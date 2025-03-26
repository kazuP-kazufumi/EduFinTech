// ドロップダウンメニューを制御するStimulusコントローラー
// メニューの開閉とメニュー外クリック時の処理を管理
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // メニュー要素をターゲットとして定義
  // data-dropdown-target="menu"の要素を参照可能に
  static targets = ["menu"]

  // コントローラーが要素に接続された時に実行
  connect() {
    // メニューの開閉状態を管理するフラグ
    // 初期状態は閉じている(false)
    this.isOpen = false
  }

  // メニューの開閉を切り替えるメソッド
  // data-action="click->dropdown#toggle"で呼び出し
  toggle() {
    // メニューの状態を反転
    this.isOpen = !this.isOpen
    // メニュー要素の表示/非表示を切り替え
    // hiddenクラスの有無でメニューの表示を制御
    this.menuTarget.classList.toggle("hidden")
  }

  // メニュー外のクリックを検知して閉じる処理
  // data-action="click@window->dropdown#clickOutside"で呼び出し
  clickOutside(event) {
    // クリックされた要素がメニューの外部かどうかをチェック
    if (!this.element.contains(event.target)) {
      // メニュー外がクリックされた場合、メニューを閉じる
      this.isOpen = false
      this.menuTarget.classList.add("hidden")
    }
  }
} 