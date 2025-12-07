#!/bin/bash
#
# Claude Code設定セットアップスクリプト
# Usage: curl -fsSL https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main/setup-claude-config.sh | bash
#

set -e

REPO_URL="https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main"

echo "⚙️  Claude Code設定をセットアップ中..."

# .claude ディレクトリ作成
mkdir -p .claude/commands

# ダウンロード関数
download() {
    local url=$1
    local dest=$2
    mkdir -p "$(dirname "$dest")"
    curl -fsSL "$url" -o "$dest" 2>/dev/null || echo "⚠️  スキップ: $dest"
}

# 設定ファイルをダウンロード
download "$REPO_URL/examples/.claude/settings.json" ".claude/settings.json"
download "$REPO_URL/examples/.claude/CLAUDE.md" ".claude/CLAUDE.md"

# カスタムコマンドをダウンロード
download "$REPO_URL/examples/.claude/commands/new-doc.md" ".claude/commands/new-doc.md"
download "$REPO_URL/examples/.claude/commands/update-doc.md" ".claude/commands/update-doc.md"
download "$REPO_URL/examples/.claude/commands/check-doc.md" ".claude/commands/check-doc.md"

echo ""
echo "✅ Claude Code設定のセットアップ完了！"
echo ""
echo "📂 作成されたファイル:"
echo "  .claude/settings.json    - 権限設定"
echo "  .claude/CLAUDE.md        - プロジェクトルール"
echo "  .claude/commands/        - カスタムコマンド"
echo ""
echo "📖 利用可能なカスタムコマンド:"
echo "  /new-doc <パス> <説明>   - 新規ドキュメント作成"
echo "  /update-doc <パス> <変更> - ドキュメント更新"
echo "  /check-doc <パス>        - 品質チェック"
echo ""
echo "💡 Claude Code を起動して使ってみてください:"
echo "  claude"
echo ""
