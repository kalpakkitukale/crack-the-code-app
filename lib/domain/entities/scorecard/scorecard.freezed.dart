// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scorecard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Scorecard {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  ScorecardLevel get level => throw _privateConstructorUsedError;
  String get entityId => throw _privateConstructorUsedError;
  int get totalQuizzes => throw _privateConstructorUsedError;
  int get completedQuizzes => throw _privateConstructorUsedError;
  int get passedQuizzes => throw _privateConstructorUsedError;
  double get averageScore => throw _privateConstructorUsedError;
  int get totalPoints => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  int get totalTimeSpent => throw _privateConstructorUsedError;
  int get perfectScores => throw _privateConstructorUsedError;
  List<double> get recentScores => throw _privateConstructorUsedError;
  Map<String, ConceptPerformance>? get conceptPerformance =>
      throw _privateConstructorUsedError;
  Map<String, int>? get difficultyBreakdown =>
      throw _privateConstructorUsedError;

  /// Create a copy of Scorecard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScorecardCopyWith<Scorecard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScorecardCopyWith<$Res> {
  factory $ScorecardCopyWith(Scorecard value, $Res Function(Scorecard) then) =
      _$ScorecardCopyWithImpl<$Res, Scorecard>;
  @useResult
  $Res call({
    String id,
    String studentId,
    ScorecardLevel level,
    String entityId,
    int totalQuizzes,
    int completedQuizzes,
    int passedQuizzes,
    double averageScore,
    int totalPoints,
    DateTime lastUpdated,
    int totalTimeSpent,
    int perfectScores,
    List<double> recentScores,
    Map<String, ConceptPerformance>? conceptPerformance,
    Map<String, int>? difficultyBreakdown,
  });
}

/// @nodoc
class _$ScorecardCopyWithImpl<$Res, $Val extends Scorecard>
    implements $ScorecardCopyWith<$Res> {
  _$ScorecardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Scorecard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? level = null,
    Object? entityId = null,
    Object? totalQuizzes = null,
    Object? completedQuizzes = null,
    Object? passedQuizzes = null,
    Object? averageScore = null,
    Object? totalPoints = null,
    Object? lastUpdated = null,
    Object? totalTimeSpent = null,
    Object? perfectScores = null,
    Object? recentScores = null,
    Object? conceptPerformance = freezed,
    Object? difficultyBreakdown = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as ScorecardLevel,
            entityId: null == entityId
                ? _value.entityId
                : entityId // ignore: cast_nullable_to_non_nullable
                      as String,
            totalQuizzes: null == totalQuizzes
                ? _value.totalQuizzes
                : totalQuizzes // ignore: cast_nullable_to_non_nullable
                      as int,
            completedQuizzes: null == completedQuizzes
                ? _value.completedQuizzes
                : completedQuizzes // ignore: cast_nullable_to_non_nullable
                      as int,
            passedQuizzes: null == passedQuizzes
                ? _value.passedQuizzes
                : passedQuizzes // ignore: cast_nullable_to_non_nullable
                      as int,
            averageScore: null == averageScore
                ? _value.averageScore
                : averageScore // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPoints: null == totalPoints
                ? _value.totalPoints
                : totalPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalTimeSpent: null == totalTimeSpent
                ? _value.totalTimeSpent
                : totalTimeSpent // ignore: cast_nullable_to_non_nullable
                      as int,
            perfectScores: null == perfectScores
                ? _value.perfectScores
                : perfectScores // ignore: cast_nullable_to_non_nullable
                      as int,
            recentScores: null == recentScores
                ? _value.recentScores
                : recentScores // ignore: cast_nullable_to_non_nullable
                      as List<double>,
            conceptPerformance: freezed == conceptPerformance
                ? _value.conceptPerformance
                : conceptPerformance // ignore: cast_nullable_to_non_nullable
                      as Map<String, ConceptPerformance>?,
            difficultyBreakdown: freezed == difficultyBreakdown
                ? _value.difficultyBreakdown
                : difficultyBreakdown // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScorecardImplCopyWith<$Res>
    implements $ScorecardCopyWith<$Res> {
  factory _$$ScorecardImplCopyWith(
    _$ScorecardImpl value,
    $Res Function(_$ScorecardImpl) then,
  ) = __$$ScorecardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String studentId,
    ScorecardLevel level,
    String entityId,
    int totalQuizzes,
    int completedQuizzes,
    int passedQuizzes,
    double averageScore,
    int totalPoints,
    DateTime lastUpdated,
    int totalTimeSpent,
    int perfectScores,
    List<double> recentScores,
    Map<String, ConceptPerformance>? conceptPerformance,
    Map<String, int>? difficultyBreakdown,
  });
}

/// @nodoc
class __$$ScorecardImplCopyWithImpl<$Res>
    extends _$ScorecardCopyWithImpl<$Res, _$ScorecardImpl>
    implements _$$ScorecardImplCopyWith<$Res> {
  __$$ScorecardImplCopyWithImpl(
    _$ScorecardImpl _value,
    $Res Function(_$ScorecardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Scorecard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? level = null,
    Object? entityId = null,
    Object? totalQuizzes = null,
    Object? completedQuizzes = null,
    Object? passedQuizzes = null,
    Object? averageScore = null,
    Object? totalPoints = null,
    Object? lastUpdated = null,
    Object? totalTimeSpent = null,
    Object? perfectScores = null,
    Object? recentScores = null,
    Object? conceptPerformance = freezed,
    Object? difficultyBreakdown = freezed,
  }) {
    return _then(
      _$ScorecardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as ScorecardLevel,
        entityId: null == entityId
            ? _value.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalQuizzes: null == totalQuizzes
            ? _value.totalQuizzes
            : totalQuizzes // ignore: cast_nullable_to_non_nullable
                  as int,
        completedQuizzes: null == completedQuizzes
            ? _value.completedQuizzes
            : completedQuizzes // ignore: cast_nullable_to_non_nullable
                  as int,
        passedQuizzes: null == passedQuizzes
            ? _value.passedQuizzes
            : passedQuizzes // ignore: cast_nullable_to_non_nullable
                  as int,
        averageScore: null == averageScore
            ? _value.averageScore
            : averageScore // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPoints: null == totalPoints
            ? _value.totalPoints
            : totalPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalTimeSpent: null == totalTimeSpent
            ? _value.totalTimeSpent
            : totalTimeSpent // ignore: cast_nullable_to_non_nullable
                  as int,
        perfectScores: null == perfectScores
            ? _value.perfectScores
            : perfectScores // ignore: cast_nullable_to_non_nullable
                  as int,
        recentScores: null == recentScores
            ? _value._recentScores
            : recentScores // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        conceptPerformance: freezed == conceptPerformance
            ? _value._conceptPerformance
            : conceptPerformance // ignore: cast_nullable_to_non_nullable
                  as Map<String, ConceptPerformance>?,
        difficultyBreakdown: freezed == difficultyBreakdown
            ? _value._difficultyBreakdown
            : difficultyBreakdown // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
      ),
    );
  }
}

/// @nodoc

class _$ScorecardImpl extends _Scorecard {
  const _$ScorecardImpl({
    required this.id,
    required this.studentId,
    required this.level,
    required this.entityId,
    required this.totalQuizzes,
    required this.completedQuizzes,
    required this.passedQuizzes,
    required this.averageScore,
    required this.totalPoints,
    required this.lastUpdated,
    this.totalTimeSpent = 0,
    this.perfectScores = 0,
    final List<double> recentScores = const [],
    final Map<String, ConceptPerformance>? conceptPerformance,
    final Map<String, int>? difficultyBreakdown,
  }) : _recentScores = recentScores,
       _conceptPerformance = conceptPerformance,
       _difficultyBreakdown = difficultyBreakdown,
       super._();

  @override
  final String id;
  @override
  final String studentId;
  @override
  final ScorecardLevel level;
  @override
  final String entityId;
  @override
  final int totalQuizzes;
  @override
  final int completedQuizzes;
  @override
  final int passedQuizzes;
  @override
  final double averageScore;
  @override
  final int totalPoints;
  @override
  final DateTime lastUpdated;
  @override
  @JsonKey()
  final int totalTimeSpent;
  @override
  @JsonKey()
  final int perfectScores;
  final List<double> _recentScores;
  @override
  @JsonKey()
  List<double> get recentScores {
    if (_recentScores is EqualUnmodifiableListView) return _recentScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentScores);
  }

  final Map<String, ConceptPerformance>? _conceptPerformance;
  @override
  Map<String, ConceptPerformance>? get conceptPerformance {
    final value = _conceptPerformance;
    if (value == null) return null;
    if (_conceptPerformance is EqualUnmodifiableMapView)
      return _conceptPerformance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, int>? _difficultyBreakdown;
  @override
  Map<String, int>? get difficultyBreakdown {
    final value = _difficultyBreakdown;
    if (value == null) return null;
    if (_difficultyBreakdown is EqualUnmodifiableMapView)
      return _difficultyBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Scorecard(id: $id, studentId: $studentId, level: $level, entityId: $entityId, totalQuizzes: $totalQuizzes, completedQuizzes: $completedQuizzes, passedQuizzes: $passedQuizzes, averageScore: $averageScore, totalPoints: $totalPoints, lastUpdated: $lastUpdated, totalTimeSpent: $totalTimeSpent, perfectScores: $perfectScores, recentScores: $recentScores, conceptPerformance: $conceptPerformance, difficultyBreakdown: $difficultyBreakdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScorecardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.totalQuizzes, totalQuizzes) ||
                other.totalQuizzes == totalQuizzes) &&
            (identical(other.completedQuizzes, completedQuizzes) ||
                other.completedQuizzes == completedQuizzes) &&
            (identical(other.passedQuizzes, passedQuizzes) ||
                other.passedQuizzes == passedQuizzes) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.totalTimeSpent, totalTimeSpent) ||
                other.totalTimeSpent == totalTimeSpent) &&
            (identical(other.perfectScores, perfectScores) ||
                other.perfectScores == perfectScores) &&
            const DeepCollectionEquality().equals(
              other._recentScores,
              _recentScores,
            ) &&
            const DeepCollectionEquality().equals(
              other._conceptPerformance,
              _conceptPerformance,
            ) &&
            const DeepCollectionEquality().equals(
              other._difficultyBreakdown,
              _difficultyBreakdown,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentId,
    level,
    entityId,
    totalQuizzes,
    completedQuizzes,
    passedQuizzes,
    averageScore,
    totalPoints,
    lastUpdated,
    totalTimeSpent,
    perfectScores,
    const DeepCollectionEquality().hash(_recentScores),
    const DeepCollectionEquality().hash(_conceptPerformance),
    const DeepCollectionEquality().hash(_difficultyBreakdown),
  );

  /// Create a copy of Scorecard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScorecardImplCopyWith<_$ScorecardImpl> get copyWith =>
      __$$ScorecardImplCopyWithImpl<_$ScorecardImpl>(this, _$identity);
}

abstract class _Scorecard extends Scorecard {
  const factory _Scorecard({
    required final String id,
    required final String studentId,
    required final ScorecardLevel level,
    required final String entityId,
    required final int totalQuizzes,
    required final int completedQuizzes,
    required final int passedQuizzes,
    required final double averageScore,
    required final int totalPoints,
    required final DateTime lastUpdated,
    final int totalTimeSpent,
    final int perfectScores,
    final List<double> recentScores,
    final Map<String, ConceptPerformance>? conceptPerformance,
    final Map<String, int>? difficultyBreakdown,
  }) = _$ScorecardImpl;
  const _Scorecard._() : super._();

  @override
  String get id;
  @override
  String get studentId;
  @override
  ScorecardLevel get level;
  @override
  String get entityId;
  @override
  int get totalQuizzes;
  @override
  int get completedQuizzes;
  @override
  int get passedQuizzes;
  @override
  double get averageScore;
  @override
  int get totalPoints;
  @override
  DateTime get lastUpdated;
  @override
  int get totalTimeSpent;
  @override
  int get perfectScores;
  @override
  List<double> get recentScores;
  @override
  Map<String, ConceptPerformance>? get conceptPerformance;
  @override
  Map<String, int>? get difficultyBreakdown;

  /// Create a copy of Scorecard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScorecardImplCopyWith<_$ScorecardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ConceptPerformance {
  String get concept => throw _privateConstructorUsedError;
  int get totalQuestions => throw _privateConstructorUsedError;
  int get correctAnswers => throw _privateConstructorUsedError;
  int get attempts => throw _privateConstructorUsedError;

  /// Create a copy of ConceptPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConceptPerformanceCopyWith<ConceptPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConceptPerformanceCopyWith<$Res> {
  factory $ConceptPerformanceCopyWith(
    ConceptPerformance value,
    $Res Function(ConceptPerformance) then,
  ) = _$ConceptPerformanceCopyWithImpl<$Res, ConceptPerformance>;
  @useResult
  $Res call({
    String concept,
    int totalQuestions,
    int correctAnswers,
    int attempts,
  });
}

/// @nodoc
class _$ConceptPerformanceCopyWithImpl<$Res, $Val extends ConceptPerformance>
    implements $ConceptPerformanceCopyWith<$Res> {
  _$ConceptPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConceptPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? concept = null,
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? attempts = null,
  }) {
    return _then(
      _value.copyWith(
            concept: null == concept
                ? _value.concept
                : concept // ignore: cast_nullable_to_non_nullable
                      as String,
            totalQuestions: null == totalQuestions
                ? _value.totalQuestions
                : totalQuestions // ignore: cast_nullable_to_non_nullable
                      as int,
            correctAnswers: null == correctAnswers
                ? _value.correctAnswers
                : correctAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
            attempts: null == attempts
                ? _value.attempts
                : attempts // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConceptPerformanceImplCopyWith<$Res>
    implements $ConceptPerformanceCopyWith<$Res> {
  factory _$$ConceptPerformanceImplCopyWith(
    _$ConceptPerformanceImpl value,
    $Res Function(_$ConceptPerformanceImpl) then,
  ) = __$$ConceptPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String concept,
    int totalQuestions,
    int correctAnswers,
    int attempts,
  });
}

/// @nodoc
class __$$ConceptPerformanceImplCopyWithImpl<$Res>
    extends _$ConceptPerformanceCopyWithImpl<$Res, _$ConceptPerformanceImpl>
    implements _$$ConceptPerformanceImplCopyWith<$Res> {
  __$$ConceptPerformanceImplCopyWithImpl(
    _$ConceptPerformanceImpl _value,
    $Res Function(_$ConceptPerformanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConceptPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? concept = null,
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? attempts = null,
  }) {
    return _then(
      _$ConceptPerformanceImpl(
        concept: null == concept
            ? _value.concept
            : concept // ignore: cast_nullable_to_non_nullable
                  as String,
        totalQuestions: null == totalQuestions
            ? _value.totalQuestions
            : totalQuestions // ignore: cast_nullable_to_non_nullable
                  as int,
        correctAnswers: null == correctAnswers
            ? _value.correctAnswers
            : correctAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
        attempts: null == attempts
            ? _value.attempts
            : attempts // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$ConceptPerformanceImpl extends _ConceptPerformance {
  const _$ConceptPerformanceImpl({
    required this.concept,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.attempts,
  }) : super._();

  @override
  final String concept;
  @override
  final int totalQuestions;
  @override
  final int correctAnswers;
  @override
  final int attempts;

  @override
  String toString() {
    return 'ConceptPerformance(concept: $concept, totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, attempts: $attempts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConceptPerformanceImpl &&
            (identical(other.concept, concept) || other.concept == concept) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.attempts, attempts) ||
                other.attempts == attempts));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    concept,
    totalQuestions,
    correctAnswers,
    attempts,
  );

  /// Create a copy of ConceptPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConceptPerformanceImplCopyWith<_$ConceptPerformanceImpl> get copyWith =>
      __$$ConceptPerformanceImplCopyWithImpl<_$ConceptPerformanceImpl>(
        this,
        _$identity,
      );
}

abstract class _ConceptPerformance extends ConceptPerformance {
  const factory _ConceptPerformance({
    required final String concept,
    required final int totalQuestions,
    required final int correctAnswers,
    required final int attempts,
  }) = _$ConceptPerformanceImpl;
  const _ConceptPerformance._() : super._();

  @override
  String get concept;
  @override
  int get totalQuestions;
  @override
  int get correctAnswers;
  @override
  int get attempts;

  /// Create a copy of ConceptPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConceptPerformanceImplCopyWith<_$ConceptPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
