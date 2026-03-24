/// Database helper for SQLite with platform detection
///
/// This class handles database initialization, migrations, and provides
/// access to the SQLite database with proper platform-specific handling.
library;

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite_mobile;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_desktop;
import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/spelling_attempt_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/word_mastery_dao.dart';
import 'package:universal_platform/universal_platform.dart';

/// Database helper class for managing SQLite database operations
class DatabaseHelper {
  static DatabaseHelper? _instance;
  static dynamic _database;

  DatabaseHelper._();

  /// Get singleton instance
  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  /// Get database instance
  Future<dynamic> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  /// Initialize database with platform-specific implementation
  Future<dynamic> _initDatabase() async {
    try {
      logger.info('Initializing database for platform: ${_getPlatformName()}');

      // Platform-specific initialization
      if (UniversalPlatform.isWindows ||
          UniversalPlatform.isLinux ||
          UniversalPlatform.isMacOS) {
        return await _initDesktopDatabase();
      } else if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
        return await _initMobileDatabase();
      } else if (UniversalPlatform.isWeb) {
        throw const PlatformException(
          message: 'Web platform uses IndexedDB, not SQLite',
          platform: 'web',
        );
      } else {
        throw PlatformException(
          message: 'Unsupported platform: ${_getPlatformName()}',
          platform: _getPlatformName(),
        );
      }
    } catch (e, stackTrace) {
      logger.error('Failed to initialize database', e, stackTrace);
      throw DatabaseException(
        message: 'Failed to initialize database: ${e.toString()}',
        details: e,
      );
    }
  }

  /// Initialize database for desktop platforms (Windows, macOS, Linux)
  Future<sqflite_desktop.Database> _initDesktopDatabase() async {
    try {
      logger.info('Initializing desktop database using sqflite_common_ffi');

      // Initialize FFI
      sqflite_desktop.sqfliteFfiInit();

      // Get database path
      final String dbPath = await _getDesktopDatabasePath();
      logger.debug('Desktop database path: $dbPath');

      // Open database
      final database = await sqflite_desktop.databaseFactoryFfi.openDatabase(
        dbPath,
        options: sqflite_desktop.OpenDatabaseOptions(
          version: kDatabaseVersion,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onConfigure: _onConfigure,
        ),
      );

      logger.info('Desktop database initialized successfully');
      return database;
    } catch (e, stackTrace) {
      logger.error('Failed to initialize desktop database', e, stackTrace);
      rethrow;
    }
  }

  /// Initialize database for mobile platforms (Android, iOS)
  Future<sqflite_mobile.Database> _initMobileDatabase() async {
    try {
      logger.info('Initializing mobile database using sqflite');

      // Get database path
      final String dbPath = await _getMobileDatabasePath();
      logger.debug('Mobile database path: $dbPath');

      // Open database
      final database = await sqflite_mobile.openDatabase(
        dbPath,
        version: kDatabaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure,
      );

      logger.info('Mobile database initialized successfully');
      return database;
    } catch (e, stackTrace) {
      logger.error('Failed to initialize mobile database', e, stackTrace);
      rethrow;
    }
  }

  /// Get database path for desktop platforms
  Future<String> _getDesktopDatabasePath() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String dbDir = join(appDocDir.path, 'streamshaala');

    // Create directory if it doesn't exist
    final dir = Directory(dbDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return join(dbDir, kDatabaseName);
  }

  /// Get database path for mobile platforms
  Future<String> _getMobileDatabasePath() async {
    final String dbDir = await sqflite_mobile.getDatabasesPath();
    return join(dbDir, kDatabaseName);
  }

  /// Configure database settings
  Future<void> _onConfigure(dynamic db) async {
    logger.debug('Configuring database');

    // Enable foreign keys
    if (db is sqflite_mobile.Database) {
      await db.execute('PRAGMA foreign_keys = ON');
    } else if (db is sqflite_desktop.Database) {
      await db.execute('PRAGMA foreign_keys = ON');
    }

    logger.debug('Database configuration completed');
  }

  /// Create database tables
  Future<void> _onCreate(dynamic db, int version) async {
    logger.info('Creating database tables (version $version)');

    try {
      // Create tables
      await _executeSQL(db, BookmarksTable.createTable);
      await _executeSQL(db, NotesTable.createTable);
      await _executeSQL(db, ProgressTable.createTable);
      await _executeSQL(db, CollectionsTable.createTable);
      await _executeSQL(db, CollectionVideosTable.createTable);
      await _executeSQL(db, PreferencesTable.createTable);
      await _executeSQL(db, SearchHistoryTable.createTable);
      await _executeSQL(db, AppStateTable.createTable);

      // Create quiz system tables
      await _executeSQL(db, QuestionsOfflineTable.createTable);
      await _executeSQL(db, QuizzesOfflineTable.createTable);
      await _executeSQL(db, QuizSessionsTable.createTable);
      await _executeSQL(db, QuizAttemptsTable.createTable);

      // Create pedagogy system tables
      await _executeSQL(db, ConceptMasteryTable.createTable);
      await _executeSQL(db, SpacedRepetitionTable.createTable);
      await _executeSQL(db, LearningPathsTable.createTable);
      await _executeSQL(db, GamificationTable.createTable);
      await _executeSQL(db, XpEventsTable.createTable);
      await _executeSQL(db, BadgesTable.createTable);
      await _executeSQL(db, VideoLearningSessionsTable.createTable);
      await _executeSQL(db, PreAssessmentsTable.createTable);
      await _executeSQL(db, ChapterAssessmentsTable.createTable);
      await _executeSQL(db, RecommendationsHistoryTable.createTable);

      // Create Junior app tables (v14)
      await _executeSQL(db, UserProfileJuniorTable.createTable);
      await _executeSQL(db, ParentalControlsTable.createTable);
      await _executeSQL(db, ScreenTimeLogTable.createTable);

      // Create Study tools tables (v17)
      await _executeSQL(db, VideoSummariesTable.createTable);
      await _executeSQL(db, GlossaryTermsTable.createTable);
      await _executeSQL(db, VideoQATable.createTable);
      await _executeSQL(db, MindMapNodesTable.createTable);
      await _executeSQL(db, FlashcardDecksTable.createTable);
      await _executeSQL(db, FlashcardsTable.createTable);
      await _executeSQL(db, FlashcardProgressTable.createTable);

      // Create Chapter study tools tables (v18)
      await _executeSQL(db, ChapterSummariesTable.createTable);
      await _executeSQL(db, ChapterNotesTable.createTable);

      // Create Spelling tables (v19)
      await _executeSQL(db, SpellingAttemptDao.createTableQuery);
      await _executeSQL(db, WordMasteryDao.createTableQuery);

      // Create indexes
      await _createIndexes(db);

      logger.info('Database tables created successfully');
    } catch (e, stackTrace) {
      logger.error('Failed to create database tables', e, stackTrace);
      rethrow;
    }
  }

  /// Create database indexes
  Future<void> _createIndexes(dynamic db) async {
    logger.debug('Creating database indexes');

    try {
      // Bookmarks indexes
      await _executeSQL(db, BookmarksTable.createVideoIdIndex);
      await _executeSQL(db, BookmarksTable.createProfileIdIndex);
      await _executeSQL(db, BookmarksTable.createCreatedAtIndex);

      // Notes indexes
      await _executeSQL(db, NotesTable.createVideoIdIndex);
      await _executeSQL(db, NotesTable.createProfileIdIndex);
      await _executeSQL(db, NotesTable.createUpdatedAtIndex);

      // Progress indexes
      await _executeSQL(db, ProgressTable.createVideoIdIndex);
      await _executeSQL(db, ProgressTable.createProfileIdIndex);
      await _executeSQL(db, ProgressTable.createLastWatchedIndex);
      await _executeSQL(db, ProgressTable.createCompletedIndex);

      // Collections indexes
      await _executeSQL(db, CollectionsTable.createProfileIdIndex);
      await _executeSQL(db, CollectionsTable.createCreatedAtIndex);

      // Collection videos indexes
      await _executeSQL(db, CollectionVideosTable.createCollectionIdIndex);
      await _executeSQL(db, CollectionVideosTable.createVideoIdIndex);
      await _executeSQL(db, CollectionVideosTable.createAddedAtIndex);

      // Search history indexes
      await _executeSQL(db, SearchHistoryTable.createProfileIdIndex);
      await _executeSQL(db, SearchHistoryTable.createQueryIndex);
      await _executeSQL(db, SearchHistoryTable.createTimestampIndex);

      // Quiz system indexes
      await _executeSQL(db, QuestionsOfflineTable.createDifficultyIndex);
      await _executeSQL(db, QuestionsOfflineTable.createTopicIdsIndex);
      await _executeSQL(db, QuizzesOfflineTable.createEntityIdIndex);
      await _executeSQL(db, QuizzesOfflineTable.createLevelIndex);
      await _executeSQL(db, QuizSessionsTable.createStudentIdIndex);
      await _executeSQL(db, QuizSessionsTable.createQuizIdIndex);
      await _executeSQL(db, QuizSessionsTable.createStartTimeIndex);

      // Quiz attempts indexes
      await _executeSQL(db, QuizAttemptsTable.createStudentIdIndex);
      await _executeSQL(db, QuizAttemptsTable.createQuizIdIndex);
      await _executeSQL(db, QuizAttemptsTable.createCompletedAtIndex);
      await _executeSQL(db, QuizAttemptsTable.createSubjectIdIndex);
      await _executeSQL(db, QuizAttemptsTable.createPassedIndex);
      await _executeSQL(db, QuizAttemptsTable.createScoreIndex);
      await _executeSQL(db, QuizAttemptsTable.createStudentCompletedIndex);
      await _executeSQL(db, QuizAttemptsTable.createStudentSubjectIndex);
      await _executeSQL(db, QuizAttemptsTable.createAssessmentTypeIndex);
      await _executeSQL(db, QuizAttemptsTable.createHasRecommendationsIndex);
      await _executeSQL(db, QuizAttemptsTable.createRecommendationStatusIndex);
      await _executeSQL(db, QuizAttemptsTable.createStudentAssessmentRecommendationsIndex);

      // Pedagogy system indexes
      await _executeSQL(db, ConceptMasteryTable.createStudentIdIndex);
      await _executeSQL(db, ConceptMasteryTable.createConceptIdIndex);
      await _executeSQL(db, ConceptMasteryTable.createIsGapIndex);
      await _executeSQL(db, ConceptMasteryTable.createNextReviewIndex);

      await _executeSQL(db, SpacedRepetitionTable.createStudentIdIndex);
      await _executeSQL(db, SpacedRepetitionTable.createNextReviewIndex);
      await _executeSQL(db, SpacedRepetitionTable.createStudentNextReviewIndex);

      await _executeSQL(db, LearningPathsTable.createStudentIdIndex);
      await _executeSQL(db, LearningPathsTable.createStatusIndex);

      await _executeSQL(db, GamificationTable.createStudentIdIndex);
      await _executeSQL(db, GamificationTable.createLevelIndex);

      await _executeSQL(db, XpEventsTable.createStudentIdIndex);
      await _executeSQL(db, XpEventsTable.createTimestampIndex);
      await _executeSQL(db, XpEventsTable.createEventTypeIndex);

      await _executeSQL(db, BadgesTable.createStudentIdIndex);
      await _executeSQL(db, BadgesTable.createUnlockedIndex);

      await _executeSQL(db, VideoLearningSessionsTable.createStudentIdIndex);
      await _executeSQL(db, VideoLearningSessionsTable.createVideoIdIndex);
      await _executeSQL(db, VideoLearningSessionsTable.createStartedAtIndex);

      await _executeSQL(db, PreAssessmentsTable.createStudentIdIndex);
      await _executeSQL(db, PreAssessmentsTable.createSubjectIdIndex);

      await _executeSQL(db, ChapterAssessmentsTable.createStudentIdIndex);
      await _executeSQL(db, ChapterAssessmentsTable.createChapterIdIndex);
      await _executeSQL(db, ChapterAssessmentsTable.createSubjectIdIndex);

      // Recommendations history indexes
      await _executeSQL(db, RecommendationsHistoryTable.createQuizAttemptIndex);
      await _executeSQL(db, RecommendationsHistoryTable.createUserIdIndex);
      await _executeSQL(db, RecommendationsHistoryTable.createAssessmentTypeIndex);
      await _executeSQL(db, RecommendationsHistoryTable.createGeneratedAtIndex);
      await _executeSQL(db, RecommendationsHistoryTable.createUserAssessmentIndex);

      // Junior app indexes (v14)
      await _executeSQL(db, UserProfileJuniorTable.createGradeIndex);
      await _executeSQL(db, ParentalControlsTable.createUserIdIndex);
      await _executeSQL(db, ParentalControlsTable.createEnabledIndex);
      await _executeSQL(db, ScreenTimeLogTable.createUserIdIndex);
      await _executeSQL(db, ScreenTimeLogTable.createDateIndex);
      await _executeSQL(db, ScreenTimeLogTable.createUserDateIndex);

      // Study tools indexes (v17)
      await _executeSQL(db, VideoSummariesTable.createVideoIdIndex);
      await _executeSQL(db, VideoSummariesTable.createSegmentIndex);
      await _executeSQL(db, GlossaryTermsTable.createChapterIdIndex);
      await _executeSQL(db, GlossaryTermsTable.createSegmentIndex);
      await _executeSQL(db, GlossaryTermsTable.createTermIndex);
      await _executeSQL(db, VideoQATable.createVideoIdIndex);
      await _executeSQL(db, VideoQATable.createProfileIdIndex);
      await _executeSQL(db, VideoQATable.createStatusIndex);
      await _executeSQL(db, MindMapNodesTable.createChapterIdIndex);
      await _executeSQL(db, MindMapNodesTable.createParentIdIndex);
      await _executeSQL(db, MindMapNodesTable.createSegmentIndex);
      await _executeSQL(db, FlashcardDecksTable.createTopicIdIndex);
      await _executeSQL(db, FlashcardDecksTable.createChapterIdIndex);
      await _executeSQL(db, FlashcardDecksTable.createSegmentIndex);
      await _executeSQL(db, FlashcardsTable.createDeckIdIndex);
      await _executeSQL(db, FlashcardsTable.createOrderIndex);
      await _executeSQL(db, FlashcardProgressTable.createCardIdIndex);
      await _executeSQL(db, FlashcardProgressTable.createProfileIdIndex);
      await _executeSQL(db, FlashcardProgressTable.createNextReviewIndex);
      await _executeSQL(db, FlashcardProgressTable.createProfileNextReviewIndex);

      // Chapter study tools indexes (v18)
      await _executeSQL(db, ChapterSummariesTable.createChapterIdIndex);
      await _executeSQL(db, ChapterSummariesTable.createSubjectIdIndex);
      await _executeSQL(db, ChapterSummariesTable.createSegmentIndex);
      await _executeSQL(db, ChapterNotesTable.createChapterIdIndex);
      await _executeSQL(db, ChapterNotesTable.createProfileIdIndex);
      await _executeSQL(db, ChapterNotesTable.createNoteTypeIndex);
      await _executeSQL(db, ChapterNotesTable.createSegmentIndex);
      await _executeSQL(db, ChapterNotesTable.createChapterProfileIndex);
      await _executeSQL(db, ChapterNotesTable.createPinnedIndex);

      // Spelling indexes (v19)
      await _executeSQL(db, SpellingAttemptDao.createIndexQuery);
      await _executeSQL(db, SpellingAttemptDao.createProfileIndexQuery);
      await _executeSQL(db, WordMasteryDao.createIndexQuery);
      await _executeSQL(db, WordMasteryDao.createReviewIndexQuery);

      logger.debug('Database indexes created successfully');
    } catch (e, stackTrace) {
      logger.error('Failed to create database indexes', e, stackTrace);
      rethrow;
    }
  }

  /// Upgrade database
  Future<void> _onUpgrade(dynamic db, int oldVersion, int newVersion) async {
    logger.info('Upgrading database from version $oldVersion to $newVersion');

    // Migration from version 1 to 2: Add title, channel_name, thumbnail_url to progress table
    if (oldVersion < 2) {
      logger.info('Migrating progress table: adding title, channel_name, thumbnail_url columns');

      try {
        await _executeSQL(db, 'ALTER TABLE progress ADD COLUMN title TEXT');
        await _executeSQL(db, 'ALTER TABLE progress ADD COLUMN channel_name TEXT');
        await _executeSQL(db, 'ALTER TABLE progress ADD COLUMN thumbnail_url TEXT');

        logger.info('Progress table migration completed successfully');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate progress table', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 2 to 3: Add quiz system tables
    if (oldVersion < 3) {
      logger.info('Migrating to v3: adding quiz system tables');

      try {
        // Create quiz system tables
        await _executeSQL(db, QuestionsOfflineTable.createTable);
        await _executeSQL(db, QuizzesOfflineTable.createTable);
        await _executeSQL(db, QuizSessionsTable.createTable);

        // Create quiz system indexes
        await _executeSQL(db, QuestionsOfflineTable.createDifficultyIndex);
        await _executeSQL(db, QuestionsOfflineTable.createTopicIdsIndex);
        await _executeSQL(db, QuizzesOfflineTable.createEntityIdIndex);
        await _executeSQL(db, QuizzesOfflineTable.createLevelIndex);
        await _executeSQL(db, QuizSessionsTable.createStudentIdIndex);
        await _executeSQL(db, QuizSessionsTable.createQuizIdIndex);
        await _executeSQL(db, QuizSessionsTable.createStartTimeIndex);

        logger.info('Quiz system tables migration completed successfully');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate quiz system tables', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 3 to 4: Add selected_question_ids to quiz_sessions
    if (oldVersion < 4) {
      logger.info('Migrating to v4: adding selected_question_ids column to quiz_sessions');

      try {
        await _executeSQL(
          db,
          'ALTER TABLE ${QuizSessionsTable.tableName} ADD COLUMN ${QuizSessionsTable.columnSelectedQuestionIds} TEXT NOT NULL DEFAULT \'[]\''
        );
        logger.info('Added selected_question_ids column to quiz_sessions table');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate quiz_sessions table', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 4 to 5: Add quiz_attempts table for Phase 4
    // IMPORTANT: Check if table exists instead of relying only on version number
    // This handles cases where database version may have been incremented by other changes
    try {
      // Check if quiz_attempts table exists
      final tableCheckQuery = "SELECT name FROM sqlite_master WHERE type='table' AND name='${QuizAttemptsTable.tableName}'";
      final List<Map<String, dynamic>> tableExists;

      if (db is sqflite_mobile.Database) {
        tableExists = await db.rawQuery(tableCheckQuery);
      } else if (db is sqflite_desktop.Database) {
        tableExists = await db.rawQuery(tableCheckQuery);
      } else {
        throw UnsupportedError('Unknown database type');
      }

      if (tableExists.isEmpty) {
        logger.info('Quiz attempts table does not exist, creating it now...');

        // Create quiz_attempts table
        await _executeSQL(db, QuizAttemptsTable.createTable);
        logger.info('Created quiz_attempts table');

        // Create all indexes for optimal query performance
        await _executeSQL(db, QuizAttemptsTable.createStudentIdIndex);
        await _executeSQL(db, QuizAttemptsTable.createQuizIdIndex);
        await _executeSQL(db, QuizAttemptsTable.createCompletedAtIndex);
        await _executeSQL(db, QuizAttemptsTable.createSubjectIdIndex);
        await _executeSQL(db, QuizAttemptsTable.createPassedIndex);
        await _executeSQL(db, QuizAttemptsTable.createScoreIndex);
        await _executeSQL(db, QuizAttemptsTable.createStudentCompletedIndex);
        await _executeSQL(db, QuizAttemptsTable.createStudentSubjectIndex);
        logger.info('Created all quiz_attempts table indexes');

        logger.info('Quiz attempts table migration completed successfully');
      } else {
        logger.info('Quiz attempts table already exists, skipping creation');
      }
    } catch (e, stackTrace) {
      logger.error('Failed to migrate quiz_attempts table', e, stackTrace);
      rethrow;
    }

    // Migration from version 5 to 6: Add questions_data column to quiz_attempts table
    if (oldVersion < 6) {
      logger.info('Migrating to v6: adding questions_data column to quiz_attempts table');

      try {
        // Check if column already exists
        final columnCheckQuery = "PRAGMA table_info(${QuizAttemptsTable.tableName})";
        final List<Map<String, dynamic>> columns;

        if (db is sqflite_mobile.Database) {
          columns = await db.rawQuery(columnCheckQuery);
        } else if (db is sqflite_desktop.Database) {
          columns = await db.rawQuery(columnCheckQuery);
        } else {
          throw UnsupportedError('Unknown database type');
        }

        final hasQuestionsDataColumn = columns.any((col) => col['name'] == QuizAttemptsTable.columnQuestionsData);

        if (!hasQuestionsDataColumn) {
          await _executeSQL(
            db,
            'ALTER TABLE ${QuizAttemptsTable.tableName} ADD COLUMN ${QuizAttemptsTable.columnQuestionsData} TEXT'
          );
          logger.info('Added questions_data column to quiz_attempts table');
        } else {
          logger.info('questions_data column already exists, skipping');
        }
      } catch (e, stackTrace) {
        logger.error('Failed to migrate quiz_attempts table with questions_data column', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 6 to 7: Add status column to quiz_attempts table
    if (oldVersion < 7) {
      logger.info('Migrating to v7: adding status column to quiz_attempts table');

      try {
        // Check if column already exists
        final columnCheckQuery = "PRAGMA table_info(${QuizAttemptsTable.tableName})";
        final List<Map<String, dynamic>> columns;

        if (db is sqflite_mobile.Database) {
          columns = await db.rawQuery(columnCheckQuery);
        } else if (db is sqflite_desktop.Database) {
          columns = await db.rawQuery(columnCheckQuery);
        } else {
          throw UnsupportedError('Unknown database type');
        }

        final hasStatusColumn = columns.any((col) => col['name'] == QuizAttemptsTable.columnStatus);

        if (!hasStatusColumn) {
          await _executeSQL(
            db,
            'ALTER TABLE ${QuizAttemptsTable.tableName} ADD COLUMN ${QuizAttemptsTable.columnStatus} TEXT NOT NULL DEFAULT \'completed\''
          );
          logger.info('Added status column to quiz_attempts table');
        } else {
          logger.info('status column already exists, skipping');
        }
      } catch (e, stackTrace) {
        logger.error('Failed to migrate quiz_attempts table with status column', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 7 to 8: Add title column to quizzes_offline table
    if (oldVersion < 8) {
      logger.info('Migrating to v8: adding title column to quizzes_offline table');

      try {
        // Check if column already exists
        final columnCheckQuery = "PRAGMA table_info(${QuizzesOfflineTable.tableName})";
        final List<Map<String, dynamic>> columns;

        if (db is sqflite_mobile.Database) {
          columns = await db.rawQuery(columnCheckQuery);
        } else if (db is sqflite_desktop.Database) {
          columns = await db.rawQuery(columnCheckQuery);
        } else {
          throw UnsupportedError('Unknown database type');
        }

        final hasTitleColumn = columns.any((col) => col['name'] == QuizzesOfflineTable.columnTitle);

        if (!hasTitleColumn) {
          await _executeSQL(
            db,
            'ALTER TABLE ${QuizzesOfflineTable.tableName} ADD COLUMN ${QuizzesOfflineTable.columnTitle} TEXT'
          );
          logger.info('Added title column to quizzes_offline table');
        } else {
          logger.info('title column already exists, skipping');
        }
      } catch (e, stackTrace) {
        logger.error('Failed to migrate quizzes_offline table with title column', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 8 to 9: Add app_state table
    if (oldVersion < 9) {
      logger.info('Migrating to v9: adding app_state table');

      try {
        await _executeSQL(db, AppStateTable.createTable);
        logger.info('Added app_state table');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate app_state table', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 9 to 10: Add pedagogy system tables
    if (oldVersion < 10) {
      logger.info('Migrating to v10: adding pedagogy system tables');

      try {
        // Create concept mastery table
        await _executeSQL(db, ConceptMasteryTable.createTable);
        await _executeSQL(db, ConceptMasteryTable.createStudentIdIndex);
        await _executeSQL(db, ConceptMasteryTable.createConceptIdIndex);
        await _executeSQL(db, ConceptMasteryTable.createIsGapIndex);
        await _executeSQL(db, ConceptMasteryTable.createNextReviewIndex);
        logger.info('Created concept_mastery table with indexes');

        // Create spaced repetition table
        await _executeSQL(db, SpacedRepetitionTable.createTable);
        await _executeSQL(db, SpacedRepetitionTable.createStudentIdIndex);
        await _executeSQL(db, SpacedRepetitionTable.createNextReviewIndex);
        await _executeSQL(db, SpacedRepetitionTable.createStudentNextReviewIndex);
        logger.info('Created spaced_repetition table with indexes');

        // Create learning paths table
        await _executeSQL(db, LearningPathsTable.createTable);
        await _executeSQL(db, LearningPathsTable.createStudentIdIndex);
        await _executeSQL(db, LearningPathsTable.createStatusIndex);
        logger.info('Created learning_paths table with indexes');

        // Create gamification table
        await _executeSQL(db, GamificationTable.createTable);
        await _executeSQL(db, GamificationTable.createStudentIdIndex);
        await _executeSQL(db, GamificationTable.createLevelIndex);
        logger.info('Created gamification table with indexes');

        // Create XP events table
        await _executeSQL(db, XpEventsTable.createTable);
        await _executeSQL(db, XpEventsTable.createStudentIdIndex);
        await _executeSQL(db, XpEventsTable.createTimestampIndex);
        await _executeSQL(db, XpEventsTable.createEventTypeIndex);
        logger.info('Created xp_events table with indexes');

        // Create badges table
        await _executeSQL(db, BadgesTable.createTable);
        await _executeSQL(db, BadgesTable.createStudentIdIndex);
        await _executeSQL(db, BadgesTable.createUnlockedIndex);
        logger.info('Created badges table with indexes');

        // Create video learning sessions table
        await _executeSQL(db, VideoLearningSessionsTable.createTable);
        await _executeSQL(db, VideoLearningSessionsTable.createStudentIdIndex);
        await _executeSQL(db, VideoLearningSessionsTable.createVideoIdIndex);
        await _executeSQL(db, VideoLearningSessionsTable.createStartedAtIndex);
        logger.info('Created video_learning_sessions table with indexes');

        // Create pre-assessments table
        await _executeSQL(db, PreAssessmentsTable.createTable);
        await _executeSQL(db, PreAssessmentsTable.createStudentIdIndex);
        await _executeSQL(db, PreAssessmentsTable.createSubjectIdIndex);
        logger.info('Created pre_assessments table with indexes');

        // Create chapter assessments table
        await _executeSQL(db, ChapterAssessmentsTable.createTable);
        await _executeSQL(db, ChapterAssessmentsTable.createStudentIdIndex);
        await _executeSQL(db, ChapterAssessmentsTable.createChapterIdIndex);
        await _executeSQL(db, ChapterAssessmentsTable.createSubjectIdIndex);
        logger.info('Created chapter_assessments table with indexes');

        logger.info('Pedagogy system tables migration completed successfully');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate pedagogy system tables', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 10 to 11: Add recommendations history and quiz attempt recommendation metadata
    if (oldVersion < 11) {
      logger.info('Migrating to v11: adding recommendations history table and quiz attempt metadata');

      try {
        // Step 1: Add new columns to quiz_attempts table
        logger.info('Adding recommendation metadata columns to quiz_attempts table');

        // Check existing columns to avoid duplicates
        final columnCheckQuery = "PRAGMA table_info(${QuizAttemptsTable.tableName})";
        final List<Map<String, dynamic>> existingColumns;

        if (db is sqflite_mobile.Database) {
          existingColumns = await db.rawQuery(columnCheckQuery);
        } else if (db is sqflite_desktop.Database) {
          existingColumns = await db.rawQuery(columnCheckQuery);
        } else {
          throw UnsupportedError('Unknown database type');
        }

        final columnNames = existingColumns.map((col) => col['name'] as String).toSet();

        // Add assessment_type column
        if (!columnNames.contains(QuizAttemptsTable.columnAssessmentType)) {
          await _executeSQL(
            db,
            'ALTER TABLE ${QuizAttemptsTable.tableName} ADD COLUMN ${QuizAttemptsTable.columnAssessmentType} TEXT NOT NULL DEFAULT \'practice\''
          );
          logger.info('Added assessment_type column');
        }

        // Add has_recommendations column
        if (!columnNames.contains(QuizAttemptsTable.columnHasRecommendations)) {
          await _executeSQL(
            db,
            'ALTER TABLE ${QuizAttemptsTable.tableName} ADD COLUMN ${QuizAttemptsTable.columnHasRecommendations} INTEGER NOT NULL DEFAULT 0'
          );
          logger.info('Added has_recommendations column');
        }

        // Add recommendation_count column
        if (!columnNames.contains(QuizAttemptsTable.columnRecommendationCount)) {
          await _executeSQL(
            db,
            'ALTER TABLE ${QuizAttemptsTable.tableName} ADD COLUMN ${QuizAttemptsTable.columnRecommendationCount} INTEGER'
          );
          logger.info('Added recommendation_count column');
        }

        // Add recommendations_generated_at column
        if (!columnNames.contains(QuizAttemptsTable.columnRecommendationsGeneratedAt)) {
          await _executeSQL(
            db,
            'ALTER TABLE ${QuizAttemptsTable.tableName} ADD COLUMN ${QuizAttemptsTable.columnRecommendationsGeneratedAt} INTEGER'
          );
          logger.info('Added recommendations_generated_at column');
        }

        // Add recommendation_status column
        if (!columnNames.contains(QuizAttemptsTable.columnRecommendationStatus)) {
          await _executeSQL(
            db,
            'ALTER TABLE ${QuizAttemptsTable.tableName} ADD COLUMN ${QuizAttemptsTable.columnRecommendationStatus} TEXT NOT NULL DEFAULT \'none\''
          );
          logger.info('Added recommendation_status column');
        }

        // Add recommendations_history_id column
        if (!columnNames.contains(QuizAttemptsTable.columnRecommendationsHistoryId)) {
          await _executeSQL(
            db,
            'ALTER TABLE ${QuizAttemptsTable.tableName} ADD COLUMN ${QuizAttemptsTable.columnRecommendationsHistoryId} TEXT'
          );
          logger.info('Added recommendations_history_id column');
        }

        // Add learning_path_id column
        if (!columnNames.contains(QuizAttemptsTable.columnLearningPathId)) {
          await _executeSQL(
            db,
            'ALTER TABLE ${QuizAttemptsTable.tableName} ADD COLUMN ${QuizAttemptsTable.columnLearningPathId} TEXT'
          );
          logger.info('Added learning_path_id column');
        }

        // Add learning_path_progress column
        if (!columnNames.contains(QuizAttemptsTable.columnLearningPathProgress)) {
          await _executeSQL(
            db,
            'ALTER TABLE ${QuizAttemptsTable.tableName} ADD COLUMN ${QuizAttemptsTable.columnLearningPathProgress} REAL'
          );
          logger.info('Added learning_path_progress column');
        }

        // NOTE: We do NOT classify existing quiz attempts by score!
        // Assessment type is determined by USER INTENT (what button they clicked),
        // NOT by their score. Existing quizzes will retain default 'practice' type.
        logger.info('Skipping classification of existing quiz attempts (will use default: practice)');

        // Step 2: Create recommendations_history table
        logger.info('Creating recommendations_history table');
        await _executeSQL(db, RecommendationsHistoryTable.createTable);
        logger.info('Created recommendations_history table');

        // Step 3: Create indexes for quiz_attempts new columns
        logger.info('Creating indexes for new quiz_attempts columns');
        await _executeSQL(db, QuizAttemptsTable.createAssessmentTypeIndex);
        await _executeSQL(db, QuizAttemptsTable.createHasRecommendationsIndex);
        await _executeSQL(db, QuizAttemptsTable.createRecommendationStatusIndex);
        await _executeSQL(db, QuizAttemptsTable.createStudentAssessmentRecommendationsIndex);
        logger.info('Created quiz_attempts recommendation indexes');

        // Step 4: Create indexes for recommendations_history table
        logger.info('Creating indexes for recommendations_history table');
        await _executeSQL(db, RecommendationsHistoryTable.createQuizAttemptIndex);
        await _executeSQL(db, RecommendationsHistoryTable.createUserIdIndex);
        await _executeSQL(db, RecommendationsHistoryTable.createAssessmentTypeIndex);
        await _executeSQL(db, RecommendationsHistoryTable.createGeneratedAtIndex);
        await _executeSQL(db, RecommendationsHistoryTable.createUserAssessmentIndex);
        logger.info('Created recommendations_history indexes');

        logger.info('v11 migration completed successfully');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate to v11', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 11 to 12: Add metadata column to learning_paths table
    if (oldVersion < 12) {
      logger.info('Migrating to v12: adding metadata column to learning_paths table');

      try {
        // Check if metadata column already exists
        final columnCheckQuery = "PRAGMA table_info(${LearningPathsTable.tableName})";
        final List<Map<String, dynamic>> existingColumns;

        if (db is sqflite_mobile.Database) {
          existingColumns = await db.rawQuery(columnCheckQuery);
        } else if (db is sqflite_desktop.Database) {
          existingColumns = await db.rawQuery(columnCheckQuery);
        } else {
          throw UnsupportedError('Unknown database type');
        }

        final columnNames = existingColumns.map((col) => col['name'] as String).toSet();

        // Add metadata column if it doesn't exist
        if (!columnNames.contains(LearningPathsTable.columnMetadata)) {
          logger.info('Adding metadata column to learning_paths table');
          await _executeSQL(
            db,
            'ALTER TABLE ${LearningPathsTable.tableName} '
            'ADD COLUMN ${LearningPathsTable.columnMetadata} TEXT',
          );
          logger.info('Added metadata column to learning_paths table');
        } else {
          logger.info('metadata column already exists in learning_paths table, skipping');
        }

        logger.info('v12 migration completed successfully');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate to v12', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 12 to 13: Add assessment_type column to quiz_sessions table
    if (oldVersion < 13) {
      logger.info('Migrating to v13: adding assessment_type column to quiz_sessions table');

      try {
        // Check if assessment_type column already exists
        final columnCheckQuery = "PRAGMA table_info(${QuizSessionsTable.tableName})";
        final List<Map<String, dynamic>> existingColumns;

        if (db is sqflite_mobile.Database) {
          existingColumns = await db.rawQuery(columnCheckQuery);
        } else if (db is sqflite_desktop.Database) {
          existingColumns = await db.rawQuery(columnCheckQuery);
        } else {
          throw UnsupportedError('Unknown database type');
        }

        final columnNames = existingColumns.map((col) => col['name'] as String).toSet();

        // Add assessment_type column if it doesn't exist
        if (!columnNames.contains(QuizSessionsTable.columnAssessmentType)) {
          logger.info('Adding assessment_type column to quiz_sessions table');
          await _executeSQL(
            db,
            'ALTER TABLE ${QuizSessionsTable.tableName} '
            'ADD COLUMN ${QuizSessionsTable.columnAssessmentType} TEXT NOT NULL DEFAULT \'practice\'',
          );
          logger.info('Added assessment_type column to quiz_sessions table');
          logger.info('CRITICAL FIX: Quiz sessions will now preserve assessment type (readiness/knowledge/practice)');
        } else {
          logger.info('assessment_type column already exists in quiz_sessions table, skipping');
        }

        logger.info('v13 migration completed successfully');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate to v13', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 13 to 14: Add Junior app tables (user_profile_junior, parental_controls, screen_time_log)
    if (oldVersion < 14) {
      logger.info('Migrating to v14: adding Junior app tables');

      try {
        // Create user_profile_junior table
        logger.info('Creating user_profile_junior table');
        await _executeSQL(db, UserProfileJuniorTable.createTable);
        await _executeSQL(db, UserProfileJuniorTable.createGradeIndex);
        logger.info('Created user_profile_junior table with indexes');

        // Create parental_controls table
        logger.info('Creating parental_controls table');
        await _executeSQL(db, ParentalControlsTable.createTable);
        await _executeSQL(db, ParentalControlsTable.createUserIdIndex);
        await _executeSQL(db, ParentalControlsTable.createEnabledIndex);
        logger.info('Created parental_controls table with indexes');

        // Create screen_time_log table
        logger.info('Creating screen_time_log table');
        await _executeSQL(db, ScreenTimeLogTable.createTable);
        await _executeSQL(db, ScreenTimeLogTable.createUserIdIndex);
        await _executeSQL(db, ScreenTimeLogTable.createDateIndex);
        await _executeSQL(db, ScreenTimeLogTable.createUserDateIndex);
        logger.info('Created screen_time_log table with indexes');

        logger.info('v14 migration completed successfully (Junior app tables added)');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate to v14', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 14 to 15: Add profile_id column to progress and bookmarks tables
    if (oldVersion < 15) {
      logger.info('Migrating to v15: adding profile_id column to progress and bookmarks tables');

      try {
        // Check existing columns in progress table
        final progressColumnCheckQuery = "PRAGMA table_info(${ProgressTable.tableName})";
        final List<Map<String, dynamic>> progressColumns;

        if (db is sqflite_mobile.Database) {
          progressColumns = await db.rawQuery(progressColumnCheckQuery);
        } else if (db is sqflite_desktop.Database) {
          progressColumns = await db.rawQuery(progressColumnCheckQuery);
        } else {
          throw UnsupportedError('Unknown database type');
        }

        final progressColumnNames = progressColumns.map((col) => col['name'] as String).toSet();

        // Add profile_id to progress table if it doesn't exist
        if (!progressColumnNames.contains(ProgressTable.columnProfileId)) {
          logger.info('Adding profile_id column to progress table');
          await _executeSQL(
            db,
            'ALTER TABLE ${ProgressTable.tableName} ADD COLUMN ${ProgressTable.columnProfileId} TEXT NOT NULL DEFAULT \'\'',
          );

          // Create index for profile_id
          await _executeSQL(db, ProgressTable.createProfileIdIndex);
          logger.info('Added profile_id column and index to progress table');
        } else {
          logger.info('profile_id column already exists in progress table, skipping');
        }

        // Check existing columns in bookmarks table
        final bookmarksColumnCheckQuery = "PRAGMA table_info(${BookmarksTable.tableName})";
        final List<Map<String, dynamic>> bookmarksColumns;

        if (db is sqflite_mobile.Database) {
          bookmarksColumns = await db.rawQuery(bookmarksColumnCheckQuery);
        } else if (db is sqflite_desktop.Database) {
          bookmarksColumns = await db.rawQuery(bookmarksColumnCheckQuery);
        } else {
          throw UnsupportedError('Unknown database type');
        }

        final bookmarksColumnNames = bookmarksColumns.map((col) => col['name'] as String).toSet();

        // Add profile_id to bookmarks table if it doesn't exist
        if (!bookmarksColumnNames.contains(BookmarksTable.columnProfileId)) {
          logger.info('Adding profile_id column to bookmarks table');
          await _executeSQL(
            db,
            'ALTER TABLE ${BookmarksTable.tableName} ADD COLUMN ${BookmarksTable.columnProfileId} TEXT NOT NULL DEFAULT \'\'',
          );

          // Create index for profile_id
          await _executeSQL(db, BookmarksTable.createProfileIdIndex);
          logger.info('Added profile_id column and index to bookmarks table');
        } else {
          logger.info('profile_id column already exists in bookmarks table, skipping');
        }

        logger.info('v15 migration completed successfully (multi-profile support for progress and bookmarks)');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate to v15', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 15 to 16: Add profile_id column to notes, collections, search_history tables
    if (oldVersion < 16) {
      logger.info('Migrating to v16: adding profile_id column to notes, collections, search_history tables');

      try {
        // Helper function to check if column exists
        Future<bool> columnExists(String tableName, String columnName) async {
          final String query = "PRAGMA table_info($tableName)";
          List<Map<String, dynamic>> columns;
          if (db is sqflite_mobile.Database) {
            columns = await db.rawQuery(query);
          } else if (db is sqflite_desktop.Database) {
            columns = await db.rawQuery(query);
          } else {
            throw UnsupportedError('Unknown database type');
          }
          return columns.any((col) => col['name'] == columnName);
        }

        // Add profile_id to notes table
        if (!await columnExists(NotesTable.tableName, NotesTable.columnProfileId)) {
          logger.info('Adding profile_id column to notes table');
          await _executeSQL(
            db,
            'ALTER TABLE ${NotesTable.tableName} ADD COLUMN ${NotesTable.columnProfileId} TEXT NOT NULL DEFAULT \'\'',
          );
          await _executeSQL(db, NotesTable.createProfileIdIndex);
          logger.info('Added profile_id column and index to notes table');
        }

        // Add profile_id to collections table
        if (!await columnExists(CollectionsTable.tableName, CollectionsTable.columnProfileId)) {
          logger.info('Adding profile_id column to collections table');
          await _executeSQL(
            db,
            'ALTER TABLE ${CollectionsTable.tableName} ADD COLUMN ${CollectionsTable.columnProfileId} TEXT NOT NULL DEFAULT \'\'',
          );
          await _executeSQL(db, CollectionsTable.createProfileIdIndex);
          logger.info('Added profile_id column and index to collections table');
        }

        // Add profile_id to search_history table
        if (!await columnExists(SearchHistoryTable.tableName, SearchHistoryTable.columnProfileId)) {
          logger.info('Adding profile_id column to search_history table');
          await _executeSQL(
            db,
            'ALTER TABLE ${SearchHistoryTable.tableName} ADD COLUMN ${SearchHistoryTable.columnProfileId} TEXT NOT NULL DEFAULT \'\'',
          );
          await _executeSQL(db, SearchHistoryTable.createProfileIdIndex);
          logger.info('Added profile_id column and index to search_history table');
        }

        logger.info('v16 migration completed successfully (complete multi-profile support)');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate to v16', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 16 to 17: Add study tools tables
    if (oldVersion < 17) {
      logger.info('Migrating to v17: adding study tools tables');

      try {
        // Create video_summaries table
        logger.info('Creating video_summaries table');
        await _executeSQL(db, VideoSummariesTable.createTable);
        await _executeSQL(db, VideoSummariesTable.createVideoIdIndex);
        await _executeSQL(db, VideoSummariesTable.createSegmentIndex);
        logger.info('Created video_summaries table with indexes');

        // Create glossary_terms table
        logger.info('Creating glossary_terms table');
        await _executeSQL(db, GlossaryTermsTable.createTable);
        await _executeSQL(db, GlossaryTermsTable.createChapterIdIndex);
        await _executeSQL(db, GlossaryTermsTable.createSegmentIndex);
        await _executeSQL(db, GlossaryTermsTable.createTermIndex);
        logger.info('Created glossary_terms table with indexes');

        // Create video_qa table
        logger.info('Creating video_qa table');
        await _executeSQL(db, VideoQATable.createTable);
        await _executeSQL(db, VideoQATable.createVideoIdIndex);
        await _executeSQL(db, VideoQATable.createProfileIdIndex);
        await _executeSQL(db, VideoQATable.createStatusIndex);
        logger.info('Created video_qa table with indexes');

        // Create mind_map_nodes table
        logger.info('Creating mind_map_nodes table');
        await _executeSQL(db, MindMapNodesTable.createTable);
        await _executeSQL(db, MindMapNodesTable.createChapterIdIndex);
        await _executeSQL(db, MindMapNodesTable.createParentIdIndex);
        await _executeSQL(db, MindMapNodesTable.createSegmentIndex);
        logger.info('Created mind_map_nodes table with indexes');

        // Create flashcard_decks table
        logger.info('Creating flashcard_decks table');
        await _executeSQL(db, FlashcardDecksTable.createTable);
        await _executeSQL(db, FlashcardDecksTable.createTopicIdIndex);
        await _executeSQL(db, FlashcardDecksTable.createChapterIdIndex);
        await _executeSQL(db, FlashcardDecksTable.createSegmentIndex);
        logger.info('Created flashcard_decks table with indexes');

        // Create flashcards table
        logger.info('Creating flashcards table');
        await _executeSQL(db, FlashcardsTable.createTable);
        await _executeSQL(db, FlashcardsTable.createDeckIdIndex);
        await _executeSQL(db, FlashcardsTable.createOrderIndex);
        logger.info('Created flashcards table with indexes');

        // Create flashcard_progress table
        logger.info('Creating flashcard_progress table');
        await _executeSQL(db, FlashcardProgressTable.createTable);
        await _executeSQL(db, FlashcardProgressTable.createCardIdIndex);
        await _executeSQL(db, FlashcardProgressTable.createProfileIdIndex);
        await _executeSQL(db, FlashcardProgressTable.createNextReviewIndex);
        await _executeSQL(db, FlashcardProgressTable.createProfileNextReviewIndex);
        logger.info('Created flashcard_progress table with indexes');

        logger.info('v17 migration completed successfully (study tools tables added)');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate to v17', e, stackTrace);
        rethrow;
      }
    }

    // Migration from version 17 to 18: Add chapter_summaries and chapter_notes tables
    if (oldVersion < 18) {
      logger.info('Migrating to v18: adding chapter study tools tables');

      try {
        // Create chapter_summaries table
        logger.info('Creating chapter_summaries table');
        await _executeSQL(db, ChapterSummariesTable.createTable);
        await _executeSQL(db, ChapterSummariesTable.createChapterIdIndex);
        await _executeSQL(db, ChapterSummariesTable.createSubjectIdIndex);
        await _executeSQL(db, ChapterSummariesTable.createSegmentIndex);
        logger.info('Created chapter_summaries table with indexes');

        // Create chapter_notes table
        logger.info('Creating chapter_notes table');
        await _executeSQL(db, ChapterNotesTable.createTable);
        await _executeSQL(db, ChapterNotesTable.createChapterIdIndex);
        await _executeSQL(db, ChapterNotesTable.createProfileIdIndex);
        await _executeSQL(db, ChapterNotesTable.createNoteTypeIndex);
        await _executeSQL(db, ChapterNotesTable.createSegmentIndex);
        await _executeSQL(db, ChapterNotesTable.createChapterProfileIndex);
        await _executeSQL(db, ChapterNotesTable.createPinnedIndex);
        logger.info('Created chapter_notes table with indexes');

        logger.info('v18 migration completed successfully (chapter study tools tables added)');
      } catch (e, stackTrace) {
        logger.error('Failed to migrate to v18', e, stackTrace);
        rethrow;
      }
    }

    if (oldVersion < 19) {
      logger.info('Upgrading database to version 19 (spelling tables)');
      await _executeSQL(db, SpellingAttemptDao.createTableQuery);
      await _executeSQL(db, SpellingAttemptDao.createIndexQuery);
      await _executeSQL(db, SpellingAttemptDao.createProfileIndexQuery);
      await _executeSQL(db, WordMasteryDao.createTableQuery);
      await _executeSQL(db, WordMasteryDao.createIndexQuery);
      await _executeSQL(db, WordMasteryDao.createReviewIndexQuery);
    }

    logger.info('Database upgrade completed');
  }

  /// Execute SQL statement on database
  Future<void> _executeSQL(dynamic db, String sql) async {
    if (db is sqflite_mobile.Database) {
      await db.execute(sql);
    } else if (db is sqflite_desktop.Database) {
      await db.execute(sql);
    } else {
      throw DatabaseException(
        message: 'Unknown database type: ${db.runtimeType}',
        details: db,
      );
    }
  }

  /// Get platform name
  String _getPlatformName() {
    if (UniversalPlatform.isAndroid) return 'Android';
    if (UniversalPlatform.isIOS) return 'iOS';
    if (UniversalPlatform.isWindows) return 'Windows';
    if (UniversalPlatform.isMacOS) return 'macOS';
    if (UniversalPlatform.isLinux) return 'Linux';
    if (UniversalPlatform.isWeb) return 'Web';
    return 'Unknown';
  }

  /// Close database
  Future<void> close() async {
    if (_database != null) {
      logger.info('Closing database');

      if (_database is sqflite_mobile.Database) {
        await (_database as sqflite_mobile.Database).close();
      } else if (_database is sqflite_desktop.Database) {
        await (_database as sqflite_desktop.Database).close();
      }

      _database = null;
      logger.info('Database closed successfully');
    }
  }

  /// Delete database (for testing or reset)
  Future<void> deleteDatabase() async {
    try {
      logger.warning('Deleting database');

      await close();

      String dbPath;
      if (UniversalPlatform.isWindows ||
          UniversalPlatform.isLinux ||
          UniversalPlatform.isMacOS) {
        dbPath = await _getDesktopDatabasePath();
        await sqflite_desktop.databaseFactoryFfi.deleteDatabase(dbPath);
      } else if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
        dbPath = await _getMobileDatabasePath();
        await sqflite_mobile.deleteDatabase(dbPath);
      }

      logger.info('Database deleted successfully');
    } catch (e, stackTrace) {
      logger.error('Failed to delete database', e, stackTrace);
      throw DatabaseException(
        message: 'Failed to delete database: ${e.toString()}',
        details: e,
      );
    }
  }
}
