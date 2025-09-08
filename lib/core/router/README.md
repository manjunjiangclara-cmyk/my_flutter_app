# Router Architecture

This directory contains the navigation system for the app, organized by feature for better maintainability and separation of concerns.

## Structure

```
lib/core/router/
├── app_router.dart              # Main app router configuration
├── bottom_navigation_shell.dart # Bottom navigation shell component
├── navigation_helper.dart       # Navigation utility functions
├── router_exports.dart          # Centralized exports
└── README.md                    # This file

lib/features/{feature}/presentation/router/
├── {feature}_router.dart        # Feature-specific router configuration
```

## Features

### 1. Feature-Specific Routers
Each feature has its own router file that defines:
- Route paths and names
- Route builders
- Feature-specific navigation logic

### 2. Bottom Navigation Shell
A reusable component that provides:
- Bottom navigation bar
- Tab switching logic
- Consistent navigation behavior

### 3. Navigation Helper
Utility class providing:
- Type-safe navigation methods
- Consistent navigation patterns
- Easy-to-use navigation functions

## Usage

### Adding a New Route

1. Add the route to the appropriate feature router:
```dart
// In lib/features/your_feature/presentation/router/your_feature_router.dart
static const String newRoutePath = '/your-feature/new-route';
static const String newRouteName = 'new-route';

static List<RouteBase> get routes => [
  // ... existing routes
  GoRoute(
    path: newRoutePath,
    name: newRouteName,
    builder: (context, state) => const YourNewScreen(),
  ),
];
```

2. Add the route to the main app router if it's a top-level route:
```dart
// In lib/core/router/app_router.dart
routes: [
  // ... existing routes
  ...YourFeatureRouter.routes,
],
```

### Navigation

Use the NavigationHelper for consistent navigation:

```dart
// Navigate to a screen
NavigationHelper.goToMemory(context);
NavigationHelper.goToJournalView(context, journalId);

// Go back
NavigationHelper.goBack(context);
```

### Direct GoRouter Usage

For more complex navigation, use GoRouter directly:

```dart
// Using context.go() for replacement navigation
context.go('/memory');

// Using context.push() for stack navigation
context.push('/journal/123');
```

## Benefits

1. **Modularity**: Each feature manages its own routes
2. **Maintainability**: Easy to add/remove routes per feature
3. **Type Safety**: Route paths and names are constants
4. **Consistency**: Centralized navigation patterns
5. **Testability**: Each router can be tested independently
