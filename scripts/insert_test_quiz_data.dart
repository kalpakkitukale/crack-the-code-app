/// Script to insert test quiz data for testing recommendations navigation and filters
///
/// This script creates sample quiz attempts with different:
/// - Assessment types (readiness, knowledge, practice)
/// - Scores (high, medium, low)
/// - Recommendation statuses (none, available, viewed, inProgress, completed)
///
/// Run with: dart run scripts/insert_test_quiz_data.dart

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

Future<void> main() async {
  // Initialize FFI for desktop
  sqfliteFfiInit();

  print('🚀 Starting test data insertion...');
  print('');

  // Get database path
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String dbPath = join(appDocDir.path, 'crackthecode', 'crackthecode.db');

  print('📁 Database path: $dbPath');

  // Check if database exists
  if (!await File(dbPath).exists()) {
    print('❌ Database not found at $dbPath');
    print('   Please run the app first to create the database.');
    exit(1);
  }

  // Open database
  final db = await databaseFactoryFfi.openDatabase(dbPath);

  print('✅ Database opened successfully');
  print('');

  try {
    // Get current timestamp
    final now = DateTime.now().millisecondsSinceEpoch;

    // Student ID (using a test student)
    const studentId = 'test-student-001';

    // Subject IDs
    const physicsSubjectId = 'subject-physics-11';
    const chemistrySubjectId = 'subject-chemistry-11';
    const mathsSubjectId = 'subject-maths-11';

    print('📊 Inserting quiz attempts...');
    print('');

    // ========================================
    // 1. Readiness Check - Low Score - With Recommendations (Available)
    // ========================================
    final quiz1Id = _uuid.v4();
    final quiz1AttemptId = _uuid.v4();
    final rec1Id = _uuid.v4();

    await db.insert('quiz_attempts', {
      'id': quiz1AttemptId,
      'quiz_id': quiz1Id,
      'student_id': studentId,
      'answers': jsonEncode({}),
      'score': 0.45, // 45%
      'passed': 0,
      'completed_at': now - (3 * 24 * 60 * 60 * 1000), // 3 days ago
      'time_taken': 12 * 60 * 1000, // 12 minutes
      'start_time': now - (3 * 24 * 60 * 60 * 1000) - (12 * 60 * 1000),
      'attempt_number': 1,
      'synced_to_server': 0,
      'sync_retry_count': 0,
      'subject_id': physicsSubjectId,
      'subject_name': 'Physics',
      'chapter_id': 'chapter-mechanics',
      'chapter_name': 'Mechanics',
      'topic_id': 'topic-motion',
      'topic_name': 'Motion in a Straight Line',
      'quiz_level': 'chapter',
      'total_questions': 20,
      'correct_answers': 9,
      'status': 'completed',
      'assessment_type': 'readiness',
      'has_recommendations': 1,
      'recommendation_count': 5,
      'recommendations_generated_at': now - (3 * 24 * 60 * 60 * 1000),
      'recommendation_status': 'available',
      'recommendations_history_id': rec1Id,
    });

    // Insert recommendations history
    await db.insert('recommendations_history', {
      'id': rec1Id,
      'quiz_attempt_id': quiz1AttemptId,
      'user_id': studentId,
      'subject_id': physicsSubjectId,
      'topic_id': 'topic-motion',
      'assessment_type': 'readiness',
      'recommendations_json': jsonEncode([
        {
          'conceptId': 'concept-displacement',
          'conceptName': 'Displacement and Distance',
          'severity': 'critical',
          'masteryScore': 0.35,
          'priorityScore': 95,
          'videoIds': ['video-1', 'video-2'],
          'estimatedMinutes': 25,
        },
        {
          'conceptId': 'concept-velocity',
          'conceptName': 'Velocity and Speed',
          'severity': 'severe',
          'masteryScore': 0.42,
          'priorityScore': 85,
          'videoIds': ['video-3', 'video-4'],
          'estimatedMinutes': 20,
        },
      ]),
      'total_recommendations': 5,
      'critical_gaps': 2,
      'severe_gaps': 2,
      'estimated_minutes': 75,
      'generated_at': now - (3 * 24 * 60 * 60 * 1000),
    });

    print('✅ Inserted Readiness Check (Low, Available Recommendations)');

    // ========================================
    // 2. Readiness Check - Medium Score - With Recommendations (Viewed)
    // ========================================
    final quiz2Id = _uuid.v4();
    final quiz2AttemptId = _uuid.v4();
    final rec2Id = _uuid.v4();

    await db.insert('quiz_attempts', {
      'id': quiz2AttemptId,
      'quiz_id': quiz2Id,
      'student_id': studentId,
      'answers': jsonEncode({}),
      'score': 0.62, // 62%
      'passed': 0,
      'completed_at': now - (2 * 24 * 60 * 60 * 1000), // 2 days ago
      'time_taken': 15 * 60 * 1000, // 15 minutes
      'start_time': now - (2 * 24 * 60 * 60 * 1000) - (15 * 60 * 1000),
      'attempt_number': 1,
      'synced_to_server': 0,
      'sync_retry_count': 0,
      'subject_id': chemistrySubjectId,
      'subject_name': 'Chemistry',
      'chapter_id': 'chapter-atoms',
      'chapter_name': 'Structure of Atom',
      'quiz_level': 'chapter',
      'total_questions': 25,
      'correct_answers': 16,
      'status': 'completed',
      'assessment_type': 'readiness',
      'has_recommendations': 1,
      'recommendation_count': 3,
      'recommendations_generated_at': now - (2 * 24 * 60 * 60 * 1000),
      'recommendation_status': 'viewed',
      'recommendations_history_id': rec2Id,
    });

    await db.insert('recommendations_history', {
      'id': rec2Id,
      'quiz_attempt_id': quiz2AttemptId,
      'user_id': studentId,
      'subject_id': chemistrySubjectId,
      'assessment_type': 'readiness',
      'recommendations_json': jsonEncode([
        {
          'conceptId': 'concept-quantum',
          'conceptName': 'Quantum Numbers',
          'severity': 'moderate',
          'masteryScore': 0.55,
          'priorityScore': 65,
          'videoIds': ['video-5'],
          'estimatedMinutes': 18,
        },
      ]),
      'total_recommendations': 3,
      'critical_gaps': 0,
      'severe_gaps': 1,
      'estimated_minutes': 45,
      'generated_at': now - (2 * 24 * 60 * 60 * 1000),
      'viewed_at': now - (24 * 60 * 60 * 1000), // Viewed 1 day ago
      'last_accessed_at': now - (24 * 60 * 60 * 1000),
      'view_count': 1,
    });

    print('✅ Inserted Readiness Check (Medium, Viewed Recommendations)');

    // ========================================
    // 3. Knowledge Check - Low Score - With Recommendations (In Progress)
    // ========================================
    final quiz3Id = _uuid.v4();
    final quiz3AttemptId = _uuid.v4();
    final rec3Id = _uuid.v4();
    final learningPath3Id = _uuid.v4();

    await db.insert('quiz_attempts', {
      'id': quiz3AttemptId,
      'quiz_id': quiz3Id,
      'student_id': studentId,
      'answers': jsonEncode({}),
      'score': 0.50, // 50%
      'passed': 0,
      'completed_at': now - (5 * 24 * 60 * 60 * 1000), // 5 days ago
      'time_taken': 10 * 60 * 1000, // 10 minutes
      'start_time': now - (5 * 24 * 60 * 60 * 1000) - (10 * 60 * 1000),
      'attempt_number': 1,
      'synced_to_server': 0,
      'sync_retry_count': 0,
      'subject_id': mathsSubjectId,
      'subject_name': 'Mathematics',
      'topic_id': 'topic-trigonometry',
      'topic_name': 'Trigonometric Functions',
      'quiz_level': 'topic',
      'total_questions': 15,
      'correct_answers': 8,
      'status': 'completed',
      'assessment_type': 'knowledge',
      'has_recommendations': 1,
      'recommendation_count': 4,
      'recommendations_generated_at': now - (5 * 24 * 60 * 60 * 1000),
      'recommendation_status': 'inProgress',
      'recommendations_history_id': rec3Id,
      'learning_path_id': learningPath3Id,
      'learning_path_progress': 0.35,
    });

    await db.insert('recommendations_history', {
      'id': rec3Id,
      'quiz_attempt_id': quiz3AttemptId,
      'user_id': studentId,
      'subject_id': mathsSubjectId,
      'topic_id': 'topic-trigonometry',
      'assessment_type': 'knowledge',
      'recommendations_json': jsonEncode([
        {
          'conceptId': 'concept-sine-cosine',
          'conceptName': 'Sine and Cosine Functions',
          'severity': 'severe',
          'masteryScore': 0.38,
          'priorityScore': 80,
          'videoIds': ['video-6', 'video-7'],
          'estimatedMinutes': 22,
        },
      ]),
      'total_recommendations': 4,
      'critical_gaps': 1,
      'severe_gaps': 2,
      'estimated_minutes': 60,
      'generated_at': now - (5 * 24 * 60 * 60 * 1000),
      'viewed_at': now - (4 * 24 * 60 * 60 * 1000),
      'last_accessed_at': now - (24 * 60 * 60 * 1000),
      'view_count': 3,
      'learning_path_id': learningPath3Id,
      'learning_path_started': 1,
      'learning_path_started_at': now - (4 * 24 * 60 * 60 * 1000),
      'viewed_video_ids': jsonEncode(['video-6']),
    });

    print('✅ Inserted Knowledge Check (Low, In Progress)');

    // ========================================
    // 4. Practice Quiz - High Score - No Recommendations
    // ========================================
    final quiz4Id = _uuid.v4();
    final quiz4AttemptId = _uuid.v4();

    await db.insert('quiz_attempts', {
      'id': quiz4AttemptId,
      'quiz_id': quiz4Id,
      'student_id': studentId,
      'answers': jsonEncode({}),
      'score': 0.92, // 92%
      'passed': 1,
      'completed_at': now - (24 * 60 * 60 * 1000), // 1 day ago
      'time_taken': 8 * 60 * 1000, // 8 minutes
      'start_time': now - (24 * 60 * 60 * 1000) - (8 * 60 * 1000),
      'attempt_number': 1,
      'synced_to_server': 0,
      'sync_retry_count': 0,
      'subject_id': physicsSubjectId,
      'subject_name': 'Physics',
      'topic_id': 'topic-vectors',
      'topic_name': 'Vectors',
      'video_title': 'Introduction to Vectors',
      'quiz_level': 'video',
      'total_questions': 10,
      'correct_answers': 9,
      'status': 'completed',
      'assessment_type': 'practice',
      'has_recommendations': 0,
      'recommendation_status': 'none',
    });

    print('✅ Inserted Practice Quiz (High, No Recommendations)');

    // ========================================
    // 5. Practice Quiz - Medium Score - No Recommendations
    // ========================================
    final quiz5Id = _uuid.v4();
    final quiz5AttemptId = _uuid.v4();

    await db.insert('quiz_attempts', {
      'id': quiz5AttemptId,
      'quiz_id': quiz5Id,
      'student_id': studentId,
      'answers': jsonEncode({}),
      'score': 0.75, // 75%
      'passed': 1,
      'completed_at': now - (12 * 60 * 60 * 1000), // 12 hours ago
      'time_taken': 6 * 60 * 1000, // 6 minutes
      'start_time': now - (12 * 60 * 60 * 1000) - (6 * 60 * 1000),
      'attempt_number': 2,
      'synced_to_server': 0,
      'sync_retry_count': 0,
      'subject_id': chemistrySubjectId,
      'subject_name': 'Chemistry',
      'video_title': 'Chemical Bonding Basics',
      'quiz_level': 'video',
      'total_questions': 8,
      'correct_answers': 6,
      'status': 'completed',
      'assessment_type': 'practice',
      'has_recommendations': 0,
      'recommendation_status': 'none',
    });

    print('✅ Inserted Practice Quiz (Medium, No Recommendations)');

    // ========================================
    // 6. Readiness Check - Low Score - With Recommendations (Completed)
    // ========================================
    final quiz6Id = _uuid.v4();
    final quiz6AttemptId = _uuid.v4();
    final rec6Id = _uuid.v4();
    final learningPath6Id = _uuid.v4();

    await db.insert('quiz_attempts', {
      'id': quiz6AttemptId,
      'quiz_id': quiz6Id,
      'student_id': studentId,
      'answers': jsonEncode({}),
      'score': 0.38, // 38%
      'passed': 0,
      'completed_at': now - (7 * 24 * 60 * 60 * 1000), // 7 days ago
      'time_taken': 18 * 60 * 1000, // 18 minutes
      'start_time': now - (7 * 24 * 60 * 60 * 1000) - (18 * 60 * 1000),
      'attempt_number': 1,
      'synced_to_server': 0,
      'sync_retry_count': 0,
      'subject_id': physicsSubjectId,
      'subject_name': 'Physics',
      'chapter_id': 'chapter-laws-of-motion',
      'chapter_name': 'Laws of Motion',
      'quiz_level': 'chapter',
      'total_questions': 20,
      'correct_answers': 8,
      'status': 'completed',
      'assessment_type': 'readiness',
      'has_recommendations': 1,
      'recommendation_count': 6,
      'recommendations_generated_at': now - (7 * 24 * 60 * 60 * 1000),
      'recommendation_status': 'completed',
      'recommendations_history_id': rec6Id,
      'learning_path_id': learningPath6Id,
      'learning_path_progress': 1.0,
    });

    await db.insert('recommendations_history', {
      'id': rec6Id,
      'quiz_attempt_id': quiz6AttemptId,
      'user_id': studentId,
      'subject_id': physicsSubjectId,
      'assessment_type': 'readiness',
      'recommendations_json': jsonEncode([
        {
          'conceptId': 'concept-newtons-laws',
          'conceptName': "Newton's Laws of Motion",
          'severity': 'critical',
          'masteryScore': 0.30,
          'priorityScore': 98,
          'videoIds': ['video-8', 'video-9', 'video-10'],
          'estimatedMinutes': 35,
        },
      ]),
      'total_recommendations': 6,
      'critical_gaps': 3,
      'severe_gaps': 2,
      'estimated_minutes': 90,
      'generated_at': now - (7 * 24 * 60 * 60 * 1000),
      'viewed_at': now - (6 * 24 * 60 * 60 * 1000),
      'last_accessed_at': now - (2 * 24 * 60 * 60 * 1000),
      'view_count': 5,
      'learning_path_id': learningPath6Id,
      'learning_path_started': 1,
      'learning_path_started_at': now - (6 * 24 * 60 * 60 * 1000),
      'learning_path_completed': 1,
      'learning_path_completed_at': now - (2 * 24 * 60 * 60 * 1000),
      'viewed_video_ids': jsonEncode(['video-8', 'video-9', 'video-10']),
    });

    print('✅ Inserted Readiness Check (Low, Completed Learning Path)');

    // ========================================
    // 7. Knowledge Check - Medium Score - With Recommendations
    // ========================================
    final quiz7Id = _uuid.v4();
    final quiz7AttemptId = _uuid.v4();
    final rec7Id = _uuid.v4();

    await db.insert('quiz_attempts', {
      'id': quiz7AttemptId,
      'quiz_id': quiz7Id,
      'student_id': studentId,
      'answers': jsonEncode({}),
      'score': 0.68, // 68%
      'passed': 0,
      'completed_at': now - (4 * 24 * 60 * 60 * 1000), // 4 days ago
      'time_taken': 11 * 60 * 1000, // 11 minutes
      'start_time': now - (4 * 24 * 60 * 60 * 1000) - (11 * 60 * 1000),
      'attempt_number': 1,
      'synced_to_server': 0,
      'sync_retry_count': 0,
      'subject_id': mathsSubjectId,
      'subject_name': 'Mathematics',
      'topic_id': 'topic-sets',
      'topic_name': 'Sets and Relations',
      'quiz_level': 'topic',
      'total_questions': 12,
      'correct_answers': 8,
      'status': 'completed',
      'assessment_type': 'knowledge',
      'has_recommendations': 1,
      'recommendation_count': 2,
      'recommendations_generated_at': now - (4 * 24 * 60 * 60 * 1000),
      'recommendation_status': 'available',
      'recommendations_history_id': rec7Id,
    });

    await db.insert('recommendations_history', {
      'id': rec7Id,
      'quiz_attempt_id': quiz7AttemptId,
      'user_id': studentId,
      'subject_id': mathsSubjectId,
      'topic_id': 'topic-sets',
      'assessment_type': 'knowledge',
      'recommendations_json': jsonEncode([
        {
          'conceptId': 'concept-relations',
          'conceptName': 'Types of Relations',
          'severity': 'mild',
          'masteryScore': 0.58,
          'priorityScore': 55,
          'videoIds': ['video-11'],
          'estimatedMinutes': 15,
        },
      ]),
      'total_recommendations': 2,
      'critical_gaps': 0,
      'severe_gaps': 0,
      'estimated_minutes': 30,
      'generated_at': now - (4 * 24 * 60 * 60 * 1000),
    });

    print('✅ Inserted Knowledge Check (Medium, Available Recommendations)');

    // ========================================
    // 8. Practice Quiz - High Score
    // ========================================
    final quiz8Id = _uuid.v4();
    final quiz8AttemptId = _uuid.v4();

    await db.insert('quiz_attempts', {
      'id': quiz8AttemptId,
      'quiz_id': quiz8Id,
      'student_id': studentId,
      'answers': jsonEncode({}),
      'score': 0.88, // 88%
      'passed': 1,
      'completed_at': now - (6 * 60 * 60 * 1000), // 6 hours ago
      'time_taken': 5 * 60 * 1000, // 5 minutes
      'start_time': now - (6 * 60 * 60 * 1000) - (5 * 60 * 1000),
      'attempt_number': 1,
      'synced_to_server': 0,
      'sync_retry_count': 0,
      'subject_id': chemistrySubjectId,
      'subject_name': 'Chemistry',
      'video_title': 'Ionic Bonding Explained',
      'quiz_level': 'video',
      'total_questions': 10,
      'correct_answers': 9,
      'status': 'completed',
      'assessment_type': 'practice',
      'has_recommendations': 0,
      'recommendation_status': 'none',
    });

    print('✅ Inserted Practice Quiz (High)');

    print('');
    print('📊 Summary:');
    print('   - Total quiz attempts: 8');
    print('   - Readiness Checks: 3 (2 with recommendations)');
    print('   - Knowledge Checks: 2 (both with recommendations)');
    print('   - Practice Quizzes: 3 (none with recommendations)');
    print('   - Recommendation statuses:');
    print('     • Available: 2');
    print('     • Viewed: 1');
    print('     • In Progress: 1');
    print('     • Completed: 1');
    print('');
    print('✅ Test data inserted successfully!');
    print('');
    print('🎯 You can now test:');
    print('   1. Filter by assessment type (Readiness/Knowledge/Practice)');
    print('   2. Filter by "Has Learning Path"');
    print('   3. Navigate to recommendations detail screen');
    print('   4. View different recommendation statuses');
    print('');
    print('🔄 Restart the app to see the new data.');
  } catch (e, stackTrace) {
    print('❌ Error inserting test data:');
    print(e);
    print(stackTrace);
    exit(1);
  } finally {
    await db.close();
  }
}
