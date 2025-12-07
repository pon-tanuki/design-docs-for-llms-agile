---
id: DOC-GLOSSARY-001
title: 用語集
status: approved
created: 2025-01-01
updated: 2025-01-01
author: <作成者>
related: [DOC-FORMAT-001, DOC-CODEGEN-001]
---

# 用語集

このドキュメントは、本プロジェクトで使用するドメイン用語を定義する。
生成AIはこの用語集を参照して、用語を正しく解釈する。

> **重要**: AIに正確なコードを生成させるため、用語の定義は明確かつ具体的に記述すること。

## 用語定義のフォーマット

各用語は以下の形式で定義する：

```yaml
<用語>:
  definition: <定義>
  alias: [<別名>, <略称>]  # 任意
  related: [<関連用語>]  # 任意
  example: <使用例>  # 任意
  note: <補足説明>  # 任意
```

---

## ビジネス用語

### ユーザー (User)

```yaml
ユーザー:
  definition: システムを利用する人物。アカウントを持ち、認証後に機能を利用できる。
  alias: [User, 利用者]
  related: [アカウント, ロール]
  example: "ユーザーがログインする"
```

### アカウント (Account)

```yaml
アカウント:
  definition: ユーザーがシステムにログインするための認証情報の集合。
  alias: [Account]
  related: [ユーザー, 認証]
  note: 1ユーザーは1アカウントを持つ（1:1の関係）
```

### ロール (Role)

```yaml
ロール:
  definition: ユーザーに付与される権限の集合を表す役割。
  alias: [Role, 権限グループ]
  related: [ユーザー, 権限]
  example: |
    - admin: 全機能にアクセス可能
    - user: 一般機能のみアクセス可能
    - guest: 閲覧のみ可能
```

<!-- 以下、プロジェクト固有の用語を追加 -->

### <用語1>

```yaml
<用語1>:
  definition: <定義を記述>
  alias: [<別名>]
  related: [<関連用語>]
  example: <使用例>
```

### <用語2>

```yaml
<用語2>:
  definition: <定義を記述>
```

---

## 技術用語

### JWT (JSON Web Token)

```yaml
JWT:
  definition: JSON形式で情報を安全に伝達するためのトークン規格。
  alias: [JSON Web Token]
  related: [認証, アクセストークン]
  note: 本プロジェクトではHS256アルゴリズムを使用
```

### API (Application Programming Interface)

```yaml
API:
  definition: システム間でデータをやり取りするためのインターフェース。
  alias: [Application Programming Interface]
  note: 本プロジェクトではREST APIを採用
```

### CRUD

```yaml
CRUD:
  definition: データ操作の4つの基本操作の頭文字。
  note: |
    - Create: 作成
    - Read: 読み取り
    - Update: 更新
    - Delete: 削除
```

---

## ステータス・状態

### ユーザーステータス

```yaml
user_status:
  definition: ユーザーアカウントの状態を表す。
  values:
    active: 有効なアカウント
    inactive: 非アクティブ（一時停止）
    pending: 本人確認待ち
    deleted: 削除済み（論理削除）
```

<!-- 以下、プロジェクト固有のステータスを追加 -->

### <エンティティ名>ステータス

```yaml
<entity>_status:
  definition: <定義>
  values:
    <status1>: <説明>
    <status2>: <説明>
```

---

## 略語・頭字語

| 略語 | 正式名称 | 説明 |
|------|---------|------|
| API | Application Programming Interface | システム間インターフェース |
| JWT | JSON Web Token | 認証トークン |
| CRUD | Create, Read, Update, Delete | 基本データ操作 |
| DTO | Data Transfer Object | データ転送オブジェクト |
| ORM | Object-Relational Mapping | オブジェクト関係マッピング |
| SSO | Single Sign-On | シングルサインオン |
| MFA | Multi-Factor Authentication | 多要素認証 |
| RBAC | Role-Based Access Control | ロールベースアクセス制御 |

<!-- 以下、プロジェクト固有の略語を追加 -->

---

## 用語の使い分け

### 紛らわしい用語の区別

| 用語A | 用語B | 違い |
|-------|-------|------|
| ユーザー | アカウント | ユーザーは人物、アカウントは認証情報 |
| 認証 | 認可 | 認証は本人確認、認可は権限確認 |
| 論理削除 | 物理削除 | 論理削除はフラグ管理、物理削除はデータ消去 |

### 禁止用語

以下の曖昧な用語は使用しない：

| 禁止用語 | 推奨用語 |
|---------|---------|
| データ | 具体的なエンティティ名（User, Orderなど） |
| 処理 | 具体的な動詞（create, update, deleteなど） |
| 情報 | 具体的なフィールド名（email, nameなど） |

---

## 更新履歴

| 日付 | 変更内容 | 担当者 |
|------|---------|--------|
| 2025-01-01 | 初版作成 | <作成者> |
