# Claude Code 設定ファイル サンプル

このディレクトリには、テンプレートを導入したプロジェクトで使用するClaude Code設定ファイルのサンプルが含まれています。

## 含まれるファイル

```
examples/.claude/
├── settings.json           # Claude Code設定ファイル
├── CLAUDE.md              # プロジェクト固有ルール定義
└── commands/
    ├── update-doc.md      # ドキュメント更新コマンド
    ├── check-doc.md       # ドキュメント品質チェックコマンド
    └── new-doc.md         # 新規ドキュメント作成コマンド
```

## セットアップ方法

### 1. テンプレートをダウンロード

まず、ドキュメントテンプレートをプロジェクトにダウンロードします：

```bash
cd your-project
curl -fsSL https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main/quick-setup.sh | bash
```

### 2. Claude Code設定をセットアップ

次に、Claude Code設定ファイルをプロジェクトルートにコピーします：

```bash
# すべてを一度にセットアップ
SETUP_CLAUDE=yes curl -fsSL https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main/quick-setup.sh | bash

# または設定のみセットアップ
curl -fsSL https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main/setup-claude-config.sh | bash
```

## 使い方

### Claude Code の起動

```bash
claude
```

### カスタムコマンドの使用

#### 1. 新規ドキュメント作成

```bash
/new-doc feature-specs/feature-payment.md 決済機能の仕様書
```

#### 2. ドキュメント更新

```bash
/update-doc docs/product-vision.md ターゲットユーザーを追加
```

#### 3. ドキュメント品質チェック

```bash
/check-doc docs/global-rules.md
```

## 設定のカスタマイズ

### ドキュメントディレクトリ名の変更

`.claude/settings.json` を編集して、プロジェクトに合わせて調整：

```json
{
  "env": {
    "DOCS_DIR": "documents"  // "docs"から変更
  }
}
```

### プロジェクト固有ルールの追加

`.claude/CLAUDE.md` に追記：

```markdown
## プロジェクト固有ルール

### 技術スタック
- フロントエンド: Next.js 14
- バックエンド: NestJS
- データベース: PostgreSQL
```

## Git管理

`.claude/settings.json` と `.claude/CLAUDE.md` は Git にコミットし、チーム全体で共有することを推奨します。

`.claude/settings.local.json` は個人の設定なので `.gitignore` に追加：

```gitignore
.claude/settings.local.json
```

## 関連リンク

- [メインリポジトリ](https://github.com/pon-tanuki/design-docs-for-llms-agile)
- [テンプレート一覧](../templates/)
- [Claude Code 公式ドキュメント](https://docs.claude.com/en/docs/claude-code)
