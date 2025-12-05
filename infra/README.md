# Infrastructure

インフラストラクチャ関連のコードと設定。

## ディレクトリ構成

```
infra/
├─ docker/               # Docker設定
│   ├─ Dockerfile.backend
│   ├─ Dockerfile.frontend
│   └─ docker-compose.yml
├─ terraform/            # IaC（Infrastructure as Code）
│   ├─ environments/
│   │   ├─ dev/
│   │   ├─ staging/
│   │   └─ production/
│   └─ modules/
├─ ci-cd/                # CI/CDパイプライン
│   └─ .github/
│       └─ workflows/
├─ scripts/              # 運用スクリプト
│   ├─ deploy.sh
│   ├─ backup.sh
│   └─ restore.sh
└─ README.md
```

## Docker

### ローカル開発環境の起動

```bash
# 全サービスを起動
docker-compose up -d

# ログを確認
docker-compose logs -f

# 停止
docker-compose down
```

### イメージのビルド

```bash
# バックエンド
docker build -f docker/Dockerfile.backend -t <app>-backend .

# フロントエンド
docker build -f docker/Dockerfile.frontend -t <app>-frontend .
```

## Terraform

### 環境の作成

```bash
cd terraform/environments/<env>

# 初期化
terraform init

# プラン確認
terraform plan

# 適用
terraform apply
```

### 環境変数

| 変数名 | 説明 |
|--------|------|
| `AWS_ACCESS_KEY_ID` | AWSアクセスキー |
| `AWS_SECRET_ACCESS_KEY` | AWSシークレットキー |
| `TF_VAR_environment` | 環境名 |

## CI/CD

### GitHub Actions ワークフロー

- **ci.yml**: プルリクエスト時のテスト・Lint
- **deploy-staging.yml**: ステージングデプロイ
- **deploy-production.yml**: 本番デプロイ

### デプロイフロー

```
[PR作成] → [CI実行] → [レビュー・マージ]
                           ↓
                    [ステージングデプロイ]
                           ↓
                    [動作確認]
                           ↓
                    [本番デプロイ承認]
                           ↓
                    [本番デプロイ]
```

## 運用スクリプト

| スクリプト | 説明 |
|-----------|------|
| `deploy.sh` | デプロイ実行 |
| `backup.sh` | DBバックアップ |
| `restore.sh` | DBリストア |
| `scale.sh` | スケーリング |

## 関連ドキュメント

- [アーキテクチャ概要](../docs/system-design/architecture.md)
- [運用Runbook](../docs/operations/runbook.md)
