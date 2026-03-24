// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QuizResult {
  String get sessionId => throw _privateConstructorUsedError;
  int get totalQuestions => throw _privateConstructorUsedError;
  int get correctAnswers => throw _privateConstructorUsedError;
  double get scorePercentage => throw _privateConstructorUsedError;
  bool get passed => throw _privateConstructorUsedError;
  Map<String, bool> get questionResults => throw _privateConstructorUsedError;
  Duration get timeTaken => throw _privateConstructorUsedError;
  DateTime get evaluatedAt => throw _privateConstructorUsedError;
  bool get evaluatedOffline => throw _privateConstructorUsedError;
  Map<String, ConceptScore>? get conceptAnalysis =>
      throw _privateConstructorUsedError;
  List<String>? get weakAreas => throw _privateConstructorUsedError;
  List<String>? get strongAreas => throw _privateConstructorUsedError;
  String? get recommendation =>
      throw _privateConstructorUsedError; // Questions data for detailed review (populated from quiz attempts)
  List<Question>? get questions =>
      throw _privateConstructorUsedError; // Student's answers for detailed review (populated from quiz attempts)
  Map<String, String>? get answers =>
      throw _privateConstructorUsedError; // Breadcrumb metadata for quiz context display
  String? get quizLevel => throw _privateConstructorUsedError;
  String? get subjectName => throw _privateConstructorUsedError;
  String? get chapterName => throw _privateConstructorUsedError;
  String? get topicName => throw _privateConstructorUsedError;
  String? get videoTitle => throw _privateConstructorUsedError;

  /// Create a copy of QuizResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizResultCopyWith<QuizResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizResultCopyWith<$Res> {
  factory $QuizResultCopyWith(
    QuizResult value,
    $Res Function(QuizResult) then,
  ) = _$QuizResultCopyWithImpl<$Res, QuizResult>;
  @useResult
  $Res call({
    String sessionId,
    int totalQuestions,
    int correctAnswers,
    double scorePercentage,
    bool passed,
    Map<String, bool> questionResults,
    Duration timeTaken,
    DateTime evaluatedAt,
    bool evaluatedOffline,
    Map<String, ConceptScore>? conceptAnalysis,
    List<String>? weakAreas,
    List<String>? strongAreas,
    String? recommendation,
    List<Question>? questions,
    Map<String, String>? answers,
    String? quizLevel,
    String? subjectName,
    String? chapterName,
    String? topicName,
    String? videoTitle,
  });
}

/// @nodoc
class _$QuizResultCopyWithImpl<$Res, $Val extends QuizResult>
    implements $QuizResultCopyWith<$Res> {
  _$QuizResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? scorePercentage = null,
    Object? passed = null,
    Object? questionResults = null,
    Object? timeTaken = null,
    Object? evaluatedAt = null,
    Object? evaluatedOffline = null,
    Object? conceptAnalysis = freezed,
    Object? weakAreas = freezed,
    Object? strongAreas = freezed,
    Object? recommendation = freezed,
    Object? questions = freezed,
    Object? answers = freezed,
    Object? quizLevel = freezed,
    Object? subjectName = freezed,
    Object? chapterName = freezed,
    Object? topicName = freezed,
    Object? videoTitle = freezed,
  }) {
    return _then(
      _value.copyWith(
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            totalQuestions: null == totalQuestions
                ? _value.totalQuestions
                : totalQuestions // ignore: cast_nullable_to_non_nullable
                      as int,
            correctAnswers: null == correctAnswers
                ? _value.correctAnswers
                : correctAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
            scorePercentage: null == scorePercentage
                ? _value.scorePercentage
                : scorePercentage // ignore: cast_nullable_to_non_nullable
                      as double,
            passed: null == passed
                ? _value.passed
                : passed // ignore: cast_nullable_to_non_nullable
                      as bool,
            questionResults: null == questionResults
                ? _value.questionResults
                : questionResults // ignore: cast_nullable_to_non_nullable
                      as Map<String, bool>,
            timeTaken: null == timeTaken
                ? _value.timeTaken
                : timeTaken // ignore: cast_nullable_to_non_nullable
                      as Duration,
            evaluatedAt: null == evaluatedAt
                ? _value.evaluatedAt
                : evaluatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            evaluatedOffline: null == evaluatedOffline
                ? _value.evaluatedOffline
                : evaluatedOffline // ignore: cast_nullable_to_non_nullable
                      as bool,
            conceptAnalysis: freezed == conceptAnalysis
                ? _value.conceptAnalysis
                : conceptAnalysis // ignore: cast_nullable_to_non_nullable
                      as Map<String, ConceptScore>?,
            weakAreas: freezed == weakAreas
                ? _value.weakAreas
                : weakAreas // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            strongAreas: freezed == strongAreas
                ? _value.strongAreas
                : strongAreas // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            recommendation: freezed == recommendation
                ? _value.recommendation
                : recommendation // ignore: cast_nullable_to_non_nullable
                      as String?,
            questions: freezed == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<Question>?,
            answers: freezed == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
            quizLevel: freezed == quizLevel
                ? _value.quizLevel
                : quizLevel // ignore: cast_nullable_to_non_nullable
                      as String?,
            subjectName: freezed == subjectName
                ? _value.subjectName
                : subjectName // ignore: cast_nullable_to_non_nullable
                      as String?,
            chapterName: freezed == chapterName
                ? _value.chapterName
                : chapterName // ignore: cast_nullable_to_non_nullable
                      as String?,
            topicName: freezed == topicName
                ? _value.topicName
                : topicName // ignore: cast_nullable_to_non_nullable
                      as String?,
            videoTitle: freezed == videoTitle
                ? _value.videoTitle
                : videoTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizResultImplCopyWith<$Res>
    implements $QuizResultCopyWith<$Res> {
  factory _$$QuizResultImplCopyWith(
    _$QuizResultImpl value,
    $Res Function(_$QuizResultImpl) then,
  ) = __$$QuizResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sessionId,
    int totalQuestions,
    int correctAnswers,
    double scorePercentage,
    bool passed,
    Map<String, bool> questionResults,
    Duration timeTaken,
    DateTime evaluatedAt,
    bool evaluatedOffline,
    Map<String, ConceptScore>? conceptAnalysis,
    List<String>? weakAreas,
    List<String>? strongAreas,
    String? recommendation,
    List<Question>? questions,
    Map<String, String>? answers,
    String? quizLevel,
    String? subjectName,
    String? chapterName,
    String? topicName,
    String? videoTitle,
  });
}

/// @nodoc
class __$$QuizResultImplCopyWithImpl<$Res>
    extends _$QuizResultCopyWithImpl<$Res, _$QuizResultImpl>
    implements _$$QuizResultImplCopyWith<$Res> {
  __$$QuizResultImplCopyWithImpl(
    _$QuizResultImpl _value,
    $Res Function(_$QuizResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? scorePercentage = null,
    Object? passed = null,
    Object? questionResults = null,
    Object? timeTaken = null,
    Object? evaluatedAt = null,
    Object? evaluatedOffline = null,
    Object? conceptAnalysis = freezed,
    Object? weakAreas = freezed,
    Object? strongAreas = freezed,
    Object? recommendation = freezed,
    Object? questions = freezed,
    Object? answers = freezed,
    Object? quizLevel = freezed,
    Object? subjectName = freezed,
    Object? chapterName = freezed,
    Object? topicName = freezed,
    Object? videoTitle = freezed,
  }) {
    return _then(
      _$QuizResultImpl(
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalQuestions: null == totalQuestions
            ? _value.totalQuestions
            : totalQuestions // ignore: cast_nullable_to_non_nullable
                  as int,
        correctAnswers: null == correctAnswers
            ? _value.correctAnswers
            : correctAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
        scorePercentage: null == scorePercentage
            ? _value.scorePercentage
            : scorePercentage // ignore: cast_nullable_to_non_nullable
                  as double,
        passed: null == passed
            ? _value.passed
            : passed // ignore: cast_nullable_to_non_nullable
                  as bool,
        questionResults: null == questionResults
            ? _value._questionResults
            : questionResults // ignore: cast_nullable_to_non_nullable
                  as Map<String, bool>,
        timeTaken: null == timeTaken
            ? _value.timeTaken
            : timeTaken // ignore: cast_nullable_to_non_nullable
                  as Duration,
        evaluatedAt: null == evaluatedAt
            ? _value.evaluatedAt
            : evaluatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        evaluatedOffline: null == evaluatedOffline
            ? _value.evaluatedOffline
            : evaluatedOffline // ignore: cast_nullable_to_non_nullable
                  as bool,
        conceptAnalysis: freezed == conceptAnalysis
            ? _value._conceptAnalysis
            : conceptAnalysis // ignore: cast_nullable_to_non_nullable
                  as Map<String, ConceptScore>?,
        weakAreas: freezed == weakAreas
            ? _value._weakAreas
            : weakAreas // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        strongAreas: freezed == strongAreas
            ? _value._strongAreas
            : strongAreas // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        recommendation: freezed == recommendation
            ? _value.recommendation
            : recommendation // ignore: cast_nullable_to_non_nullable
                  as String?,
        questions: freezed == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<Question>?,
        answers: freezed == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        quizLevel: freezed == quizLevel
            ? _value.quizLevel
            : quizLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        subjectName: freezed == subjectName
            ? _value.subjectName
            : subjectName // ignore: cast_nullable_to_non_nullable
                  as String?,
        chapterName: freezed == chapterName
            ? _value.chapterName
            : chapterName // ignore: cast_nullable_to_non_nullable
                  as String?,
        topicName: freezed == topicName
            ? _value.topicName
            : topicName // ignore: cast_nullable_to_non_nullable
                  as String?,
        videoTitle: freezed == videoTitle
            ? _value.videoTitle
            : videoTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$QuizResultImpl extends _QuizResult {
  const _$QuizResultImpl({
    required this.sessionId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.scorePercentage,
    required this.passed,
    required final Map<String, bool> questionResults,
    required this.timeTaken,
    required this.evaluatedAt,
    this.evaluatedOffline = false,
    final Map<String, ConceptScore>? conceptAnalysis,
    final List<String>? weakAreas,
    final List<String>? strongAreas,
    this.recommendation,
    final List<Question>? questions,
    final Map<String, String>? answers,
    this.quizLevel,
    this.subjectName,
    this.chapterName,
    this.topicName,
    this.videoTitle,
  }) : _questionResults = questionResults,
       _conceptAnalysis = conceptAnalysis,
       _weakAreas = weakAreas,
       _strongAreas = strongAreas,
       _questions = questions,
       _answers = answers,
       super._();

  @override
  final String sessionId;
  @override
  final int totalQuestions;
  @override
  final int correctAnswers;
  @override
  final double scorePercentage;
  @override
  final bool passed;
  final Map<String, bool> _questionResults;
  @override
  Map<String, bool> get questionResults {
    if (_questionResults is EqualUnmodifiableMapView) return _questionResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_questionResults);
  }

  @override
  final Duration timeTaken;
  @override
  final DateTime evaluatedAt;
  @override
  @JsonKey()
  final bool evaluatedOffline;
  final Map<String, ConceptScore>? _conceptAnalysis;
  @override
  Map<String, ConceptScore>? get conceptAnalysis {
    final value = _conceptAnalysis;
    if (value == null) return null;
    if (_conceptAnalysis is EqualUnmodifiableMapView) return _conceptAnalysis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _weakAreas;
  @override
  List<String>? get weakAreas {
    final value = _weakAreas;
    if (value == null) return null;
    if (_weakAreas is EqualUnmodifiableListView) return _weakAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _strongAreas;
  @override
  List<String>? get strongAreas {
    final value = _strongAreas;
    if (value == null) return null;
    if (_strongAreas is EqualUnmodifiableListView) return _strongAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? recommendation;
  // Questions data for detailed review (populated from quiz attempts)
  final List<Question>? _questions;
  // Questions data for detailed review (populated from quiz attempts)
  @override
  List<Question>? get questions {
    final value = _questions;
    if (value == null) return null;
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // Student's answers for detailed review (populated from quiz attempts)
  final Map<String, String>? _answers;
  // Student's answers for detailed review (populated from quiz attempts)
  @override
  Map<String, String>? get answers {
    final value = _answers;
    if (value == null) return null;
    if (_answers is EqualUnmodifiableMapView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Breadcrumb metadata for quiz context display
  @override
  final String? quizLevel;
  @override
  final String? subjectName;
  @override
  final String? chapterName;
  @override
  final String? topicName;
  @override
  final String? videoTitle;

  @override
  String toString() {
    return 'QuizResult(sessionId: $sessionId, totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, scorePercentage: $scorePercentage, passed: $passed, questionResults: $questionResults, timeTaken: $timeTaken, evaluatedAt: $evaluatedAt, evaluatedOffline: $evaluatedOffline, conceptAnalysis: $conceptAnalysis, weakAreas: $weakAreas, strongAreas: $strongAreas, recommendation: $recommendation, questions: $questions, answers: $answers, quizLevel: $quizLevel, subjectName: $subjectName, chapterName: $chapterName, topicName: $topicName, videoTitle: $videoTitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizResultImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.scorePercentage, scorePercentage) ||
                other.scorePercentage == scorePercentage) &&
            (identical(other.passed, passed) || other.passed == passed) &&
            const DeepCollectionEquality().equals(
              other._questionResults,
              _questionResults,
            ) &&
            (identical(other.timeTaken, timeTaken) ||
                other.timeTaken == timeTaken) &&
            (identical(other.evaluatedAt, evaluatedAt) ||
                other.evaluatedAt == evaluatedAt) &&
            (identical(other.evaluatedOffline, evaluatedOffline) ||
                other.evaluatedOffline == evaluatedOffline) &&
            const DeepCollectionEquality().equals(
              other._conceptAnalysis,
              _conceptAnalysis,
            ) &&
            const DeepCollectionEquality().equals(
              other._weakAreas,
              _weakAreas,
            ) &&
            const DeepCollectionEquality().equals(
              other._strongAreas,
              _strongAreas,
            ) &&
            (identical(other.recommendation, recommendation) ||
                other.recommendation == recommendation) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(other.quizLevel, quizLevel) ||
                other.quizLevel == quizLevel) &&
            (identical(other.subjectName, subjectName) ||
                other.subjectName == subjectName) &&
            (identical(other.chapterName, chapterName) ||
                other.chapterName == chapterName) &&
            (identical(other.topicName, topicName) ||
                other.topicName == topicName) &&
            (identical(other.videoTitle, videoTitle) ||
                other.videoTitle == videoTitle));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    sessionId,
    totalQuestions,
    correctAnswers,
    scorePercentage,
    passed,
    const DeepCollectionEquality().hash(_questionResults),
    timeTaken,
    evaluatedAt,
    evaluatedOffline,
    const DeepCollectionEquality().hash(_conceptAnalysis),
    const DeepCollectionEquality().hash(_weakAreas),
    const DeepCollectionEquality().hash(_strongAreas),
    recommendation,
    const DeepCollectionEquality().hash(_questions),
    const DeepCollectionEquality().hash(_answers),
    quizLevel,
    subjectName,
    chapterName,
    topicName,
    videoTitle,
  ]);

  /// Create a copy of QuizResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizResultImplCopyWith<_$QuizResultImpl> get copyWith =>
      __$$QuizResultImplCopyWithImpl<_$QuizResultImpl>(this, _$identity);
}

abstract class _QuizResult extends QuizResult {
  const factory _QuizResult({
    required final String sessionId,
    required final int totalQuestions,
    required final int correctAnswers,
    required final double scorePercentage,
    required final bool passed,
    required final Map<String, bool> questionResults,
    required final Duration timeTaken,
    required final DateTime evaluatedAt,
    final bool evaluatedOffline,
    final Map<String, ConceptScore>? conceptAnalysis,
    final List<String>? weakAreas,
    final List<String>? strongAreas,
    final String? recommendation,
    final List<Question>? questions,
    final Map<String, String>? answers,
    final String? quizLevel,
    final String? subjectName,
    final String? chapterName,
    final String? topicName,
    final String? videoTitle,
  }) = _$QuizResultImpl;
  const _QuizResult._() : super._();

  @override
  String get sessionId;
  @override
  int get totalQuestions;
  @override
  int get correctAnswers;
  @override
  double get scorePercentage;
  @override
  bool get passed;
  @override
  Map<String, bool> get questionResults;
  @override
  Duration get timeTaken;
  @override
  DateTime get evaluatedAt;
  @override
  bool get evaluatedOffline;
  @override
  Map<String, ConceptScore>? get conceptAnalysis;
  @override
  List<String>? get weakAreas;
  @override
  List<String>? get strongAreas;
  @override
  String? get recommendation; // Questions data for detailed review (populated from quiz attempts)
  @override
  List<Question>? get questions; // Student's answers for detailed review (populated from quiz attempts)
  @override
  Map<String, String>? get answers; // Breadcrumb metadata for quiz context display
  @override
  String? get quizLevel;
  @override
  String? get subjectName;
  @override
  String? get chapterName;
  @override
  String? get topicName;
  @override
  String? get videoTitle;

  /// Create a copy of QuizResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizResultImplCopyWith<_$QuizResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ConceptScore {
  String get concept => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get correct => throw _privateConstructorUsedError;

  /// Create a copy of ConceptScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConceptScoreCopyWith<ConceptScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConceptScoreCopyWith<$Res> {
  factory $ConceptScoreCopyWith(
    ConceptScore value,
    $Res Function(ConceptScore) then,
  ) = _$ConceptScoreCopyWithImpl<$Res, ConceptScore>;
  @useResult
  $Res call({String concept, int total, int correct});
}

/// @nodoc
class _$ConceptScoreCopyWithImpl<$Res, $Val extends ConceptScore>
    implements $ConceptScoreCopyWith<$Res> {
  _$ConceptScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConceptScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? concept = null,
    Object? total = null,
    Object? correct = null,
  }) {
    return _then(
      _value.copyWith(
            concept: null == concept
                ? _value.concept
                : concept // ignore: cast_nullable_to_non_nullable
                      as String,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            correct: null == correct
                ? _value.correct
                : correct // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConceptScoreImplCopyWith<$Res>
    implements $ConceptScoreCopyWith<$Res> {
  factory _$$ConceptScoreImplCopyWith(
    _$ConceptScoreImpl value,
    $Res Function(_$ConceptScoreImpl) then,
  ) = __$$ConceptScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String concept, int total, int correct});
}

/// @nodoc
class __$$ConceptScoreImplCopyWithImpl<$Res>
    extends _$ConceptScoreCopyWithImpl<$Res, _$ConceptScoreImpl>
    implements _$$ConceptScoreImplCopyWith<$Res> {
  __$$ConceptScoreImplCopyWithImpl(
    _$ConceptScoreImpl _value,
    $Res Function(_$ConceptScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConceptScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? concept = null,
    Object? total = null,
    Object? correct = null,
  }) {
    return _then(
      _$ConceptScoreImpl(
        concept: null == concept
            ? _value.concept
            : concept // ignore: cast_nullable_to_non_nullable
                  as String,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        correct: null == correct
            ? _value.correct
            : correct // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$ConceptScoreImpl extends _ConceptScore {
  const _$ConceptScoreImpl({
    required this.concept,
    required this.total,
    required this.correct,
  }) : super._();

  @override
  final String concept;
  @override
  final int total;
  @override
  final int correct;

  @override
  String toString() {
    return 'ConceptScore(concept: $concept, total: $total, correct: $correct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConceptScoreImpl &&
            (identical(other.concept, concept) || other.concept == concept) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.correct, correct) || other.correct == correct));
  }

  @override
  int get hashCode => Object.hash(runtimeType, concept, total, correct);

  /// Create a copy of ConceptScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConceptScoreImplCopyWith<_$ConceptScoreImpl> get copyWith =>
      __$$ConceptScoreImplCopyWithImpl<_$ConceptScoreImpl>(this, _$identity);
}

abstract class _ConceptScore extends ConceptScore {
  const factory _ConceptScore({
    required final String concept,
    required final int total,
    required final int correct,
  }) = _$ConceptScoreImpl;
  const _ConceptScore._() : super._();

  @override
  String get concept;
  @override
  int get total;
  @override
  int get correct;

  /// Create a copy of ConceptScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConceptScoreImplCopyWith<_$ConceptScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
