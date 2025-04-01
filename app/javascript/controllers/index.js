// Stimulusコントローラーの初期化と登録を行うメインファイル
// このファイルは、アプリケーション内の全てのStimulusコントローラーを管理する

// アプリケーションのメインStimulusインスタンスをインポート
// これは、Stimulusアプリケーションのルートとなる
import { application } from "controllers/application"

// Stimulusの自動ローディング機能をインポート
// これにより、controllersディレクトリ内の全てのコントローラーが自動的に読み込まれる
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// 全てのコントローラーを自動的に読み込んで登録
// 第1引数: コントローラーファイルの検索ディレクトリ
// 第2引数: 登録先のStimulusアプリケーションインスタンス
eagerLoadControllersFrom("controllers", application)