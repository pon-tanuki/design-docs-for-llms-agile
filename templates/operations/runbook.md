---
id: DOC-RUNBOOK-001
title: 運用Runbook
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: <作成者>
related: [DOC-ARCH-001]
---

# 運用Runbook

このドキュメントは、システムの運用に必要な情報をまとめたものである。
インシデント対応や日常運用の手順を記載する。

## システム概要

```yaml
system:
  name: <システム名>
  environment:
    production: <本番URL>
    staging: <ステージングURL>
    development: <開発URL>

  components:
    - name: Frontend
      type: SPA
      hosting: <ホスティング>
    - name: Backend API
      type: REST API
      hosting: <ホスティング>
    - name: Database
      type: PostgreSQL
      hosting: <ホスティング>
```

## 監視・アラート

### 監視ダッシュボード

```yaml
dashboards:
  - name: <ダッシュボード名>
    url: <URL>
    purpose: システム全体の健全性監視

  - name: <ダッシュボード名>
    url: <URL>
    purpose: APIパフォーマンス監視
```

### アラート設定

```yaml
alerts:
  - name: API高レイテンシ
    condition: p95 > 1000ms for 5 minutes
    severity: warning
    notification: Slack #alerts

  - name: エラー率上昇
    condition: error_rate > 1% for 5 minutes
    severity: critical
    notification: PagerDuty

  - name: DB接続数上限
    condition: connections > 80% of max
    severity: warning
    notification: Slack #alerts
```

## よくあるインシデント

### 1. APIレスポンス遅延

```yaml
incident: APIレスポンス遅延
symptoms:
  - API応答時間が通常より遅い
  - タイムアウトエラーが発生

diagnosis:
  steps:
    - 1. 監視ダッシュボードでレイテンシを確認
    - 2. DBクエリの実行時間を確認
    - 3. CPUとメモリ使用率を確認
    - 4. 外部サービスの応答時間を確認

  commands:
    # コンテナのリソース使用状況
    - kubectl top pods -n <namespace>
    # DBスロークエリ確認
    - "SELECT * FROM pg_stat_activity WHERE state = 'active';"

resolution:
  - DBクエリが遅い場合:
      - インデックス追加を検討
      - クエリの最適化
  - リソース不足の場合:
      - スケールアウト: kubectl scale deployment <name> --replicas=<n>
  - 外部サービス遅延の場合:
      - タイムアウト設定の見直し
      - サーキットブレーカーの確認
```

### 2. メモリ不足（OOM）

```yaml
incident: メモリ不足
symptoms:
  - Podが頻繁に再起動
  - OOMKilled ステータス

diagnosis:
  steps:
    - 1. Podのステータスを確認
    - 2. メモリ使用量の推移を確認
    - 3. メモリリークの兆候を確認

  commands:
    - kubectl describe pod <pod-name> -n <namespace>
    - kubectl logs <pod-name> -n <namespace> --previous

resolution:
  - 一時対応:
      - Pod再起動: kubectl delete pod <pod-name>
  - 恒久対応:
      - メモリリミット増加
      - メモリリークの修正
      - キャッシュ設定の見直し
```

### 3. DB接続エラー

```yaml
incident: DB接続エラー
symptoms:
  - "Connection refused" エラー
  - 接続タイムアウト

diagnosis:
  steps:
    - 1. DBインスタンスの状態を確認
    - 2. 接続数を確認
    - 3. ネットワーク設定を確認

  commands:
    # 接続数確認
    - "SELECT count(*) FROM pg_stat_activity;"
    # アクティブなクエリ確認
    - "SELECT * FROM pg_stat_activity WHERE state = 'active';"

resolution:
  - 接続数上限の場合:
      - アイドル接続を切断: "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE state = 'idle';"
      - コネクションプール設定の見直し
  - DBダウンの場合:
      - DBインスタンスの再起動（要承認）
      - フェイルオーバーの実行
```

### 4. 認証エラー多発

```yaml
incident: 認証エラー多発
symptoms:
  - 401エラーの増加
  - ユーザーからのログイン失敗報告

diagnosis:
  steps:
    - 1. JWT検証エラーのログを確認
    - 2. トークン有効期限の確認
    - 3. シークレットキーの整合性確認

  commands:
    # エラーログ確認
    - kubectl logs -l app=api -n <namespace> | grep "AUTH_"

resolution:
  - トークン期限切れ:
      - ユーザーに再ログインを案内
  - シークレット不一致:
      - 全環境のJWT_SECRETを確認
      - 必要に応じてシークレットをローテーション
```

## 定期運用タスク

### 日次

```yaml
daily_tasks:
  - task: ログ確認
    time: 09:00
    procedure:
      - エラーログを確認
      - 異常なパターンがないか確認
    owner: <担当チーム>

  - task: バックアップ確認
    time: 10:00
    procedure:
      - 自動バックアップが成功しているか確認
    owner: <担当チーム>
```

### 週次

```yaml
weekly_tasks:
  - task: パフォーマンスレビュー
    day: 月曜日
    procedure:
      - 週間のレスポンスタイム推移を確認
      - スロークエリをレビュー
    owner: <担当チーム>

  - task: セキュリティスキャン
    day: 水曜日
    procedure:
      - 依存関係の脆弱性スキャンを実行
      - 結果を確認し対応を検討
    owner: <担当チーム>
```

### 月次

```yaml
monthly_tasks:
  - task: キャパシティプランニング
    procedure:
      - リソース使用量の推移を確認
      - 増強が必要か検討
    owner: <担当チーム>

  - task: 災害復旧テスト
    procedure:
      - バックアップからのリストアテスト
      - フェイルオーバーテスト
    owner: <担当チーム>
```

## デプロイ手順

### 通常デプロイ

```yaml
deploy:
  prerequisites:
    - すべてのテストがパス
    - PRがレビュー承認済み
    - mainブランチにマージ済み

  procedure:
    staging:
      - 1. CI/CDパイプラインが自動実行
      - 2. ステージング環境でスモークテスト
      - 3. 動作確認後、本番デプロイを承認

    production:
      - 1. 本番デプロイを開始
      - 2. ローリングアップデート完了を待機
      - 3. ヘルスチェックがパスすることを確認
      - 4. スモークテスト実行
      - 5. 監視ダッシュボードで異常がないことを確認

  commands:
    # デプロイ状況確認
    - kubectl rollout status deployment/<name> -n <namespace>
    # ロールバック
    - kubectl rollout undo deployment/<name> -n <namespace>
```

### ロールバック

```yaml
rollback:
  trigger:
    - エラー率の急上昇
    - 重大な機能障害

  procedure:
    - 1. 即座にロールバックを実行
    - 2. ロールバック完了を確認
    - 3. サービス正常化を確認
    - 4. 原因調査（ポストモーテム）

  commands:
    - kubectl rollout undo deployment/<name> -n <namespace>
    - kubectl rollout status deployment/<name> -n <namespace>
```

## 緊急連絡先

```yaml
contacts:
  primary_oncall:
    name: <名前>
    phone: <電話番号>
    slack: @<ユーザー名>

  escalation:
    - level: 1
      name: <名前>
      role: <役割>
    - level: 2
      name: <名前>
      role: <役割>

  external:
    - service: <外部サービス名>
      support: <サポート連絡先>
```

## 環境情報

### 環境変数

```yaml
environment_variables:
  required:
    - DATABASE_URL: DB接続文字列
    - JWT_SECRET: JWT署名用シークレット
    - REDIS_URL: Redis接続文字列

  optional:
    - LOG_LEVEL: ログレベル（default: info）
    - RATE_LIMIT: レート制限（default: 100/min）
```

### インフラ情報

```yaml
infrastructure:
  kubernetes:
    cluster: <クラスター名>
    namespace: <ネームスペース>

  database:
    host: <ホスト>
    port: 5432
    name: <DB名>

  cache:
    host: <ホスト>
    port: 6379
```

## よく使うコマンド

```bash
# Pod一覧
kubectl get pods -n <namespace>

# ログ確認
kubectl logs -f <pod-name> -n <namespace>

# Podに入る
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh

# リソース使用状況
kubectl top pods -n <namespace>

# デプロイメント状況
kubectl rollout status deployment/<name> -n <namespace>

# シークレット確認
kubectl get secret <name> -n <namespace> -o yaml

# DB接続
psql $DATABASE_URL

# Redis接続
redis-cli -h <host> -p 6379
```

---

## 更新履歴

| 日付 | 変更内容 | 担当者 |
|------|---------|--------|
| YYYY-MM-DD | 初版作成 | <作成者> |
