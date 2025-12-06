---
id: DOC-ARCH-001
title: アーキテクチャ概要
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: <作成者>
related: [DOC-FLOW-001, DOC-API-001, DOC-DATA-001]
---

# アーキテクチャ概要

このドキュメントは、システムのアーキテクチャを定義する。
生成AIはこのドキュメントを参照して、アーキテクチャに沿ったコードを生成する。

## システム構成図

```
┌─────────────────────────────────────────────────────────────────┐
│                         Client Layer                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   Browser   │  │  Mobile App │  │  API Client │              │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘              │
└─────────┼────────────────┼────────────────┼─────────────────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      API Gateway / Load Balancer                 │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                       Application Layer                          │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    Backend Service                       │    │
│  │  ┌───────────┐  ┌───────────┐  ┌───────────┐            │    │
│  │  │Controller │──▶│  Service  │──▶│Repository │            │    │
│  │  └───────────┘  └───────────┘  └─────┬─────┘            │    │
│  └──────────────────────────────────────┼──────────────────┘    │
└─────────────────────────────────────────┼───────────────────────┘
                                          │
                                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                         Data Layer                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │  Database   │  │    Cache    │  │   Storage   │              │
│  │ (PostgreSQL)│  │   (Redis)   │  │    (S3)     │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
```

## レイヤードアーキテクチャ

### 層の責務

```yaml
layers:
  presentation:
    description: ユーザーインターフェース層
    responsibilities:
      - リクエスト/レスポンスの処理
      - 入力バリデーション
      - 認証トークンの処理
    components:
      - Controller
      - Middleware
      - DTO

  application:
    description: アプリケーション層（ビジネスロジック）
    responsibilities:
      - ビジネスルールの実装
      - ユースケースの調整
      - トランザクション管理
    components:
      - Service
      - UseCase

  domain:
    description: ドメイン層
    responsibilities:
      - エンティティの定義
      - ドメインロジック
      - ビジネスルールのカプセル化
    components:
      - Entity
      - ValueObject
      - DomainService

  infrastructure:
    description: インフラストラクチャ層
    responsibilities:
      - データ永続化
      - 外部サービス連携
      - 技術的な関心事
    components:
      - Repository
      - ExternalService
      - Config
```

### 依存関係のルール

```
Presentation → Application → Domain ← Infrastructure
                              ↑
                              │
                    (依存性の逆転)
```

- 上位層は下位層に依存してよい
- 下位層は上位層に依存してはならない
- Domainは何にも依存しない（純粋なビジネスロジック）
- InfrastructureはDomainのインターフェースを実装する

## コンポーネント構成

### バックエンド

```yaml
backend:
  controllers:
    description: HTTPリクエストを受け取り、適切なサービスに委譲
    pattern: "<Resource>Controller"
    location: src/backend/app/controllers/

  services:
    description: ビジネスロジックを実装
    pattern: "<Resource>Service"
    location: src/backend/app/services/

  repositories:
    description: データアクセスを抽象化
    pattern: "<Resource>Repository"
    location: src/backend/app/repositories/

  models:
    description: エンティティ/データモデル
    pattern: "<Resource>"
    location: src/backend/app/models/

  dtos:
    description: データ転送オブジェクト
    pattern: "<Action><Resource>Dto"
    location: src/backend/app/dtos/

  middleware:
    description: 横断的関心事
    pattern: "<Name>Middleware"
    location: src/backend/app/middleware/
```

### フロントエンド

```yaml
frontend:
  pages:
    description: ルーティング先のページコンポーネント
    pattern: "<Name>Page"
    location: src/frontend/app/pages/

  components:
    description: 再利用可能なUIコンポーネント
    pattern: "<Name>"
    location: src/frontend/app/components/

  features:
    description: 機能単位のモジュール
    structure:
      - components/  # 機能固有のコンポーネント
      - hooks/       # 機能固有のフック
      - api/         # API呼び出し
      - types/       # 型定義
    location: src/frontend/app/features/<feature>/

  hooks:
    description: カスタムフック
    pattern: "use<Name>"
    location: src/frontend/app/hooks/

  contexts:
    description: React Context
    pattern: "<Name>Context"
    location: src/frontend/app/contexts/
```

## 技術スタック

### バックエンド

```yaml
backend:
  language: <言語>  # 例: TypeScript
  runtime: <ランタイム>  # 例: Node.js 20
  framework: <フレームワーク>  # 例: Express, NestJS
  orm: <ORM>  # 例: Prisma, TypeORM
  testing: <テストフレームワーク>  # 例: Jest
```

### フロントエンド

```yaml
frontend:
  language: <言語>  # 例: TypeScript
  framework: <フレームワーク>  # 例: React, Next.js
  state_management: <状態管理>  # 例: React Query, Zustand
  styling: <スタイリング>  # 例: Tailwind CSS
  testing: <テストフレームワーク>  # 例: Vitest, Testing Library
```

### インフラストラクチャ

```yaml
infrastructure:
  cloud: <クラウドプロバイダー>  # 例: AWS, GCP
  container: <コンテナ>  # 例: Docker
  orchestration: <オーケストレーション>  # 例: Kubernetes, ECS
  ci_cd: <CI/CD>  # 例: GitHub Actions
  monitoring: <モニタリング>  # 例: CloudWatch, Datadog
```

### データストア

```yaml
datastore:
  database:
    type: <DBタイプ>  # 例: PostgreSQL
    version: <バージョン>
    hosting: <ホスティング>  # 例: RDS, Cloud SQL
  cache:
    type: <キャッシュ>  # 例: Redis
    use_case:
      - セッション管理
      - レスポンスキャッシュ
  storage:
    type: <ストレージ>  # 例: S3
    use_case:
      - ファイルアップロード
      - 静的アセット
```

## 設計原則

### SOLID原則

```yaml
principles:
  single_responsibility:
    description: 単一責任の原則
    application: 1つのクラス/モジュールは1つの責務のみを持つ

  open_closed:
    description: 開放閉鎖の原則
    application: 拡張に対して開き、修正に対して閉じる

  liskov_substitution:
    description: リスコフの置換原則
    application: 派生クラスは基底クラスと置換可能

  interface_segregation:
    description: インターフェース分離の原則
    application: クライアント固有のインターフェースを使用

  dependency_inversion:
    description: 依存性逆転の原則
    application: 抽象に依存し、具体に依存しない
```

### その他の原則

```yaml
other_principles:
  dry:
    description: Don't Repeat Yourself
    application: コードの重複を避ける

  kiss:
    description: Keep It Simple, Stupid
    application: シンプルな設計を心がける

  yagni:
    description: You Aren't Gonna Need It
    application: 必要になるまで実装しない
```

## セキュリティアーキテクチャ

### 認証・認可

```yaml
security:
  authentication:
    method: JWT
    storage: HTTPOnly Cookie または Authorization Header
    expiration: 24時間

  authorization:
    method: RBAC
    enforcement: Middleware
```

### データ保護

```yaml
data_protection:
  encryption:
    at_rest: AES-256
    in_transit: TLS 1.3

  sensitive_data:
    - パスワード: bcryptハッシュ
    - 個人情報: 暗号化
```

## スケーラビリティ

### 水平スケーリング

```yaml
scaling:
  stateless:
    description: アプリケーションはステートレスに設計
    session: Redis等の外部ストアに保存

  load_balancing:
    description: ロードバランサーで負荷分散
    strategy: Round Robin / Least Connections
```

### パフォーマンス最適化

```yaml
performance:
  caching:
    - レスポンスキャッシュ
    - クエリ結果キャッシュ
    - 静的アセットのCDN配信

  database:
    - インデックス最適化
    - コネクションプーリング
    - リードレプリカ
```

---

## 更新履歴

| 日付 | 変更内容 | 担当者 |
|------|---------|--------|
| YYYY-MM-DD | 初版作成 | <作成者> |
