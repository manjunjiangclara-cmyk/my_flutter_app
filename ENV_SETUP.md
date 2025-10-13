# 环境变量设置指南

## 概述

本项目使用 `flutter_dotenv` 来管理敏感的环境变量，如API密钥。这确保了代码的安全性和可维护性。

## 快速开始

### 1. 复制环境变量模板

```bash
cp .env.example .env
```

### 2. 编辑环境变量

打开 `.env` 文件并设置你的API密钥：

```env
# Google Places API Configuration
GOOGLE_PLACES_API_KEY=your_actual_api_key_here

# Other API Keys (add as needed)
# STRIPE_API_KEY=your_stripe_key_here
# FIREBASE_API_KEY=your_firebase_key_here
```

### 3. 运行应用

```bash
flutter run
```

## 文件说明

- `.env` - 实际环境变量文件（已添加到.gitignore）
- `.env.example` - 环境变量模板文件（提交到版本控制）
- `lib/core/constants/api_constants.dart` - 使用环境变量的常量定义

## 安全最佳实践

### ✅ 推荐做法

1. **使用环境变量**: 所有敏感信息都存储在 `.env` 文件中
2. **版本控制**: `.env` 文件已添加到 `.gitignore`
3. **模板文件**: 提供 `.env.example` 供团队使用
4. **运行时加载**: API密钥在应用启动时动态加载

### ❌ 避免的做法

1. **硬编码密钥**: 不要在代码中直接写入API密钥
2. **提交敏感信息**: 不要将 `.env` 文件提交到版本控制
3. **共享密钥**: 不要通过不安全的方式分享API密钥

## 环境变量使用

### 在代码中访问环境变量

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 直接访问
String apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';

// 通过常量类访问（推荐）
String apiKey = ApiConstants.googlePlacesApiKey;
```

### 添加新的环境变量

1. 在 `.env.example` 中添加新变量：
   ```env
   NEW_API_KEY=your_new_api_key_here
   ```

2. 在 `api_constants.dart` 中添加getter：
   ```dart
   static String get newApiKey => 
       dotenv.env['NEW_API_KEY'] ?? '';
   ```

3. 更新你的 `.env` 文件：
   ```env
   NEW_API_KEY=your_actual_new_api_key_here
   ```

## 故障排除

### 常见问题

1. **环境变量未加载**
   - 确保 `main.dart` 中调用了 `await dotenv.load(fileName: ".env")`
   - 检查 `.env` 文件是否存在
   - 确认 `pubspec.yaml` 中包含了 `.env` 文件

2. **API密钥为空**
   - 检查 `.env` 文件中的变量名是否正确
   - 确认没有多余的空格或引号
   - 验证API密钥本身是否有效

3. **测试失败**
   - 在测试中也需要加载环境变量
   - 使用 `setUpAll()` 或 `setUp()` 加载环境变量

### 调试技巧

```dart
// 检查环境变量是否正确加载
print('API Key loaded: ${dotenv.env['GOOGLE_PLACES_API_KEY']?.isNotEmpty}');

// 列出所有环境变量
print('All env vars: ${dotenv.env.keys}');
```

## 团队协作

### 新团队成员设置

1. 克隆项目
2. 复制 `.env.example` 为 `.env`
3. 获取必要的API密钥
4. 在 `.env` 文件中设置密钥
5. 运行应用

### 部署注意事项

- 确保生产环境有正确的环境变量
- 使用CI/CD管道安全地注入环境变量
- 定期轮换API密钥
- 监控API使用情况

## 相关文档

- [flutter_dotenv 官方文档](https://pub.dev/packages/flutter_dotenv)
- [Google Places API 文档](https://developers.google.com/maps/documentation/places/web-service)
- [Flutter 环境变量最佳实践](https://docs.flutter.dev/deployment/environment-variables)
