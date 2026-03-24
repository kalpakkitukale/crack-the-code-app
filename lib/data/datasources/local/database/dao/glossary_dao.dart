/// Data Access Object for Glossary Term operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/core/utils/validation_helpers.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';
import 'package:crack_the_code/data/models/study_tools/glossary_term_model.dart';

/// DAO for glossary terms table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class GlossaryDao extends BaseDao {
  GlossaryDao(super.dbHelper);

  /// Insert or replace a glossary term
  Future<void> insert(GlossaryTermModel term) async {
    await executeWithErrorHandling(
      operationName: 'insert glossary term',
      operation: () async {
        await insertRow(
          table: GlossaryTermsTable.tableName,
          values: term.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Glossary term inserted: ${term.id}');
      },
    );
  }

  /// Insert multiple terms at once
  Future<void> insertAll(List<GlossaryTermModel> terms) async {
    await executeWithErrorHandling(
      operationName: 'insert glossary terms',
      operation: () async {
        await batch(
          (batchHelper) {
            for (final term in terms) {
              batchHelper.insert(
                GlossaryTermsTable.tableName,
                term.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          },
          noResult: true,
        );
        logger.debug('Inserted ${terms.length} glossary terms');
      },
    );
  }

  /// Get all terms for a chapter and segment
  Future<List<GlossaryTermModel>> getByChapterId(
      String chapterId, String segment) async {
    return await executeWithErrorHandling(
      operationName: 'get glossary terms',
      operation: () async {
        final maps = await queryRows(
          table: GlossaryTermsTable.tableName,
          where:
              '${GlossaryTermsTable.columnChapterId} = ? AND ${GlossaryTermsTable.columnSegment} = ?',
          whereArgs: [chapterId, segment],
          orderBy: '${GlossaryTermsTable.columnTerm} ASC',
        );

        logger.debug(
            'Retrieved ${maps.length} glossary terms for chapter: $chapterId');
        return maps.map((map) => GlossaryTermModel.fromMap(map)).toList();
      },
    );
  }

  /// Search terms by term text
  Future<List<GlossaryTermModel>> searchTerms(
      String query, String chapterId, String segment) async {
    return await executeWithErrorHandling(
      operationName: 'search glossary terms',
      operation: () async {
        // Sanitize search query to prevent LIKE injection
        final sanitizedQuery = SqlSanitizer.sanitizeSearchQuery(query);

        final maps = await queryRows(
          table: GlossaryTermsTable.tableName,
          where:
              "${GlossaryTermsTable.columnChapterId} = ? AND ${GlossaryTermsTable.columnSegment} = ? AND (${GlossaryTermsTable.columnTerm} LIKE ? ESCAPE '\\' OR ${GlossaryTermsTable.columnDefinition} LIKE ? ESCAPE '\\')",
          whereArgs: [chapterId, segment, sanitizedQuery, sanitizedQuery],
          orderBy: '${GlossaryTermsTable.columnTerm} ASC',
        );

        logger.debug('Found ${maps.length} glossary terms matching "$query"');
        return maps.map((map) => GlossaryTermModel.fromMap(map)).toList();
      },
    );
  }

  /// Get term by ID
  Future<GlossaryTermModel?> getById(String termId) async {
    return await executeWithErrorHandling(
      operationName: 'get glossary term by ID',
      operation: () async {
        final maps = await queryRows(
          table: GlossaryTermsTable.tableName,
          where: '${GlossaryTermsTable.columnId} = ?',
          whereArgs: [termId],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return GlossaryTermModel.fromMap(maps.first);
      },
    );
  }

  /// Delete all terms for a chapter
  Future<void> deleteByChapterId(String chapterId) async {
    await executeWithErrorHandling(
      operationName: 'delete glossary terms by chapter',
      operation: () async {
        await deleteRows(
          table: GlossaryTermsTable.tableName,
          where: '${GlossaryTermsTable.columnChapterId} = ?',
          whereArgs: [chapterId],
        );
        logger.debug('Glossary terms deleted for chapter: $chapterId');
      },
    );
  }

  /// Get term count for a chapter
  Future<int> getCountByChapterId(String chapterId, String segment) async {
    return await executeWithErrorHandling(
      operationName: 'get glossary term count',
      operation: () async {
        final query =
            'SELECT COUNT(*) FROM ${GlossaryTermsTable.tableName} WHERE ${GlossaryTermsTable.columnChapterId} = ? AND ${GlossaryTermsTable.columnSegment} = ?';
        return await firstIntValue(query, [chapterId, segment]) ?? 0;
      },
    );
  }

  /// Delete all terms
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all glossary terms',
      operation: () async {
        await deleteRows(table: GlossaryTermsTable.tableName);
        logger.debug('All glossary terms deleted');
      },
    );
  }
}
