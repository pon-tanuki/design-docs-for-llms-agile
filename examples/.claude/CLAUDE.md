# プロジェクト設定

## プロジェクト概要

[プロジェクト名を記入]

生成AIを活用した開発プロジェクト用のドキュメント設定です。

## 言語設定

- すべてのドキュメントは日本語で記述
- コード例はTypeScript/JavaScriptを優先
- コメントも日本語

## ドキュメント構成

```
docs/
├── product-vision.md       # プロダクトビジョン
├── user-stories.md         # ユーザーストーリー
├── global-rules.md         # グローバルルール
├── system-flow.md          # システムフロー
├── feature-specs/          # 機能仕様（1機能1ファイル）
├── system-design/          # システム設計
│   ├── architecture.md     # アーキテクチャ
│   ├── api-design.md       # API設計
│   └── data-model.md       # データモデル
├── ai-context/             # AI活用コンテキスト
│   ├── codegen-guidelines.md # コード生成ガイドライン
│   ├── glossary.md         # 用語集
│   └── schema.yaml         # スキーマ定義
└── operations/             # 運用
    └── runbook.md          # Runbook
```

## ドキュメント編集ルール

### 必須事項

#### YAML フロントマター
すべてのドキュメントファイルには以下のフロントマターが必要：
```yaml
---
id: DOC-XXX-001
title: ドキュメントタイトル
status: draft | review | approved
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: <作成者>
related: [関連ドキュメントID]
---
```

#### 更新履歴
ドキュメント末尾に更新履歴テーブルを含める：
```markdown
## 更新履歴

| 日付 | 変更内容 | 担当者 |
|------|---------|--------|
| YYYY-MM-DD | 初版作成 | <作成者> |
```

### フォーマット規則

- H1（#）は1回のみ（ドキュメントタイトル）
- H2→H3→H4の順で階層化
- コードブロックには必ず言語指定
- YAMLコードブロックを積極的に使用し、AIが解析しやすい形式に

## AI活用のベストプラクティス

### コンテキストの与え方

AIにコード生成を依頼する際は、以下の順序でドキュメントを読み込ませる：

1. `docs/ai-context/codegen-guidelines.md`（コーディングルール）
2. `docs/ai-context/glossary.md`（用語定義）
3. `docs/global-rules.md`（横断ルール）
4. `docs/feature-specs/<対象機能>.md`（機能仕様）
5. `docs/ai-context/schema.yaml`（スキーマ定義）

### スキーマの一元管理

型定義は `docs/ai-context/schema.yaml` に集約し、他のドキュメントでは参照のみにする。

## Git コミットルール

### Conventional Commits形式
- `feat:` 新機能の追加
- `fix:` バグ修正
- `docs:` ドキュメント変更のみ
- `refactor:` リファクタリング
- `chore:` ビルド、設定ファイルの変更

## 禁止事項

- 機密情報の含有（APIキー、パスワード等）
- `.env` ファイルの直接編集
- 破壊的なGit操作（force push等）
