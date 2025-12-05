# Frontend

フロントエンドアプリケーションのソースコード。

## ディレクトリ構成

```
frontend/
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

## セットアップ

```bash
# 依存関係のインストール
npm install

# 環境変数の設定
cp .env.example .env.local

# 開発サーバーの起動
npm run dev
```

## スクリプト

| コマンド | 説明 |
|---------|------|
| `npm run dev` | 開発サーバーを起動 |
| `npm run build` | プロダクションビルド |
| `npm run start` | プロダクションサーバーを起動 |
| `npm run test` | テストを実行 |
| `npm run lint` | Lintを実行 |
| `npm run storybook` | Storybookを起動 |

## 環境変数

| 変数名 | 説明 | 例 |
|--------|------|-----|
| `NEXT_PUBLIC_API_URL` | APIのベースURL | `http://localhost:3000/api/v1` |
| `NEXT_PUBLIC_APP_NAME` | アプリケーション名 | `My App` |

## コンポーネント設計

### 命名規則

- コンポーネント: PascalCase (`UserProfile.tsx`)
- フック: camelCase + useプレフィックス (`useUser.ts`)
- ユーティリティ: camelCase (`formatDate.ts`)

### ファイル構成

```
components/
├─ Button/
│   ├─ Button.tsx        # コンポーネント本体
│   ├─ Button.test.tsx   # テスト
│   ├─ Button.stories.tsx # Storybook
│   └─ index.ts          # エクスポート
```

## 関連ドキュメント

- [アーキテクチャ概要](../../docs/system-design/architecture.md)
- [コード生成ガイドライン](../../docs/ai-context/codegen-guidelines.md)
