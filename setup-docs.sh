#!/bin/bash
#
# インタラクティブセットアップスクリプト
# Usage: curl -fsSL https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main/setup-docs.sh | bash
#

set -e

REPO_URL="https://raw.githubusercontent.com/pon-tanuki/design-docs-for-llms-agile/main"

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  AI最適化アジャイル開発向けドキュメントテンプレート       ║${NC}"
echo -e "${BLUE}║  インタラクティブセットアップ                              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# ドキュメントディレクトリ名の入力
echo -e "${YELLOW}📂 ドキュメントディレクトリ名を入力してください${NC}"
echo -n "   (デフォルト: docs): "
read -r DOCS_DIR
DOCS_DIR="${DOCS_DIR:-docs}"

# Claude Code設定のセットアップ確認
echo ""
echo -e "${YELLOW}⚙️  Claude Code設定もセットアップしますか？${NC}"
echo -n "   (y/n, デフォルト: y): "
read -r SETUP_CLAUDE
SETUP_CLAUDE="${SETUP_CLAUDE:-y}"

echo ""
echo -e "${GREEN}📋 セットアップ内容:${NC}"
echo "   ドキュメントディレクトリ: ${DOCS_DIR}"
echo "   Claude Code設定: ${SETUP_CLAUDE}"
echo ""
echo -n "この内容でセットアップを開始しますか？ (y/n): "
read -r CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo -e "${RED}❌ セットアップをキャンセルしました${NC}"
    exit 0
fi

echo ""
echo -e "${GREEN}🚀 セットアップを開始します...${NC}"

# 環境変数を設定してquick-setup.shを実行
export DOCS_DIR
export SETUP_CLAUDE
curl -fsSL "$REPO_URL/quick-setup.sh" | bash

echo ""
echo -e "${GREEN}🎉 セットアップが完了しました！${NC}"
echo ""
echo -e "${BLUE}📖 次のステップ:${NC}"
echo "   1. ${DOCS_DIR}/product-vision.md を編集"
echo "   2. ${DOCS_DIR}/global-rules.md で横断ルールを定義"
echo "   3. Claude Code を起動: claude"
echo ""
