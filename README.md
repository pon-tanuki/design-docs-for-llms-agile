# <プロジェクト名>

> 生成AIを最大限活用するアジャイル開発向けのドキュメントテンプレートリポジトリ

## 概要

このリポジトリは、生成AI（Claude、ChatGPT等）を活用したアプリケーション開発において、AIが理解しやすく、一貫性のあるコードを生成できるようにするためのドキュメントテンプレート集です。

### 特徴

- **AIフレンドリー**: 生成AIが正確に解釈できる構造化フォーマット
- **ミニマム設計**: 必要最小限のドキュメントで最大の効果
- **アジャイル対応**: スプリント単位で高速に回せる構成
- **1機能1ファイル**: 機能ごとに独立したドキュメント管理

## クイックスタート

### 1. テンプレートの取り込み

```bash
# 新規プロジェクトにテンプレートをコピー
git clone https://github.com/<your-org>/design-docs-for-llms-agile.git
cp -r design-docs-for-llms-agile/docs your-project/
cp -r design-docs-for-llms-agile/src your-project/
```

### 2. 最初に編集するファイル

1. `docs/product-vision.md` - プロダクトの目的・方向性を定義
2. `docs/global-rules.md` - 認証・エラー形式などの横断ルールを定義
3. `docs/ai-context/glossary.md` - ドメイン用語を定義

### 3. 機能開発時

1. `docs/feature-specs/_template.md` をコピーして機能仕様を作成
2. `docs/ai-context/schema.yaml` にスキーマを追加
3. AIに仕様ファイルを読み込ませてコード生成

## ディレクトリ構成

```
/
├─ README.md                    # このファイル
├─ CONTRIBUTING.md              # 貢献ガイドライン
├─ CHANGELOG.md                 # 変更履歴
│
├─ docs/                        # ドキュメント（AI最重要領域）
│   ├─ product-vision.md        # プロダクトブリーフ
│   ├─ user-stories.md          # ユーザーストーリー一覧
│   ├─ global-rules.md          # グローバルルール集
│   ├─ system-flow.md           # システムフロー図
│   │
│   ├─ feature-specs/           # 機能仕様（1機能1ファイル）
│   │   └─ _template.md         # 機能仕様テンプレート
│   │
│   ├─ system-design/           # システム設計
│   │   ├─ architecture.md      # アーキテクチャ概要
│   │   ├─ api-design.md        # API設計
│   │   └─ data-model.md        # データモデル
│   │
│   ├─ ai-context/              # AI活用の核心
│   │   ├─ document-format.md   # ドキュメント共通フォーマット
│   │   ├─ codegen-guidelines.md# コード生成ガイドライン
│   │   ├─ glossary.md          # 用語集
│   │   ├─ schema.yaml          # スキーマ定義（唯一のソース）
│   │   └─ prompts/             # プロンプトテンプレート
│   │       └─ _template.md
│   │
│   └─ operations/              # 運用
│       └─ runbook.md           # ミニRunbook
│
├─ src/                         # ソースコード
│   ├─ backend/                 # バックエンド
│   ├─ frontend/                # フロントエンド
│   └─ shared/                  # 共通モジュール
│
├─ infra/                       # インフラ
│   ├─ docker/                  # Docker設定
│   ├─ terraform/               # IaC
│   ├─ ci-cd/                   # CI/CDパイプライン
│   └─ scripts/                 # 運用スクリプト
│
└─ tests/                       # テスト
    ├─ e2e/                     # E2Eテスト
    └─ integration/             # 統合テスト
```

## ドキュメント一覧

### プロダクト全体（固定）

| ドキュメント | 説明 | AIへの重要度 |
|-------------|------|-------------|
| [product-vision.md](docs/product-vision.md) | プロダクトの目的・ターゲット・成功指標 | 高 |
| [global-rules.md](docs/global-rules.md) | 認証・エラー形式・バリデーション等の横断ルール | 最高 |
| [system-flow.md](docs/system-flow.md) | UI→API→DBのシステムフロー図 | 高 |

### スプリント単位

| ドキュメント | 説明 | AIへの重要度 |
|-------------|------|-------------|
| [user-stories.md](docs/user-stories.md) | ユーザーストーリー一覧 | 中 |
| [feature-specs/](docs/feature-specs/) | 機能仕様（AIが最も参照） | 最高 |

### AI活用（核心）

| ドキュメント | 説明 | AIへの重要度 |
|-------------|------|-------------|
| [document-format.md](docs/ai-context/document-format.md) | ドキュメント共通フォーマット | 中 |
| [codegen-guidelines.md](docs/ai-context/codegen-guidelines.md) | コード生成時のルール | 最高 |
| [glossary.md](docs/ai-context/glossary.md) | ドメイン用語集（AIの誤解を防ぐ） | 最高 |
| [schema.yaml](docs/ai-context/schema.yaml) | スキーマ定義（型の唯一のソース） | 最高 |

## AI活用のベストプラクティス

### 1. コンテキストの与え方

AIにコード生成を依頼する際は、以下の順序でドキュメントを読み込ませる：

```
1. docs/ai-context/codegen-guidelines.md（コーディングルール）
2. docs/ai-context/glossary.md（用語定義）
3. docs/global-rules.md（横断ルール）
4. docs/feature-specs/<対象機能>.md（機能仕様）
5. docs/ai-context/schema.yaml（スキーマ定義）
```

### 2. プロンプトテンプレートの活用

`docs/ai-context/prompts/` にプロンプトテンプレートを用意することで、一貫した品質のコードを生成できる。

### 3. スキーマの一元管理

型定義は `docs/ai-context/schema.yaml` に集約し、他のドキュメントでは参照のみにする。これによりAIが混乱せずに正しい型を使用できる。

## 開発フロー

```
[PRODUCT VISION]
       ↓
[GLOBAL RULES] — [SCHEMA] — [SYSTEM FLOW]
       ↓
スプリント毎
  ├─ [機能仕様]
  ├─ [API仕様]
  └─ [DBモデル]
       ↓
AIがコード生成
       ↓
Runbookで運用
```

## ライセンス

<ライセンスを記述>

## 貢献

[CONTRIBUTING.md](CONTRIBUTING.md) を参照してください。
