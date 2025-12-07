# design-docs-for-llms-agile プロジェクト設定

## プロジェクト概要

このプロジェクトは、生成AI（Claude Code等）を活用したアジャイル開発向けのドキュメントテンプレート集を提供します。

**リポジトリ**: https://github.com/pon-tanuki/design-docs-for-llms-agile

## 言語設定

- すべてのドキュメントは日本語で記述
- コード例はTypeScript/JavaScriptを優先
- コメントも日本語

## プロジェクト構成

```
.
├── README.md                    # メインドキュメント
├── quick-setup.sh              # クイックセットアップスクリプト
├── setup-docs.sh               # インタラクティブセットアップスクリプト
├── setup-claude-config.sh      # Claude Code設定セットアップ
├── templates/                  # ドキュメントテンプレート
│   ├── product-vision.md       # プロダクトビジョン
│   ├── user-stories.md         # ユーザーストーリー
│   ├── global-rules.md         # グローバルルール
│   ├── system-flow.md          # システムフロー
│   ├── feature-specs/          # 機能仕様テンプレート
│   ├── system-design/          # システム設計
│   ├── ai-context/             # AI活用コンテキスト
│   └── operations/             # 運用ドキュメント
└── examples/                   # 利用者向けClaude Code設定サンプル
    └── .claude/                # Claude Code設定ファイル
```

## テンプレート編集ルール

### 必須事項

#### YAML フロントマター
すべてのテンプレートファイルには以下のフロントマターが必要：
```yaml
---
id: DOC-XXX-001
title: ドキュメントタイトル
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: <作成者>
related: []
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

#### 見出し階層
- H1（#）は1回のみ（ドキュメントタイトル）
- H2→H3→H4の順で階層化
- 見出しレベルをスキップしない

#### コードブロック
必ず言語指定を行う：
```yaml
# YAML形式での構造化データを積極的に使用
example:
  key: value
```

#### プレースホルダー
テンプレートでは以下のプレースホルダーを使用：
- `<プロジェクト名>`
- `<作成者>`
- `YYYY-MM-DD`（日付）
- `<詳細>`

### AI最適化のポイント

#### 構造化データ
- YAMLコードブロックを積極的に使用し、AIが解析しやすい形式にする
- リスト形式で明確に項目を列挙

#### コンテキスト参照
AIにコード生成を依頼する際は、以下の順序でドキュメントを読み込ませる：
1. `templates/ai-context/codegen-guidelines.md`（コーディングルール）
2. `templates/ai-context/glossary.md`（用語定義）
3. `templates/global-rules.md`（横断ルール）
4. `templates/feature-specs/<対象機能>.md`（機能仕様）
5. `templates/ai-context/schema.yaml`（スキーマ定義）

## Git コミットルール

### Conventional Commits形式
- `feat:` 新機能の追加
- `fix:` バグ修正
- `docs:` ドキュメント変更のみ
- `refactor:` リファクタリング
- `chore:` ビルド、設定ファイルの変更

### コミットメッセージ
```
feat: 新機能の概要（日本語）

詳細な説明（複数行可）

## 追加内容
- 項目1
- 項目2
```

## 禁止事項

- 機密情報の含有
- 実践的でないコード例
- 英語のみのドキュメント
- プレースホルダーの不統一

## テンプレート追加時のチェックリスト

新しいテンプレートを追加する際は以下を確認：
- [ ] YAMLフロントマターが完全
- [ ] 見出し階層が正しい
- [ ] コードブロックに言語指定がある
- [ ] プレースホルダーが一貫している
- [ ] 更新履歴セクションがある
- [ ] 関連ドキュメントへのリンクがある
- [ ] AI最適化の構造化データが含まれている

## 参考リンク

- [Claude Code ドキュメント](https://docs.claude.com/en/docs/claude-code)
- [Conventional Commits](https://www.conventionalcommits.org/ja/)
