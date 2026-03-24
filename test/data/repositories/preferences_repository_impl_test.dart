/// Comprehensive tests for PreferencesRepositoryImpl
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/data/repositories/preferences_repository_impl.dart';
import 'package:crack_the_code/domain/entities/user/user_preference.dart';
import 'package:crack_the_code/data/models/user/preference_model.dart';
import '../../mocks/mock_use_cases.dart';

void main() {
  group('PreferencesRepositoryImpl', () {
    late MockPreferenceDao mockDao;
    late PreferencesRepositoryImpl repository;

    setUp(() {
      mockDao = MockPreferenceDao();
      repository = PreferencesRepositoryImpl(mockDao);
    });

    tearDown(() {
      mockDao.clear();
    });

    // Helper to create test preference
    UserPreference createPreference({
      String key = 'test_key',
      String value = 'test_value',
    }) {
      return UserPreference(
        key: key,
        value: value,
      );
    }

    group('savePreference', () {
      test('success_savesPreferenceToDao', () async {
        final preference = createPreference();

        final result = await repository.savePreference(preference);

        expect(result.isRight(), true);
        expect(mockDao.all.length, 1);
        expect(mockDao.all['test_key']?.value, 'test_value');
      });

      test('update_overwritesExistingPreference', () async {
        final preference = createPreference(value: 'old_value');
        await repository.savePreference(preference);

        final updated = createPreference(value: 'new_value');
        await repository.savePreference(updated);

        expect(mockDao.all.length, 1);
        expect(mockDao.all['test_key']?.value, 'new_value');
      });

      test('databaseException_returnsDatabaseFailure', () async {
        final preference = createPreference();
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.savePreference(preference);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to save preference'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('unknownException_returnsUnknownFailure', () async {
        final preference = createPreference();
        mockDao.setNextException(Exception('Unknown error'));

        final result = await repository.savePreference(preference);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('unexpected error'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('getPreference', () {
      test('found_returnsPreference', () async {
        final preference = createPreference();
        await repository.savePreference(preference);

        final result = await repository.getPreference('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (pref) {
            expect(pref?.key, 'test_key');
            expect(pref?.value, 'test_value');
          },
        );
      });

      test('notFound_returnsNull', () async {
        final result = await repository.getPreference('non_existent');

        result.fold(
          (_) => fail('Should succeed'),
          (pref) {
            expect(pref, null);
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getPreference('test_key');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to get preference'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('getString', () {
      test('found_returnsStringValue', () async {
        final preference = createPreference(value: 'hello world');
        await repository.savePreference(preference);

        final result = await repository.getString('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 'hello world');
          },
        );
      });

      test('notFound_returnsNull', () async {
        final result = await repository.getString('non_existent');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, null);
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getString('test_key');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to get string value'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('getBool', () {
      test('trueString_returnsTrue', () async {
        await repository.savePreference(createPreference(value: 'true'));

        final result = await repository.getBool('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, true);
          },
        );
      });

      test('oneString_returnsTrue', () async {
        await repository.savePreference(createPreference(value: '1'));

        final result = await repository.getBool('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, true);
          },
        );
      });

      test('falseString_returnsFalse', () async {
        await repository.savePreference(createPreference(value: 'false'));

        final result = await repository.getBool('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, false);
          },
        );
      });

      test('zeroString_returnsFalse', () async {
        await repository.savePreference(createPreference(value: '0'));

        final result = await repository.getBool('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, false);
          },
        );
      });

      test('invalidValue_returnsDefaultValue', () async {
        await repository.savePreference(createPreference(value: 'invalid'));

        final result = await repository.getBool('test_key', defaultValue: true);

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, true);
          },
        );
      });

      test('notFound_returnsDefaultValue', () async {
        final result = await repository.getBool('non_existent', defaultValue: true);

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, true);
          },
        );
      });

      test('caseInsensitive_parsesCorrectly', () async {
        await repository.savePreference(createPreference(value: 'TRUE'));

        final result = await repository.getBool('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, true);
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getBool('test_key');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to get bool value'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('getInt', () {
      test('validInt_returnsValue', () async {
        await repository.savePreference(createPreference(value: '42'));

        final result = await repository.getInt('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 42);
          },
        );
      });

      test('negativeInt_returnsValue', () async {
        await repository.savePreference(createPreference(value: '-100'));

        final result = await repository.getInt('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, -100);
          },
        );
      });

      test('invalidValue_returnsDefaultValue', () async {
        await repository.savePreference(createPreference(value: 'not_a_number'));

        final result = await repository.getInt('test_key', defaultValue: 99);

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 99);
          },
        );
      });

      test('notFound_returnsDefaultValue', () async {
        final result = await repository.getInt('non_existent', defaultValue: 50);

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 50);
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getInt('test_key');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to get int value'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('getDouble', () {
      test('validDouble_returnsValue', () async {
        await repository.savePreference(createPreference(value: '3.14'));

        final result = await repository.getDouble('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 3.14);
          },
        );
      });

      test('integerValue_parsesAsDouble', () async {
        await repository.savePreference(createPreference(value: '42'));

        final result = await repository.getDouble('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 42.0);
          },
        );
      });

      test('negativeDouble_returnsValue', () async {
        await repository.savePreference(createPreference(value: '-2.5'));

        final result = await repository.getDouble('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, -2.5);
          },
        );
      });

      test('invalidValue_returnsDefaultValue', () async {
        await repository.savePreference(createPreference(value: 'not_a_number'));

        final result = await repository.getDouble('test_key', defaultValue: 1.5);

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 1.5);
          },
        );
      });

      test('notFound_returnsDefaultValue', () async {
        final result = await repository.getDouble('non_existent', defaultValue: 2.5);

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 2.5);
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getDouble('test_key');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to get double value'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('getAllPreferences', () {
      test('success_returnsAllPreferences', () async {
        await repository.savePreference(createPreference(key: 'key1', value: 'value1'));
        await repository.savePreference(createPreference(key: 'key2', value: 'value2'));
        await repository.savePreference(createPreference(key: 'key3', value: 'value3'));

        final result = await repository.getAllPreferences();

        result.fold(
          (_) => fail('Should succeed'),
          (preferences) {
            expect(preferences.length, 3);
          },
        );
      });

      test('emptyList_returnsEmptyList', () async {
        final result = await repository.getAllPreferences();

        result.fold(
          (_) => fail('Should succeed'),
          (preferences) {
            expect(preferences.length, 0);
          },
        );
      });

      test('sortedByKey_returnsSortedList', () async {
        await repository.savePreference(createPreference(key: 'z_key', value: 'val1'));
        await repository.savePreference(createPreference(key: 'a_key', value: 'val2'));
        await repository.savePreference(createPreference(key: 'm_key', value: 'val3'));

        final result = await repository.getAllPreferences();

        result.fold(
          (_) => fail('Should succeed'),
          (preferences) {
            expect(preferences[0].key, 'a_key');
            expect(preferences[1].key, 'm_key');
            expect(preferences[2].key, 'z_key');
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getAllPreferences();

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to get preferences'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('deletePreference', () {
      test('success_deletesPreference', () async {
        await repository.savePreference(createPreference());

        final result = await repository.deletePreference('test_key');

        expect(result.isRight(), true);
        expect(mockDao.all.length, 0);
      });

      test('notFound_returnsNotFoundFailure', () async {
        final result = await repository.deletePreference('non_existent');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Preference not found'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.deletePreference('test_key');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to delete preference'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('clearAllPreferences', () {
      test('success_clearsAllPreferences', () async {
        await repository.savePreference(createPreference(key: 'key1'));
        await repository.savePreference(createPreference(key: 'key2'));
        await repository.savePreference(createPreference(key: 'key3'));

        final result = await repository.clearAllPreferences();

        expect(result.isRight(), true);
        expect(mockDao.all.length, 0);
      });

      test('emptyPreferences_stillSucceeds', () async {
        final result = await repository.clearAllPreferences();

        expect(result.isRight(), true);
        expect(mockDao.all.length, 0);
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.clearAllPreferences();

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to clear preferences'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('hasPreference', () {
      test('exists_returnsTrue', () async {
        await repository.savePreference(createPreference());

        final result = await repository.hasPreference('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (exists) {
            expect(exists, true);
          },
        );
      });

      test('notExists_returnsFalse', () async {
        final result = await repository.hasPreference('non_existent');

        result.fold(
          (_) => fail('Should succeed'),
          (exists) {
            expect(exists, false);
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.hasPreference('test_key');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to check preference status'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('Type Conversion Edge Cases', () {
      test('getBool_withMixedCase_parsesCorrectly', () async {
        await repository.savePreference(createPreference(value: 'TrUe'));

        final result = await repository.getBool('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, true);
          },
        );
      });

      test('getInt_withFloatString_returnsDefaultValue', () async {
        await repository.savePreference(createPreference(value: '3.14'));

        final result = await repository.getInt('test_key', defaultValue: 0);

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 0);
          },
        );
      });

      test('getDouble_withScientificNotation_parsesCorrectly', () async {
        await repository.savePreference(createPreference(value: '1.5e2'));

        final result = await repository.getDouble('test_key');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 150.0);
          },
        );
      });
    });

    group('Practical Use Cases', () {
      test('themeMode_saveAndRetrieve', () async {
        await repository.savePreference(createPreference(
          key: 'theme_mode',
          value: 'dark',
        ));

        final result = await repository.getString('theme_mode');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 'dark');
          },
        );
      });

      test('autoPlayNext_saveAndRetrieve', () async {
        await repository.savePreference(createPreference(
          key: 'auto_play_next',
          value: 'true',
        ));

        final result = await repository.getBool('auto_play_next');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, true);
          },
        );
      });

      test('playbackSpeed_saveAndRetrieve', () async {
        await repository.savePreference(createPreference(
          key: 'playback_speed',
          value: '1.5',
        ));

        final result = await repository.getDouble('playback_speed');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 1.5);
          },
        );
      });

      test('videoQuality_saveAndRetrieve', () async {
        await repository.savePreference(createPreference(
          key: 'video_quality',
          value: 'high',
        ));

        final result = await repository.getString('video_quality');

        result.fold(
          (_) => fail('Should succeed'),
          (value) {
            expect(value, 'high');
          },
        );
      });
    });
  });
}
