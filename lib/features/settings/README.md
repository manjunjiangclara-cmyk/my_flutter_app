# Settings Feature

This directory contains the modular settings feature implementation.

## Structure

```
settings/
└── presentation/
    ├── constants/
    │   └── settings_constants.dart  # Settings configuration
    ├── models/
    │   ├── models.dart              # Barrel file for models
    │   └── settings_item_model.dart # Settings data models
    ├── screens/
    │   └── settings_screen.dart     # Main settings screen
    └── widgets/
        ├── settings_app_bar.dart    # Custom app bar
        ├── settings_list.dart       # Settings list container
        ├── settings_section.dart    # Individual section widget
        ├── settings_tile.dart       # Individual setting item
        └── widgets.dart             # Barrel file for widgets
```

## Components

### Models
- **`SettingsItemModel`**: Represents a single settings item with icon, title, subtitle, and callback
- **`SettingsSectionModel`**: Represents a section containing multiple settings items

### Widgets
- **`SettingsScreen`**: Main screen that orchestrates all settings components
- **`SettingsAppBar`**: Custom app bar with settings title and emoji
- **`SettingsList`**: Container widget that renders all settings sections
- **`SettingsSection`**: Widget for displaying a section with title and items
- **`SettingsTile`**: Reusable widget for individual setting items

### Constants
- **`SettingsConstants`**: Centralized configuration for all settings sections and items

## Benefits of Modular Structure

1. **Reusability**: Components can be reused in other parts of the app
2. **Maintainability**: Each component has a single responsibility
3. **Testability**: Individual components can be tested in isolation
4. **Scalability**: Easy to add new settings sections or modify existing ones
5. **Separation of Concerns**: Data models, UI components, and configuration are separated

## Usage

The settings screen automatically loads all sections from `SettingsConstants.settingsSections`. To add new settings:

1. Add new strings to `AppStrings` if needed
2. Add new `SettingsItemModel` objects to the appropriate section in `SettingsConstants`
3. Implement the `onTap` callback for the new setting

## Adding New Settings

```dart
// In SettingsConstants.settingsSections
SettingsItemModel(
  icon: Icons.new_feature,
  title: 'New Setting',
  subtitle: 'Description of the new setting',
  onTap: () {
    // Handle the new setting
  },
),
```
