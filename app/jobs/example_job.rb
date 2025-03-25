# ExampleJobは非同期処理を実装するためのジョブクラスです
# ApplicationJobを継承することで、Active Jobの機能を利用できます
class ExampleJob < ApplicationJob
  # queue_asメソッドで、このジョブを実行するキューを指定します
  # :defaultは標準のキューを使用することを意味します
  # 優先度の高いジョブは別のキュー（例：:high_priority）を指定することも可能です
  queue_as :default

  # performメソッドは、ジョブの実際の処理を定義するメソッドです
  # *argsは可変長引数で、任意の数の引数を受け取ることができます
  def perform(*args)
    # Rails.loggerを使用してログを出力
    # args.inspectで引数の内容を文字列として確認できます
    Rails.logger.info "ExampleJob is running with args: #{args.inspect}"

    # sleepメソッドで処理を一時停止
    # この例では5秒間待機していますが、実際のアプリケーションでは
    # メール送信、ファイル処理、外部APIとの通信などの重い処理を行います
    sleep 5

    # ジョブの完了をログに記録
    # 実運用では、処理の結果や所要時間なども記録すると便利です
    Rails.logger.info "ExampleJob completed"
  end
end
