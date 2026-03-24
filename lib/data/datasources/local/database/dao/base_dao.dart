/// Base Data Access Object with platform-abstracted database operations
///
/// Provides common database operations that work across mobile (sqflite)
/// and desktop (sqflite_common_ffi) platforms, eliminating the need for
/// platform checks in each DAO method.
library;

import 'package:sqflite/sqflite.dart' as sqflite_mobile;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_desktop;
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';

/// Conflict resolution algorithm for insert operations
enum ConflictAlgorithm {
  /// Replace existing row if conflict
  replace,

  /// Abort operation on conflict
  abort,

  /// Ignore operation on conflict
  ignore,

  /// Rollback transaction on conflict
  rollback,

  /// Fail operation on conflict
  fail,
}

/// Base DAO class providing platform-abstracted database operations
///
/// Extend this class to create DAOs without repeating platform checks.
/// All platform-specific code is centralized here.
///
/// Example:
/// ```dart
/// class BookmarkDao extends BaseDao {
///   BookmarkDao(DatabaseHelper dbHelper) : super(dbHelper);
///
///   Future<void> insert(BookmarkModel bookmark) async {
///     await insertRow(
///       table: BookmarksTable.tableName,
///       values: bookmark.toMap(),
///       conflictAlgorithm: ConflictAlgorithm.replace,
///     );
///   }
/// }
/// ```
abstract class BaseDao {
  final DatabaseHelper dbHelper;

  const BaseDao(this.dbHelper);

  /// Insert a row into a table
  Future<int> insertRow({
    required String table,
    required Map<String, dynamic> values,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async {
    final db = await dbHelper.database;

    if (db is sqflite_mobile.Database) {
      return await db.insert(
        table,
        values,
        conflictAlgorithm: _toMobileConflictAlgorithm(conflictAlgorithm),
      );
    } else if (db is sqflite_desktop.Database) {
      return await db.insert(
        table,
        values,
        conflictAlgorithm: _toDesktopConflictAlgorithm(conflictAlgorithm),
      );
    }

    throw _unknownDatabaseError(db);
  }

  /// Update rows in a table
  Future<int> updateRows({
    required String table,
    required Map<String, dynamic> values,
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async {
    final db = await dbHelper.database;

    if (db is sqflite_mobile.Database) {
      return await db.update(
        table,
        values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: _toMobileConflictAlgorithm(conflictAlgorithm),
      );
    } else if (db is sqflite_desktop.Database) {
      return await db.update(
        table,
        values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: _toDesktopConflictAlgorithm(conflictAlgorithm),
      );
    }

    throw _unknownDatabaseError(db);
  }

  /// Delete rows from a table
  Future<int> deleteRows({
    required String table,
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await dbHelper.database;

    if (db is sqflite_mobile.Database) {
      return await db.delete(
        table,
        where: where,
        whereArgs: whereArgs,
      );
    } else if (db is sqflite_desktop.Database) {
      return await db.delete(
        table,
        where: where,
        whereArgs: whereArgs,
      );
    }

    throw _unknownDatabaseError(db);
  }

  /// Query rows from a table
  Future<List<Map<String, dynamic>>> queryRows({
    required String table,
    bool distinct = false,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await dbHelper.database;

    if (db is sqflite_mobile.Database) {
      return await db.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
    } else if (db is sqflite_desktop.Database) {
      return await db.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
    }

    throw _unknownDatabaseError(db);
  }

  /// Execute a raw SQL query
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await dbHelper.database;

    if (db is sqflite_mobile.Database) {
      return await db.rawQuery(sql, arguments);
    } else if (db is sqflite_desktop.Database) {
      return await db.rawQuery(sql, arguments);
    }

    throw _unknownDatabaseError(db);
  }

  /// Execute a raw SQL statement (INSERT, UPDATE, DELETE)
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async {
    final db = await dbHelper.database;

    if (db is sqflite_mobile.Database) {
      return await db.rawInsert(sql, arguments);
    } else if (db is sqflite_desktop.Database) {
      return await db.rawInsert(sql, arguments);
    }

    throw _unknownDatabaseError(db);
  }

  /// Execute a raw SQL update statement
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async {
    final db = await dbHelper.database;

    if (db is sqflite_mobile.Database) {
      return await db.rawUpdate(sql, arguments);
    } else if (db is sqflite_desktop.Database) {
      return await db.rawUpdate(sql, arguments);
    }

    throw _unknownDatabaseError(db);
  }

  /// Execute a raw SQL delete statement
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async {
    final db = await dbHelper.database;

    if (db is sqflite_mobile.Database) {
      return await db.rawDelete(sql, arguments);
    } else if (db is sqflite_desktop.Database) {
      return await db.rawDelete(sql, arguments);
    }

    throw _unknownDatabaseError(db);
  }

  /// Execute a batch of operations
  ///
  /// The [operations] callback receives a batch helper that provides
  /// platform-agnostic batch operations.
  Future<List<dynamic>> batch(
    void Function(BatchHelper batch) operations, {
    bool noResult = false,
  }) async {
    final db = await dbHelper.database;

    if (db is sqflite_mobile.Database) {
      final batch = db.batch();
      final helper = _MobileBatchHelper(batch);
      operations(helper);
      return await batch.commit(noResult: noResult);
    } else if (db is sqflite_desktop.Database) {
      final batch = db.batch();
      final helper = _DesktopBatchHelper(batch);
      operations(helper);
      return await batch.commit(noResult: noResult);
    }

    throw _unknownDatabaseError(db);
  }

  /// Get the first integer value from a query result (useful for COUNT)
  Future<int?> firstIntValue(String sql, [List<dynamic>? arguments]) async {
    final db = await dbHelper.database;

    if (db is sqflite_mobile.Database) {
      return sqflite_mobile.Sqflite.firstIntValue(
        await db.rawQuery(sql, arguments),
      );
    } else if (db is sqflite_desktop.Database) {
      final result = await db.rawQuery(sql, arguments);
      if (result.isEmpty) return null;
      return result.first.values.first as int?;
    }

    throw _unknownDatabaseError(db);
  }

  /// Execute a database transaction
  ///
  /// The [action] callback receives a TransactionHelper that provides
  /// platform-agnostic transaction operations.
  Future<T> transaction<T>(
    Future<T> Function(TransactionHelper txn) action,
  ) async {
    final db = await dbHelper.database;

    if (db is sqflite_mobile.Database) {
      return await db.transaction((txn) async {
        return await action(_MobileTransactionHelper(txn));
      });
    } else if (db is sqflite_desktop.Database) {
      return await db.transaction((txn) async {
        return await action(_DesktopTransactionHelper(txn));
      });
    }

    throw _unknownDatabaseError(db);
  }

  /// Execute operation with error handling
  ///
  /// Wraps database operations with consistent error handling and logging.
  Future<T> executeWithErrorHandling<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async {
    try {
      return await operation();
    } on DatabaseException {
      rethrow;
    } on NotFoundException {
      rethrow;
    } catch (e, stackTrace) {
      logger.error('Database error in $operationName', e, stackTrace);
      throw DatabaseException(
        message: 'Failed to $operationName: ${e.toString()}',
        details: e,
      );
    }
  }

  /// Convert to mobile conflict algorithm
  sqflite_mobile.ConflictAlgorithm _toMobileConflictAlgorithm(
    ConflictAlgorithm algorithm,
  ) {
    switch (algorithm) {
      case ConflictAlgorithm.replace:
        return sqflite_mobile.ConflictAlgorithm.replace;
      case ConflictAlgorithm.abort:
        return sqflite_mobile.ConflictAlgorithm.abort;
      case ConflictAlgorithm.ignore:
        return sqflite_mobile.ConflictAlgorithm.ignore;
      case ConflictAlgorithm.rollback:
        return sqflite_mobile.ConflictAlgorithm.rollback;
      case ConflictAlgorithm.fail:
        return sqflite_mobile.ConflictAlgorithm.fail;
    }
  }

  /// Convert to desktop conflict algorithm
  sqflite_desktop.ConflictAlgorithm _toDesktopConflictAlgorithm(
    ConflictAlgorithm algorithm,
  ) {
    switch (algorithm) {
      case ConflictAlgorithm.replace:
        return sqflite_desktop.ConflictAlgorithm.replace;
      case ConflictAlgorithm.abort:
        return sqflite_desktop.ConflictAlgorithm.abort;
      case ConflictAlgorithm.ignore:
        return sqflite_desktop.ConflictAlgorithm.ignore;
      case ConflictAlgorithm.rollback:
        return sqflite_desktop.ConflictAlgorithm.rollback;
      case ConflictAlgorithm.fail:
        return sqflite_desktop.ConflictAlgorithm.fail;
    }
  }

  /// Create unknown database error
  DatabaseException _unknownDatabaseError(dynamic db) {
    return DatabaseException(
      message: 'Unknown database type: ${db.runtimeType}',
      details: db,
    );
  }
}

/// Abstract batch helper for platform-agnostic batch operations
abstract class BatchHelper {
  void insert(
    String table,
    Map<String, dynamic> values, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  });

  void update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  });

  void delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  });

  void rawInsert(String sql, [List<dynamic>? arguments]);
}

/// Mobile batch helper implementation
class _MobileBatchHelper implements BatchHelper {
  final sqflite_mobile.Batch _batch;

  _MobileBatchHelper(this._batch);

  @override
  void insert(
    String table,
    Map<String, dynamic> values, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) {
    _batch.insert(
      table,
      values,
      conflictAlgorithm: _toConflictAlgorithm(conflictAlgorithm),
    );
  }

  @override
  void update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) {
    _batch.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: _toConflictAlgorithm(conflictAlgorithm),
    );
  }

  @override
  void delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) {
    _batch.delete(table, where: where, whereArgs: whereArgs);
  }

  @override
  void rawInsert(String sql, [List<dynamic>? arguments]) {
    _batch.rawInsert(sql, arguments);
  }

  sqflite_mobile.ConflictAlgorithm _toConflictAlgorithm(
    ConflictAlgorithm algorithm,
  ) {
    switch (algorithm) {
      case ConflictAlgorithm.replace:
        return sqflite_mobile.ConflictAlgorithm.replace;
      case ConflictAlgorithm.abort:
        return sqflite_mobile.ConflictAlgorithm.abort;
      case ConflictAlgorithm.ignore:
        return sqflite_mobile.ConflictAlgorithm.ignore;
      case ConflictAlgorithm.rollback:
        return sqflite_mobile.ConflictAlgorithm.rollback;
      case ConflictAlgorithm.fail:
        return sqflite_mobile.ConflictAlgorithm.fail;
    }
  }
}

/// Desktop batch helper implementation
class _DesktopBatchHelper implements BatchHelper {
  final sqflite_desktop.Batch _batch;

  _DesktopBatchHelper(this._batch);

  @override
  void insert(
    String table,
    Map<String, dynamic> values, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) {
    _batch.insert(
      table,
      values,
      conflictAlgorithm: _toConflictAlgorithm(conflictAlgorithm),
    );
  }

  @override
  void update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) {
    _batch.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: _toConflictAlgorithm(conflictAlgorithm),
    );
  }

  @override
  void delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) {
    _batch.delete(table, where: where, whereArgs: whereArgs);
  }

  @override
  void rawInsert(String sql, [List<dynamic>? arguments]) {
    _batch.rawInsert(sql, arguments);
  }

  sqflite_desktop.ConflictAlgorithm _toConflictAlgorithm(
    ConflictAlgorithm algorithm,
  ) {
    switch (algorithm) {
      case ConflictAlgorithm.replace:
        return sqflite_desktop.ConflictAlgorithm.replace;
      case ConflictAlgorithm.abort:
        return sqflite_desktop.ConflictAlgorithm.abort;
      case ConflictAlgorithm.ignore:
        return sqflite_desktop.ConflictAlgorithm.ignore;
      case ConflictAlgorithm.rollback:
        return sqflite_desktop.ConflictAlgorithm.rollback;
      case ConflictAlgorithm.fail:
        return sqflite_desktop.ConflictAlgorithm.fail;
    }
  }
}

/// Abstract transaction helper for platform-agnostic transaction operations
abstract class TransactionHelper {
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    int? limit,
  });

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
  });

  Future<int> insert(
    String table,
    Map<String, dynamic> values, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  });

  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  });
}

/// Mobile transaction helper implementation
class _MobileTransactionHelper implements TransactionHelper {
  final sqflite_mobile.Transaction _txn;

  _MobileTransactionHelper(this._txn);

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    int? limit,
  }) async {
    return await _txn.query(
      table,
      where: where,
      whereArgs: whereArgs,
      limit: limit,
    );
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    return await _txn.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<int> insert(
    String table,
    Map<String, dynamic> values, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async {
    return await _txn.insert(
      table,
      values,
      conflictAlgorithm: _toConflictAlgorithm(conflictAlgorithm),
    );
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    return await _txn.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  sqflite_mobile.ConflictAlgorithm _toConflictAlgorithm(
    ConflictAlgorithm algorithm,
  ) {
    switch (algorithm) {
      case ConflictAlgorithm.replace:
        return sqflite_mobile.ConflictAlgorithm.replace;
      case ConflictAlgorithm.abort:
        return sqflite_mobile.ConflictAlgorithm.abort;
      case ConflictAlgorithm.ignore:
        return sqflite_mobile.ConflictAlgorithm.ignore;
      case ConflictAlgorithm.rollback:
        return sqflite_mobile.ConflictAlgorithm.rollback;
      case ConflictAlgorithm.fail:
        return sqflite_mobile.ConflictAlgorithm.fail;
    }
  }
}

/// Desktop transaction helper implementation
class _DesktopTransactionHelper implements TransactionHelper {
  final sqflite_desktop.Transaction _txn;

  _DesktopTransactionHelper(this._txn);

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    int? limit,
  }) async {
    return await _txn.query(
      table,
      where: where,
      whereArgs: whereArgs,
      limit: limit,
    );
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    return await _txn.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<int> insert(
    String table,
    Map<String, dynamic> values, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async {
    return await _txn.insert(
      table,
      values,
      conflictAlgorithm: _toConflictAlgorithm(conflictAlgorithm),
    );
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    return await _txn.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  sqflite_desktop.ConflictAlgorithm _toConflictAlgorithm(
    ConflictAlgorithm algorithm,
  ) {
    switch (algorithm) {
      case ConflictAlgorithm.replace:
        return sqflite_desktop.ConflictAlgorithm.replace;
      case ConflictAlgorithm.abort:
        return sqflite_desktop.ConflictAlgorithm.abort;
      case ConflictAlgorithm.ignore:
        return sqflite_desktop.ConflictAlgorithm.ignore;
      case ConflictAlgorithm.rollback:
        return sqflite_desktop.ConflictAlgorithm.rollback;
      case ConflictAlgorithm.fail:
        return sqflite_desktop.ConflictAlgorithm.fail;
    }
  }
}
