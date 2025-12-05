# Backend

バックエンドアプリケーションのソースコード。

## ディレクトリ構成

```
backend/
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
│   ├─ unit/             # ユニットテスト
│   └─ integration/      # 統合テスト
└─ README.md
```

## セットアップ

```bash
# 依存関係のインストール
npm install

# 環境変数の設定
cp .env.example .env

# データベースのマイグレーション
npm run db:migrate

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
| `npm run db:migrate` | マイグレーションを実行 |
| `npm run db:seed` | シードデータを投入 |

## 環境変数

| 変数名 | 説明 | 例 |
|--------|------|-----|
| `DATABASE_URL` | DB接続文字列 | `postgresql://user:pass@localhost:5432/db` |
| `JWT_SECRET` | JWT署名用シークレット | `your-secret-key` |
| `PORT` | サーバーポート | `3000` |
| `NODE_ENV` | 実行環境 | `development` |

## 関連ドキュメント

- [アーキテクチャ概要](../../docs/system-design/architecture.md)
- [API設計](../../docs/system-design/api-design.md)
- [コード生成ガイドライン](../../docs/ai-context/codegen-guidelines.md)
