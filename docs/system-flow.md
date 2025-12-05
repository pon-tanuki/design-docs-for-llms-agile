---
id: DOC-FLOW-001
title: システムフロー
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: <作成者>
related: [DOC-ARCH-001, DOC-API-001]
---

# システムフロー

このドキュメントは、UI→API→DBの縦の流れを定義する。
生成AIはこのドキュメントを参照して、各層の整合性を保ったコードを生成する。

## 概要図

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Frontend  │────▶│   Backend   │────▶│  Database   │
│    (UI)     │◀────│    (API)    │◀────│    (DB)     │
└─────────────┘     └─────────────┘     └─────────────┘
       │                   │                   │
       │                   │                   │
   ユーザー操作        ビジネスロジック      データ永続化
```

## 認証フロー

### ログイン

```yaml
flow: ログイン
steps:
  - step: 1
    layer: UI
    action: ログインフォーム表示
    component: LoginPage
    description: email, passwordの入力フォームを表示

  - step: 2
    layer: UI
    action: フォーム送信
    component: LoginForm
    request:
      method: POST
      endpoint: /api/v1/auth/login
      body:
        email: string
        password: string

  - step: 3
    layer: API
    action: 認証処理
    controller: AuthController.login
    service: AuthService.authenticate
    process:
      - emailでユーザー検索
      - パスワード照合
      - JWTトークン生成

  - step: 4
    layer: DB
    action: ユーザー取得
    repository: UserRepository.findByEmail
    table: users
    query: "SELECT * FROM users WHERE email = ?"

  - step: 5
    layer: API
    action: レスポンス返却
    response:
      success:
        status: 200
        body:
          token: string
          expiresAt: datetime
          user: User
      error:
        - code: AUTH_INVALID_CREDENTIALS
          status: 401
          message: "メールアドレスまたはパスワードが正しくありません"

  - step: 6
    layer: UI
    action: 認証状態保存
    storage: localStorage または Cookie
    redirect: /dashboard
```

### トークン検証

```yaml
flow: トークン検証
steps:
  - step: 1
    layer: UI
    action: APIリクエスト
    header: "Authorization: Bearer <token>"

  - step: 2
    layer: API
    action: ミドルウェアでトークン検証
    middleware: AuthMiddleware
    process:
      - Authorizationヘッダー取得
      - Bearerトークン抽出
      - JWT署名検証
      - 有効期限確認
      - ユーザー情報をリクエストに付与

  - step: 3
    layer: API
    action: リクエスト処理続行
    error:
      - code: AUTH_TOKEN_MISSING
        status: 401
      - code: AUTH_TOKEN_INVALID
        status: 401
      - code: AUTH_TOKEN_EXPIRED
        status: 401
```

## CRUD フロー

### 一覧取得 (Read - List)

```yaml
flow: リソース一覧取得
example: ユーザー一覧

steps:
  - step: 1
    layer: UI
    action: 一覧画面表示
    component: UserListPage
    trigger: ページ読み込み時

  - step: 2
    layer: UI
    action: API呼び出し
    hook: useUsers
    request:
      method: GET
      endpoint: /api/v1/users
      params:
        page: 1
        limit: 20
        sort: "createdAt:desc"

  - step: 3
    layer: API
    action: リクエスト処理
    controller: UserController.list
    service: UserService.findAll
    process:
      - クエリパラメータのバリデーション
      - ページネーション計算
      - ソート条件適用

  - step: 4
    layer: DB
    action: データ取得
    repository: UserRepository.findAll
    table: users
    query: |
      SELECT * FROM users
      ORDER BY created_at DESC
      LIMIT 20 OFFSET 0

  - step: 5
    layer: API
    action: レスポンス返却
    response:
      status: 200
      body:
        data: User[]
        meta:
          page: 1
          limit: 20
          total: 100
          totalPages: 5

  - step: 6
    layer: UI
    action: データ表示
    component: UserTable
    state: users, isLoading, error
```

### 単一取得 (Read - Single)

```yaml
flow: リソース単一取得
example: ユーザー詳細

steps:
  - step: 1
    layer: UI
    action: 詳細画面表示
    component: UserDetailPage
    params: { id: string }

  - step: 2
    layer: UI
    action: API呼び出し
    hook: useUser(id)
    request:
      method: GET
      endpoint: /api/v1/users/:id

  - step: 3
    layer: API
    action: リクエスト処理
    controller: UserController.findById
    service: UserService.findById
    process:
      - IDのバリデーション
      - ユーザー検索
      - 存在確認

  - step: 4
    layer: DB
    action: データ取得
    repository: UserRepository.findById
    table: users
    query: "SELECT * FROM users WHERE id = ?"

  - step: 5
    layer: API
    action: レスポンス返却
    response:
      success:
        status: 200
        body:
          data: User
      error:
        - code: RESOURCE_NOT_FOUND
          status: 404
          message: "ユーザーが見つかりません"
```

### 作成 (Create)

```yaml
flow: リソース作成
example: ユーザー作成

steps:
  - step: 1
    layer: UI
    action: 作成フォーム表示
    component: UserCreateForm

  - step: 2
    layer: UI
    action: フォーム送信
    request:
      method: POST
      endpoint: /api/v1/users
      body:
        email: string
        name: string
        password: string

  - step: 3
    layer: API
    action: リクエスト処理
    controller: UserController.create
    service: UserService.create
    process:
      - 入力バリデーション
      - 重複チェック（email）
      - パスワードハッシュ化
      - ユーザー作成

  - step: 4
    layer: DB
    action: データ挿入
    repository: UserRepository.create
    table: users
    query: |
      INSERT INTO users (id, email, name, password_hash, ...)
      VALUES (?, ?, ?, ?, ...)

  - step: 5
    layer: API
    action: レスポンス返却
    response:
      success:
        status: 201
        header:
          Location: /api/v1/users/:id
        body:
          data: User
      error:
        - code: CONFLICT_EMAIL_EXISTS
          status: 409
          message: "このメールアドレスは既に使用されています"
        - code: VALIDATION_ERROR
          status: 422

  - step: 6
    layer: UI
    action: 成功処理
    redirect: /users/:id
    toast: "ユーザーを作成しました"
```

### 更新 (Update)

```yaml
flow: リソース更新
example: ユーザー更新

steps:
  - step: 1
    layer: UI
    action: 編集フォーム表示
    component: UserEditForm
    initial_data: 既存のユーザーデータ

  - step: 2
    layer: UI
    action: フォーム送信
    request:
      method: PATCH
      endpoint: /api/v1/users/:id
      body:
        name: string  # 変更するフィールドのみ

  - step: 3
    layer: API
    action: リクエスト処理
    controller: UserController.update
    service: UserService.update
    process:
      - 入力バリデーション
      - 存在確認
      - 更新処理

  - step: 4
    layer: DB
    action: データ更新
    repository: UserRepository.update
    table: users
    query: |
      UPDATE users
      SET name = ?, updated_at = NOW()
      WHERE id = ?

  - step: 5
    layer: API
    action: レスポンス返却
    response:
      success:
        status: 200
        body:
          data: User
      error:
        - code: RESOURCE_NOT_FOUND
          status: 404
```

### 削除 (Delete)

```yaml
flow: リソース削除
example: ユーザー削除

steps:
  - step: 1
    layer: UI
    action: 削除確認ダイアログ
    component: DeleteConfirmDialog

  - step: 2
    layer: UI
    action: 削除リクエスト
    request:
      method: DELETE
      endpoint: /api/v1/users/:id

  - step: 3
    layer: API
    action: リクエスト処理
    controller: UserController.delete
    service: UserService.delete
    process:
      - 存在確認
      - 削除処理（論理削除または物理削除）

  - step: 4
    layer: DB
    action: データ削除
    repository: UserRepository.delete
    table: users
    query:
      logical: "UPDATE users SET status = 'deleted', deleted_at = NOW() WHERE id = ?"
      physical: "DELETE FROM users WHERE id = ?"

  - step: 5
    layer: API
    action: レスポンス返却
    response:
      success:
        status: 204
        body: null
      error:
        - code: RESOURCE_NOT_FOUND
          status: 404
```

---

## プロジェクト固有のフロー

以下にプロジェクト固有のフローを追加する。

### <機能名1>フロー

```yaml
flow: <機能名>
steps:
  - step: 1
    layer: UI
    action: <アクション>
    component: <コンポーネント名>

  - step: 2
    layer: API
    action: <アクション>
    controller: <コントローラー>
    service: <サービス>

  - step: 3
    layer: DB
    action: <アクション>
    repository: <リポジトリ>
    table: <テーブル名>
```

---

## 更新履歴

| 日付 | 変更内容 | 担当者 |
|------|---------|--------|
| YYYY-MM-DD | 初版作成 | <作成者> |
