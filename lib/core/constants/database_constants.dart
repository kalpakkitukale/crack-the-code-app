/// Database configuration constants for StreamShaala
///
/// This file contains all database-related constants including:
/// - Database name and version
/// - Table names
/// - Column names for each table
/// - SQL queries for table creation
library;

/// Main database name
const String kDatabaseName = 'streamshaala.db';

/// Current database version
/// Version 2: Added title, channel_name, thumbnail_url to progress table
/// Version 3: Added quiz system tables (questions_offline, quizzes_offline, quiz_sessions)
/// Version 4: Added selected_question_ids to quiz_sessions table
/// Version 5: Added quiz_attempts table for Phase 4 statistics and history
/// Version 6: Added questions_data column to quiz_attempts table for detailed question review
/// Version 7: Added status column to quiz_attempts table to track in-progress, completed, and abandoned quizzes
/// Version 8: Added title column to quizzes_offline table for proper quiz history display
/// Version 9: Added app_state table for migration tracking and app configuration
/// Version 10: Added pedagogy system tables (concept_mastery, spaced_repetition, gamification, learning_paths)
/// Version 11: Added recommendations_history table and quiz attempt recommendation metadata
/// Version 12: Added metadata column to learning_paths table
/// Version 13: Added assessment_type column to quiz_sessions table (CRITICAL FIX)
/// Version 14: Added Junior app tables (user_profile_junior, parental_controls, screen_time_log)
/// Version 15: Added profile_id column to progress and bookmarks tables for multi-profile support
/// Version 16: Added profile_id column to notes, collections, collection_videos, search_history for complete multi-profile support
/// Version 17: Added study tools tables (video_summaries, glossary_terms, video_qa, mind_map_nodes, flashcard_decks, flashcards, flashcard_progress)
/// Version 18: Added chapter_summaries and chapter_notes tables for Study Hub Summary & Notes features
/// Version 19: Added spelling tables (spelling_attempts, word_mastery)
const int kDatabaseVersion = 19;

/// Table Names
class DatabaseTables {
  static const String bookmarks = 'bookmarks';
  static const String notes = 'notes';
  static const String progress = 'progress';
  static const String collections = 'collections';
  static const String collectionVideos = 'collection_videos';
  static const String preferences = 'preferences';
  static const String searchHistory = 'search_history';
  static const String appState = 'app_state';

  // Quiz system tables
  static const String questionsOffline = 'questions_offline';
  static const String quizzesOffline = 'quizzes_offline';
  static const String quizSessions = 'quiz_sessions';
  static const String quizAttempts = 'quiz_attempts';

  // Pedagogy system tables
  static const String conceptMastery = 'concept_mastery';
  static const String spacedRepetition = 'spaced_repetition';
  static const String learningPaths = 'learning_paths';
  static const String gamification = 'gamification';
  static const String xpEvents = 'xp_events';
  static const String badges = 'badges';
  static const String videoLearningSessions = 'video_learning_sessions';
  static const String preAssessments = 'pre_assessments';
  static const String chapterAssessments = 'chapter_assessments';
  static const String recommendationsHistory = 'recommendations_history';

  // Junior app tables (v14)
  static const String userProfileJunior = 'user_profile_junior';
  static const String parentalControls = 'parental_controls';
  static const String screenTimeLog = 'screen_time_log';

  // Study tools tables (v17)
  static const String videoSummaries = 'video_summaries';
  static const String glossaryTerms = 'glossary_terms';
  static const String videoQA = 'video_qa';
  static const String mindMapNodes = 'mind_map_nodes';
  static const String flashcardDecks = 'flashcard_decks';
  static const String flashcards = 'flashcards';
  static const String flashcardProgress = 'flashcard_progress';

  // Chapter study tools tables (v18)
  static const String chapterSummaries = 'chapter_summaries';
  static const String chapterNotes = 'chapter_notes';

  // Spelling tables (v19)
  static const String spellingAttempts = 'spelling_attempts';
  static const String wordMastery = 'word_mastery';
}

/// Bookmarks Table
class BookmarksTable {
  static const String tableName = DatabaseTables.bookmarks;

  // Column names
  static const String columnId = 'id';
  static const String columnVideoId = 'video_id';
  static const String columnProfileId = 'profile_id';
  static const String columnTitle = 'title';
  static const String columnThumbnailUrl = 'thumbnail_url';
  static const String columnDuration = 'duration';
  static const String columnChannelName = 'channel_name';
  static const String columnCreatedAt = 'created_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnVideoId TEXT NOT NULL,
      $columnProfileId TEXT NOT NULL DEFAULT '',
      $columnTitle TEXT NOT NULL,
      $columnThumbnailUrl TEXT,
      $columnDuration INTEGER,
      $columnChannelName TEXT,
      $columnCreatedAt INTEGER NOT NULL,
      UNIQUE($columnVideoId, $columnProfileId)
    )
  ''';

  // Indexes
  static const String createVideoIdIndex = '''
    CREATE INDEX idx_bookmarks_video_id ON $tableName($columnVideoId)
  ''';

  static const String createProfileIdIndex = '''
    CREATE INDEX idx_bookmarks_profile_id ON $tableName($columnProfileId)
  ''';

  static const String createCreatedAtIndex = '''
    CREATE INDEX idx_bookmarks_created_at ON $tableName($columnCreatedAt DESC)
  ''';
}

/// Notes Table
class NotesTable {
  static const String tableName = DatabaseTables.notes;

  // Column names
  static const String columnId = 'id';
  static const String columnVideoId = 'video_id';
  static const String columnProfileId = 'profile_id';
  static const String columnContent = 'content';
  static const String columnTimestampSeconds = 'timestamp_seconds';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnVideoId TEXT NOT NULL,
      $columnProfileId TEXT NOT NULL DEFAULT '',
      $columnContent TEXT NOT NULL,
      $columnTimestampSeconds INTEGER,
      $columnCreatedAt INTEGER NOT NULL,
      $columnUpdatedAt INTEGER NOT NULL
    )
  ''';

  // Indexes
  static const String createVideoIdIndex = '''
    CREATE INDEX idx_notes_video_id ON $tableName($columnVideoId)
  ''';

  static const String createProfileIdIndex = '''
    CREATE INDEX idx_notes_profile_id ON $tableName($columnProfileId)
  ''';

  static const String createUpdatedAtIndex = '''
    CREATE INDEX idx_notes_updated_at ON $tableName($columnUpdatedAt DESC)
  ''';
}

/// Progress Table
class ProgressTable {
  static const String tableName = DatabaseTables.progress;

  // Column names
  static const String columnId = 'id';
  static const String columnVideoId = 'video_id';
  static const String columnProfileId = 'profile_id';
  static const String columnTitle = 'title';
  static const String columnChannelName = 'channel_name';
  static const String columnThumbnailUrl = 'thumbnail_url';
  static const String columnWatchDuration = 'watch_duration';
  static const String columnTotalDuration = 'total_duration';
  static const String columnCompleted = 'completed';
  static const String columnLastWatched = 'last_watched';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnVideoId TEXT NOT NULL,
      $columnProfileId TEXT NOT NULL DEFAULT '',
      $columnTitle TEXT,
      $columnChannelName TEXT,
      $columnThumbnailUrl TEXT,
      $columnWatchDuration INTEGER NOT NULL,
      $columnTotalDuration INTEGER NOT NULL,
      $columnCompleted INTEGER NOT NULL DEFAULT 0,
      $columnLastWatched INTEGER NOT NULL,
      UNIQUE($columnVideoId, $columnProfileId)
    )
  ''';

  // Indexes
  static const String createVideoIdIndex = '''
    CREATE INDEX idx_progress_video_id ON $tableName($columnVideoId)
  ''';

  static const String createProfileIdIndex = '''
    CREATE INDEX idx_progress_profile_id ON $tableName($columnProfileId)
  ''';

  static const String createLastWatchedIndex = '''
    CREATE INDEX idx_progress_last_watched ON $tableName($columnLastWatched DESC)
  ''';

  static const String createCompletedIndex = '''
    CREATE INDEX idx_progress_completed ON $tableName($columnCompleted)
  ''';
}

/// Collections Table
class CollectionsTable {
  static const String tableName = DatabaseTables.collections;

  // Column names
  static const String columnId = 'id';
  static const String columnProfileId = 'profile_id';
  static const String columnName = 'name';
  static const String columnDescription = 'description';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnProfileId TEXT NOT NULL DEFAULT '',
      $columnName TEXT NOT NULL,
      $columnDescription TEXT,
      $columnCreatedAt INTEGER NOT NULL,
      $columnUpdatedAt INTEGER NOT NULL
    )
  ''';

  // Indexes
  static const String createProfileIdIndex = '''
    CREATE INDEX idx_collections_profile_id ON $tableName($columnProfileId)
  ''';

  static const String createCreatedAtIndex = '''
    CREATE INDEX idx_collections_created_at ON $tableName($columnCreatedAt DESC)
  ''';
}

/// Collection Videos Table (Many-to-Many relationship)
class CollectionVideosTable {
  static const String tableName = DatabaseTables.collectionVideos;

  // Column names
  static const String columnId = 'id';
  static const String columnCollectionId = 'collection_id';
  static const String columnVideoId = 'video_id';
  static const String columnVideoTitle = 'video_title';
  static const String columnThumbnailUrl = 'thumbnail_url';
  static const String columnDuration = 'duration';
  static const String columnChannelName = 'channel_name';
  static const String columnAddedAt = 'added_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnCollectionId TEXT NOT NULL,
      $columnVideoId TEXT NOT NULL,
      $columnVideoTitle TEXT NOT NULL,
      $columnThumbnailUrl TEXT,
      $columnDuration INTEGER,
      $columnChannelName TEXT,
      $columnAddedAt INTEGER NOT NULL,
      FOREIGN KEY ($columnCollectionId) REFERENCES ${CollectionsTable.tableName}(${CollectionsTable.columnId}) ON DELETE CASCADE,
      UNIQUE($columnCollectionId, $columnVideoId)
    )
  ''';

  // Indexes
  static const String createCollectionIdIndex = '''
    CREATE INDEX idx_collection_videos_collection_id ON $tableName($columnCollectionId)
  ''';

  static const String createVideoIdIndex = '''
    CREATE INDEX idx_collection_videos_video_id ON $tableName($columnVideoId)
  ''';

  static const String createAddedAtIndex = '''
    CREATE INDEX idx_collection_videos_added_at ON $tableName($columnAddedAt DESC)
  ''';
}

/// Preferences Table (Key-Value store)
class PreferencesTable {
  static const String tableName = DatabaseTables.preferences;

  // Column names
  static const String columnKey = 'key';
  static const String columnValue = 'value';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnKey TEXT PRIMARY KEY,
      $columnValue TEXT NOT NULL
    )
  ''';

  // Preference Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyAutoPlayNext = 'auto_play_next';
  static const String keyVideoQuality = 'video_quality';
  static const String keyPlaybackSpeed = 'playback_speed';
  static const String keySubtitlesEnabled = 'subtitles_enabled';
}

/// Search History Table
class SearchHistoryTable {
  static const String tableName = DatabaseTables.searchHistory;

  // Column names
  static const String columnId = 'id';
  static const String columnProfileId = 'profile_id';
  static const String columnQuery = 'query';
  static const String columnTimestamp = 'timestamp';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnProfileId TEXT NOT NULL DEFAULT '',
      $columnQuery TEXT NOT NULL,
      $columnTimestamp INTEGER NOT NULL
    )
  ''';

  // Indexes
  static const String createProfileIdIndex = '''
    CREATE INDEX idx_search_history_profile_id ON $tableName($columnProfileId)
  ''';

  static const String createQueryIndex = '''
    CREATE INDEX idx_search_history_query ON $tableName($columnQuery)
  ''';

  static const String createTimestampIndex = '''
    CREATE INDEX idx_search_history_timestamp ON $tableName($columnTimestamp DESC)
  ''';
}

/// App State Table (Key-Value store for app configuration and migration tracking)
class AppStateTable {
  static const String tableName = DatabaseTables.appState;

  // Column names
  static const String columnKey = 'key';
  static const String columnValue = 'value';
  static const String columnUpdatedAt = 'updated_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnKey TEXT PRIMARY KEY,
      $columnValue TEXT NOT NULL,
      $columnUpdatedAt INTEGER NOT NULL
    )
  ''';

  // App State Keys
  static const String keyProgressMigrationV1 = 'progress_migration_v1_completed';
  static const String keyDatabaseVersion = 'database_version';
  static const String keyCompletionThreshold = 'completion_threshold';
}

/// Questions Offline Table
class QuestionsOfflineTable {
  static const String tableName = DatabaseTables.questionsOffline;

  // Column names
  static const String columnId = 'id';
  static const String columnQuestionText = 'question_text';
  static const String columnQuestionType = 'question_type';
  static const String columnOptions = 'options';
  static const String columnCorrectAnswer = 'correct_answer';
  static const String columnExplanation = 'explanation';
  static const String columnHints = 'hints';
  static const String columnDifficulty = 'difficulty';
  static const String columnConceptTags = 'concept_tags';
  static const String columnTopicIds = 'topic_ids';
  static const String columnVideoTimestamp = 'video_timestamp';
  static const String columnPoints = 'points';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnQuestionText TEXT NOT NULL,
      $columnQuestionType TEXT NOT NULL,
      $columnOptions TEXT NOT NULL,
      $columnCorrectAnswer TEXT NOT NULL,
      $columnExplanation TEXT NOT NULL,
      $columnHints TEXT NOT NULL,
      $columnDifficulty TEXT NOT NULL,
      $columnConceptTags TEXT NOT NULL,
      $columnTopicIds TEXT NOT NULL DEFAULT '[]',
      $columnVideoTimestamp TEXT,
      $columnPoints INTEGER NOT NULL DEFAULT 1
    )
  ''';

  // Indexes for efficient querying
  static const String createDifficultyIndex = '''
    CREATE INDEX idx_questions_difficulty ON $tableName($columnDifficulty)
  ''';

  static const String createTopicIdsIndex = '''
    CREATE INDEX idx_questions_topic_ids ON $tableName($columnTopicIds)
  ''';
}

/// Quizzes Offline Table
class QuizzesOfflineTable {
  static const String tableName = DatabaseTables.quizzesOffline;

  // Column names
  static const String columnId = 'id';
  static const String columnLevel = 'level';
  static const String columnEntityId = 'entity_id';
  static const String columnQuestionIds = 'question_ids';
  static const String columnTimeLimit = 'time_limit';
  static const String columnPassingScore = 'passing_score';
  static const String columnTitle = 'title';
  static const String columnConfig = 'config';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnLevel TEXT NOT NULL,
      $columnEntityId TEXT NOT NULL,
      $columnQuestionIds TEXT NOT NULL,
      $columnTimeLimit INTEGER NOT NULL,
      $columnPassingScore REAL NOT NULL DEFAULT 0.75,
      $columnTitle TEXT,
      $columnConfig TEXT
    )
  ''';

  // Indexes for efficient querying
  static const String createEntityIdIndex = '''
    CREATE INDEX idx_quizzes_entity_id ON $tableName($columnEntityId)
  ''';

  static const String createLevelIndex = '''
    CREATE INDEX idx_quizzes_level ON $tableName($columnLevel)
  ''';
}

/// Quiz Sessions Table
class QuizSessionsTable {
  static const String tableName = DatabaseTables.quizSessions;

  // Column names
  static const String columnId = 'id';
  static const String columnQuizId = 'quiz_id';
  static const String columnStudentId = 'student_id';
  static const String columnStartTime = 'start_time';
  static const String columnState = 'state';
  static const String columnCurrentQuestionIndex = 'current_question_index';
  static const String columnAnswers = 'answers';
  static const String columnSelectedQuestionIds = 'selected_question_ids';
  static const String columnEndTime = 'end_time';
  static const String columnAssessmentType = 'assessment_type';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnQuizId TEXT NOT NULL,
      $columnStudentId TEXT NOT NULL,
      $columnStartTime INTEGER NOT NULL,
      $columnState TEXT NOT NULL,
      $columnCurrentQuestionIndex INTEGER NOT NULL DEFAULT 0,
      $columnAnswers TEXT NOT NULL DEFAULT '{}',
      $columnSelectedQuestionIds TEXT NOT NULL DEFAULT '[]',
      $columnEndTime INTEGER,
      $columnAssessmentType TEXT NOT NULL DEFAULT 'practice'
    )
  ''';

  // Indexes for efficient querying
  static const String createStudentIdIndex = '''
    CREATE INDEX idx_quiz_sessions_student_id ON $tableName($columnStudentId)
  ''';

  static const String createQuizIdIndex = '''
    CREATE INDEX idx_quiz_sessions_quiz_id ON $tableName($columnQuizId)
  ''';

  static const String createStartTimeIndex = '''
    CREATE INDEX idx_quiz_sessions_start_time ON $tableName($columnStartTime DESC)
  ''';
}

/// Quiz Attempts Table (Phase 4: Quiz History and Statistics)
class QuizAttemptsTable {
  static const String tableName = DatabaseTables.quizAttempts;

  // Column names
  static const String columnId = 'id';
  static const String columnQuizId = 'quiz_id';
  static const String columnStudentId = 'student_id';
  static const String columnAnswers = 'answers';
  static const String columnScore = 'score';
  static const String columnPassed = 'passed';
  static const String columnCompletedAt = 'completed_at';
  static const String columnTimeTaken = 'time_taken';
  static const String columnStartTime = 'start_time';
  static const String columnAttemptNumber = 'attempt_number';
  static const String columnSyncedToServer = 'synced_to_server';
  static const String columnSyncRetryCount = 'sync_retry_count';
  static const String columnAnalytics = 'analytics';
  static const String columnSubjectId = 'subject_id';
  static const String columnSubjectName = 'subject_name';
  static const String columnChapterId = 'chapter_id';
  static const String columnChapterName = 'chapter_name';
  static const String columnTopicId = 'topic_id';
  static const String columnTopicName = 'topic_name';
  static const String columnVideoTitle = 'video_title';
  static const String columnQuizLevel = 'quiz_level';
  static const String columnTotalQuestions = 'total_questions';
  static const String columnCorrectAnswers = 'correct_answers';
  static const String columnQuestionsData = 'questions_data';
  static const String columnStatus = 'status';
  // NEW: Recommendation metadata (v11)
  static const String columnAssessmentType = 'assessment_type';
  static const String columnHasRecommendations = 'has_recommendations';
  static const String columnRecommendationCount = 'recommendation_count';
  static const String columnRecommendationsGeneratedAt =
      'recommendations_generated_at';
  static const String columnRecommendationStatus = 'recommendation_status';
  static const String columnRecommendationsHistoryId =
      'recommendations_history_id';
  static const String columnLearningPathId = 'learning_path_id';
  static const String columnLearningPathProgress = 'learning_path_progress';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnQuizId TEXT NOT NULL,
      $columnStudentId TEXT NOT NULL,
      $columnAnswers TEXT NOT NULL,
      $columnScore REAL NOT NULL,
      $columnPassed INTEGER NOT NULL,
      $columnCompletedAt INTEGER NOT NULL,
      $columnTimeTaken INTEGER NOT NULL,
      $columnStartTime INTEGER,
      $columnAttemptNumber INTEGER NOT NULL DEFAULT 1,
      $columnSyncedToServer INTEGER NOT NULL DEFAULT 0,
      $columnSyncRetryCount INTEGER NOT NULL DEFAULT 0,
      $columnAnalytics TEXT,
      $columnSubjectId TEXT,
      $columnSubjectName TEXT,
      $columnChapterId TEXT,
      $columnChapterName TEXT,
      $columnTopicId TEXT,
      $columnTopicName TEXT,
      $columnVideoTitle TEXT,
      $columnQuizLevel TEXT,
      $columnTotalQuestions INTEGER,
      $columnCorrectAnswers INTEGER,
      $columnQuestionsData TEXT,
      $columnStatus TEXT NOT NULL DEFAULT 'completed',
      $columnAssessmentType TEXT NOT NULL DEFAULT 'practice',
      $columnHasRecommendations INTEGER NOT NULL DEFAULT 0,
      $columnRecommendationCount INTEGER,
      $columnRecommendationsGeneratedAt INTEGER,
      $columnRecommendationStatus TEXT NOT NULL DEFAULT 'none',
      $columnRecommendationsHistoryId TEXT,
      $columnLearningPathId TEXT,
      $columnLearningPathProgress REAL
    )
  ''';

  // Indexes for efficient querying (critical for Phase 4 performance)
  static const String createStudentIdIndex = '''
    CREATE INDEX idx_quiz_attempts_student_id ON $tableName($columnStudentId)
  ''';

  static const String createQuizIdIndex = '''
    CREATE INDEX idx_quiz_attempts_quiz_id ON $tableName($columnQuizId)
  ''';

  static const String createCompletedAtIndex = '''
    CREATE INDEX idx_quiz_attempts_completed_at ON $tableName($columnCompletedAt DESC)
  ''';

  static const String createSubjectIdIndex = '''
    CREATE INDEX idx_quiz_attempts_subject_id ON $tableName($columnSubjectId)
  ''';

  static const String createPassedIndex = '''
    CREATE INDEX idx_quiz_attempts_passed ON $tableName($columnPassed)
  ''';

  static const String createScoreIndex = '''
    CREATE INDEX idx_quiz_attempts_score ON $tableName($columnScore DESC)
  ''';

  // Composite index for common filter combinations
  static const String createStudentCompletedIndex = '''
    CREATE INDEX idx_quiz_attempts_student_completed
    ON $tableName($columnStudentId, $columnCompletedAt DESC)
  ''';

  static const String createStudentSubjectIndex = '''
    CREATE INDEX idx_quiz_attempts_student_subject
    ON $tableName($columnStudentId, $columnSubjectId, $columnCompletedAt DESC)
  ''';

  // NEW v11: Indexes for recommendation filtering
  static const String createAssessmentTypeIndex = '''
    CREATE INDEX idx_quiz_attempts_assessment_type ON $tableName($columnAssessmentType)
  ''';

  static const String createHasRecommendationsIndex = '''
    CREATE INDEX idx_quiz_attempts_has_recommendations ON $tableName($columnHasRecommendations)
  ''';

  static const String createRecommendationStatusIndex = '''
    CREATE INDEX idx_quiz_attempts_recommendation_status ON $tableName($columnRecommendationStatus)
  ''';

  // Composite index for filtering by student + assessment type + recommendations
  static const String createStudentAssessmentRecommendationsIndex = '''
    CREATE INDEX idx_quiz_attempts_student_assessment_rec
    ON $tableName($columnStudentId, $columnAssessmentType, $columnHasRecommendations, $columnCompletedAt DESC)
  ''';
}

/// Recommendations History Table (v11: Persistent Recommendations)
class RecommendationsHistoryTable {
  static const String tableName = DatabaseTables.recommendationsHistory;

  // Column names
  static const String columnId = 'id';
  static const String columnQuizAttemptId = 'quiz_attempt_id';
  static const String columnUserId = 'user_id';
  static const String columnSubjectId = 'subject_id';
  static const String columnTopicId = 'topic_id';
  static const String columnAssessmentType = 'assessment_type';
  static const String columnRecommendationsJson = 'recommendations_json';
  static const String columnTotalRecommendations = 'total_recommendations';
  static const String columnCriticalGaps = 'critical_gaps';
  static const String columnSevereGaps = 'severe_gaps';
  static const String columnEstimatedMinutes = 'estimated_minutes';
  static const String columnGeneratedAt = 'generated_at';
  static const String columnViewedAt = 'viewed_at';
  static const String columnLastAccessedAt = 'last_accessed_at';
  static const String columnViewCount = 'view_count';
  static const String columnLearningPathId = 'learning_path_id';
  static const String columnLearningPathStarted = 'learning_path_started';
  static const String columnLearningPathStartedAt = 'learning_path_started_at';
  static const String columnLearningPathCompleted = 'learning_path_completed';
  static const String columnLearningPathCompletedAt =
      'learning_path_completed_at';
  static const String columnViewedVideoIds = 'viewed_video_ids';
  static const String columnDismissedRecommendationIds =
      'dismissed_recommendation_ids';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnQuizAttemptId TEXT NOT NULL,
      $columnUserId TEXT NOT NULL,
      $columnSubjectId TEXT NOT NULL,
      $columnTopicId TEXT,
      $columnAssessmentType TEXT NOT NULL,
      $columnRecommendationsJson TEXT NOT NULL,
      $columnTotalRecommendations INTEGER NOT NULL,
      $columnCriticalGaps INTEGER NOT NULL,
      $columnSevereGaps INTEGER NOT NULL,
      $columnEstimatedMinutes INTEGER NOT NULL,
      $columnGeneratedAt INTEGER NOT NULL,
      $columnViewedAt INTEGER,
      $columnLastAccessedAt INTEGER,
      $columnViewCount INTEGER DEFAULT 0,
      $columnLearningPathId TEXT,
      $columnLearningPathStarted INTEGER DEFAULT 0,
      $columnLearningPathStartedAt INTEGER,
      $columnLearningPathCompleted INTEGER DEFAULT 0,
      $columnLearningPathCompletedAt INTEGER,
      $columnViewedVideoIds TEXT,
      $columnDismissedRecommendationIds TEXT,
      FOREIGN KEY ($columnQuizAttemptId) REFERENCES ${DatabaseTables.quizAttempts}(${QuizAttemptsTable.columnId})
    )
  ''';

  // Indexes for efficient querying
  static const String createQuizAttemptIndex = '''
    CREATE INDEX idx_recommendations_quiz_attempt
    ON $tableName($columnQuizAttemptId)
  ''';

  static const String createUserIdIndex = '''
    CREATE INDEX idx_recommendations_user
    ON $tableName($columnUserId)
  ''';

  static const String createAssessmentTypeIndex = '''
    CREATE INDEX idx_recommendations_assessment_type
    ON $tableName($columnAssessmentType)
  ''';

  static const String createGeneratedAtIndex = '''
    CREATE INDEX idx_recommendations_generated_at
    ON $tableName($columnGeneratedAt DESC)
  ''';

  // Composite index for common queries
  static const String createUserAssessmentIndex = '''
    CREATE INDEX idx_recommendations_user_assessment
    ON $tableName($columnUserId, $columnAssessmentType, $columnGeneratedAt DESC)
  ''';
}

/// Concept Mastery Table (Pedagogy System)
class ConceptMasteryTable {
  static const String tableName = DatabaseTables.conceptMastery;

  // Column names
  static const String columnId = 'id';
  static const String columnConceptId = 'concept_id';
  static const String columnStudentId = 'student_id';
  static const String columnMasteryScore = 'mastery_score';
  static const String columnLevel = 'level';
  static const String columnLastAssessed = 'last_assessed';
  static const String columnTotalAttempts = 'total_attempts';
  static const String columnIsGap = 'is_gap';
  static const String columnNextReviewDate = 'next_review_date';
  static const String columnReviewStreak = 'review_streak';
  static const String columnPreQuizScore = 'pre_quiz_score';
  static const String columnCheckpointScore = 'checkpoint_score';
  static const String columnPostQuizScore = 'post_quiz_score';
  static const String columnPracticeScore = 'practice_score';
  static const String columnSpacedRepScore = 'spaced_rep_score';
  static const String columnGradeLevel = 'grade_level';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnConceptId TEXT NOT NULL,
      $columnStudentId TEXT NOT NULL,
      $columnMasteryScore REAL NOT NULL DEFAULT 0,
      $columnLevel TEXT NOT NULL DEFAULT 'notLearned',
      $columnLastAssessed INTEGER NOT NULL,
      $columnTotalAttempts INTEGER NOT NULL DEFAULT 0,
      $columnIsGap INTEGER NOT NULL DEFAULT 0,
      $columnNextReviewDate INTEGER,
      $columnReviewStreak INTEGER NOT NULL DEFAULT 0,
      $columnPreQuizScore REAL,
      $columnCheckpointScore REAL,
      $columnPostQuizScore REAL,
      $columnPracticeScore REAL,
      $columnSpacedRepScore REAL,
      $columnGradeLevel INTEGER,
      UNIQUE($columnConceptId, $columnStudentId)
    )
  ''';

  // Indexes
  static const String createStudentIdIndex = '''
    CREATE INDEX idx_concept_mastery_student_id ON $tableName($columnStudentId)
  ''';

  static const String createConceptIdIndex = '''
    CREATE INDEX idx_concept_mastery_concept_id ON $tableName($columnConceptId)
  ''';

  static const String createIsGapIndex = '''
    CREATE INDEX idx_concept_mastery_is_gap ON $tableName($columnIsGap)
  ''';

  static const String createNextReviewIndex = '''
    CREATE INDEX idx_concept_mastery_next_review ON $tableName($columnNextReviewDate)
  ''';
}

/// Spaced Repetition Table (SM-2 Algorithm)
class SpacedRepetitionTable {
  static const String tableName = DatabaseTables.spacedRepetition;

  // Column names
  static const String columnId = 'id';
  static const String columnConceptId = 'concept_id';
  static const String columnStudentId = 'student_id';
  static const String columnIntervalDays = 'interval_days';
  static const String columnEaseFactor = 'ease_factor';
  static const String columnConsecutiveCorrect = 'consecutive_correct';
  static const String columnNextReviewDate = 'next_review_date';
  static const String columnLastReviewDate = 'last_review_date';
  static const String columnTotalReviews = 'total_reviews';
  static const String columnCorrectReviews = 'correct_reviews';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnConceptId TEXT NOT NULL,
      $columnStudentId TEXT NOT NULL,
      $columnIntervalDays INTEGER NOT NULL DEFAULT 1,
      $columnEaseFactor REAL NOT NULL DEFAULT 2.5,
      $columnConsecutiveCorrect INTEGER NOT NULL DEFAULT 0,
      $columnNextReviewDate INTEGER NOT NULL,
      $columnLastReviewDate INTEGER,
      $columnTotalReviews INTEGER NOT NULL DEFAULT 0,
      $columnCorrectReviews INTEGER NOT NULL DEFAULT 0,
      UNIQUE($columnConceptId, $columnStudentId)
    )
  ''';

  // Indexes
  static const String createStudentIdIndex = '''
    CREATE INDEX idx_spaced_rep_student_id ON $tableName($columnStudentId)
  ''';

  static const String createNextReviewIndex = '''
    CREATE INDEX idx_spaced_rep_next_review ON $tableName($columnNextReviewDate)
  ''';

  static const String createStudentNextReviewIndex = '''
    CREATE INDEX idx_spaced_rep_student_next_review
    ON $tableName($columnStudentId, $columnNextReviewDate)
  ''';
}

/// Learning Paths Table
class LearningPathsTable {
  static const String tableName = DatabaseTables.learningPaths;

  // Column names
  static const String columnId = 'id';
  static const String columnStudentId = 'student_id';
  static const String columnSubjectId = 'subject_id';
  static const String columnTargetConceptId = 'target_concept_id';
  static const String columnNodes = 'nodes';
  static const String columnCurrentNodeIndex = 'current_node_index';
  static const String columnCompletedNodeIds = 'completed_node_ids';
  static const String columnStatus = 'status';
  static const String columnCreatedAt = 'created_at';
  static const String columnLastUpdated = 'last_updated';
  static const String columnCompletedAt = 'completed_at';
  static const String columnMetadata = 'metadata';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnStudentId TEXT NOT NULL,
      $columnSubjectId TEXT NOT NULL,
      $columnTargetConceptId TEXT,
      $columnNodes TEXT NOT NULL,
      $columnCurrentNodeIndex INTEGER NOT NULL DEFAULT 0,
      $columnCompletedNodeIds TEXT NOT NULL DEFAULT '[]',
      $columnStatus TEXT NOT NULL DEFAULT 'active',
      $columnCreatedAt INTEGER NOT NULL,
      $columnLastUpdated INTEGER NOT NULL,
      $columnCompletedAt INTEGER,
      $columnMetadata TEXT
    )
  ''';

  // Indexes
  static const String createStudentIdIndex = '''
    CREATE INDEX idx_learning_paths_student_id ON $tableName($columnStudentId)
  ''';

  static const String createStatusIndex = '''
    CREATE INDEX idx_learning_paths_status ON $tableName($columnStatus)
  ''';
}

/// Gamification Table (XP, Levels, Streaks)
class GamificationTable {
  static const String tableName = DatabaseTables.gamification;

  // Column names
  static const String columnId = 'id';
  static const String columnStudentId = 'student_id';
  static const String columnTotalXp = 'total_xp';
  static const String columnLevel = 'level';
  static const String columnCurrentStreak = 'current_streak';
  static const String columnLongestStreak = 'longest_streak';
  static const String columnLastActiveDate = 'last_active_date';
  static const String columnUnlockedBadgeIds = 'unlocked_badge_ids';
  static const String columnUpdatedAt = 'updated_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnStudentId TEXT NOT NULL UNIQUE,
      $columnTotalXp INTEGER NOT NULL DEFAULT 0,
      $columnLevel INTEGER NOT NULL DEFAULT 1,
      $columnCurrentStreak INTEGER NOT NULL DEFAULT 0,
      $columnLongestStreak INTEGER NOT NULL DEFAULT 0,
      $columnLastActiveDate INTEGER,
      $columnUnlockedBadgeIds TEXT NOT NULL DEFAULT '[]',
      $columnUpdatedAt INTEGER NOT NULL
    )
  ''';

  // Indexes
  static const String createStudentIdIndex = '''
    CREATE INDEX idx_gamification_student_id ON $tableName($columnStudentId)
  ''';

  static const String createLevelIndex = '''
    CREATE INDEX idx_gamification_level ON $tableName($columnLevel)
  ''';
}

/// XP Events Table (Audit log of XP awards)
class XpEventsTable {
  static const String tableName = DatabaseTables.xpEvents;

  // Column names
  static const String columnId = 'id';
  static const String columnStudentId = 'student_id';
  static const String columnEventType = 'event_type';
  static const String columnXpAwarded = 'xp_awarded';
  static const String columnEntityId = 'entity_id';
  static const String columnEntityType = 'entity_type';
  static const String columnTimestamp = 'timestamp';
  static const String columnMetadata = 'metadata';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnStudentId TEXT NOT NULL,
      $columnEventType TEXT NOT NULL,
      $columnXpAwarded INTEGER NOT NULL,
      $columnEntityId TEXT,
      $columnEntityType TEXT,
      $columnTimestamp INTEGER NOT NULL,
      $columnMetadata TEXT
    )
  ''';

  // Indexes
  static const String createStudentIdIndex = '''
    CREATE INDEX idx_xp_events_student_id ON $tableName($columnStudentId)
  ''';

  static const String createTimestampIndex = '''
    CREATE INDEX idx_xp_events_timestamp ON $tableName($columnTimestamp DESC)
  ''';

  static const String createEventTypeIndex = '''
    CREATE INDEX idx_xp_events_event_type ON $tableName($columnEventType)
  ''';
}

/// Badges Table
class BadgesTable {
  static const String tableName = DatabaseTables.badges;

  // Column names
  static const String columnId = 'id';
  static const String columnStudentId = 'student_id';
  static const String columnBadgeId = 'badge_id';
  static const String columnUnlockedAt = 'unlocked_at';
  static const String columnProgress = 'progress';
  static const String columnIsUnlocked = 'is_unlocked';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnStudentId TEXT NOT NULL,
      $columnBadgeId TEXT NOT NULL,
      $columnUnlockedAt INTEGER,
      $columnProgress REAL NOT NULL DEFAULT 0,
      $columnIsUnlocked INTEGER NOT NULL DEFAULT 0,
      UNIQUE($columnStudentId, $columnBadgeId)
    )
  ''';

  // Indexes
  static const String createStudentIdIndex = '''
    CREATE INDEX idx_badges_student_id ON $tableName($columnStudentId)
  ''';

  static const String createUnlockedIndex = '''
    CREATE INDEX idx_badges_unlocked ON $tableName($columnIsUnlocked)
  ''';
}

/// Video Learning Sessions Table
class VideoLearningSessionsTable {
  static const String tableName = DatabaseTables.videoLearningSessions;

  // Column names
  static const String columnId = 'id';
  static const String columnStudentId = 'student_id';
  static const String columnVideoId = 'video_id';
  static const String columnConceptId = 'concept_id';
  static const String columnPreQuizCompleted = 'pre_quiz_completed';
  static const String columnPreQuizScore = 'pre_quiz_score';
  static const String columnPreQuizGaps = 'pre_quiz_gaps';
  static const String columnCheckpoints = 'checkpoints';
  static const String columnCurrentCheckpointIndex = 'current_checkpoint_index';
  static const String columnCheckpointsCorrect = 'checkpoints_correct';
  static const String columnCheckpointsAttempted = 'checkpoints_attempted';
  static const String columnWatchDurationSeconds = 'watch_duration_seconds';
  static const String columnVideoCompleted = 'video_completed';
  static const String columnPostQuizCompleted = 'post_quiz_completed';
  static const String columnPostQuizScore = 'post_quiz_score';
  static const String columnStartedAt = 'started_at';
  static const String columnCompletedAt = 'completed_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnStudentId TEXT NOT NULL,
      $columnVideoId TEXT NOT NULL,
      $columnConceptId TEXT NOT NULL,
      $columnPreQuizCompleted INTEGER NOT NULL DEFAULT 0,
      $columnPreQuizScore REAL,
      $columnPreQuizGaps TEXT NOT NULL DEFAULT '[]',
      $columnCheckpoints TEXT NOT NULL DEFAULT '[]',
      $columnCurrentCheckpointIndex INTEGER NOT NULL DEFAULT 0,
      $columnCheckpointsCorrect INTEGER NOT NULL DEFAULT 0,
      $columnCheckpointsAttempted INTEGER NOT NULL DEFAULT 0,
      $columnWatchDurationSeconds INTEGER NOT NULL DEFAULT 0,
      $columnVideoCompleted INTEGER NOT NULL DEFAULT 0,
      $columnPostQuizCompleted INTEGER NOT NULL DEFAULT 0,
      $columnPostQuizScore REAL,
      $columnStartedAt INTEGER NOT NULL,
      $columnCompletedAt INTEGER
    )
  ''';

  // Indexes
  static const String createStudentIdIndex = '''
    CREATE INDEX idx_video_sessions_student_id ON $tableName($columnStudentId)
  ''';

  static const String createVideoIdIndex = '''
    CREATE INDEX idx_video_sessions_video_id ON $tableName($columnVideoId)
  ''';

  static const String createStartedAtIndex = '''
    CREATE INDEX idx_video_sessions_started_at ON $tableName($columnStartedAt DESC)
  ''';
}

/// Pre-Assessments Table
class PreAssessmentsTable {
  static const String tableName = DatabaseTables.preAssessments;

  // Column names
  static const String columnId = 'id';
  static const String columnStudentId = 'student_id';
  static const String columnSubjectId = 'subject_id';
  static const String columnTargetGrade = 'target_grade';
  static const String columnCurrentPhase = 'current_phase';
  static const String columnQuestionIds = 'question_ids';
  static const String columnAnswers = 'answers';
  static const String columnCurrentQuestionIndex = 'current_question_index';
  static const String columnStartedAt = 'started_at';
  static const String columnCompletedAt = 'completed_at';
  static const String columnResult = 'result';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnStudentId TEXT NOT NULL,
      $columnSubjectId TEXT NOT NULL,
      $columnTargetGrade INTEGER NOT NULL,
      $columnCurrentPhase TEXT NOT NULL DEFAULT 'quickScreening',
      $columnQuestionIds TEXT NOT NULL DEFAULT '[]',
      $columnAnswers TEXT NOT NULL DEFAULT '{}',
      $columnCurrentQuestionIndex INTEGER NOT NULL DEFAULT 0,
      $columnStartedAt INTEGER NOT NULL,
      $columnCompletedAt INTEGER,
      $columnResult TEXT
    )
  ''';

  // Indexes
  static const String createStudentIdIndex = '''
    CREATE INDEX idx_pre_assessments_student_id ON $tableName($columnStudentId)
  ''';

  static const String createSubjectIdIndex = '''
    CREATE INDEX idx_pre_assessments_subject_id ON $tableName($columnSubjectId)
  ''';
}

/// Chapter Assessments Table
class ChapterAssessmentsTable {
  static const String tableName = DatabaseTables.chapterAssessments;

  // Column names
  static const String columnId = 'id';
  static const String columnStudentId = 'student_id';
  static const String columnChapterId = 'chapter_id';
  static const String columnChapterName = 'chapter_name';
  static const String columnSubjectId = 'subject_id';
  static const String columnGradeLevel = 'grade_level';
  static const String columnQuestionIds = 'question_ids';
  static const String columnAnswers = 'answers';
  static const String columnCurrentQuestionIndex = 'current_question_index';
  static const String columnStartedAt = 'started_at';
  static const String columnCompletedAt = 'completed_at';
  static const String columnResult = 'result';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnStudentId TEXT NOT NULL,
      $columnChapterId TEXT NOT NULL,
      $columnChapterName TEXT NOT NULL,
      $columnSubjectId TEXT NOT NULL,
      $columnGradeLevel INTEGER NOT NULL,
      $columnQuestionIds TEXT NOT NULL DEFAULT '[]',
      $columnAnswers TEXT NOT NULL DEFAULT '{}',
      $columnCurrentQuestionIndex INTEGER NOT NULL DEFAULT 0,
      $columnStartedAt INTEGER NOT NULL,
      $columnCompletedAt INTEGER,
      $columnResult TEXT
    )
  ''';

  // Indexes
  static const String createStudentIdIndex = '''
    CREATE INDEX idx_chapter_assessments_student_id ON $tableName($columnStudentId)
  ''';

  static const String createChapterIdIndex = '''
    CREATE INDEX idx_chapter_assessments_chapter_id ON $tableName($columnChapterId)
  ''';

  static const String createSubjectIdIndex = '''
    CREATE INDEX idx_chapter_assessments_subject_id ON $tableName($columnSubjectId)
  ''';
}

// ==================== JUNIOR APP TABLES (v14) ====================

/// User Profile Junior Table (Junior app specific profile data)
class UserProfileJuniorTable {
  static const String tableName = DatabaseTables.userProfileJunior;

  // Column names
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnGrade = 'grade';
  static const String columnAvatarConfig = 'avatar_config';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnName TEXT,
      $columnGrade INTEGER NOT NULL,
      $columnAvatarConfig TEXT,
      $columnCreatedAt INTEGER NOT NULL,
      $columnUpdatedAt INTEGER NOT NULL
    )
  ''';

  // Indexes
  static const String createGradeIndex = '''
    CREATE INDEX idx_user_profile_junior_grade ON $tableName($columnGrade)
  ''';
}

/// Parental Controls Table (PIN, time limits, content restrictions)
class ParentalControlsTable {
  static const String tableName = DatabaseTables.parentalControls;

  // Column names
  static const String columnId = 'id';
  static const String columnUserId = 'user_id';
  static const String columnPinHash = 'pin_hash';
  static const String columnDailyLimitMinutes = 'daily_limit_minutes';
  static const String columnDifficultyFilter = 'difficulty_filter';
  static const String columnHiddenSubjects = 'hidden_subjects';
  static const String columnShowTimeToChild = 'show_time_to_child';
  static const String columnWeeklyReportEmail = 'weekly_report_email';
  static const String columnIsEnabled = 'is_enabled';
  static const String columnPinChangedAt = 'pin_changed_at';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnUserId TEXT NOT NULL UNIQUE,
      $columnPinHash TEXT,
      $columnDailyLimitMinutes INTEGER DEFAULT 0,
      $columnDifficultyFilter TEXT NOT NULL DEFAULT 'all',
      $columnHiddenSubjects TEXT NOT NULL DEFAULT '[]',
      $columnShowTimeToChild INTEGER NOT NULL DEFAULT 1,
      $columnWeeklyReportEmail TEXT,
      $columnIsEnabled INTEGER NOT NULL DEFAULT 0,
      $columnPinChangedAt INTEGER,
      $columnCreatedAt INTEGER NOT NULL,
      $columnUpdatedAt INTEGER NOT NULL,
      FOREIGN KEY ($columnUserId) REFERENCES ${UserProfileJuniorTable.tableName}(${UserProfileJuniorTable.columnId})
    )
  ''';

  // Indexes
  static const String createUserIdIndex = '''
    CREATE INDEX idx_parental_controls_user_id ON $tableName($columnUserId)
  ''';

  static const String createEnabledIndex = '''
    CREATE INDEX idx_parental_controls_enabled ON $tableName($columnIsEnabled)
  ''';
}

/// Screen Time Log Table (Daily usage tracking)
class ScreenTimeLogTable {
  static const String tableName = DatabaseTables.screenTimeLog;

  // Column names
  static const String columnId = 'id';
  static const String columnUserId = 'user_id';
  static const String columnDate = 'date';
  static const String columnMinutesUsed = 'minutes_used';
  static const String columnSessions = 'sessions';
  static const String columnLimitReached = 'limit_reached';
  static const String columnWasExtended = 'was_extended';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnUserId TEXT NOT NULL,
      $columnDate TEXT NOT NULL,
      $columnMinutesUsed INTEGER NOT NULL DEFAULT 0,
      $columnSessions TEXT NOT NULL DEFAULT '[]',
      $columnLimitReached INTEGER NOT NULL DEFAULT 0,
      $columnWasExtended INTEGER NOT NULL DEFAULT 0,
      $columnCreatedAt INTEGER NOT NULL,
      $columnUpdatedAt INTEGER NOT NULL,
      UNIQUE($columnUserId, $columnDate),
      FOREIGN KEY ($columnUserId) REFERENCES ${UserProfileJuniorTable.tableName}(${UserProfileJuniorTable.columnId})
    )
  ''';

  // Indexes
  static const String createUserIdIndex = '''
    CREATE INDEX idx_screen_time_log_user_id ON $tableName($columnUserId)
  ''';

  static const String createDateIndex = '''
    CREATE INDEX idx_screen_time_log_date ON $tableName($columnDate DESC)
  ''';

  static const String createUserDateIndex = '''
    CREATE INDEX idx_screen_time_log_user_date ON $tableName($columnUserId, $columnDate DESC)
  ''';
}

// ==================== STUDY TOOLS TABLES (v17) ====================

/// Video Summaries Table
class VideoSummariesTable {
  static const String tableName = DatabaseTables.videoSummaries;

  // Column names
  static const String columnId = 'id';
  static const String columnVideoId = 'video_id';
  static const String columnContent = 'content';
  static const String columnKeyPoints = 'key_points';
  static const String columnSource = 'source';
  static const String columnSegment = 'segment';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnVideoId TEXT NOT NULL,
      $columnContent TEXT NOT NULL,
      $columnKeyPoints TEXT NOT NULL DEFAULT '[]',
      $columnSource TEXT NOT NULL DEFAULT 'manual',
      $columnSegment TEXT NOT NULL,
      $columnCreatedAt INTEGER NOT NULL,
      $columnUpdatedAt INTEGER NOT NULL,
      UNIQUE($columnVideoId, $columnSegment)
    )
  ''';

  // Indexes
  static const String createVideoIdIndex = '''
    CREATE INDEX idx_video_summaries_video_id ON $tableName($columnVideoId)
  ''';

  static const String createSegmentIndex = '''
    CREATE INDEX idx_video_summaries_segment ON $tableName($columnSegment)
  ''';
}

/// Glossary Terms Table
class GlossaryTermsTable {
  static const String tableName = DatabaseTables.glossaryTerms;

  // Column names
  static const String columnId = 'id';
  static const String columnTerm = 'term';
  static const String columnDefinition = 'definition';
  static const String columnPronunciation = 'pronunciation';
  static const String columnExampleUsage = 'example_usage';
  static const String columnChapterId = 'chapter_id';
  static const String columnSegment = 'segment';
  static const String columnDifficulty = 'difficulty';
  static const String columnImageUrl = 'image_url';
  static const String columnAudioUrl = 'audio_url';
  static const String columnCreatedAt = 'created_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnTerm TEXT NOT NULL,
      $columnDefinition TEXT NOT NULL,
      $columnPronunciation TEXT,
      $columnExampleUsage TEXT,
      $columnChapterId TEXT NOT NULL,
      $columnSegment TEXT NOT NULL,
      $columnDifficulty TEXT NOT NULL DEFAULT 'medium',
      $columnImageUrl TEXT,
      $columnAudioUrl TEXT,
      $columnCreatedAt INTEGER NOT NULL
    )
  ''';

  // Indexes
  static const String createChapterIdIndex = '''
    CREATE INDEX idx_glossary_terms_chapter_id ON $tableName($columnChapterId)
  ''';

  static const String createSegmentIndex = '''
    CREATE INDEX idx_glossary_terms_segment ON $tableName($columnSegment)
  ''';

  static const String createTermIndex = '''
    CREATE INDEX idx_glossary_terms_term ON $tableName($columnTerm)
  ''';
}

/// Video Q&A Table
class VideoQATable {
  static const String tableName = DatabaseTables.videoQA;

  // Column names
  static const String columnId = 'id';
  static const String columnVideoId = 'video_id';
  static const String columnProfileId = 'profile_id';
  static const String columnQuestion = 'question';
  static const String columnAnswer = 'answer';
  static const String columnStatus = 'status';
  static const String columnTimestampSeconds = 'timestamp_seconds';
  static const String columnUpvotes = 'upvotes';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnVideoId TEXT NOT NULL,
      $columnProfileId TEXT NOT NULL DEFAULT '',
      $columnQuestion TEXT NOT NULL,
      $columnAnswer TEXT,
      $columnStatus TEXT NOT NULL DEFAULT 'pending',
      $columnTimestampSeconds INTEGER,
      $columnUpvotes INTEGER NOT NULL DEFAULT 0,
      $columnCreatedAt INTEGER NOT NULL,
      $columnUpdatedAt INTEGER NOT NULL
    )
  ''';

  // Indexes
  static const String createVideoIdIndex = '''
    CREATE INDEX idx_video_qa_video_id ON $tableName($columnVideoId)
  ''';

  static const String createProfileIdIndex = '''
    CREATE INDEX idx_video_qa_profile_id ON $tableName($columnProfileId)
  ''';

  static const String createStatusIndex = '''
    CREATE INDEX idx_video_qa_status ON $tableName($columnStatus)
  ''';
}

/// Mind Map Nodes Table
class MindMapNodesTable {
  static const String tableName = DatabaseTables.mindMapNodes;

  // Column names
  static const String columnId = 'id';
  static const String columnChapterId = 'chapter_id';
  static const String columnLabel = 'label';
  static const String columnDescription = 'description';
  static const String columnParentId = 'parent_id';
  static const String columnPositionX = 'position_x';
  static const String columnPositionY = 'position_y';
  static const String columnColor = 'color';
  static const String columnSegment = 'segment';
  static const String columnOrderIndex = 'order_index';
  static const String columnCreatedAt = 'created_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnChapterId TEXT NOT NULL,
      $columnLabel TEXT NOT NULL,
      $columnDescription TEXT,
      $columnParentId TEXT,
      $columnPositionX REAL NOT NULL DEFAULT 0,
      $columnPositionY REAL NOT NULL DEFAULT 0,
      $columnColor TEXT,
      $columnSegment TEXT NOT NULL,
      $columnOrderIndex INTEGER NOT NULL DEFAULT 0,
      $columnCreatedAt INTEGER NOT NULL
    )
  ''';

  // Indexes
  static const String createChapterIdIndex = '''
    CREATE INDEX idx_mind_map_nodes_chapter_id ON $tableName($columnChapterId)
  ''';

  static const String createParentIdIndex = '''
    CREATE INDEX idx_mind_map_nodes_parent_id ON $tableName($columnParentId)
  ''';

  static const String createSegmentIndex = '''
    CREATE INDEX idx_mind_map_nodes_segment ON $tableName($columnSegment)
  ''';
}

/// Flashcard Decks Table
class FlashcardDecksTable {
  static const String tableName = DatabaseTables.flashcardDecks;

  // Column names
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnDescription = 'description';
  static const String columnTopicId = 'topic_id';
  static const String columnChapterId = 'chapter_id';
  static const String columnCardCount = 'card_count';
  static const String columnSegment = 'segment';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnDescription TEXT,
      $columnTopicId TEXT,
      $columnChapterId TEXT,
      $columnCardCount INTEGER NOT NULL DEFAULT 0,
      $columnSegment TEXT NOT NULL,
      $columnCreatedAt INTEGER NOT NULL,
      $columnUpdatedAt INTEGER NOT NULL
    )
  ''';

  // Indexes
  static const String createTopicIdIndex = '''
    CREATE INDEX idx_flashcard_decks_topic_id ON $tableName($columnTopicId)
  ''';

  static const String createChapterIdIndex = '''
    CREATE INDEX idx_flashcard_decks_chapter_id ON $tableName($columnChapterId)
  ''';

  static const String createSegmentIndex = '''
    CREATE INDEX idx_flashcard_decks_segment ON $tableName($columnSegment)
  ''';
}

/// Flashcards Table
class FlashcardsTable {
  static const String tableName = DatabaseTables.flashcards;

  // Column names
  static const String columnId = 'id';
  static const String columnDeckId = 'deck_id';
  static const String columnFront = 'front';
  static const String columnBack = 'back';
  static const String columnHint = 'hint';
  static const String columnImageUrl = 'image_url';
  static const String columnOrderIndex = 'order_index';
  static const String columnCreatedAt = 'created_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnDeckId TEXT NOT NULL,
      $columnFront TEXT NOT NULL,
      $columnBack TEXT NOT NULL,
      $columnHint TEXT,
      $columnImageUrl TEXT,
      $columnOrderIndex INTEGER NOT NULL DEFAULT 0,
      $columnCreatedAt INTEGER NOT NULL,
      FOREIGN KEY ($columnDeckId) REFERENCES ${FlashcardDecksTable.tableName}(${FlashcardDecksTable.columnId}) ON DELETE CASCADE
    )
  ''';

  // Indexes
  static const String createDeckIdIndex = '''
    CREATE INDEX idx_flashcards_deck_id ON $tableName($columnDeckId)
  ''';

  static const String createOrderIndex = '''
    CREATE INDEX idx_flashcards_order ON $tableName($columnDeckId, $columnOrderIndex)
  ''';
}

/// Flashcard Progress Table (Spaced Repetition)
class FlashcardProgressTable {
  static const String tableName = DatabaseTables.flashcardProgress;

  // Column names
  static const String columnId = 'id';
  static const String columnCardId = 'card_id';
  static const String columnProfileId = 'profile_id';
  static const String columnKnown = 'known';
  static const String columnEaseFactor = 'ease_factor';
  static const String columnIntervalDays = 'interval_days';
  static const String columnNextReviewDate = 'next_review_date';
  static const String columnReviewCount = 'review_count';
  static const String columnCorrectCount = 'correct_count';
  static const String columnLastReviewedAt = 'last_reviewed_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnCardId TEXT NOT NULL,
      $columnProfileId TEXT NOT NULL DEFAULT '',
      $columnKnown INTEGER NOT NULL DEFAULT 0,
      $columnEaseFactor REAL NOT NULL DEFAULT 2.5,
      $columnIntervalDays INTEGER NOT NULL DEFAULT 1,
      $columnNextReviewDate INTEGER,
      $columnReviewCount INTEGER NOT NULL DEFAULT 0,
      $columnCorrectCount INTEGER NOT NULL DEFAULT 0,
      $columnLastReviewedAt INTEGER,
      UNIQUE($columnCardId, $columnProfileId),
      FOREIGN KEY ($columnCardId) REFERENCES ${FlashcardsTable.tableName}(${FlashcardsTable.columnId}) ON DELETE CASCADE
    )
  ''';

  // Indexes
  static const String createCardIdIndex = '''
    CREATE INDEX idx_flashcard_progress_card_id ON $tableName($columnCardId)
  ''';

  static const String createProfileIdIndex = '''
    CREATE INDEX idx_flashcard_progress_profile_id ON $tableName($columnProfileId)
  ''';

  static const String createNextReviewIndex = '''
    CREATE INDEX idx_flashcard_progress_next_review ON $tableName($columnNextReviewDate)
  ''';

  static const String createProfileNextReviewIndex = '''
    CREATE INDEX idx_flashcard_progress_profile_next_review ON $tableName($columnProfileId, $columnNextReviewDate)
  ''';
}

// ==================== CHAPTER STUDY TOOLS TABLES (v18) ====================

/// Chapter Summaries Table
class ChapterSummariesTable {
  static const String tableName = DatabaseTables.chapterSummaries;

  // Column names
  static const String columnId = 'id';
  static const String columnChapterId = 'chapter_id';
  static const String columnSubjectId = 'subject_id';
  static const String columnTitle = 'title';
  static const String columnContent = 'content';
  static const String columnKeyPoints = 'key_points';
  static const String columnLearningObjectives = 'learning_objectives';
  static const String columnSource = 'source';
  static const String columnSegment = 'segment';
  static const String columnEstimatedReadTime = 'estimated_read_time';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnChapterId TEXT NOT NULL,
      $columnSubjectId TEXT NOT NULL,
      $columnTitle TEXT NOT NULL,
      $columnContent TEXT NOT NULL,
      $columnKeyPoints TEXT NOT NULL DEFAULT '[]',
      $columnLearningObjectives TEXT NOT NULL DEFAULT '[]',
      $columnSource TEXT NOT NULL DEFAULT 'manual',
      $columnSegment TEXT NOT NULL,
      $columnEstimatedReadTime INTEGER NOT NULL DEFAULT 0,
      $columnCreatedAt INTEGER NOT NULL,
      $columnUpdatedAt INTEGER NOT NULL,
      UNIQUE($columnChapterId, $columnSubjectId, $columnSegment)
    )
  ''';

  // Indexes
  static const String createChapterIdIndex = '''
    CREATE INDEX idx_chapter_summaries_chapter_id ON $tableName($columnChapterId)
  ''';

  static const String createSubjectIdIndex = '''
    CREATE INDEX idx_chapter_summaries_subject_id ON $tableName($columnSubjectId)
  ''';

  static const String createSegmentIndex = '''
    CREATE INDEX idx_chapter_summaries_segment ON $tableName($columnSegment)
  ''';
}

/// Chapter Notes Table (Curated + Personal Notes)
class ChapterNotesTable {
  static const String tableName = DatabaseTables.chapterNotes;

  // Column names
  static const String columnId = 'id';
  static const String columnChapterId = 'chapter_id';
  static const String columnProfileId = 'profile_id';
  static const String columnSubjectId = 'subject_id';
  static const String columnContent = 'content';
  static const String columnTitle = 'title';
  static const String columnTags = 'tags';
  static const String columnIsPinned = 'is_pinned';
  static const String columnNoteType = 'note_type';
  static const String columnSegment = 'segment';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnChapterId TEXT NOT NULL,
      $columnProfileId TEXT,
      $columnSubjectId TEXT,
      $columnContent TEXT NOT NULL,
      $columnTitle TEXT,
      $columnTags TEXT NOT NULL DEFAULT '[]',
      $columnIsPinned INTEGER NOT NULL DEFAULT 0,
      $columnNoteType TEXT NOT NULL DEFAULT 'personal',
      $columnSegment TEXT NOT NULL,
      $columnCreatedAt INTEGER NOT NULL,
      $columnUpdatedAt INTEGER NOT NULL
    )
  ''';

  // Indexes
  static const String createChapterIdIndex = '''
    CREATE INDEX idx_chapter_notes_chapter_id ON $tableName($columnChapterId)
  ''';

  static const String createProfileIdIndex = '''
    CREATE INDEX idx_chapter_notes_profile_id ON $tableName($columnProfileId)
  ''';

  static const String createNoteTypeIndex = '''
    CREATE INDEX idx_chapter_notes_note_type ON $tableName($columnNoteType)
  ''';

  static const String createSegmentIndex = '''
    CREATE INDEX idx_chapter_notes_segment ON $tableName($columnSegment)
  ''';

  static const String createChapterProfileIndex = '''
    CREATE INDEX idx_chapter_notes_chapter_profile ON $tableName($columnChapterId, $columnProfileId)
  ''';

  static const String createPinnedIndex = '''
    CREATE INDEX idx_chapter_notes_pinned ON $tableName($columnIsPinned)
  ''';
}
