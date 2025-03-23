# ApplicationJobは全てのジョブクラスの基底クラスです
# Active Job フレームワークを使用して非同期処理を実装します
class ApplicationJob < ActiveJob::Base
  # データベースのデッドロックが発生した場合、自動的にジョブを再試行します
  # - ActiveRecord::Deadlocked: 複数のトランザクションが互いのロックを待ち合わせる状態
  # - retry_on: 特定の例外が発生した場合にジョブを自動的に再実行するメソッド
  retry_on ActiveRecord::Deadlocked

  # ジョブ実行時に対象レコードが既に削除されている場合、そのジョブを破棄します
  # - ActiveJob::DeserializationError: シリアライズされたデータを復元できない場合に発生する例外
  # - discard_on: 特定の例外が発生した場合にジョブを破棄するメソッド
  # - 例：ユーザー削除後に、そのユーザーに関連するメール送信ジョブが実行される場合など
  discard_on ActiveJob::DeserializationError
end
