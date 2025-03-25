# ./bin/importmapを実行してnpmパッケージをピン留めする
# importmapはES Modulesをネイティブに使用するための仕組み

# アプリケーションのJavaScriptエントリーポイントをピン留め
# preload: trueで事前読み込みを有効化し、パフォーマンスを向上
pin "application", preload: true

# Turbo Railsをピン留め
# ページ遷移を高速化し、SPAのような体験を提供するライブラリ
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true

# Stimulusをピン留め
# JavaScriptフレームワーク。HTMLにインタラクティブな機能を追加
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true

# Stimulusのローディング機能をピン留め
# Stimulusコントローラーの自動読み込みを管理
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# app/javascript/controllersディレクトリ内の全Stimulusコントローラーを
# 'controllers'名前空間の下にピン留め
pin_all_from "app/javascript/controllers", under: "controllers"