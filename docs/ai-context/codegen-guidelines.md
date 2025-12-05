---
id: DOC-CODEGEN-001
title: コード生成ガイドライン
status: approved
created: 2025-01-01
updated: 2025-01-01
author: <作成者>
related: [DOC-FORMAT-001]
---

# コード生成ガイドライン

このドキュメントは、生成AIがコードを生成する際に従うべきルールを定義する。
AIはこのガイドラインを参照して、一貫性のあるコードを生成する。

## 1. 基本原則

### 言語・フレームワーク

```yaml
backend:
  language: <言語名>  # 例: TypeScript, Python, Go
  framework: <フレームワーク名>  # 例: Express, FastAPI, Gin
  runtime: <ランタイム>  # 例: Node.js 20, Python 3.11

frontend:
  language: <言語名>  # 例: TypeScript
  framework: <フレームワーク名>  # 例: React, Vue, Next.js
  styling: <スタイリング>  # 例: Tailwind CSS, CSS Modules

database:
  type: <DBタイプ>  # 例: PostgreSQL, MySQL, MongoDB
  orm: <ORM>  # 例: Prisma, TypeORM, SQLAlchemy
```

### コーディングスタイル

```yaml
style:
  indentation: spaces  # spaces または tabs
  indent_size: 2  # インデント幅
  line_length: 100  # 最大行長
  quotes: single  # single または double
  semicolons: true  # セミコロンの有無（JavaScript/TypeScript）
  trailing_comma: es5  # none, es5, all
```

## 2. 命名規則

### 全般

| 対象 | 規則 | 例 |
|------|------|-----|
| ファイル名 | ケバブケース | `user-service.ts` |
| クラス名 | パスカルケース | `UserService` |
| 関数名 | キャメルケース | `getUserById` |
| 変数名 | キャメルケース | `userName` |
| 定数名 | アッパースネークケース | `MAX_RETRY_COUNT` |
| 型名（TypeScript） | パスカルケース | `UserResponse` |
| インターフェース名 | パスカルケース + I接頭辞（任意） | `IUserRepository` または `UserRepository` |

### バックエンド固有

```yaml
naming:
  controller: <Name>Controller  # 例: UserController
  service: <Name>Service  # 例: UserService
  repository: <Name>Repository  # 例: UserRepository
  dto: <Name>Dto  # 例: CreateUserDto
  entity: <Name>  # 例: User
```

### フロントエンド固有

```yaml
naming:
  component: PascalCase  # 例: UserProfile
  hook: use<Name>  # 例: useUser
  context: <Name>Context  # 例: AuthContext
  page: <Name>Page  # 例: LoginPage
```

## 3. ディレクトリ構成

### バックエンド

```
src/backend/
├─ app/
│   ├─ controllers/      # リクエストハンドラ
│   ├─ services/         # ビジネスロジック
│   ├─ repositories/     # データアクセス
│   ├─ models/           # エンティティ/モデル
│   ├─ dtos/             # データ転送オブジェクト
│   ├─ middleware/       # ミドルウェア
│   ├─ utils/            # ユーティリティ
│   └─ config/           # 設定
├─ tests/
│   ├─ unit/
│   └─ integration/
└─ README.md
```

### フロントエンド

```
src/frontend/
├─ app/
│   ├─ components/       # 共通コンポーネント
│   │   ├─ ui/           # UIコンポーネント
│   │   └─ layout/       # レイアウトコンポーネント
│   ├─ features/         # 機能別モジュール
│   │   └─ <feature>/
│   │       ├─ components/
│   │       ├─ hooks/
│   │       └─ api/
│   ├─ hooks/            # 共通フック
│   ├─ contexts/         # コンテキスト
│   ├─ utils/            # ユーティリティ
│   ├─ types/            # 型定義
│   └─ pages/            # ページコンポーネント
├─ tests/
└─ README.md
```

## 4. エラーハンドリング

### エラーレスポンス形式

```json
{
  "code": "ERROR_CODE",
  "message": "Human readable message",
  "details": {}
}
```

### エラーコード規則

| カテゴリ | プレフィックス | 例 |
|---------|---------------|-----|
| バリデーション | VALIDATION_ | `VALIDATION_EMAIL_INVALID` |
| 認証 | AUTH_ | `AUTH_TOKEN_EXPIRED` |
| 認可 | AUTHZ_ | `AUTHZ_FORBIDDEN` |
| リソース | RESOURCE_ | `RESOURCE_NOT_FOUND` |
| システム | SYSTEM_ | `SYSTEM_INTERNAL_ERROR` |

### HTTPステータスコード

| 状況 | ステータスコード |
|------|-----------------|
| 成功 | 200 OK |
| 作成成功 | 201 Created |
| 削除成功（レスポンスなし） | 204 No Content |
| バリデーションエラー | 400 Bad Request |
| 認証エラー | 401 Unauthorized |
| 認可エラー | 403 Forbidden |
| リソースなし | 404 Not Found |
| 競合 | 409 Conflict |
| バリデーションエラー（詳細） | 422 Unprocessable Entity |
| サーバーエラー | 500 Internal Server Error |

## 5. ログ出力

### ログレベル

| レベル | 用途 |
|--------|------|
| debug | 開発時のデバッグ情報 |
| info | 正常な処理の記録 |
| warn | 警告（処理は継続可能） |
| error | エラー（処理が失敗） |

### ログ形式

```json
{
  "timestamp": "2025-01-01T00:00:00.000Z",
  "level": "info",
  "message": "User logged in",
  "context": {
    "userId": "123",
    "action": "login"
  }
}
```

## 6. セキュリティ

### 必須ルール

- [ ] ユーザー入力は必ずバリデーションする
- [ ] SQLクエリはパラメータ化する（SQLインジェクション対策）
- [ ] HTMLエスケープを行う（XSS対策）
- [ ] 認証トークンはHTTPOnly Cookieまたはセキュアストレージに保存
- [ ] 機密情報はログに出力しない
- [ ] 環境変数から設定を読み込む（ハードコーディング禁止）

### パスワード

```yaml
password:
  min_length: 8
  require_uppercase: true
  require_lowercase: true
  require_number: true
  require_special: false  # 任意
  hash_algorithm: bcrypt
  salt_rounds: 10
```

## 7. テスト

### テストファイル命名

```yaml
unit_test: <name>.test.ts  # 例: user-service.test.ts
integration_test: <name>.integration.test.ts
e2e_test: <name>.e2e.test.ts
```

### テスト構造

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a user with valid input', async () => {
      // Arrange
      // Act
      // Assert
    });

    it('should throw error when email is invalid', async () => {
      // Arrange
      // Act
      // Assert
    });
  });
});
```

### カバレッジ目標

```yaml
coverage:
  statements: 80
  branches: 80
  functions: 80
  lines: 80
```

## 8. コメント

### いつコメントを書くか

- [ ] 複雑なビジネスロジックの説明
- [ ] 非自明なアルゴリズムの説明
- [ ] TODO/FIXME
- [ ] 公開API（JSDoc/TSDoc）

### いつコメントを書かないか

- [ ] 自明なコード
- [ ] 変数名で意図が伝わる場合
- [ ] コメントで補うより命名を改善すべき場合

### JSDoc/TSDoc形式

```typescript
/**
 * ユーザーを作成する
 * @param dto - 作成データ
 * @returns 作成されたユーザー
 * @throws {ValidationError} バリデーションエラー時
 */
async function createUser(dto: CreateUserDto): Promise<User> {
  // ...
}
```

## 9. 禁止事項

### コード品質

- [ ] `any` 型の使用（TypeScript）
- [ ] コンソールログの本番コードへの残存
- [ ] マジックナンバー（定数化する）
- [ ] 深いネスト（3階層以上）
- [ ] 長い関数（50行以上）
- [ ] 未使用の変数・インポート

### セキュリティ

- [ ] パスワードの平文保存
- [ ] 機密情報のハードコーディング
- [ ] eval()の使用
- [ ] 動的SQL文字列連結

## 10. Lint/Formatter設定

### ESLint（TypeScript）

```json
{
  "extends": [
    "eslint:recommended",
    "@typescript-eslint/recommended"
  ],
  "rules": {
    "no-console": "warn",
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": "warn"
  }
}
```

### Prettier

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

## チェックリスト

AIがコードを生成する際に確認すべき項目：

- [ ] 命名規則に従っているか
- [ ] ディレクトリ構成に従っているか
- [ ] エラーハンドリングが適切か
- [ ] セキュリティルールを満たしているか
- [ ] テストが含まれているか
- [ ] 禁止事項に違反していないか
