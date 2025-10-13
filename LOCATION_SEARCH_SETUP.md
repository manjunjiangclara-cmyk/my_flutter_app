# 地点搜索功能设置指南

## 概述

本应用已集成Google Places API，提供强大的地点搜索功能。用户可以搜索地点、地标、商家等，并获取详细的地点信息。

## 功能特性

- 🔍 **实时地点搜索**: 使用Google Places Text Search API
- 📍 **详细地点信息**: 包含名称、地址、经纬度、评分等
- ⭐ **地点评分显示**: 显示Google Places的评分信息
- 🏷️ **地点类型分类**: 自动分类为城市、地标、商家、社区等
- 💾 **数据持久化**: 地点信息保存到本地数据库
- 🔄 **离线回退**: API失败时使用模拟数据

## 设置步骤

### 1. 获取Google Places API密钥

1. 访问 [Google Cloud Console](https://console.cloud.google.com/)
2. 创建新项目或选择现有项目
3. 启用以下API：
   - Places API
   - Places API (New)
4. 创建API密钥
5. 限制API密钥的使用范围（推荐）

### 2. 配置API密钥

#### 方法一：使用环境变量（推荐）

1. 复制 `.env.example` 文件为 `.env`：
   ```bash
   cp .env.example .env
   ```

2. 在 `.env` 文件中设置你的API密钥：
   ```env
   GOOGLE_PLACES_API_KEY=your_actual_api_key_here
   ```

#### 方法二：直接修改代码（不推荐用于生产环境）

在 `lib/core/constants/api_constants.dart` 文件中，将 `YOUR_GOOGLE_PLACES_API_KEY` 替换为你的实际API密钥：

```dart
static const String googlePlacesApiKey = 'YOUR_ACTUAL_API_KEY_HERE';
```

### 3. 安全考虑

**重要**: 在生产环境中，不要将API密钥硬编码在代码中。本项目已配置使用环境变量：

1. **环境变量**: 使用 `flutter_dotenv` 包（已配置）
2. **构建配置**: 使用不同的构建配置
3. **服务器代理**: 通过你的后端服务器代理API调用

#### 环境变量安全特性

- ✅ `.env` 文件已添加到 `.gitignore`，不会被提交到版本控制
- ✅ 提供 `.env.example` 模板文件供团队使用
- ✅ API密钥在运行时动态加载，不在代码中硬编码

### 4. 测试功能

1. 运行应用
2. 进入Compose页面
3. 点击"Add Location"按钮
4. 在搜索框中输入地点名称（如"悉尼歌剧院"）
5. 查看搜索结果

## API使用限制

- **免费额度**: Google Places API有免费使用额度
- **请求限制**: 每分钟和每日都有请求限制
- **计费**: 超出免费额度后按使用量计费

## 故障排除

### 常见问题

1. **搜索无结果**
   - 检查API密钥是否正确
   - 确认API已启用
   - 检查网络连接

2. **API错误**
   - 查看控制台错误信息
   - 检查API配额是否用完
   - 验证API密钥权限

3. **应用崩溃**
   - 检查依赖是否正确安装
   - 运行 `flutter pub get`
   - 清理并重新构建应用

### 调试模式

在开发过程中，如果API调用失败，应用会自动回退到模拟数据，确保功能正常运行。

## 数据库结构

地点信息存储在以下字段中：

- `location_name`: 地点名称
- `location_address`: 详细地址
- `location_place_id`: Google Places ID
- `location_latitude`: 纬度
- `location_longitude`: 经度
- `location_types`: 地点类型（JSON格式）

## 自定义配置

可以在 `api_constants.dart` 中调整以下参数：

```dart
static const int maxSearchResults = 20;        // 最大搜索结果数
static const String defaultLanguage = 'en';    // 默认语言
static const String defaultRegion = 'us';      // 默认地区
```

## 支持的地点类型

- **城市** (City): 城市、行政区
- **地标** (Landmark): 旅游景点、纪念碑
- **商家** (Business): 餐厅、商店、服务
- **社区** (Neighborhood): 社区、街区

## 更新日志

- **v1.0.0**: 初始实现，支持基本地点搜索
- **v1.1.0**: 添加评分显示和类型分类
- **v1.2.0**: 集成数据库存储和离线回退

## 技术支持

如有问题，请检查：
1. API密钥配置
2. 网络连接
3. 应用日志
4. Google Cloud Console中的API状态
