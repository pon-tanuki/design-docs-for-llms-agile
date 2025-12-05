---
id: DOC-STORIES-001
title: ユーザーストーリー一覧
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: <作成者>
related: [DOC-VISION-001]
---

# ユーザーストーリー一覧

このドキュメントは、プロダクトのユーザーストーリーを一覧化する。
各ストーリーの詳細仕様は `docs/feature-specs/` に配置する。

## ストーリーフォーマット

```yaml
id: US-<番号>
priority: must | should | could | wont
status: backlog | ready | in_progress | done
story: |
  As a <ユーザータイプ>,
  I want to <したいこと>
  So that <得られる価値>
acceptance_criteria:
  - <完了条件1>
  - <完了条件2>
spec: <詳細仕様へのリンク>
```

---

## Epic 1: 認証・ユーザー管理

### US-001: ユーザー登録

```yaml
id: US-001
priority: must
status: backlog
story: |
  As a 新規ユーザー,
  I want to アカウントを作成したい
  So that システムを利用できるようになる

acceptance_criteria:
  - email, password, nameを入力して登録できる
  - emailの重複チェックが行われる
  - パスワードは8文字以上で検証される
  - 登録後に確認メールが送信される

spec: ./feature-specs/feature-user-registration.md
```

### US-002: ログイン

```yaml
id: US-002
priority: must
status: backlog
story: |
  As a 登録済みユーザー,
  I want to ログインしたい
  So that 自分のアカウントにアクセスできる

acceptance_criteria:
  - email, passwordでログインできる
  - 認証成功時にダッシュボードへリダイレクトされる
  - 認証失敗時にエラーメッセージが表示される
  - 5回連続失敗でアカウントがロックされる

spec: ./feature-specs/feature-login.md
```

### US-003: ログアウト

```yaml
id: US-003
priority: must
status: backlog
story: |
  As a ログイン済みユーザー,
  I want to ログアウトしたい
  So that セッションを終了できる

acceptance_criteria:
  - ログアウトボタンをクリックするとセッションが終了する
  - ログアウト後はログインページにリダイレクトされる
  - ログアウト後は認証が必要なページにアクセスできない

spec: ./feature-specs/feature-logout.md
```

### US-004: パスワードリセット

```yaml
id: US-004
priority: should
status: backlog
story: |
  As a パスワードを忘れたユーザー,
  I want to パスワードをリセットしたい
  So that アカウントに再度アクセスできる

acceptance_criteria:
  - emailを入力してリセットメールを送信できる
  - リセットリンクは24時間有効
  - 新しいパスワードを設定できる

spec: ./feature-specs/feature-password-reset.md
```

---

## Epic 2: <エピック名>

### US-005: <ストーリー名>

```yaml
id: US-005
priority: <must | should | could | wont>
status: backlog
story: |
  As a <ユーザータイプ>,
  I want to <したいこと>
  So that <得られる価値>

acceptance_criteria:
  - <完了条件1>
  - <完了条件2>

spec: ./feature-specs/feature-<機能名>.md
```

---

## ストーリー管理

### 優先度の定義（MoSCoW法）

| 優先度 | 説明 |
|--------|------|
| must | 必須。これがないとリリースできない |
| should | 重要。できれば含めたい |
| could | あると良い。余裕があれば |
| wont | 今回は対象外 |

### ステータスの定義

| ステータス | 説明 |
|-----------|------|
| backlog | バックログに積まれている |
| ready | 詳細仕様が完了し、着手可能 |
| in_progress | 実装中 |
| done | 完了 |

### スプリント計画

| スプリント | ストーリー | ポイント |
|-----------|-----------|---------|
| Sprint 1 | US-001, US-002, US-003 | - |
| Sprint 2 | US-004, US-005 | - |

---

## 更新履歴

| 日付 | 変更内容 | 担当者 |
|------|---------|--------|
| YYYY-MM-DD | 初版作成 | <作成者> |
