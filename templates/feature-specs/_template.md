---
id: FEAT-<機能名>-001
title: <機能名>仕様
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: <作成者>
related: [US-<番号>]
---

# <機能名>

## 概要

<機能の概要を1〜2文で記述>

## ユーザーストーリー

```yaml
story: |
  As a <ユーザータイプ>,
  I want to <したいこと>
  So that <得られる価値>

priority: must | should | could | wont
```

## 完了条件（Acceptance Criteria）

```yaml
acceptance_criteria:
  - <完了条件1>
  - <完了条件2>
  - <完了条件3>
```

## 構造化仕様（Structured Spec）

### 入力

```yaml
inputs:
  <フィールド1>:
    type: string | number | boolean | object | array
    required: true | false
    description: <説明>
    validation:
      - <バリデーションルール1>
      - <バリデーションルール2>
    example: <例>

  <フィールド2>:
    type: string
    required: false
    description: <説明>
    default: <デフォルト値>
```

### 出力

```yaml
outputs:
  <フィールド1>:
    type: string
    description: <説明>
    example: <例>

  <フィールド2>:
    type: object
    description: <説明>
    schema: <スキーマ参照>
```

### ビジネスルール

```yaml
rules:
  - id: RULE-001
    description: <ルールの説明>
    condition: <条件>
    action: <アクション>

  - id: RULE-002
    description: <ルールの説明>
    condition: <条件>
    action: <アクション>
```

### エラーケース

```yaml
error_cases:
  - condition: <エラー条件1>
    code: <エラーコード>
    message: <エラーメッセージ>
    http_status: <HTTPステータス>

  - condition: <エラー条件2>
    code: <エラーコード>
    message: <エラーメッセージ>
    http_status: <HTTPステータス>
```

## 具体例（Examples）

### 正例（有効なケース）

```yaml
example_1:
  description: <正常系の説明>
  input:
    <フィールド1>: <値>
    <フィールド2>: <値>
  expected_output:
    <フィールド1>: <値>
  expected_status: 200

example_2:
  description: <別の正常系の説明>
  input:
    <フィールド1>: <値>
  expected_output:
    <フィールド1>: <値>
  expected_status: 201
```

### 負例（無効なケース）

```yaml
invalid_example_1:
  description: <異常系の説明>
  input:
    <フィールド1>: <無効な値>
  expected_error:
    code: <エラーコード>
    message: <エラーメッセージ>
  expected_status: 400

invalid_example_2:
  description: <別の異常系の説明>
  input:
    <フィールド1>: ""
  expected_error:
    code: VALIDATION_<FIELD>_REQUIRED
    message: "<フィールド名>は必須です"
  expected_status: 422
```

## API仕様

### エンドポイント

```yaml
api:
  method: POST | GET | PUT | PATCH | DELETE
  endpoint: /api/v1/<resource>
  authentication: required | optional | none
  authorization:
    - <必要なロール1>
    - <必要なロール2>
```

### リクエスト

```yaml
request:
  headers:
    Authorization: Bearer <token>
    Content-Type: application/json

  body:
    <フィールド1>: <型>
    <フィールド2>: <型>
```

### レスポンス

```yaml
response:
  success:
    status: 200
    body:
      data:
        <フィールド1>: <型>
        <フィールド2>: <型>

  error:
    - status: 400
      body:
        code: VALIDATION_ERROR
        message: <メッセージ>
        errors: [...]
```

## UI仕様 <!-- optional -->

### 画面構成

```yaml
page:
  name: <ページ名>
  route: /<ルート>
  components:
    - <コンポーネント1>
    - <コンポーネント2>
```

### フォーム要素

```yaml
form:
  fields:
    - name: <フィールド名>
      type: text | email | password | select | checkbox | ...
      label: <ラベル>
      placeholder: <プレースホルダー>
      validation: <バリデーションルール>

  buttons:
    submit:
      label: <ボタンラベル>
      loading_label: <ローディング中のラベル>
    cancel:
      label: キャンセル
```

### 状態

```yaml
states:
  initial: フォーム表示
  loading: 処理中（ボタン非活性、ローディング表示）
  success: 成功（リダイレクトまたはメッセージ表示）
  error: エラー（エラーメッセージ表示）
```

## データモデル <!-- optional -->

### 関連テーブル

```yaml
tables:
  - name: <テーブル名>
    operation: select | insert | update | delete
    fields:
      - <フィールド1>
      - <フィールド2>
```

### クエリ例

```sql
-- <操作の説明>
SELECT <fields>
FROM <table>
WHERE <condition>
```

## 関連ドキュメント

- [グローバルルール](../global-rules.md)
- [スキーマ定義](../ai-context/schema.yaml)
- [API設計](../system-design/api-design.md)

---

## チェックリスト

実装前に以下を確認する：

- [ ] 入出力の型が `schema.yaml` で定義されているか
- [ ] エラーコードが `global-rules.md` の規則に従っているか
- [ ] 認証・認可の要件が明確か
- [ ] 正例・負例が十分に定義されているか
- [ ] UI仕様が明確か（該当する場合）

---

## 更新履歴

| 日付 | 変更内容 | 担当者 |
|------|---------|--------|
| YYYY-MM-DD | 初版作成 | <作成者> |
