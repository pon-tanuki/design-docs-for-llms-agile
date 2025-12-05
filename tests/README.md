# Tests

E2Eテストと統合テストのディレクトリ。

## ディレクトリ構成

```
tests/
├─ e2e/                  # E2E（End-to-End）テスト
│   ├─ fixtures/         # テストデータ
│   ├─ pages/            # ページオブジェクト
│   ├─ specs/            # テストケース
│   └─ support/          # ヘルパー
├─ integration/          # 統合テスト
│   └─ api/              # APIテスト
└─ README.md
```

## E2Eテスト

### セットアップ

```bash
# Playwrightのインストール
npm install -D @playwright/test
npx playwright install

# 環境変数の設定
cp .env.test.example .env.test
```

### 実行

```bash
# 全テスト実行
npm run test:e2e

# 特定のテスト実行
npm run test:e2e -- --grep "login"

# UIモードで実行
npm run test:e2e:ui

# レポート表示
npm run test:e2e:report
```

### テストファイル命名

```
<feature>.e2e.test.ts
例: login.e2e.test.ts, user-management.e2e.test.ts
```

### テスト例

```typescript
// tests/e2e/specs/login.e2e.test.ts
import { test, expect } from '@playwright/test';

test.describe('ログイン機能', () => {
  test('有効な認証情報でログインできる', async ({ page }) => {
    // Arrange
    await page.goto('/login');

    // Act
    await page.fill('[data-testid="email"]', 'user@example.com');
    await page.fill('[data-testid="password"]', 'password123');
    await page.click('[data-testid="submit"]');

    // Assert
    await expect(page).toHaveURL('/dashboard');
  });

  test('無効なパスワードでエラーが表示される', async ({ page }) => {
    await page.goto('/login');
    await page.fill('[data-testid="email"]', 'user@example.com');
    await page.fill('[data-testid="password"]', 'wrong');
    await page.click('[data-testid="submit"]');

    await expect(page.locator('[data-testid="error"]')).toBeVisible();
  });
});
```

## 統合テスト

### セットアップ

```bash
# テスト用DBの起動
docker-compose -f docker-compose.test.yml up -d

# マイグレーション
npm run db:migrate:test
```

### 実行

```bash
# 全テスト実行
npm run test:integration

# 特定のテスト実行
npm run test:integration -- --grep "users"
```

### テスト例

```typescript
// tests/integration/api/users.test.ts
import request from 'supertest';
import { app } from '../../../src/backend/app';

describe('Users API', () => {
  describe('GET /api/v1/users', () => {
    it('should return users list', async () => {
      const response = await request(app)
        .get('/api/v1/users')
        .set('Authorization', `Bearer ${token}`)
        .expect(200);

      expect(response.body.data).toBeInstanceOf(Array);
      expect(response.body.meta).toHaveProperty('total');
    });
  });
});
```

## テストデータ

### フィクスチャ

```typescript
// tests/e2e/fixtures/users.ts
export const testUser = {
  email: 'test@example.com',
  password: 'TestPass123',
  name: 'テストユーザー',
};
```

### シード

```bash
# テストデータの投入
npm run db:seed:test
```

## ベストプラクティス

- テストは独立して実行可能にする
- テストデータは各テストでセットアップ・クリーンアップする
- 本番データに依存しない
- `data-testid` 属性を使用してセレクタを安定させる
- 非同期処理は適切に待機する

## 関連ドキュメント

- [コード生成ガイドライン](../docs/ai-context/codegen-guidelines.md)
