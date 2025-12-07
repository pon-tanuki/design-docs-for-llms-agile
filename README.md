# AI最適化アジャイル開発向けドキュメントテンプレート

生成AI（Claude Code等）を最大限活用するアジャイル開発向けのドキュメントテンプレート集です。

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Language](https://img.shields.io/badge/language-Japanese-red.svg)

## 概要

このプロジェクトは、生成AIを活用したアプリケーション開発において、AIが理解しやすく、一貫性のあるコードを生成できるようにするためのドキュメントテンプレート集を提供します。

### 特徴

- **AIフレンドリー**: 生成AIが正確に解釈できる構造化フォーマット（YAMLブロック活用）
- **ミニマム設計**: 必要最小限のドキュメントで最大の効果
- **アジャイル対応**: スプリント単位で高速に回せる構成
- **1機能1ファイル**: 機能ごとに独立したドキュメント管理
- **Claude Code最適化**: カスタムコマンドで効率的な編集

## クイックスタート

### 方法1: すべて一度に（推奨）

```bash
SETUP_CLAUDE=yes curl -fsSL https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main/quick-setup.sh | bash
```

テンプレート + Claude Code設定を同時にセットアップします。

### 方法2: テンプレートのみ

```bash
curl -fsSL https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main/quick-setup.sh | bash
```

### 方法3: インタラクティブセットアップ

```bash
curl -fsSL https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main/setup-docs.sh | bash
```

対話形式でディレクトリ名などを選択できます。

### 環境変数でカスタマイズ

```bash
# ドキュメントディレクトリを"documents"に変更
DOCS_DIR=documents SETUP_CLAUDE=yes curl -fsSL https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main/quick-setup.sh | bash
```

## 使い方

### 1. テンプレートのセットアップ

上記のクイックスタートでテンプレートをダウンロードします。

### 2. 最初に編集するファイル

1. `docs/product-vision.md` - プロダクトの目的・方向性を定義
2. `docs/global-rules.md` - 認証・エラー形式などの横断ルールを定義
3. `docs/ai-context/glossary.md` - ドメイン用語を定義

### 3. 機能開発時

1. `docs/feature-specs/_template.md` をコピーして機能仕様を作成
2. `docs/ai-context/schema.yaml` にスキーマを追加
3. AIに仕様ファイルを読み込ませてコード生成

### 4. Claude Code カスタムコマンド

Claude Code設定をセットアップすると、以下のコマンドが使えます：

```bash
# 新規ドキュメント作成
/new-doc feature-specs/feature-payment.md 決済機能の仕様書

# ドキュメント更新（メタデータ自動更新）
/update-doc docs/product-vision.md ターゲットユーザーを追加

# 品質チェック
/check-doc docs/global-rules.md
```

## ディレクトリ構成

```
.
├── README.md                    # このファイル
├── CONTRIBUTING.md              # 貢献ガイドライン
├── CHANGELOG.md                 # 変更履歴
├── quick-setup.sh              # クイックセットアップスクリプト
├── setup-docs.sh               # インタラクティブセットアップ
├── setup-claude-config.sh      # Claude Code設定セットアップ
│
├── templates/                  # ドキュメントテンプレート
│   ├── product-vision.md       # プロダクトビジョン
│   ├── user-stories.md         # ユーザーストーリー
│   ├── global-rules.md         # グローバルルール
│   ├── system-flow.md          # システムフロー
│   │
│   ├── feature-specs/          # 機能仕様（1機能1ファイル）
│   │   └── _template.md        # 機能仕様テンプレート
│   │
│   ├── system-design/          # システム設計
│   │   ├── architecture.md     # アーキテクチャ概要
│   │   ├── api-design.md       # API設計
│   │   └── data-model.md       # データモデル
│   │
│   ├── ai-context/             # AI活用の核心
│   │   ├── document-format.md  # ドキュメント共通フォーマット
│   │   ├── codegen-guidelines.md # コード生成ガイドライン
│   │   ├── glossary.md         # 用語集
│   │   ├── schema.yaml         # スキーマ定義（唯一のソース）
│   │   └── prompts/            # プロンプトテンプレート
│   │       └── _template.md
│   │
│   └── operations/             # 運用
│       └── runbook.md          # ミニRunbook
│
├── examples/                   # Claude Code設定サンプル
│   ├── README.md               # 設定ガイド
│   └── .claude/                # Claude Code設定ファイル
│       ├── settings.json
│       ├── CLAUDE.md
│       └── commands/           # カスタムコマンド
│
└── .claude/                    # このプロジェクト用の設定
    ├── settings.json
    ├── CLAUDE.md
    └── commands/
```

## テンプレート一覧

### プロダクト全体（固定）

| ドキュメント | 説明 | AIへの重要度 |
|-------------|------|-------------|
| [product-vision.md](templates/product-vision.md) | プロダクトの目的・ターゲット・成功指標 | 高 |
| [global-rules.md](templates/global-rules.md) | 認証・エラー形式・バリデーション等の横断ルール | 最高 |
| [system-flow.md](templates/system-flow.md) | UI→API→DBのシステムフロー図 | 高 |

### スプリント単位

| ドキュメント | 説明 | AIへの重要度 |
|-------------|------|-------------|
| [user-stories.md](templates/user-stories.md) | ユーザーストーリー一覧 | 中 |
| [feature-specs/](templates/feature-specs/) | 機能仕様（AIが最も参照） | 最高 |

### AI活用（核心）

| ドキュメント | 説明 | AIへの重要度 |
|-------------|------|-------------|
| [codegen-guidelines.md](templates/ai-context/codegen-guidelines.md) | コード生成時のルール | 最高 |
| [glossary.md](templates/ai-context/glossary.md) | ドメイン用語集（AIの誤解を防ぐ） | 最高 |
| [schema.yaml](templates/ai-context/schema.yaml) | スキーマ定義（型の唯一のソース） | 最高 |
| [document-format.md](templates/ai-context/document-format.md) | ドキュメント共通フォーマット | 中 |

## AI活用のベストプラクティス

### コンテキストの与え方

AIにコード生成を依頼する際は、以下の順序でドキュメントを読み込ませる：

```
1. docs/ai-context/codegen-guidelines.md（コーディングルール）
2. docs/ai-context/glossary.md（用語定義）
3. docs/global-rules.md（横断ルール）
4. docs/feature-specs/<対象機能>.md（機能仕様）
5. docs/ai-context/schema.yaml（スキーマ定義）
```

### スキーマの一元管理

型定義は `docs/ai-context/schema.yaml` に集約し、他のドキュメントでは参照のみにする。これによりAIが混乱せずに正しい型を使用できる。

### プロンプトテンプレートの活用

`docs/ai-context/prompts/` にプロンプトテンプレートを用意することで、一貫した品質のコードを生成できる。

## Claude Code設定

Claude Code設定をセットアップすると、以下が可能になります：

### セットアップ

```bash
curl -fsSL https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main/setup-claude-config.sh | bash
```

### セットアップ内容

#### `.claude/settings.json`
- ドキュメントファイルの読み書き許可
- Git操作の適切な制御
- 機密ファイルへのアクセス拒否

#### `.claude/CLAUDE.md`
- ドキュメント編集ルール
- YAMLフロントマターの規約
- バージョン管理規約

#### カスタムコマンド
- `/new-doc <パス> <説明>`: 新規ドキュメント作成
- `/update-doc <パス> <変更内容>`: ドキュメント更新
- `/check-doc <パス>`: 品質チェック

詳細は [examples/README.md](./examples/README.md) を参照してください。

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

## よくある質問

### Q: Claude Code 以外の LLM でも使える？

**A:** はい、どの LLM でも使用できます。Markdown形式なので、ChatGPT、GitHub Copilot、Cursor など、あらゆる LLM ツールで編集可能です。

### Q: テンプレートをカスタマイズしてもいい？

**A:** もちろんです！これらのテンプレートはあくまでベースです。プロジェクトに合わせて自由に編集してください。

### Q: 商用プロジェクトで使える？

**A:** はい、MIT ライセンスなので商用利用可能です。クレジット表記も不要です。

## 貢献

バグ報告、機能要望、プルリクエストを歓迎します！

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'feat: Add some amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

詳細は [CONTRIBUTING.md](CONTRIBUTING.md) を参照してください。

## ライセンス

MIT License - 商用利用可能、クレジット表記不要

詳細は [LICENSE](./LICENSE) ファイルを参照してください。

---

このプロジェクトが役に立った場合は、スターをつけていただけると嬉しいです！
