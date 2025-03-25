# frozen_string_literal: true

# このマイグレーションはDeviseの認証機能をUsersテーブルに追加するためのものです
class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def self.up
    change_table :users do |t|
      ## Trackable（ユーザーのログイン履歴を追跡する機能）
      # ログイン回数
      t.integer  :sign_in_count, default: 0, null: false
      # 現在のログイン時刻
      t.datetime :current_sign_in_at
      # 前回のログイン時刻
      t.datetime :last_sign_in_at
      # 現在のログインIPアドレス
      t.string   :current_sign_in_ip
      # 前回のログインIPアドレス
      t.string   :last_sign_in_ip

      ## Confirmable（メール確認機能）
      # メール確認用のトークン
      t.string   :confirmation_token
      # メール確認完了時刻
      t.datetime :confirmed_at
      # 確認メール送信時刻
      t.datetime :confirmation_sent_at
      # 新しいメールアドレス（メールアドレス変更時の確認用）
      t.string   :unconfirmed_email # 再確認が必要な場合のみ使用

      ## Lockable（アカウントロック機能）
      # ログイン失敗回数 - failed_attempts戦略を使用する場合のみ
      t.integer  :failed_attempts, default: 0, null: false
      # アカウントロック解除用のトークン - emailまたはboth戦略を使用する場合
      t.string   :unlock_token
      # アカウントがロックされた時刻
      t.datetime :locked_at
    end

    # 各トークンに一意性制約を追加
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end

  def self.down
    # このマイグレーションのロールバック方法は、既存のモデルの状態に依存するため
    # デフォルトでは特定のロールバック処理を定義せず、手動での対応を要求します
    raise ActiveRecord::IrreversibleMigration
  end
end
