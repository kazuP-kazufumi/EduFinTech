# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# EduFinTech - 学生と投資家のマッチングプラットフォーム

## サービス概要
このサービスは、進学資金を募りたい学生と、進学資金を投資として援助したい投資家をマッチングするサービスです。学生は自身の学習計画や将来の目標を公開し、投資家は魅力を感じた学生に対して支援を申し込みます。

## このサービスへの思い・作りたい理由
私は家庭の経済事情で大学進学を諦めた過去を持つものです。高額な学費が進学の障壁となる進学資金を工面するのに苦労する学生が存在する一方で、奨学金制度やクラウドファンディングでは対応しきれない課題もあります。そこで、学生と投資家が直接つながり、透明性を持った資金調達ができる仕組みを提供したいと考え、このサービスを企画しました。

## ユーザー層について
- 学生（高校生・大学生・専門学校生など）：進学資金を確保したいが、奨学金やアルバイトだけでは不十分な人。社会人になる前のスキルアップのための学習資金を集めたい人。
- 投資家（個人投資家・社会貢献に関心のある人・企業）：若手人材とのコネクションを作りたい企業。

## サービスの利用イメージ
経済的な事情で進路を諦めざるを得ない状況にある中学生や高校生、またはその保護者が債権対象となる学生自身の志をWEBアプリにアップロードし、進学資金として債権を発行して投資を募ります。投資家は学生ごとに発行される債権と、債権を発行している学生が公開している志を閲覧し、共感を得られる学生の債券を購入することで教育資金を援助します。

## 実装したい機能要件（優先順位順）
### 必須機能（MVP）
1. ユーザー認証
   - メールアドレス・パスワードによる登録・ログイン
   - ログイン状態の管理

2. 投稿機能
   - 資金調達投稿フォーム
   - 投稿一覧表示
   - 投稿詳細表示

3. マッチング機能
   - 支援申し込み機能
   - アプリ内通知
   - チャットコミュニケーション

### オプション機能（MVP後）
- プロフィール機能の拡充
- 検索・フィルタリング機能
- 管理画面

## 技術スタック
### MVP
| カテゴリ | 技術 | 選定理由 |
|----------|------|----------|
| 開発環境 | Docker | 環境構築の簡素化 |
| インフラ | Vercel | デプロイの容易さ |
| サーバーサイド | Ruby on Rails | 開発速度の速さ |
| データベース | PostgreSQL | 信頼性と無料枠の存在 |
| KVS | Redis | セッション管理と通知機能 |

### MVP後
| カテゴリ | 技術 | 目的 |
|----------|------|------|
| フロントエンド | React Next.js | パフォーマンス向上 |
| CSS | TailwindCSS | デザインの一貫性 |
| 認証 | Auth0 | セキュリティ強化 |

## 開発スケジュール
### フェーズ1（MVP開発：45-60日）
- 1日あたりの作業時間：2時間
- 1イシューあたりの作業時間：2時間程度
- 主な実装機能：
  - ユーザー認証システム
  - 資金調達投稿機能
  - 投稿一覧・詳細表示
  - チャットコミュニケーション機能
  - 通知システム

### フェーズ2（技術スタック改善）
- フロントエンド：React Next.jsへの移行
- UI/UX改善：TailwindCSSの導入
- 認証システム：Auth0の導入

## 開発フロー
- 1日2時間の作業時間を確保
- 1イシューあたり2時間程度のタスク分割
- 毎日の進捗管理とコミット

## プロジェクトの制約事項
- 個人開発のため、1日2時間程度の作業時間
- 1イシューあたり2時間程度の規模でタスクを分割
- 総開発期間：45-60日
- 優先順位の高い機能から実装
- セキュリティとユーザー体験を重視

## 設計資料
- 画面遷移図：https://www.figma.com/design/6UniA3RT5hVxYcEmARGgRt/Edumuch?node-id=0-1&p=f&t=zFVXGIKMkrWiqbk2-0
- ER図：https://gyazo.com/23f97bfc5fa38fec24b890527cab0b84
