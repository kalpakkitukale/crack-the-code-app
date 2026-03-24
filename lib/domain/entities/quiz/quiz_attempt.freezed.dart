// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_attempt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QuizAttempt {
  String get id => throw _privateConstructorUsedError;
  String get quizId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  Map<String, String> get answers => throw _privateConstructorUsedError;
  double get score => throw _privateConstructorUsedError;
  bool get passed => throw _privateConstructorUsedError;
  DateTime get completedAt => throw _privateConstructorUsedError;
  int get timeTaken => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  int get attemptNumber => throw _privateConstructorUsedError;
  bool get syncedToServer => throw _privateConstructorUsedError;
  int get syncRetryCount => throw _privateConstructorUsedError;
  Map<String, dynamic>? get analytics =>
      throw _privateConstructorUsedError; // Additional metadata for Phase 4 statistics
  String? get subjectId => throw _privateConstructorUsedError;
  String? get subjectName => throw _privateConstructorUsedError;
  String? get chapterId => throw _privateConstructorUsedError;
  String? get chapterName => throw _privateConstructorUsedError;
  String? get topicId => throw _privateConstructorUsedError;
  String? get topicName => throw _privateConstructorUsedError;
  String? get videoTitle => throw _privateConstructorUsedError;
  String? get quizLevel => throw _privateConstructorUsedError;
  int? get totalQuestions => throw _privateConstructorUsedError;
  int? get correctAnswers =>
      throw _privateConstructorUsedError; // Questions data for detailed review from history
  List<Question>? get questions =>
      throw _privateConstructorUsedError; // Quiz attempt status (completed, in progress, or abandoned)
  QuizAttemptStatus get status =>
      throw _privateConstructorUsedError; // NEW: Assessment type classification (readiness, knowledge, practice)
  AssessmentType get assessmentType =>
      throw _privateConstructorUsedError; // NEW: Recommendation metadata
  bool get hasRecommendations => throw _privateConstructorUsedError;
  int? get recommendationCount => throw _privateConstructorUsedError;
  DateTime? get recommendationsGeneratedAt =>
      throw _privateConstructorUsedError;
  RecommendationStatus get recommendationStatus =>
      throw _privateConstructorUsedError;
  String? get recommendationsHistoryId =>
      throw _privateConstructorUsedError; // NEW: Learning path tracking
  String? get learningPathId => throw _privateConstructorUsedError;
  double? get learningPathProgress => throw _privateConstructorUsedError;

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizAttemptCopyWith<QuizAttempt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizAttemptCopyWith<$Res> {
  factory $QuizAttemptCopyWith(
    QuizAttempt value,
    $Res Function(QuizAttempt) then,
  ) = _$QuizAttemptCopyWithImpl<$Res, QuizAttempt>;
  @useResult
  $Res call({
    String id,
    String quizId,
    String studentId,
    Map<String, String> answers,
    double score,
    bool passed,
    DateTime completedAt,
    int timeTaken,
    DateTime? startTime,
    int attemptNumber,
    bool syncedToServer,
    int syncRetryCount,
    Map<String, dynamic>? analytics,
    String? subjectId,
    String? subjectName,
    String? chapterId,
    String? chapterName,
    String? topicId,
    String? topicName,
    String? videoTitle,
    String? quizLevel,
    int? totalQuestions,
    int? correctAnswers,
    List<Question>? questions,
    QuizAttemptStatus status,
    AssessmentType assessmentType,
    bool hasRecommendations,
    int? recommendationCount,
    DateTime? recommendationsGeneratedAt,
    RecommendationStatus recommendationStatus,
    String? recommendationsHistoryId,
    String? learningPathId,
    double? learningPathProgress,
  });
}

/// @nodoc
class _$QuizAttemptCopyWithImpl<$Res, $Val extends QuizAttempt>
    implements $QuizAttemptCopyWith<$Res> {
  _$QuizAttemptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizId = null,
    Object? studentId = null,
    Object? answers = null,
    Object? score = null,
    Object? passed = null,
    Object? completedAt = null,
    Object? timeTaken = null,
    Object? startTime = freezed,
    Object? attemptNumber = null,
    Object? syncedToServer = null,
    Object? syncRetryCount = null,
    Object? analytics = freezed,
    Object? subjectId = freezed,
    Object? subjectName = freezed,
    Object? chapterId = freezed,
    Object? chapterName = freezed,
    Object? topicId = freezed,
    Object? topicName = freezed,
    Object? videoTitle = freezed,
    Object? quizLevel = freezed,
    Object? totalQuestions = freezed,
    Object? correctAnswers = freezed,
    Object? questions = freezed,
    Object? status = null,
    Object? assessmentType = null,
    Object? hasRecommendations = null,
    Object? recommendationCount = freezed,
    Object? recommendationsGeneratedAt = freezed,
    Object? recommendationStatus = null,
    Object? recommendationsHistoryId = freezed,
    Object? learningPathId = freezed,
    Object? learningPathProgress = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            quizId: null == quizId
                ? _value.quizId
                : quizId // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            answers: null == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as double,
            passed: null == passed
                ? _value.passed
                : passed // ignore: cast_nullable_to_non_nullable
                      as bool,
            completedAt: null == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            timeTaken: null == timeTaken
                ? _value.timeTaken
                : timeTaken // ignore: cast_nullable_to_non_nullable
                      as int,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            attemptNumber: null == attemptNumber
                ? _value.attemptNumber
                : attemptNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            syncedToServer: null == syncedToServer
                ? _value.syncedToServer
                : syncedToServer // ignore: cast_nullable_to_non_nullable
                      as bool,
            syncRetryCount: null == syncRetryCount
                ? _value.syncRetryCount
                : syncRetryCount // ignore: cast_nullable_to_non_nullable
                      as int,
            analytics: freezed == analytics
                ? _value.analytics
                : analytics // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            subjectId: freezed == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            subjectName: freezed == subjectName
                ? _value.subjectName
                : subjectName // ignore: cast_nullable_to_non_nullable
                      as String?,
            chapterId: freezed == chapterId
                ? _value.chapterId
                : chapterId // ignore: cast_nullable_to_non_nullable
                      as String?,
            chapterName: freezed == chapterName
                ? _value.chapterName
                : chapterName // ignore: cast_nullable_to_non_nullable
                      as String?,
            topicId: freezed == topicId
                ? _value.topicId
                : topicId // ignore: cast_nullable_to_non_nullable
                      as String?,
            topicName: freezed == topicName
                ? _value.topicName
                : topicName // ignore: cast_nullable_to_non_nullable
                      as String?,
            videoTitle: freezed == videoTitle
                ? _value.videoTitle
                : videoTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            quizLevel: freezed == quizLevel
                ? _value.quizLevel
                : quizLevel // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalQuestions: freezed == totalQuestions
                ? _value.totalQuestions
                : totalQuestions // ignore: cast_nullable_to_non_nullable
                      as int?,
            correctAnswers: freezed == correctAnswers
                ? _value.correctAnswers
                : correctAnswers // ignore: cast_nullable_to_non_nullable
                      as int?,
            questions: freezed == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<Question>?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as QuizAttemptStatus,
            assessmentType: null == assessmentType
                ? _value.assessmentType
                : assessmentType // ignore: cast_nullable_to_non_nullable
                      as AssessmentType,
            hasRecommendations: null == hasRecommendations
                ? _value.hasRecommendations
                : hasRecommendations // ignore: cast_nullable_to_non_nullable
                      as bool,
            recommendationCount: freezed == recommendationCount
                ? _value.recommendationCount
                : recommendationCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            recommendationsGeneratedAt: freezed == recommendationsGeneratedAt
                ? _value.recommendationsGeneratedAt
                : recommendationsGeneratedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            recommendationStatus: null == recommendationStatus
                ? _value.recommendationStatus
                : recommendationStatus // ignore: cast_nullable_to_non_nullable
                      as RecommendationStatus,
            recommendationsHistoryId: freezed == recommendationsHistoryId
                ? _value.recommendationsHistoryId
                : recommendationsHistoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            learningPathId: freezed == learningPathId
                ? _value.learningPathId
                : learningPathId // ignore: cast_nullable_to_non_nullable
                      as String?,
            learningPathProgress: freezed == learningPathProgress
                ? _value.learningPathProgress
                : learningPathProgress // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizAttemptImplCopyWith<$Res>
    implements $QuizAttemptCopyWith<$Res> {
  factory _$$QuizAttemptImplCopyWith(
    _$QuizAttemptImpl value,
    $Res Function(_$QuizAttemptImpl) then,
  ) = __$$QuizAttemptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String quizId,
    String studentId,
    Map<String, String> answers,
    double score,
    bool passed,
    DateTime completedAt,
    int timeTaken,
    DateTime? startTime,
    int attemptNumber,
    bool syncedToServer,
    int syncRetryCount,
    Map<String, dynamic>? analytics,
    String? subjectId,
    String? subjectName,
    String? chapterId,
    String? chapterName,
    String? topicId,
    String? topicName,
    String? videoTitle,
    String? quizLevel,
    int? totalQuestions,
    int? correctAnswers,
    List<Question>? questions,
    QuizAttemptStatus status,
    AssessmentType assessmentType,
    bool hasRecommendations,
    int? recommendationCount,
    DateTime? recommendationsGeneratedAt,
    RecommendationStatus recommendationStatus,
    String? recommendationsHistoryId,
    String? learningPathId,
    double? learningPathProgress,
  });
}

/// @nodoc
class __$$QuizAttemptImplCopyWithImpl<$Res>
    extends _$QuizAttemptCopyWithImpl<$Res, _$QuizAttemptImpl>
    implements _$$QuizAttemptImplCopyWith<$Res> {
  __$$QuizAttemptImplCopyWithImpl(
    _$QuizAttemptImpl _value,
    $Res Function(_$QuizAttemptImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizId = null,
    Object? studentId = null,
    Object? answers = null,
    Object? score = null,
    Object? passed = null,
    Object? completedAt = null,
    Object? timeTaken = null,
    Object? startTime = freezed,
    Object? attemptNumber = null,
    Object? syncedToServer = null,
    Object? syncRetryCount = null,
    Object? analytics = freezed,
    Object? subjectId = freezed,
    Object? subjectName = freezed,
    Object? chapterId = freezed,
    Object? chapterName = freezed,
    Object? topicId = freezed,
    Object? topicName = freezed,
    Object? videoTitle = freezed,
    Object? quizLevel = freezed,
    Object? totalQuestions = freezed,
    Object? correctAnswers = freezed,
    Object? questions = freezed,
    Object? status = null,
    Object? assessmentType = null,
    Object? hasRecommendations = null,
    Object? recommendationCount = freezed,
    Object? recommendationsGeneratedAt = freezed,
    Object? recommendationStatus = null,
    Object? recommendationsHistoryId = freezed,
    Object? learningPathId = freezed,
    Object? learningPathProgress = freezed,
  }) {
    return _then(
      _$QuizAttemptImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        quizId: null == quizId
            ? _value.quizId
            : quizId // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        answers: null == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double,
        passed: null == passed
            ? _value.passed
            : passed // ignore: cast_nullable_to_non_nullable
                  as bool,
        completedAt: null == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        timeTaken: null == timeTaken
            ? _value.timeTaken
            : timeTaken // ignore: cast_nullable_to_non_nullable
                  as int,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        attemptNumber: null == attemptNumber
            ? _value.attemptNumber
            : attemptNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        syncedToServer: null == syncedToServer
            ? _value.syncedToServer
            : syncedToServer // ignore: cast_nullable_to_non_nullable
                  as bool,
        syncRetryCount: null == syncRetryCount
            ? _value.syncRetryCount
            : syncRetryCount // ignore: cast_nullable_to_non_nullable
                  as int,
        analytics: freezed == analytics
            ? _value._analytics
            : analytics // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        subjectId: freezed == subjectId
            ? _value.subjectId
            : subjectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        subjectName: freezed == subjectName
            ? _value.subjectName
            : subjectName // ignore: cast_nullable_to_non_nullable
                  as String?,
        chapterId: freezed == chapterId
            ? _value.chapterId
            : chapterId // ignore: cast_nullable_to_non_nullable
                  as String?,
        chapterName: freezed == chapterName
            ? _value.chapterName
            : chapterName // ignore: cast_nullable_to_non_nullable
                  as String?,
        topicId: freezed == topicId
            ? _value.topicId
            : topicId // ignore: cast_nullable_to_non_nullable
                  as String?,
        topicName: freezed == topicName
            ? _value.topicName
            : topicName // ignore: cast_nullable_to_non_nullable
                  as String?,
        videoTitle: freezed == videoTitle
            ? _value.videoTitle
            : videoTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        quizLevel: freezed == quizLevel
            ? _value.quizLevel
            : quizLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalQuestions: freezed == totalQuestions
            ? _value.totalQuestions
            : totalQuestions // ignore: cast_nullable_to_non_nullable
                  as int?,
        correctAnswers: freezed == correctAnswers
            ? _value.correctAnswers
            : correctAnswers // ignore: cast_nullable_to_non_nullable
                  as int?,
        questions: freezed == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<Question>?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as QuizAttemptStatus,
        assessmentType: null == assessmentType
            ? _value.assessmentType
            : assessmentType // ignore: cast_nullable_to_non_nullable
                  as AssessmentType,
        hasRecommendations: null == hasRecommendations
            ? _value.hasRecommendations
            : hasRecommendations // ignore: cast_nullable_to_non_nullable
                  as bool,
        recommendationCount: freezed == recommendationCount
            ? _value.recommendationCount
            : recommendationCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        recommendationsGeneratedAt: freezed == recommendationsGeneratedAt
            ? _value.recommendationsGeneratedAt
            : recommendationsGeneratedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        recommendationStatus: null == recommendationStatus
            ? _value.recommendationStatus
            : recommendationStatus // ignore: cast_nullable_to_non_nullable
                  as RecommendationStatus,
        recommendationsHistoryId: freezed == recommendationsHistoryId
            ? _value.recommendationsHistoryId
            : recommendationsHistoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        learningPathId: freezed == learningPathId
            ? _value.learningPathId
            : learningPathId // ignore: cast_nullable_to_non_nullable
                  as String?,
        learningPathProgress: freezed == learningPathProgress
            ? _value.learningPathProgress
            : learningPathProgress // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$QuizAttemptImpl extends _QuizAttempt {
  const _$QuizAttemptImpl({
    required this.id,
    required this.quizId,
    required this.studentId,
    required final Map<String, String> answers,
    required this.score,
    required this.passed,
    required this.completedAt,
    required this.timeTaken,
    this.startTime,
    this.attemptNumber = 1,
    this.syncedToServer = false,
    this.syncRetryCount = 0,
    final Map<String, dynamic>? analytics,
    this.subjectId,
    this.subjectName,
    this.chapterId,
    this.chapterName,
    this.topicId,
    this.topicName,
    this.videoTitle,
    this.quizLevel,
    this.totalQuestions,
    this.correctAnswers,
    final List<Question>? questions,
    this.status = QuizAttemptStatus.completed,
    this.assessmentType = AssessmentType.practice,
    this.hasRecommendations = false,
    this.recommendationCount,
    this.recommendationsGeneratedAt,
    this.recommendationStatus = RecommendationStatus.none,
    this.recommendationsHistoryId,
    this.learningPathId,
    this.learningPathProgress,
  }) : _answers = answers,
       _analytics = analytics,
       _questions = questions,
       super._();

  @override
  final String id;
  @override
  final String quizId;
  @override
  final String studentId;
  final Map<String, String> _answers;
  @override
  Map<String, String> get answers {
    if (_answers is EqualUnmodifiableMapView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_answers);
  }

  @override
  final double score;
  @override
  final bool passed;
  @override
  final DateTime completedAt;
  @override
  final int timeTaken;
  @override
  final DateTime? startTime;
  @override
  @JsonKey()
  final int attemptNumber;
  @override
  @JsonKey()
  final bool syncedToServer;
  @override
  @JsonKey()
  final int syncRetryCount;
  final Map<String, dynamic>? _analytics;
  @override
  Map<String, dynamic>? get analytics {
    final value = _analytics;
    if (value == null) return null;
    if (_analytics is EqualUnmodifiableMapView) return _analytics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Additional metadata for Phase 4 statistics
  @override
  final String? subjectId;
  @override
  final String? subjectName;
  @override
  final String? chapterId;
  @override
  final String? chapterName;
  @override
  final String? topicId;
  @override
  final String? topicName;
  @override
  final String? videoTitle;
  @override
  final String? quizLevel;
  @override
  final int? totalQuestions;
  @override
  final int? correctAnswers;
  // Questions data for detailed review from history
  final List<Question>? _questions;
  // Questions data for detailed review from history
  @override
  List<Question>? get questions {
    final value = _questions;
    if (value == null) return null;
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // Quiz attempt status (completed, in progress, or abandoned)
  @override
  @JsonKey()
  final QuizAttemptStatus status;
  // NEW: Assessment type classification (readiness, knowledge, practice)
  @override
  @JsonKey()
  final AssessmentType assessmentType;
  // NEW: Recommendation metadata
  @override
  @JsonKey()
  final bool hasRecommendations;
  @override
  final int? recommendationCount;
  @override
  final DateTime? recommendationsGeneratedAt;
  @override
  @JsonKey()
  final RecommendationStatus recommendationStatus;
  @override
  final String? recommendationsHistoryId;
  // NEW: Learning path tracking
  @override
  final String? learningPathId;
  @override
  final double? learningPathProgress;

  @override
  String toString() {
    return 'QuizAttempt(id: $id, quizId: $quizId, studentId: $studentId, answers: $answers, score: $score, passed: $passed, completedAt: $completedAt, timeTaken: $timeTaken, startTime: $startTime, attemptNumber: $attemptNumber, syncedToServer: $syncedToServer, syncRetryCount: $syncRetryCount, analytics: $analytics, subjectId: $subjectId, subjectName: $subjectName, chapterId: $chapterId, chapterName: $chapterName, topicId: $topicId, topicName: $topicName, videoTitle: $videoTitle, quizLevel: $quizLevel, totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, questions: $questions, status: $status, assessmentType: $assessmentType, hasRecommendations: $hasRecommendations, recommendationCount: $recommendationCount, recommendationsGeneratedAt: $recommendationsGeneratedAt, recommendationStatus: $recommendationStatus, recommendationsHistoryId: $recommendationsHistoryId, learningPathId: $learningPathId, learningPathProgress: $learningPathProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizAttemptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quizId, quizId) || other.quizId == quizId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.passed, passed) || other.passed == passed) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.timeTaken, timeTaken) ||
                other.timeTaken == timeTaken) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.attemptNumber, attemptNumber) ||
                other.attemptNumber == attemptNumber) &&
            (identical(other.syncedToServer, syncedToServer) ||
                other.syncedToServer == syncedToServer) &&
            (identical(other.syncRetryCount, syncRetryCount) ||
                other.syncRetryCount == syncRetryCount) &&
            const DeepCollectionEquality().equals(
              other._analytics,
              _analytics,
            ) &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            (identical(other.subjectName, subjectName) ||
                other.subjectName == subjectName) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.chapterName, chapterName) ||
                other.chapterName == chapterName) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.topicName, topicName) ||
                other.topicName == topicName) &&
            (identical(other.videoTitle, videoTitle) ||
                other.videoTitle == videoTitle) &&
            (identical(other.quizLevel, quizLevel) ||
                other.quizLevel == quizLevel) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assessmentType, assessmentType) ||
                other.assessmentType == assessmentType) &&
            (identical(other.hasRecommendations, hasRecommendations) ||
                other.hasRecommendations == hasRecommendations) &&
            (identical(other.recommendationCount, recommendationCount) ||
                other.recommendationCount == recommendationCount) &&
            (identical(
                  other.recommendationsGeneratedAt,
                  recommendationsGeneratedAt,
                ) ||
                other.recommendationsGeneratedAt ==
                    recommendationsGeneratedAt) &&
            (identical(other.recommendationStatus, recommendationStatus) ||
                other.recommendationStatus == recommendationStatus) &&
            (identical(
                  other.recommendationsHistoryId,
                  recommendationsHistoryId,
                ) ||
                other.recommendationsHistoryId == recommendationsHistoryId) &&
            (identical(other.learningPathId, learningPathId) ||
                other.learningPathId == learningPathId) &&
            (identical(other.learningPathProgress, learningPathProgress) ||
                other.learningPathProgress == learningPathProgress));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    quizId,
    studentId,
    const DeepCollectionEquality().hash(_answers),
    score,
    passed,
    completedAt,
    timeTaken,
    startTime,
    attemptNumber,
    syncedToServer,
    syncRetryCount,
    const DeepCollectionEquality().hash(_analytics),
    subjectId,
    subjectName,
    chapterId,
    chapterName,
    topicId,
    topicName,
    videoTitle,
    quizLevel,
    totalQuestions,
    correctAnswers,
    const DeepCollectionEquality().hash(_questions),
    status,
    assessmentType,
    hasRecommendations,
    recommendationCount,
    recommendationsGeneratedAt,
    recommendationStatus,
    recommendationsHistoryId,
    learningPathId,
    learningPathProgress,
  ]);

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizAttemptImplCopyWith<_$QuizAttemptImpl> get copyWith =>
      __$$QuizAttemptImplCopyWithImpl<_$QuizAttemptImpl>(this, _$identity);
}

abstract class _QuizAttempt extends QuizAttempt {
  const factory _QuizAttempt({
    required final String id,
    required final String quizId,
    required final String studentId,
    required final Map<String, String> answers,
    required final double score,
    required final bool passed,
    required final DateTime completedAt,
    required final int timeTaken,
    final DateTime? startTime,
    final int attemptNumber,
    final bool syncedToServer,
    final int syncRetryCount,
    final Map<String, dynamic>? analytics,
    final String? subjectId,
    final String? subjectName,
    final String? chapterId,
    final String? chapterName,
    final String? topicId,
    final String? topicName,
    final String? videoTitle,
    final String? quizLevel,
    final int? totalQuestions,
    final int? correctAnswers,
    final List<Question>? questions,
    final QuizAttemptStatus status,
    final AssessmentType assessmentType,
    final bool hasRecommendations,
    final int? recommendationCount,
    final DateTime? recommendationsGeneratedAt,
    final RecommendationStatus recommendationStatus,
    final String? recommendationsHistoryId,
    final String? learningPathId,
    final double? learningPathProgress,
  }) = _$QuizAttemptImpl;
  const _QuizAttempt._() : super._();

  @override
  String get id;
  @override
  String get quizId;
  @override
  String get studentId;
  @override
  Map<String, String> get answers;
  @override
  double get score;
  @override
  bool get passed;
  @override
  DateTime get completedAt;
  @override
  int get timeTaken;
  @override
  DateTime? get startTime;
  @override
  int get attemptNumber;
  @override
  bool get syncedToServer;
  @override
  int get syncRetryCount;
  @override
  Map<String, dynamic>? get analytics; // Additional metadata for Phase 4 statistics
  @override
  String? get subjectId;
  @override
  String? get subjectName;
  @override
  String? get chapterId;
  @override
  String? get chapterName;
  @override
  String? get topicId;
  @override
  String? get topicName;
  @override
  String? get videoTitle;
  @override
  String? get quizLevel;
  @override
  int? get totalQuestions;
  @override
  int? get correctAnswers; // Questions data for detailed review from history
  @override
  List<Question>? get questions; // Quiz attempt status (completed, in progress, or abandoned)
  @override
  QuizAttemptStatus get status; // NEW: Assessment type classification (readiness, knowledge, practice)
  @override
  AssessmentType get assessmentType; // NEW: Recommendation metadata
  @override
  bool get hasRecommendations;
  @override
  int? get recommendationCount;
  @override
  DateTime? get recommendationsGeneratedAt;
  @override
  RecommendationStatus get recommendationStatus;
  @override
  String? get recommendationsHistoryId; // NEW: Learning path tracking
  @override
  String? get learningPathId;
  @override
  double? get learningPathProgress;

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizAttemptImplCopyWith<_$QuizAttemptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
