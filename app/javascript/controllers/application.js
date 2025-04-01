// StimulusのApplicationクラスをインポート
// これはStimulusアプリケーションのコアとなるクラス
import { Application } from "@hotwired/stimulus"

// Stimulusアプリケーションのインスタンスを作成
// これがアプリケーション全体のStimulus機能を管理する
const application = Application.start()

// Stimulusの開発者向け設定
// debugモードを無効化（本番環境向けの設定）
application.debug = false

// グローバルスコープにStimulusアプリケーションを公開
// ブラウザのコンソールからStimulusの機能にアクセス可能に
window.Stimulus   = application

// アプリケーションインスタンスをエクスポート
// 他のモジュールからStimulusアプリケーションにアクセス可能に
export { application }