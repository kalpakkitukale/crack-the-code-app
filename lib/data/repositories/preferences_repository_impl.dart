/// Preferences repository implementation
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/preference_dao.dart';
import 'package:streamshaala/data/models/user/preference_model.dart';
import 'package:streamshaala/domain/entities/user/user_preference.dart';
import 'package:streamshaala/domain/repositories/preferences_repository.dart';

/// Implementation of PreferencesRepository using local database
class PreferencesRepositoryImpl implements PreferencesRepository {
  final PreferenceDao _preferenceDao;

  const PreferencesRepositoryImpl(this._preferenceDao);

  @override
  Future<Either<Failure, UserPreference>> savePreference(UserPreference preference) async {
    try {
      logger.info('Saving preference: ${preference.key}');

      final model = PreferenceModel.fromEntity(preference);
      await _preferenceDao.save(model);

      logger.info('Preference saved successfully');
      return Right(preference);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error saving preference', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save preference',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error saving preference', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, UserPreference?>> getPreference(String key) async {
    try {
      logger.debug('Getting preference by key: $key');

      final model = await _preferenceDao.getByKey(key);
      final preference = model?.toEntity();

      return Right(preference);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting preference', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get preference',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting preference', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, String?>> getString(String key) async {
    try {
      logger.debug('Getting string value for key: $key');

      final model = await _preferenceDao.getByKey(key);
      return Right(model?.value);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting string value', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get string value',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting string value', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> getBool(String key, {bool defaultValue = false}) async {
    try {
      logger.debug('Getting bool value for key: $key');

      final model = await _preferenceDao.getByKey(key);

      if (model == null) {
        return Right(defaultValue);
      }

      // Parse string value to bool
      final value = model.value.toLowerCase();
      if (value == 'true' || value == '1') {
        return const Right(true);
      } else if (value == 'false' || value == '0') {
        return const Right(false);
      } else {
        logger.warning('Invalid bool value for key $key: ${model.value}, using default: $defaultValue');
        return Right(defaultValue);
      }
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting bool value', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get bool value',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting bool value', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, int>> getInt(String key, {int defaultValue = 0}) async {
    try {
      logger.debug('Getting int value for key: $key');

      final model = await _preferenceDao.getByKey(key);

      if (model == null) {
        return Right(defaultValue);
      }

      // Parse string value to int
      final parsedValue = int.tryParse(model.value);
      if (parsedValue == null) {
        logger.warning('Invalid int value for key $key: ${model.value}, using default: $defaultValue');
        return Right(defaultValue);
      }

      return Right(parsedValue);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting int value', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get int value',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting int value', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, double>> getDouble(String key, {double defaultValue = 0.0}) async {
    try {
      logger.debug('Getting double value for key: $key');

      final model = await _preferenceDao.getByKey(key);

      if (model == null) {
        return Right(defaultValue);
      }

      // Parse string value to double
      final parsedValue = double.tryParse(model.value);
      if (parsedValue == null) {
        logger.warning('Invalid double value for key $key: ${model.value}, using default: $defaultValue');
        return Right(defaultValue);
      }

      return Right(parsedValue);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting double value', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get double value',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting double value', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<UserPreference>>> getAllPreferences() async {
    try {
      logger.info('Getting all preferences');

      final models = await _preferenceDao.getAll();
      final preferences = models.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${preferences.length} preferences');
      return Right(preferences);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting preferences', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get preferences',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting preferences', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deletePreference(String key) async {
    try {
      logger.info('Deleting preference: $key');

      await _preferenceDao.delete(key);

      logger.info('Preference deleted successfully');
      return const Right(null);
    } on NotFoundException catch (e, stackTrace) {
      logger.warning('Preference not found', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Preference not found',
        entityType: 'Preference',
        entityId: key,
      ));
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error deleting preference', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to delete preference',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error deleting preference', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllPreferences() async {
    try {
      logger.warning('Clearing all preferences');

      await _preferenceDao.deleteAll();

      logger.info('All preferences cleared successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error clearing preferences', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to clear preferences',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error clearing preferences', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> hasPreference(String key) async {
    try {
      logger.debug('Checking if preference exists: $key');

      final exists = await _preferenceDao.exists(key);

      return Right(exists);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error checking preference', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to check preference status',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error checking preference', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }
}
