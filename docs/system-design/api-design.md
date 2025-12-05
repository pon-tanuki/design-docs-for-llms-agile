---
id: DOC-API-001
title: API設計
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: <作成者>
related: [DOC-RULES-001, DOC-ARCH-001]
---

# API設計

このドキュメントは、APIの設計方針と仕様を定義する。
生成AIはこのドキュメントを参照して、一貫性のあるAPIを実装する。

## API設計原則

### RESTful設計

```yaml
principles:
  - リソース指向の設計
  - HTTPメソッドを正しく使用
  - ステートレスな通信
  - 一貫したURL構造
  - 適切なHTTPステータスコード
```

### バージョニング

```yaml
versioning:
  strategy: URL path
  format: /api/v{major}/<resource>
  example: /api/v1/users
  breaking_change_policy: メジャーバージョンを上げる
```

## URL設計

### 基本パターン

```yaml
url_patterns:
  collection:
    pattern: /api/v1/<resources>
    example: /api/v1/users
    methods: [GET, POST]

  single:
    pattern: /api/v1/<resources>/<id>
    example: /api/v1/users/123
    methods: [GET, PUT, PATCH, DELETE]

  nested:
    pattern: /api/v1/<resources>/<id>/<sub-resources>
    example: /api/v1/users/123/posts
    methods: [GET, POST]

  action:
    pattern: /api/v1/<resources>/<id>/<action>
    example: /api/v1/users/123/activate
    methods: [POST]
```

### 命名規則

```yaml
naming:
  resources: 複数形、ケバブケース
  correct:
    - /api/v1/users
    - /api/v1/blog-posts
    - /api/v1/order-items
  incorrect:
    - /api/v1/user  # 単数形
    - /api/v1/blogPosts  # キャメルケース
    - /api/v1/getUsers  # 動詞を含む
```

## HTTPメソッド

### メソッドとCRUD対応

| メソッド | 操作 | 成功ステータス | べき等性 |
|---------|------|---------------|---------|
| GET | 取得（Read） | 200 | はい |
| POST | 作成（Create） | 201 | いいえ |
| PUT | 全体更新（Update） | 200 | はい |
| PATCH | 部分更新（Update） | 200 | はい |
| DELETE | 削除（Delete） | 204 | はい |

### 使い分け

```yaml
method_usage:
  GET:
    use_for:
      - リソースの取得
      - 一覧の取得
      - 検索
    constraints:
      - リクエストボディを使用しない
      - 副作用を起こさない

  POST:
    use_for:
      - リソースの作成
      - アクションの実行
      - 検索（複雑なクエリ）
    constraints:
      - べき等性が不要な操作

  PUT:
    use_for:
      - リソースの全体置換
    constraints:
      - 全フィールドを送信
      - 存在しない場合は作成（任意）

  PATCH:
    use_for:
      - リソースの部分更新
    constraints:
      - 変更するフィールドのみ送信

  DELETE:
    use_for:
      - リソースの削除
    constraints:
      - レスポンスボディなし（204）
```

## リクエスト設計

### ヘッダー

```yaml
request_headers:
  required:
    Content-Type: application/json
    Accept: application/json

  optional:
    Authorization: Bearer <token>  # 認証が必要な場合
    Accept-Language: ja  # 多言語対応の場合
    X-Request-ID: <uuid>  # トレーシング用
```

### クエリパラメータ

```yaml
query_parameters:
  pagination:
    page:
      type: integer
      default: 1
      min: 1
    limit:
      type: integer
      default: 20
      min: 1
      max: 100

  sorting:
    sort:
      format: "<field>:<direction>"
      example: "createdAt:desc"
      multiple: true  # カンマ区切りで複数指定可能

  filtering:
    format: "<field>=<value>"
    example: "status=active"
    operators:
      - "eq" (等しい): status=active
      - "ne" (等しくない): status!=active
      - "gt/gte" (より大きい): age>18
      - "lt/lte" (より小さい): price<1000
      - "in" (含まれる): status[]=active&status[]=pending

  search:
    q:
      type: string
      description: フリーテキスト検索
      example: "?q=keyword"
```

### リクエストボディ

```yaml
request_body:
  format: JSON
  content_type: application/json

  example:
    create_user:
      email: "user@example.com"
      name: "山田 太郎"
      password: "SecurePass123"

  constraints:
    - 未知のフィールドは無視（または400エラー）
    - nullと未指定を区別（PATCH時）
```

## レスポンス設計

### 成功レスポンス

```yaml
success_response:
  single_resource:
    format:
      data: <resource>
    example:
      data:
        id: "550e8400-e29b-41d4-a716-446655440000"
        email: "user@example.com"
        name: "山田 太郎"
        createdAt: "2025-01-01T00:00:00Z"

  collection:
    format:
      data: [<resource>, ...]
      meta:
        page: <number>
        limit: <number>
        total: <number>
        totalPages: <number>
    example:
      data:
        - id: "..."
          email: "..."
        - id: "..."
          email: "..."
      meta:
        page: 1
        limit: 20
        total: 100
        totalPages: 5

  created:
    status: 201
    header:
      Location: /api/v1/users/<id>
    format:
      data: <created_resource>

  no_content:
    status: 204
    body: null  # レスポンスボディなし
```

### エラーレスポンス

```yaml
error_response:
  format:
    code: <ERROR_CODE>
    message: <human_readable_message>
    details: <optional_details>

  validation_error:
    status: 400 または 422
    example:
      code: "VALIDATION_ERROR"
      message: "入力値が不正です"
      errors:
        - field: "email"
          message: "メールアドレスの形式が正しくありません"
        - field: "password"
          message: "パスワードは8文字以上で入力してください"

  not_found:
    status: 404
    example:
      code: "RESOURCE_NOT_FOUND"
      message: "ユーザーが見つかりません"

  unauthorized:
    status: 401
    example:
      code: "AUTH_TOKEN_INVALID"
      message: "認証に失敗しました"

  forbidden:
    status: 403
    example:
      code: "AUTHZ_FORBIDDEN"
      message: "この操作を行う権限がありません"
```

## 認証・認可

### 認証

```yaml
authentication:
  type: Bearer Token (JWT)
  header: "Authorization: Bearer <token>"

  endpoints:
    public:  # 認証不要
      - POST /api/v1/auth/login
      - POST /api/v1/auth/register
      - POST /api/v1/auth/forgot-password

    protected:  # 認証必要
      - GET /api/v1/users/me
      - GET /api/v1/users
      - POST /api/v1/posts
```

### 認可

```yaml
authorization:
  type: RBAC

  roles:
    admin:
      - "*"  # 全権限
    user:
      - "read:own_profile"
      - "update:own_profile"
      - "read:posts"
      - "create:posts"
      - "update:own_posts"
      - "delete:own_posts"
    guest:
      - "read:public_resources"

  ownership:
    description: リソースの所有者のみ操作可能
    example: ユーザーは自分の投稿のみ編集・削除可能
```

## エンドポイント一覧

### 認証 (Auth)

| メソッド | エンドポイント | 説明 | 認証 |
|---------|---------------|------|------|
| POST | /api/v1/auth/register | ユーザー登録 | 不要 |
| POST | /api/v1/auth/login | ログイン | 不要 |
| POST | /api/v1/auth/logout | ログアウト | 必要 |
| POST | /api/v1/auth/refresh | トークンリフレッシュ | 必要 |
| POST | /api/v1/auth/forgot-password | パスワードリセット依頼 | 不要 |
| POST | /api/v1/auth/reset-password | パスワードリセット | 不要 |

### ユーザー (Users)

| メソッド | エンドポイント | 説明 | 認証 | 認可 |
|---------|---------------|------|------|------|
| GET | /api/v1/users | ユーザー一覧 | 必要 | admin |
| POST | /api/v1/users | ユーザー作成 | 必要 | admin |
| GET | /api/v1/users/:id | ユーザー詳細 | 必要 | admin, owner |
| PATCH | /api/v1/users/:id | ユーザー更新 | 必要 | admin, owner |
| DELETE | /api/v1/users/:id | ユーザー削除 | 必要 | admin |
| GET | /api/v1/users/me | 自分の情報 | 必要 | user |

### <リソース名>

| メソッド | エンドポイント | 説明 | 認証 | 認可 |
|---------|---------------|------|------|------|
| GET | /api/v1/<resources> | 一覧取得 | 必要 | - |
| POST | /api/v1/<resources> | 作成 | 必要 | - |
| GET | /api/v1/<resources>/:id | 詳細取得 | 必要 | - |
| PATCH | /api/v1/<resources>/:id | 更新 | 必要 | - |
| DELETE | /api/v1/<resources>/:id | 削除 | 必要 | - |

## API仕様詳細（テンプレート）

### POST /api/v1/<resource>

```yaml
endpoint: POST /api/v1/<resource>
description: <リソース>を作成する

request:
  headers:
    Authorization: Bearer <token>
    Content-Type: application/json
  body:
    <field1>: <type>
    <field2>: <type>

response:
  success:
    status: 201
    headers:
      Location: /api/v1/<resource>/<id>
    body:
      data:
        id: <id>
        <field1>: <value>
        <field2>: <value>
        createdAt: <datetime>
        updatedAt: <datetime>

  errors:
    - status: 400
      code: VALIDATION_ERROR
      message: "入力値が不正です"
    - status: 401
      code: AUTH_TOKEN_INVALID
      message: "認証に失敗しました"
    - status: 409
      code: CONFLICT_<FIELD>_EXISTS
      message: "既に存在します"
```

---

## 更新履歴

| 日付 | 変更内容 | 担当者 |
|------|---------|--------|
| YYYY-MM-DD | 初版作成 | <作成者> |
