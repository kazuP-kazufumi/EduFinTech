# EduFinTech 開発ノート

このドキュメントは、EduFinTechプロジェクトの開発過程における考察、技術的な決定事項、環境構築手順などを記録するためのものです。

## 目次

- [開発環境](#開発環境)
- [技術スタック](#技術スタック)
- [デプロイ方法](#デプロイ方法)
- [技術的検討事項](#技術的検討事項)
- [進捗と課題](#進捗と課題)

## 開発環境

### 環境構築手順

```bash
# リポジトリのクローン
git clone <repository-url>
cd EduFinTech

# Dockerコンテナの起動
docker-compose up -d
```

### 開発ワークフロー

1. 新しい機能やバグ修正は新しいブランチで開発
2. 変更が完了したらテスト実行
3. プルリクエスト作成
4. レビュー後にマージ

## 技術スタック

現在の技術スタック（MVP）：

| カテゴリ | 技術 | 備考 |
|----------|------|------|
| 開発環境 | Docker | docker-compose.ymlで管理 |
| サーバーサイド | Ruby on Rails | バージョン8.0.x |
| データベース | PostgreSQL | |
| KVS | Redis | セッション管理、通知機能 |

今後の技術スタック（計画）：

| カテゴリ | 技術 | 目的 |
|----------|------|------|
| フロントエンド | React Next.js | パフォーマンス向上 |
| CSS | TailwindCSS | デザインの一貫性 |
| 認証 | Auth0 | セキュリティ強化 |

## デプロイ方法

### Kamalを使用した本番環境デプロイ

#### 必要なツールとサービス

- サーバー（VPSまたはクラウドサービス）
- Dockerレジストリアカウント（Docker Hub等）
- ドメイン名

#### デプロイ手順

```bash
# 初期設定（初回のみ）
bundle exec kamal init

# 環境変数の設定
bundle exec kamal env set RAILS_MASTER_KEY=<マスターキー>
bundle exec kamal env set DATABASE_URL=postgresql://user:password@db-host:5432/edufintech_production
bundle exec kamal env set REDIS_URL=redis://redis-host:6379/1

# デプロイ実行
bundle exec kamal setup
bundle exec kamal deploy
```

#### ゼロダウンタイムデプロイの仕組み

（ここにゼロダウンタイムデプロイの仕組みや注意点を記載）

## 技術的検討事項

### フロントエンド刷新計画

- [ ] Next.jsへの移行戦略検討
  - 段階的に移行するか、一度に置き換えるか
  - APIエンドポイントの設計

### 認証システム改善

- [ ] Auth0導入のメリット・デメリット
  - 現行のDeviseからの移行手順
  - 必要な設定項目

### パフォーマンス最適化

- [ ] N+1問題の解消
- [ ] キャッシュ戦略の検討

## 進捗と課題

### 202x年4月

- [x] Docker開発環境の構築
- [x] 基本的なCRUD機能の実装
- [ ] 本番環境へのデプロイ

### 解決すべき課題

- Kamalを使用したデプロイフロー確立
- PostgreSQLとRedisの本番環境設定
- SSL証明書の設定

---

*このドキュメントは継続的に更新されます。最終更新: 202x年4月* 