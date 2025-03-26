// モバイルメニューを制御するStimulusコントローラー
// ハンバーガーメニューの開閉とアイコンの切り替えを管理
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // メニュー要素をターゲットとして定義
  // data-mobile-menu-target="menu"の要素を参照可能に
  static targets = ["menu"]

  // コントローラーが要素に接続された時に実行
  connect() {
    // メニューの開閉状態を管理するフラグ
    // 初期状態は閉じている(false)
    this.isOpen = false
  }

  // メニューの開閉を切り替えるメソッド
  // data-action="click->mobile-menu#toggle"で呼び出し
  toggle() {
    // メニューの状態を反転
    this.isOpen = !this.isOpen
    // メニュー要素の表示/非表示を切り替え
    this.menuTarget.classList.toggle("hidden")
    
    // DOMからメニューアイコンと閉じるアイコンの要素を取得
    // data-mobile-menu-icon, data-mobile-menu-close-iconの属性で特定
    const menuIcon = document.querySelector("[data-mobile-menu-icon]")
    const closeIcon = document.querySelector("[data-mobile-menu-close-icon]")
    
    // メニューの状態に応じてアイコンの表示を切り替え
    if (this.isOpen) {
      // メニューが開いている時は、メニューアイコンを非表示にし、
      // 閉じるアイコンを表示
      menuIcon.classList.add("hidden")
      closeIcon.classList.remove("hidden")
    } else {
      // メニューが閉じている時は、メニューアイコンを表示し、
      // 閉じるアイコンを非表示
      menuIcon.classList.remove("hidden")
      closeIcon.classList.add("hidden")
    }
  }
} 