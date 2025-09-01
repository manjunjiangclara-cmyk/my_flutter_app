# SQLite Database Setup

This Flutter app uses SQLite for local data storage with the `sqflite` package.

## Dependencies

The following packages are required:

```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3
```

## Database Structure

### Journals Table

- `id`: Primary key (auto-increment)
- `title`: Journal entry title
- `content`: Journal entry content
- `created_at`: Creation timestamp
- `updated_at`: Last update timestamp
- `is_favorite`: Boolean flag (0/1)
- `tags`: Comma-separated tags
- `image_urls`: Comma-separated image URLs

### Tags Table

- `id`: Primary key (auto-increment)
- `name`: Tag name (unique)
- `color`: Tag color
- `created_at`: Creation timestamp

### Journal Tags Junction Table

- `journal_id`: Foreign key to journals table
- `tag_id`: Foreign key to tags table

## Usage

### 1. Initialize Database

```dart
final dbHelper = DatabaseHelper.instance;
final database = await dbHelper.database;
```

### 2. Basic CRUD Operations

```dart
// Insert a new journal
await db.insert('journals', {
  'title': 'My Journal Entry',
  'content': 'Today was amazing...',
  'created_at': DateTime.now().toIso8601String(),
  'updated_at': DateTime.now().toIso8601String(),
  'is_favorite': 0,
  'tags': 'personal,reflection',
  'image_urls': '',
});

// Query journals
final List<Map<String, dynamic>> journals = await db.query(
  'journals',
  orderBy: 'created_at DESC',
);

// Update a journal
await db.update(
  'journals',
  {'title': 'Updated Title'},
  where: 'id = ?',
  whereArgs: [1],
);

// Delete a journal
await db.delete(
  'journals',
  where: 'id = ?',
  whereArgs: [1],
);
```

### 3. Using the Local Data Source

```dart
final localDataSource = JournalLocalDataSourceImpl();

// Get all journals
final journals = await localDataSource.getJournals();

// Create a new journal
final journal = Journal(
  id: '0', // Use '0' for new entries
  title: 'New Entry',
  content: 'Content here...',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
await localDataSource.cacheJournal(journal);

// Search journals
final searchResults = await localDataSource.searchJournals('amazing');
```

## Best Practices

1. **Always use parameterized queries** to prevent SQL injection
2. **Handle database operations asynchronously** to avoid blocking the UI
3. **Use transactions** for multiple related operations
4. **Close the database** when the app is terminated
5. **Handle database upgrades** gracefully in the `_onUpgrade` method

## Error Handling

```dart
try {
  final result = await localDataSource.getJournals();
  // Handle success
} catch (e) {
  // Handle database errors
  print('Database error: $e');
}
```

## Performance Tips

1. **Use indexes** for frequently queried columns
2. **Limit query results** using `LIMIT` clause
3. **Use batch operations** for multiple inserts/updates
4. **Avoid SELECT \*** - specify only needed columns

## Migration

When you need to change the database schema:

1. Increment `databaseVersion` in `DatabaseHelper`
2. Add migration logic in `_onUpgrade` method
3. Test thoroughly with existing data
