# syntax=docker/dockerfile:1
# check=error=true

# このDockerfileは開発環境ではなく本番環境用に設計されています
# Kamalを使用するか、手動でビルドして実行します:
# docker build -t app .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<config/master.keyの値> --name app app

# 開発環境のコンテナ化については、Dev Containersを参照してください: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# .ruby-versionファイルのRubyバージョンと一致することを確認
ARG RUBY_VERSION=3.2.2
# ベースイメージとしてRubyの軽量版を使用
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Railsアプリケーションのワークディレクトリを設定
WORKDIR /rails

# 基本パッケージのインストール
# - curl: ネットワークリクエスト用
# - libjemalloc2: メモリ管理の最適化
# - libvips: 画像処理ライブラリ
# - postgresql-client: PostgreSQLクライアント
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# 本番環境用の設定
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# ビルド用の一時的なステージ（最終イメージのサイズを削減するため）
FROM base AS build

# gemのビルドに必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# アプリケーションのgemをインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# アプリケーションコードをコピー
COPY . .

# 起動時間を短縮するためにbootsnapコードをプリコンパイル
RUN bundle exec bootsnap precompile app/ lib/

# RAILS_MASTER_KEYを必要としない本番用アセットのプリコンパイル
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# アプリケーション用の最終ステージ
FROM base

# ビルドしたアーティファクト（gem、アプリケーション）をコピー
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# セキュリティのため、非rootユーザーとして実行時ファイルのみを所有・実行
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypointでデータベースを準備
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# デフォルトでThruster経由でサーバーを起動（実行時にオーバーライド可能）
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
