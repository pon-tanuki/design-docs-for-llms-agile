---
id: DOC-RULES-001
title: グローバルルール
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: <作成者>
related: [DOC-CODEGEN-001, DOC-GLOSSARY-001]
---

# グローバルルール

このドキュメントは、システム全体で適用される横断的なルールを定義する。
生成AIはこのドキュメントを参照して、一貫性のあるコードを生成する。

> **重要**: 個別の機能仕様よりもこのグローバルルールが優先される。

## 1. 認証 (Authentication)

### 認証方式

```yaml
authentication:
  type: JWT
  algorithm: HS256
  secret_env: JWT_SECRET  # 環境変数名
  token_location: Authorization header  # Bearer token
  token_format: "Bearer <token>"
```

### トークン仕様

```yaml
token:
  access_token:
    expires_in: 24h  # 24時間
    claims:
      - sub: user_id
      - email: user_email
      - role: user_role
      - iat: issued_at
      - exp: expiration

  refresh_token:  # 任意
    expires_in: 7d  # 7日間
```

### 認証フロー

```
1. POST /auth/login
   → email, password を送信
   → 成功: { token, expiresAt, user }
   → 失敗: 401 Unauthorized

2. リクエスト時
   → Authorization: Bearer <token> ヘッダーを付与
   → トークン検証
   → 成功: リクエスト処理
   → 失敗: 401 Unauthorized
```

## 2. 認可 (Authorization)

### RBAC（ロールベースアクセス制御）

```yaml
roles:
  admin:
    description: 管理者（全権限）
    permissions: ["*"]

  user:
    description: 一般ユーザー
    permissions:
      - "read:own_profile"
      - "update:own_profile"
      - "read:public_resources"

  guest:
    description: ゲスト（閲覧のみ）
    permissions:
      - "read:public_resources"
```

### 権限チェック

```yaml
permission_check:
  order:
    1. トークンの有効性を確認
    2. ユーザーのロールを取得
    3. 必要な権限とロールの権限を照合
    4. 権限がない場合は 403 Forbidden
```

## 3. エラー形式 (Error Format)

### 標準エラーレスポンス

```json
{
  "code": "ERROR_CODE",
  "message": "Human readable message",
  "details": {}
}
```

### エラーコード体系

| プレフィックス | カテゴリ | 例 |
|---------------|---------|-----|
| VALIDATION_ | 入力バリデーション | VALIDATION_EMAIL_INVALID |
| AUTH_ | 認証 | AUTH_TOKEN_EXPIRED |
| AUTHZ_ | 認可 | AUTHZ_FORBIDDEN |
| RESOURCE_ | リソース | RESOURCE_NOT_FOUND |
| CONFLICT_ | 競合 | CONFLICT_EMAIL_EXISTS |
| SYSTEM_ | システム | SYSTEM_INTERNAL_ERROR |

### HTTPステータスコードマッピング

| エラープレフィックス | HTTPステータス |
|---------------------|---------------|
| VALIDATION_ | 400 Bad Request または 422 Unprocessable Entity |
| AUTH_ | 401 Unauthorized |
| AUTHZ_ | 403 Forbidden |
| RESOURCE_ | 404 Not Found |
| CONFLICT_ | 409 Conflict |
| SYSTEM_ | 500 Internal Server Error |

### エラーメッセージ規則

- ユーザー向けメッセージは日本語で記述
- 技術的詳細は `details` に含める
- セキュリティ上の理由で詳細を隠す場合がある

```yaml
# 悪い例
message: "パスワードが間違っています"  # 攻撃者にヒントを与える

# 良い例
message: "メールアドレスまたはパスワードが正しくありません"
```

## 4. バリデーション (Validation)

### 共通バリデーションルール

```yaml
email:
  format: RFC 5322準拠
  max_length: 254
  error_code: VALIDATION_EMAIL_INVALID

password:
  min_length: 8
  max_length: 128
  require_uppercase: true
  require_lowercase: true
  require_number: true
  require_special: false
  error_code: VALIDATION_PASSWORD_INVALID

name:
  min_length: 1
  max_length: 100
  pattern: "^[\\p{L}\\p{N}\\s\\-_]+$"  # 文字、数字、スペース、ハイフン、アンダースコア
  error_code: VALIDATION_NAME_INVALID

id:
  format: UUID v4
  error_code: VALIDATION_ID_INVALID

date:
  format: ISO 8601 (YYYY-MM-DD)
  error_code: VALIDATION_DATE_INVALID

datetime:
  format: ISO 8601 (YYYY-MM-DDTHH:mm:ssZ)
  error_code: VALIDATION_DATETIME_INVALID
```

### バリデーションエラーレスポンス

```json
{
  "code": "VALIDATION_ERROR",
  "message": "入力値が不正です",
  "errors": [
    {
      "field": "email",
      "message": "メールアドレスの形式が正しくありません"
    },
    {
      "field": "password",
      "message": "パスワードは8文字以上で入力してください"
    }
  ]
}
```

## 5. ページネーション (Pagination)

### リクエストパラメータ

```yaml
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
```

### レスポンス形式

```json
{
  "data": [...],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

## 6. ソート (Sorting)

### リクエストパラメータ

```yaml
sorting:
  sort:
    format: "<field>:<direction>"
    direction: asc | desc
    default: "createdAt:desc"
    example: "name:asc"
```

### 複数フィールドソート

```
?sort=name:asc,createdAt:desc
```

## 7. 日時 (DateTime)

### タイムゾーン

```yaml
datetime:
  storage: UTC  # DBはUTCで保存
  api_format: ISO 8601 with timezone (YYYY-MM-DDTHH:mm:ssZ)
  display: ユーザーのタイムゾーンに変換（フロントエンドで処理）
```

### 例

```yaml
# 正例
created_at: "2025-01-01T00:00:00Z"
updated_at: "2025-01-01T12:30:45Z"

# 負例
created_at: "2025-01-01"  # 時刻がない
created_at: "2025/01/01 00:00:00"  # 形式が違う
```

## 8. ログ (Logging)

### ログレベル

| レベル | 用途 | 例 |
|--------|------|-----|
| debug | 開発時のデバッグ情報 | 変数の値、処理の詳細 |
| info | 正常な処理の記録 | ユーザーログイン、API呼び出し |
| warn | 警告（処理は継続可能） | レート制限接近、非推奨API使用 |
| error | エラー（処理が失敗） | 例外発生、外部サービス障害 |

### ログ形式

```json
{
  "timestamp": "2025-01-01T00:00:00.000Z",
  "level": "info",
  "message": "User logged in",
  "context": {
    "userId": "550e8400-e29b-41d4-a716-446655440000",
    "action": "login",
    "ip": "192.168.1.1"
  },
  "traceId": "abc123"
}
```

### ログに含めてはいけない情報

- パスワード
- アクセストークン
- クレジットカード番号
- その他の機密情報

## 9. API設計 (API Design)

### URLパターン

```yaml
url_pattern:
  collection: /api/v1/<resources>
  single: /api/v1/<resources>/<id>
  nested: /api/v1/<resources>/<id>/<sub-resources>
  action: /api/v1/<resources>/<id>/<action>

examples:
  - GET /api/v1/users
  - GET /api/v1/users/123
  - GET /api/v1/users/123/posts
  - POST /api/v1/users/123/activate
```

### HTTPメソッド

| 操作 | メソッド | 成功ステータス |
|------|---------|---------------|
| 一覧取得 | GET | 200 OK |
| 単一取得 | GET | 200 OK |
| 作成 | POST | 201 Created |
| 更新（全体） | PUT | 200 OK |
| 更新（部分） | PATCH | 200 OK |
| 削除 | DELETE | 204 No Content |

### レスポンス形式

```yaml
# 単一リソース
{
  "data": { ... }
}

# コレクション
{
  "data": [ ... ],
  "meta": { ... }
}

# 作成成功
{
  "data": { ... }
}
# Header: Location: /api/v1/users/123
```

## 10. セキュリティ (Security)

### CORS

```yaml
cors:
  allowed_origins:
    - <フロントエンドURL>
  allowed_methods:
    - GET
    - POST
    - PUT
    - PATCH
    - DELETE
  allowed_headers:
    - Authorization
    - Content-Type
  credentials: true
```

### レート制限

```yaml
rate_limit:
  default:
    requests: 100
    window: 1m  # 1分
  auth:
    requests: 10
    window: 1m
```

### セキュリティヘッダー

```yaml
security_headers:
  - X-Content-Type-Options: nosniff
  - X-Frame-Options: DENY
  - X-XSS-Protection: 1; mode=block
  - Strict-Transport-Security: max-age=31536000; includeSubDomains
```

---

## チェックリスト

コード生成時に以下を確認する：

- [ ] 認証が必要なエンドポイントにはJWT検証を実装しているか
- [ ] 適切なロールチェックを行っているか
- [ ] エラーレスポンスは標準形式に従っているか
- [ ] バリデーションルールを適用しているか
- [ ] 日時はISO 8601形式でUTCを使用しているか
- [ ] 機密情報をログに出力していないか
- [ ] セキュリティヘッダーを設定しているか

---

## 更新履歴

| 日付 | 変更内容 | 担当者 |
|------|---------|--------|
| YYYY-MM-DD | 初版作成 | <作成者> |
