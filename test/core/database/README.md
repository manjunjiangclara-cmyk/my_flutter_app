# Database Tests

This directory contains comprehensive unit tests for the database layer of the Flutter app.

## Test Structure

```
test/core/database/
├── dao/                           # Data Access Object tests
│   ├── journal_dao_test.dart     # Journal DAO unit tests
│   └── journal_dao_test.mocks.dart # Generated mock files
├── mapper/                        # Entity mapper tests
│   └── journal_entity_mapper_test.dart
├── test_helpers.dart              # Common test utilities
└── README.md                      # This file
```

## Running Tests

### Run All Database Tests

```bash
flutter test test/core/database/
```

### Run Specific Test Files

```bash
# Run only DAO tests
flutter test test/core/database/dao/

# Run only mapper tests
flutter test test/core/database/mapper/

# Run specific test file
flutter test test/core/database/dao/journal_dao_test.dart
```

### Run Tests with Coverage

```bash
flutter test --coverage test/core/database/
```

## Test Coverage

### JournalEntityMapper Tests

- ✅ **mapToJournal**: Converts database rows to Journal entities
- ✅ **mapToJournalList**: Converts lists of database rows
- ✅ **journalToMap**: Converts Journal entities to database maps for insertion
- ✅ **journalToUpdateMap**: Converts Journal entities to database maps for updates
- ✅ **Edge Cases**: Handles null, empty, and malformed data

### JournalDao Tests

- ✅ **CRUD Operations**: Insert, read, update, delete
- ✅ **Query Methods**: Find by ID, find all, find favorites, search, find by tag
- ✅ **Advanced Queries**: Date range queries, count queries
- ✅ **Batch Operations**: Multiple journal insertions
- ✅ **Constants**: Table names, column names, SQL generation
- ✅ **Mocking**: Proper dependency injection for testing

## Test Dependencies

The tests use the following packages:

- **flutter_test**: Flutter's testing framework
- **mockito**: Mocking library for creating test doubles
- **build_runner**: Code generation for mocks

## Mock Generation

After adding new mocks or changing existing ones, regenerate the mock files:

```bash
flutter packages pub run build_runner build
```

Or for continuous generation during development:

```bash
flutter packages pub run build_runner watch
```

## Test Helpers

The `DatabaseTestHelpers` class provides:

- Sample data creation methods
- Assertion helpers for comparing entities
- Database row map generators
- Utility functions for common test scenarios

## Best Practices

1. **Use Mocks**: All database operations are mocked to ensure fast, reliable tests
2. **Test Edge Cases**: Include tests for null values, empty lists, and error conditions
3. **Verify Interactions**: Use `verify()` to ensure correct database calls are made
4. **Use Test Helpers**: Leverage the helper methods for consistent test data
5. **Group Related Tests**: Use `group()` to organize related test cases

## Adding New Tests

When adding new database functionality:

1. **Add Tests First**: Follow TDD principles
2. **Mock Dependencies**: Use mocks for external dependencies
3. **Test Edge Cases**: Include boundary condition tests
4. **Update Helpers**: Add new helper methods as needed
5. **Regenerate Mocks**: Run build_runner if new mocks are added

## Example Test Structure

```dart
group('MethodName', () {
  test('should do something when condition', () async {
    // Arrange
    final input = createSampleData();
    when(mockDependency.method(any)).thenAnswer((_) async => expectedResult);

    // Act
    final result = await methodUnderTest(input);

    // Assert
    expect(result, expectedResult);
    verify(mockDependency.method(input)).called(1);
  });
});
```

## Troubleshooting

### Common Issues

1. **Mock Generation Errors**: Run `flutter packages pub run build_runner build --delete-conflicting-outputs`
2. **Import Errors**: Ensure all dependencies are properly imported
3. **Test Failures**: Check that mocks are properly configured and injected

### Debug Mode

Run tests with verbose output:

```bash
flutter test --verbose test/core/database/
```

## Continuous Integration

These tests are designed to run in CI/CD pipelines:

- Fast execution (all tests complete in under 30 seconds)
- No external dependencies
- Deterministic results
- High coverage of database operations
