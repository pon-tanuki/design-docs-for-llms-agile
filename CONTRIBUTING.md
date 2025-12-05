# コントリビューションガイド

このプロジェクトへの貢献に感謝します。

## 開発フロー

### 1. 環境セットアップ

```bash
# リポジトリのクローン
git clone <repository-url>
cd <project-name>

# 依存関係のインストール
npm install

# 環境変数の設定
cp .env.example .env
```

### 2. ブランチ戦略

```
main
├── develop          # 開発ブランチ
├── feature/*        # 機能開発
├── bugfix/*         # バグ修正
├── hotfix/*         # 緊急修正
└── release/*        # リリース準備
```

#### ブランチ命名規則

```
feature/<issue-number>-<short-description>
bugfix/<issue-number>-<short-description>
hotfix/<issue-number>-<short-description>

例:
feature/123-add-user-authentication
bugfix/456-fix-login-error
```

### 3. コミットメッセージ

[Conventional Commits](https://www.conventionalcommits.org/) に従う。

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Type

| タイプ | 説明 |
|--------|------|
| feat | 新機能 |
| fix | バグ修正 |
| docs | ドキュメントのみの変更 |
| style | コードの意味に影響しない変更（空白、フォーマット等） |
| refactor | バグ修正でも機能追加でもないコード変更 |
| perf | パフォーマンス改善 |
| test | テストの追加・修正 |
| chore | ビルドプロセスやツールの変更 |

#### 例

```
feat(auth): ログイン機能を追加

- JWTによる認証を実装
- ログインフォームを作成
- 認証ミドルウェアを追加

Closes #123
```

### 4. プルリクエスト

#### PRテンプレート

```markdown
## 概要
<!-- 変更内容の概要 -->

## 関連Issue
<!-- Closes #123 -->

## 変更内容
<!-- 変更の詳細 -->

## テスト
<!-- テスト方法 -->

## チェックリスト
- [ ] テストを追加・更新した
- [ ] ドキュメントを更新した
- [ ] Lintが通っている
- [ ] セルフレビューを行った
```

#### レビュープロセス

1. PRを作成
2. CIがパスすることを確認
3. レビュアーをアサイン
4. レビューコメントに対応
5. 承認後にマージ

## コーディング規約

[コード生成ガイドライン](docs/ai-context/codegen-guidelines.md) を参照。

### 主なルール

- TypeScriptを使用
- ESLint/Prettierの設定に従う
- テストを書く（カバレッジ80%以上）
- ドキュメントを更新する

## ドキュメント作成

[ドキュメントフォーマットガイドライン](docs/ai-context/document-format.md) を参照。

### 主なルール

- Front Matterを必ず記載
- 構造化データ（YAML/JSON）を活用
- 曖昧な表現を避ける
- 正例・負例を明示する

## Issue報告

### バグ報告

```markdown
## 環境
- OS:
- ブラウザ:
- バージョン:

## 再現手順
1.
2.
3.

## 期待される動作

## 実際の動作

## スクリーンショット（任意）
```

### 機能リクエスト

```markdown
## 背景
<!-- なぜこの機能が必要か -->

## 提案内容
<!-- 具体的な提案 -->

## 代替案（任意）
<!-- 検討した代替案 -->
```

## 行動規範

- 敬意を持ってコミュニケーションする
- 建設的なフィードバックを心がける
- 多様性を尊重する
- ハラスメントは許容しない

## 質問

- 技術的な質問: GitHub Discussions
- バグ報告: GitHub Issues
- セキュリティ問題: <security@example.com>

ご協力ありがとうございます！
