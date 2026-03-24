/// Data Access Object for ConceptMastery operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';
import 'package:crack_the_code/data/models/pedagogy/concept_mastery_model.dart';

/// DAO for concept_mastery table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class ConceptMasteryDao extends BaseDao {
  ConceptMasteryDao(super.dbHelper);

  /// Insert or replace a concept mastery record
  Future<void> upsert(ConceptMasteryModel mastery) async {
    await executeWithErrorHandling(
      operationName: 'upsert concept mastery',
      operation: () async {
        await insertRow(
          table: ConceptMasteryTable.tableName,
          values: mastery.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      },
    );
  }

  /// Get mastery by concept and student
  Future<ConceptMasteryModel?> getByConceptAndStudent({
    required String conceptId,
    required String studentId,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get concept mastery',
      operation: () async {
        final maps = await queryRows(
          table: ConceptMasteryTable.tableName,
          where:
              '${ConceptMasteryTable.columnConceptId} = ? AND ${ConceptMasteryTable.columnStudentId} = ?',
          whereArgs: [conceptId, studentId],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return ConceptMasteryModel.fromMap(maps.first);
      },
    );
  }

  /// Get all mastery records for a student
  Future<List<ConceptMasteryModel>> getByStudent(String studentId) async {
    return await executeWithErrorHandling(
      operationName: 'get student mastery records',
      operation: () async {
        final maps = await queryRows(
          table: ConceptMasteryTable.tableName,
          where: '${ConceptMasteryTable.columnStudentId} = ?',
          whereArgs: [studentId],
          orderBy: '${ConceptMasteryTable.columnMasteryScore} DESC',
        );

        return maps.map((map) => ConceptMasteryModel.fromMap(map)).toList();
      },
    );
  }

  /// Get all gaps for a student (mastery < 60%)
  Future<List<ConceptMasteryModel>> getGapsForStudent(String studentId) async {
    return await executeWithErrorHandling(
      operationName: 'get student gaps',
      operation: () async {
        final maps = await queryRows(
          table: ConceptMasteryTable.tableName,
          where:
              '${ConceptMasteryTable.columnStudentId} = ? AND ${ConceptMasteryTable.columnIsGap} = 1',
          whereArgs: [studentId],
          orderBy: '${ConceptMasteryTable.columnMasteryScore} ASC',
        );

        return maps.map((map) => ConceptMasteryModel.fromMap(map)).toList();
      },
    );
  }

  /// Get concepts due for review
  Future<List<ConceptMasteryModel>> getReviewsDue({
    required String studentId,
    DateTime? beforeDate,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get reviews due',
      operation: () async {
        final cutoffDate = beforeDate ?? DateTime.now();

        final maps = await queryRows(
          table: ConceptMasteryTable.tableName,
          where:
              '${ConceptMasteryTable.columnStudentId} = ? AND ${ConceptMasteryTable.columnNextReviewDate} <= ?',
          whereArgs: [studentId, cutoffDate.millisecondsSinceEpoch],
          orderBy: '${ConceptMasteryTable.columnNextReviewDate} ASC',
        );

        return maps.map((map) => ConceptMasteryModel.fromMap(map)).toList();
      },
    );
  }

  /// Get aggregate statistics for a student
  Future<Map<String, dynamic>> getStatistics(String studentId) async {
    return await executeWithErrorHandling(
      operationName: 'get mastery statistics',
      operation: () async {
        final result = await rawQuery('''
          SELECT
            COUNT(*) as total_concepts,
            AVG(${ConceptMasteryTable.columnMasteryScore}) as avg_mastery,
            SUM(CASE WHEN ${ConceptMasteryTable.columnIsGap} = 1 THEN 1 ELSE 0 END) as gap_count,
            SUM(CASE WHEN ${ConceptMasteryTable.columnMasteryScore} >= 80 THEN 1 ELSE 0 END) as mastered_count,
            SUM(CASE WHEN ${ConceptMasteryTable.columnMasteryScore} >= 60 AND ${ConceptMasteryTable.columnMasteryScore} < 80 THEN 1 ELSE 0 END) as familiar_count,
            SUM(CASE WHEN ${ConceptMasteryTable.columnMasteryScore} < 60 THEN 1 ELSE 0 END) as learning_count
          FROM ${ConceptMasteryTable.tableName}
          WHERE ${ConceptMasteryTable.columnStudentId} = ?
        ''', [studentId]);

        return result.first;
      },
    );
  }

  /// Get mastery by grade level for a student
  Future<Map<int, double>> getMasteryByGrade(String studentId) async {
    return await executeWithErrorHandling(
      operationName: 'get mastery by grade',
      operation: () async {
        final result = await rawQuery('''
          SELECT
            ${ConceptMasteryTable.columnGradeLevel} as grade,
            AVG(${ConceptMasteryTable.columnMasteryScore}) as avg_mastery
          FROM ${ConceptMasteryTable.tableName}
          WHERE ${ConceptMasteryTable.columnStudentId} = ?
            AND ${ConceptMasteryTable.columnGradeLevel} IS NOT NULL
          GROUP BY ${ConceptMasteryTable.columnGradeLevel}
          ORDER BY ${ConceptMasteryTable.columnGradeLevel} ASC
        ''', [studentId]);

        final gradeMap = <int, double>{};
        for (final row in result) {
          final grade = row['grade'] as int;
          final avgMastery = (row['avg_mastery'] as num).toDouble();
          gradeMap[grade] = avgMastery;
        }

        return gradeMap;
      },
    );
  }

  /// Delete mastery record
  Future<void> delete(String id) async {
    await executeWithErrorHandling(
      operationName: 'delete concept mastery',
      operation: () async {
        await deleteRows(
          table: ConceptMasteryTable.tableName,
          where: '${ConceptMasteryTable.columnId} = ?',
          whereArgs: [id],
        );
      },
    );
  }

  /// Delete all mastery records for a student
  Future<void> deleteByStudent(String studentId) async {
    await executeWithErrorHandling(
      operationName: 'delete student mastery records',
      operation: () async {
        await deleteRows(
          table: ConceptMasteryTable.tableName,
          where: '${ConceptMasteryTable.columnStudentId} = ?',
          whereArgs: [studentId],
        );
      },
    );
  }
}
