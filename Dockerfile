FROM ruby:3.2.2

# 必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client

# 作業ディレクトリの設定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# BundlerのインストールとGemのインストール
RUN bundle install

# アプリケーションのソースコードをコピー
COPY . /app

# コンテナ起動時に実行するコマンド
CMD ["rails", "server", "-b", "0.0.0.0"] 