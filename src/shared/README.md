# Shared

フロントエンドとバックエンドで共有するコード。

## ディレクトリ構成

```
shared/
├─ models/               # 共通モデル/型定義
├─ utils/                # 共通ユーティリティ
├─ constants/            # 共通定数
└─ README.md
```

## 使用例

### 型定義の共有

```typescript
// shared/models/user.ts
export interface User {
  id: string;
  email: string;
  name: string;
  role: UserRole;
  status: UserStatus;
  createdAt: string;
  updatedAt: string;
}

export type UserRole = 'admin' | 'user' | 'guest';
export type UserStatus = 'active' | 'inactive' | 'pending' | 'deleted';
```

### ユーティリティの共有

```typescript
// shared/utils/validation.ts
export const isValidEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};
```

### 定数の共有

```typescript
// shared/constants/errors.ts
export const ERROR_CODES = {
  VALIDATION_EMAIL_INVALID: 'VALIDATION_EMAIL_INVALID',
  AUTH_TOKEN_EXPIRED: 'AUTH_TOKEN_EXPIRED',
  RESOURCE_NOT_FOUND: 'RESOURCE_NOT_FOUND',
} as const;
```

## インポート方法

```typescript
// バックエンドから
import { User } from '@shared/models/user';

// フロントエンドから
import { User } from '@shared/models/user';
```

## 注意事項

- 環境固有のコードは含めない
- Node.js/ブラウザ両方で動作するコードのみ
- サードパーティ依存は最小限に
