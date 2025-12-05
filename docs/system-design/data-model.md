---
id: DOC-DATA-001
title: データモデル
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: <作成者>
related: [DOC-ARCH-001, DOC-API-001]
---

# データモデル

このドキュメントは、データベースのスキーマを定義する。
生成AIはこのドキュメントを参照して、データアクセス層のコードを生成する。

## データベース情報

```yaml
database:
  type: PostgreSQL  # MySQL, MongoDB, etc.
  version: 15
  charset: UTF-8
  collation: ja_JP.UTF-8
```

## 命名規則

```yaml
naming:
  tables:
    style: snake_case
    plural: true
    example: users, blog_posts, order_items

  columns:
    style: snake_case
    example: created_at, user_id, is_active

  primary_key:
    name: id
    type: UUID または BIGINT AUTO_INCREMENT

  foreign_key:
    pattern: "<table_singular>_id"
    example: user_id, post_id

  indexes:
    pattern: "idx_<table>_<columns>"
    example: idx_users_email

  unique_constraints:
    pattern: "uq_<table>_<columns>"
    example: uq_users_email
```

## 共通カラム

すべてのテーブルに含める標準カラム：

```yaml
common_columns:
  id:
    type: UUID
    primary_key: true
    default: gen_random_uuid()

  created_at:
    type: TIMESTAMP WITH TIME ZONE
    nullable: false
    default: CURRENT_TIMESTAMP

  updated_at:
    type: TIMESTAMP WITH TIME ZONE
    nullable: false
    default: CURRENT_TIMESTAMP
    on_update: CURRENT_TIMESTAMP

  deleted_at:  # 論理削除の場合
    type: TIMESTAMP WITH TIME ZONE
    nullable: true
    default: null
```

## ER図（テキスト形式）

```
┌──────────────────┐       ┌──────────────────┐
│      users       │       │      posts       │
├──────────────────┤       ├──────────────────┤
│ id (PK)          │───┐   │ id (PK)          │
│ email (UQ)       │   │   │ user_id (FK)     │───┐
│ password_hash    │   └──▶│ title            │   │
│ name             │       │ content          │   │
│ role             │       │ status           │   │
│ status           │       │ published_at     │   │
│ created_at       │       │ created_at       │   │
│ updated_at       │       │ updated_at       │   │
└──────────────────┘       └──────────────────┘   │
                                                   │
                           ┌──────────────────┐   │
                           │    comments      │   │
                           ├──────────────────┤   │
                           │ id (PK)          │   │
                           │ post_id (FK)     │◀──┘
                           │ user_id (FK)     │
                           │ content          │
                           │ created_at       │
                           │ updated_at       │
                           └──────────────────┘
```

## DBML定義

DBML（Database Markup Language）形式でスキーマを定義する。

```dbml
// =============================================================================
// Users
// =============================================================================
Table users {
  id uuid [pk, default: `gen_random_uuid()`]
  email varchar(254) [unique, not null, note: 'RFC 5322準拠']
  password_hash varchar(255) [not null, note: 'bcryptハッシュ']
  name varchar(100) [not null]
  role user_role [not null, default: 'user', note: 'admin, user, guest']
  status user_status [not null, default: 'pending', note: 'active, inactive, pending, deleted']
  email_verified_at timestamp [null]
  last_login_at timestamp [null]
  created_at timestamp [not null, default: `now()`]
  updated_at timestamp [not null, default: `now()`]
  deleted_at timestamp [null, note: '論理削除用']

  indexes {
    email [unique, name: 'uq_users_email']
    status [name: 'idx_users_status']
    created_at [name: 'idx_users_created_at']
  }

  note: 'ユーザーアカウント情報'
}

Enum user_role {
  admin [note: '管理者']
  user [note: '一般ユーザー']
  guest [note: 'ゲスト']
}

Enum user_status {
  active [note: '有効']
  inactive [note: '無効']
  pending [note: '確認待ち']
  deleted [note: '削除済み']
}

// =============================================================================
// Posts（例）
// =============================================================================
Table posts {
  id uuid [pk, default: `gen_random_uuid()`]
  user_id uuid [not null, ref: > users.id, note: '作成者']
  title varchar(200) [not null]
  content text [not null]
  status post_status [not null, default: 'draft']
  published_at timestamp [null, note: '公開日時']
  created_at timestamp [not null, default: `now()`]
  updated_at timestamp [not null, default: `now()`]
  deleted_at timestamp [null]

  indexes {
    user_id [name: 'idx_posts_user_id']
    status [name: 'idx_posts_status']
    published_at [name: 'idx_posts_published_at']
  }

  note: '投稿'
}

Enum post_status {
  draft [note: '下書き']
  published [note: '公開中']
  archived [note: 'アーカイブ']
}

// =============================================================================
// Comments（例）
// =============================================================================
Table comments {
  id uuid [pk, default: `gen_random_uuid()`]
  post_id uuid [not null, ref: > posts.id, note: '親投稿']
  user_id uuid [not null, ref: > users.id, note: 'コメント者']
  content text [not null]
  created_at timestamp [not null, default: `now()`]
  updated_at timestamp [not null, default: `now()`]
  deleted_at timestamp [null]

  indexes {
    post_id [name: 'idx_comments_post_id']
    user_id [name: 'idx_comments_user_id']
  }

  note: 'コメント'
}

// =============================================================================
// リレーションシップの意図
// =============================================================================
// Ref: users.id < posts.user_id
//   - 1:N の関係
//   - ユーザー削除時: posts は残す（論理削除のため）
//   - ON DELETE: RESTRICT

// Ref: posts.id < comments.post_id
//   - 1:N の関係
//   - 投稿削除時: コメントも論理削除
//   - ON DELETE: CASCADE（論理削除を伝播）
```

## テーブル詳細

### users

| カラム | 型 | NULL | デフォルト | 説明 |
|--------|-----|------|-----------|------|
| id | UUID | NO | gen_random_uuid() | 主キー |
| email | VARCHAR(254) | NO | - | メールアドレス（ユニーク） |
| password_hash | VARCHAR(255) | NO | - | bcryptハッシュ化パスワード |
| name | VARCHAR(100) | NO | - | ユーザー名 |
| role | ENUM | NO | 'user' | ロール（admin, user, guest） |
| status | ENUM | NO | 'pending' | ステータス（active, inactive, pending, deleted） |
| email_verified_at | TIMESTAMP | YES | NULL | メール確認日時 |
| last_login_at | TIMESTAMP | YES | NULL | 最終ログイン日時 |
| created_at | TIMESTAMP | NO | now() | 作成日時 |
| updated_at | TIMESTAMP | NO | now() | 更新日時 |
| deleted_at | TIMESTAMP | YES | NULL | 削除日時（論理削除） |

**インデックス:**
- `uq_users_email` (UNIQUE): email
- `idx_users_status`: status
- `idx_users_created_at`: created_at

### <テーブル名>

| カラム | 型 | NULL | デフォルト | 説明 |
|--------|-----|------|-----------|------|
| id | UUID | NO | gen_random_uuid() | 主キー |
| <column> | <type> | <nullable> | <default> | <description> |

## マイグレーション

### マイグレーションファイル命名規則

```yaml
migration:
  format: "<timestamp>_<description>.sql"
  example: "20250101000000_create_users_table.sql"
```

### マイグレーション例

```sql
-- 20250101000000_create_users_table.sql

-- Up
CREATE TYPE user_role AS ENUM ('admin', 'user', 'guest');
CREATE TYPE user_status AS ENUM ('active', 'inactive', 'pending', 'deleted');

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(254) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role user_role NOT NULL DEFAULT 'user',
    status user_status NOT NULL DEFAULT 'pending',
    email_verified_at TIMESTAMP WITH TIME ZONE,
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT uq_users_email UNIQUE (email)
);

CREATE INDEX idx_users_status ON users (status);
CREATE INDEX idx_users_created_at ON users (created_at);

-- Down
DROP TABLE IF EXISTS users;
DROP TYPE IF EXISTS user_status;
DROP TYPE IF EXISTS user_role;
```

## シーディング

### シードデータ例

```sql
-- seeds/users.sql

INSERT INTO users (id, email, password_hash, name, role, status, email_verified_at)
VALUES
  (
    '550e8400-e29b-41d4-a716-446655440000',
    'admin@example.com',
    '$2b$10$...',  -- bcrypt hash of 'password'
    '管理者',
    'admin',
    'active',
    CURRENT_TIMESTAMP
  ),
  (
    '550e8400-e29b-41d4-a716-446655440001',
    'user@example.com',
    '$2b$10$...',
    'テストユーザー',
    'user',
    'active',
    CURRENT_TIMESTAMP
  );
```

## クエリパターン

### よく使用するクエリ

```sql
-- ユーザー取得（論理削除を除外）
SELECT * FROM users
WHERE deleted_at IS NULL
ORDER BY created_at DESC;

-- ページネーション
SELECT * FROM users
WHERE deleted_at IS NULL
ORDER BY created_at DESC
LIMIT 20 OFFSET 0;

-- 検索
SELECT * FROM users
WHERE deleted_at IS NULL
  AND (name ILIKE '%keyword%' OR email ILIKE '%keyword%')
ORDER BY created_at DESC;
```

---

## 更新履歴

| 日付 | 変更内容 | 担当者 |
|------|---------|--------|
| YYYY-MM-DD | 初版作成 | <作成者> |
