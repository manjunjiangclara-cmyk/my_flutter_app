import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_bloc.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_event.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_state.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';
import 'package:my_flutter_app/features/compose/presentation/services/location_search_service.dart';

import 'location_picker_bloc_test.mocks.dart';

@GenerateMocks([LocationSearchService])
void main() {
  group('LocationPickerBloc', () {
    late LocationPickerBloc locationPickerBloc;
    late MockLocationSearchService mockLocationSearchService;

    setUp(() {
      mockLocationSearchService = MockLocationSearchService();
      locationPickerBloc = LocationPickerBloc(mockLocationSearchService);
    });

    tearDown(() {
      locationPickerBloc.close();
    });

    test('initial state is LocationPickerInitial', () {
      expect(locationPickerBloc.state, const LocationPickerInitial());
    });

    group('LocationPickerSearchRequested', () {
      const testQuery = 'Central Park';
      final testResults = [
        const LocationSearchResult(
          id: '1',
          name: 'Central Park',
          address: 'New York, NY, USA',
          type: LocationType.landmark,
        ),
      ];

      blocTest<LocationPickerBloc, LocationPickerState>(
        'emits [Loading, SearchResultsLoaded] when search is successful',
        build: () {
          when(
            mockLocationSearchService.searchLocations(testQuery),
          ).thenAnswer((_) async => testResults);
          return locationPickerBloc;
        },
        act: (bloc) => bloc.add(const LocationPickerSearchRequested(testQuery)),
        wait: const Duration(milliseconds: 600), // Wait for debounce
        expect: () => [
          const LocationPickerLoading(),
          LocationPickerSearchResultsLoaded(
            searchResults: testResults,
            query: testQuery,
          ),
        ],
        verify: (_) {
          verify(
            mockLocationSearchService.searchLocations(testQuery),
          ).called(1);
        },
      );

      blocTest<LocationPickerBloc, LocationPickerState>(
        'emits [Loading, NoResults] when search returns empty results',
        build: () {
          when(
            mockLocationSearchService.searchLocations(testQuery),
          ).thenAnswer((_) async => <LocationSearchResult>[]);
          return locationPickerBloc;
        },
        act: (bloc) => bloc.add(const LocationPickerSearchRequested(testQuery)),
        wait: const Duration(milliseconds: 600),
        expect: () => [
          const LocationPickerLoading(),
          const LocationPickerNoResults(query: testQuery),
        ],
      );

      blocTest<LocationPickerBloc, LocationPickerState>(
        'emits [Loading, Error] when search fails',
        build: () {
          when(
            mockLocationSearchService.searchLocations(testQuery),
          ).thenThrow(Exception('Search failed'));
          return locationPickerBloc;
        },
        act: (bloc) => bloc.add(const LocationPickerSearchRequested(testQuery)),
        wait: const Duration(milliseconds: 600),
        expect: () => [
          const LocationPickerLoading(),
          const LocationPickerError(
            message: 'Failed to search locations: Exception: Search failed',
          ),
        ],
      );

      blocTest<LocationPickerBloc, LocationPickerState>(
        'emits [SearchCleared] when query is too short',
        build: () => locationPickerBloc,
        act: (bloc) => bloc.add(const LocationPickerSearchRequested('a')),
        expect: () => [const LocationPickerSearchCleared()],
        verify: (_) {
          verifyNever(mockLocationSearchService.searchLocations(any));
        },
      );
    });

    group('LocationPickerLocationSelected', () {
      const testLocation = LocationSearchResult(
        id: '1',
        name: 'Central Park',
        address: 'New York, NY, USA',
        type: LocationType.landmark,
      );

      blocTest<LocationPickerBloc, LocationPickerState>(
        'emits [LocationSelected] when location is selected',
        build: () => locationPickerBloc,
        act: (bloc) =>
            bloc.add(const LocationPickerLocationSelected(testLocation)),
        expect: () => [const LocationPickerLocationSelected(testLocation)],
      );
    });

    group('LocationPickerSearchCleared', () {
      blocTest<LocationPickerBloc, LocationPickerState>(
        'emits [SearchCleared] when search is cleared',
        build: () => locationPickerBloc,
        act: (bloc) => bloc.add(const LocationPickerSearchCleared()),
        expect: () => [const LocationPickerSearchCleared()],
      );
    });

    group('LocationPickerCleared', () {
      blocTest<LocationPickerBloc, LocationPickerState>(
        'emits [Initial] when all state is cleared',
        build: () => locationPickerBloc,
        act: (bloc) => bloc.add(const LocationPickerCleared()),
        expect: () => [const LocationPickerInitial()],
      );
    });
  });
}
