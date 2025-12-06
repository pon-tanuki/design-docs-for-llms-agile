#!/bin/bash
#
# クイックセットアップスクリプト (非インタラクティブ版)
# Usage: curl -fsSL https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main/quick-setup.sh | bash
# または環境変数で設定:
# DOCS_DIR=documents SETUP_CLAUDE=yes curl -fsSL ... | bash
#

set -e

# デフォルト設定
DOCS_DIR="${DOCS_DIR:-docs}"
SETUP_CLAUDE="${SETUP_CLAUDE:-no}"
REPO_URL="https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main"

echo "🚀 AI最適化ドキュメントテンプレートをセットアップ中..."
echo "📂 ディレクトリ: ${DOCS_DIR}"
echo "⚙️  Claude Code設定: ${SETUP_CLAUDE}"
echo ""

# ディレクトリ作成
mkdir -p "$DOCS_DIR"
mkdir -p "$DOCS_DIR/feature-specs"
mkdir -p "$DOCS_DIR/system-design"
mkdir -p "$DOCS_DIR/ai-context/prompts"
mkdir -p "$DOCS_DIR/operations"

# ダウンロード関数
download() {
    local url=$1
    local dest=$2
    mkdir -p "$(dirname "$dest")"
    curl -fsSL "$url" -o "$dest" 2>/dev/null || echo "⚠️  スキップ: $dest"
}

echo "📝 ドキュメントテンプレートをダウンロード中..."

# メインドキュメント
download "$REPO_URL/templates/product-vision.md" "$DOCS_DIR/product-vision.md"
download "$REPO_URL/templates/user-stories.md" "$DOCS_DIR/user-stories.md"
download "$REPO_URL/templates/global-rules.md" "$DOCS_DIR/global-rules.md"
download "$REPO_URL/templates/system-flow.md" "$DOCS_DIR/system-flow.md"

# 機能仕様
download "$REPO_URL/templates/feature-specs/_template.md" "$DOCS_DIR/feature-specs/_template.md"

# システム設計
download "$REPO_URL/templates/system-design/architecture.md" "$DOCS_DIR/system-design/architecture.md"
download "$REPO_URL/templates/system-design/api-design.md" "$DOCS_DIR/system-design/api-design.md"
download "$REPO_URL/templates/system-design/data-model.md" "$DOCS_DIR/system-design/data-model.md"

# AIコンテキスト
download "$REPO_URL/templates/ai-context/codegen-guidelines.md" "$DOCS_DIR/ai-context/codegen-guidelines.md"
download "$REPO_URL/templates/ai-context/document-format.md" "$DOCS_DIR/ai-context/document-format.md"
download "$REPO_URL/templates/ai-context/glossary.md" "$DOCS_DIR/ai-context/glossary.md"
download "$REPO_URL/templates/ai-context/schema.yaml" "$DOCS_DIR/ai-context/schema.yaml"
download "$REPO_URL/templates/ai-context/prompts/_template.md" "$DOCS_DIR/ai-context/prompts/_template.md"

# 運用
download "$REPO_URL/templates/operations/runbook.md" "$DOCS_DIR/operations/runbook.md"

# Claude Code設定のセットアップ
if [ "$SETUP_CLAUDE" = "yes" ] || [ "$SETUP_CLAUDE" = "y" ] || [ "$SETUP_CLAUDE" = "true" ]; then
    echo ""
    echo "⚙️  Claude Code設定をセットアップ中..."
    curl -fsSL "$REPO_URL/setup-claude-config.sh" | bash
fi

echo ""
echo "✅ セットアップ完了！"
echo "📂 ${DOCS_DIR}/ を確認してください"
echo ""

if [ "$SETUP_CLAUDE" != "yes" ] && [ "$SETUP_CLAUDE" != "y" ] && [ "$SETUP_CLAUDE" != "true" ]; then
    echo "💡 Claude Code設定をセットアップする場合:"
    echo "  curl -fsSL $REPO_URL/setup-claude-config.sh | bash"
    echo "  または"
    echo "  SETUP_CLAUDE=yes curl -fsSL $REPO_URL/quick-setup.sh | bash"
    echo ""
fi

echo "📖 使い方:"
echo "  1. ${DOCS_DIR}/product-vision.md を編集してプロダクトの方向性を定義"
echo "  2. ${DOCS_DIR}/global-rules.md で横断ルールを定義"
echo "  3. ${DOCS_DIR}/ai-context/glossary.md で用語を定義"
echo "  4. 機能開発時は ${DOCS_DIR}/feature-specs/_template.md をコピーして使用"
echo ""
