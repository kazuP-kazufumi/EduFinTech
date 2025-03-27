// テキストエリアの高さを自動調整するStimulusコントローラー
// messages/_form.html.erbで使用され、ユーザーの入力に応じてテキストエリアの高さを動的に変更する

import { Controller } from "@hotwired/stimulus"

// Stimulusコントローラーのクラスを定義
export default class extends Controller {
  // 要素がDOMに接続された時に実行されるライフサイクルコールバック
  connect() {
    // 初期表示時にテキストエリアの高さを調整
    this.resize()
  }

  // テキストエリアの高さを内容に合わせて調整するメソッド
  // messages/_form.html.erbのdata-actionで指定されたキー入力時に実行される
  resize() {
    // this.elementはStimulusによって自動的にバインドされたDOM要素（テキストエリア）
    const textarea = this.element
    // 一度高さをautoにリセットして、スクロール高さを正確に計算できるようにする
    textarea.style.height = "auto"
    // テキストエリアの実際のコンテンツの高さ（scrollHeight）に合わせて高さを設定
    textarea.style.height = textarea.scrollHeight + "px"
  }
} 