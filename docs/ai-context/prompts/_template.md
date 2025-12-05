---
id: PROMPT-<機能名>-001
title: <機能名>プロンプトテンプレート
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: <作成者>
related: [FEAT-<機能名>-001]
---

# <機能名> プロンプトテンプレート

このテンプレートを使用して、AIに一貫性のあるコードを生成させる。

## 使用方法

1. このテンプレートをコピーして `<機能名>-prompt.md` として保存
2. `<プレースホルダー>` を実際の値に置き換える
3. AIにこのプロンプトを読み込ませてコード生成を依頼

---

## プロンプト本文

以下のプロンプトをAIに入力する：

---

### コンテキスト

以下のドキュメントを読み込んでください：

1. `docs/ai-context/codegen-guidelines.md`（コーディングルール）
2. `docs/ai-context/glossary.md`（用語定義）
3. `docs/global-rules.md`（横断ルール）
4. `docs/feature-specs/feature-<機能名>.md`（機能仕様）
5. `docs/ai-context/schema.yaml`（スキーマ定義）

### タスク

<機能名>機能を実装してください。

### 要件

```yaml
機能: <機能の概要>

入力:
  - <入力1>: <型>（<説明>）
  - <入力2>: <型>（<説明>）

出力:
  - <出力1>: <型>（<説明>）

ルール:
  - <ルール1>
  - <ルール2>

エラーケース:
  - <エラー条件1>: <エラーコード>
  - <エラー条件2>: <エラーコード>
```

### 生成対象

以下のファイルを生成してください：

```yaml
バックエンド:
  - src/backend/app/controllers/<機能名>-controller.ts
  - src/backend/app/services/<機能名>-service.ts
  - src/backend/app/repositories/<機能名>-repository.ts
  - src/backend/app/dtos/<機能名>-dto.ts

フロントエンド:
  - src/frontend/app/features/<機能名>/components/<コンポーネント名>.tsx
  - src/frontend/app/features/<機能名>/hooks/use-<機能名>.ts
  - src/frontend/app/features/<機能名>/api/<機能名>-api.ts

テスト:
  - src/backend/tests/unit/<機能名>-service.test.ts
  - src/frontend/tests/<機能名>.test.tsx
```

### 制約条件

- `docs/ai-context/codegen-guidelines.md` のコーディングルールに従う
- `docs/ai-context/schema.yaml` の型定義を使用する
- `docs/global-rules.md` のエラー形式・認証方式に従う
- テストコードを含める

### 出力形式

各ファイルを以下の形式で出力してください：

```
// ファイル: <ファイルパス>
<コード>
```

---

## カスタマイズポイント

このテンプレートをプロジェクトに合わせてカスタマイズする：

### 1. 言語・フレームワーク

```yaml
# プロジェクトの技術スタックに合わせて変更
backend:
  language: TypeScript  # または Python, Go など
  framework: Express  # または FastAPI, Gin など

frontend:
  framework: React  # または Vue, Next.js など
```

### 2. ディレクトリ構成

```yaml
# プロジェクトのディレクトリ構成に合わせて変更
backend_path: src/backend/app/
frontend_path: src/frontend/app/
test_path: tests/
```

### 3. 追加の制約条件

```yaml
# プロジェクト固有の制約を追加
constraints:
  - <追加の制約1>
  - <追加の制約2>
```

---

## サンプル：ログイン機能

```yaml
機能: ユーザーログイン

入力:
  - email: string（必須、RFC準拠）
  - password: string（必須、8文字以上）

出力:
  - token: string（JWT形式）
  - expiresAt: datetime（ISO 8601形式）
  - user: User（ユーザー情報）

ルール:
  - emailとpasswordの組み合わせでユーザーを認証
  - 認証成功時はJWTトークンを発行
  - トークンの有効期限は24時間

エラーケース:
  - emailが空: VALIDATION_EMAIL_REQUIRED
  - emailの形式が不正: VALIDATION_EMAIL_INVALID
  - passwordが空: VALIDATION_PASSWORD_REQUIRED
  - 認証失敗: AUTH_INVALID_CREDENTIALS
  - ユーザーが存在しない: AUTH_USER_NOT_FOUND
```
