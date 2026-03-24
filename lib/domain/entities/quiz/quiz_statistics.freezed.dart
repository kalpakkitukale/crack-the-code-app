// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QuizStatistics {
  /// Total number of quiz attempts across all subjects
  int get totalAttempts => throw _privateConstructorUsedError;

  /// Average score across all quizzes (0-100)
  double get averageScore => throw _privateConstructorUsedError;

  /// Current consecutive days with at least one quiz
  int get currentStreak => throw _privateConstructorUsedError;

  /// Total time spent on quizzes across all attempts
  Duration get totalTimeSpent => throw _privateConstructorUsedError;

  /// Statistics broken down by subject
  Map<String, SubjectStatistics> get subjectBreakdown =>
      throw _privateConstructorUsedError;

  /// List of topic IDs where performance is weak (< 60%)
  List<String> get weakTopics => throw _privateConstructorUsedError;

  /// List of topic IDs where performance is strong (>= 80%)
  List<String> get strongTopics => throw _privateConstructorUsedError;

  /// Date of the most recent quiz attempt
  DateTime? get lastQuizDate => throw _privateConstructorUsedError;

  /// Highest score achieved across all quizzes (0-100)
  int? get bestScore => throw _privateConstructorUsedError;

  /// Number of quizzes with 100% score
  int get perfectScoreCount => throw _privateConstructorUsedError;

  /// Total number of passed quizzes
  int get totalPassed => throw _privateConstructorUsedError;

  /// Total number of failed quizzes
  int get totalFailed => throw _privateConstructorUsedError;

  /// Longest streak achieved (consecutive days)
  int get longestStreak => throw _privateConstructorUsedError;

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizStatisticsCopyWith<QuizStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizStatisticsCopyWith<$Res> {
  factory $QuizStatisticsCopyWith(
    QuizStatistics value,
    $Res Function(QuizStatistics) then,
  ) = _$QuizStatisticsCopyWithImpl<$Res, QuizStatistics>;
  @useResult
  $Res call({
    int totalAttempts,
    double averageScore,
    int currentStreak,
    Duration totalTimeSpent,
    Map<String, SubjectStatistics> subjectBreakdown,
    List<String> weakTopics,
    List<String> strongTopics,
    DateTime? lastQuizDate,
    int? bestScore,
    int perfectScoreCount,
    int totalPassed,
    int totalFailed,
    int longestStreak,
  });
}

/// @nodoc
class _$QuizStatisticsCopyWithImpl<$Res, $Val extends QuizStatistics>
    implements $QuizStatisticsCopyWith<$Res> {
  _$QuizStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAttempts = null,
    Object? averageScore = null,
    Object? currentStreak = null,
    Object? totalTimeSpent = null,
    Object? subjectBreakdown = null,
    Object? weakTopics = null,
    Object? strongTopics = null,
    Object? lastQuizDate = freezed,
    Object? bestScore = freezed,
    Object? perfectScoreCount = null,
    Object? totalPassed = null,
    Object? totalFailed = null,
    Object? longestStreak = null,
  }) {
    return _then(
      _value.copyWith(
            totalAttempts: null == totalAttempts
                ? _value.totalAttempts
                : totalAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
            averageScore: null == averageScore
                ? _value.averageScore
                : averageScore // ignore: cast_nullable_to_non_nullable
                      as double,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            totalTimeSpent: null == totalTimeSpent
                ? _value.totalTimeSpent
                : totalTimeSpent // ignore: cast_nullable_to_non_nullable
                      as Duration,
            subjectBreakdown: null == subjectBreakdown
                ? _value.subjectBreakdown
                : subjectBreakdown // ignore: cast_nullable_to_non_nullable
                      as Map<String, SubjectStatistics>,
            weakTopics: null == weakTopics
                ? _value.weakTopics
                : weakTopics // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            strongTopics: null == strongTopics
                ? _value.strongTopics
                : strongTopics // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            lastQuizDate: freezed == lastQuizDate
                ? _value.lastQuizDate
                : lastQuizDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            bestScore: freezed == bestScore
                ? _value.bestScore
                : bestScore // ignore: cast_nullable_to_non_nullable
                      as int?,
            perfectScoreCount: null == perfectScoreCount
                ? _value.perfectScoreCount
                : perfectScoreCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPassed: null == totalPassed
                ? _value.totalPassed
                : totalPassed // ignore: cast_nullable_to_non_nullable
                      as int,
            totalFailed: null == totalFailed
                ? _value.totalFailed
                : totalFailed // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizStatisticsImplCopyWith<$Res>
    implements $QuizStatisticsCopyWith<$Res> {
  factory _$$QuizStatisticsImplCopyWith(
    _$QuizStatisticsImpl value,
    $Res Function(_$QuizStatisticsImpl) then,
  ) = __$$QuizStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalAttempts,
    double averageScore,
    int currentStreak,
    Duration totalTimeSpent,
    Map<String, SubjectStatistics> subjectBreakdown,
    List<String> weakTopics,
    List<String> strongTopics,
    DateTime? lastQuizDate,
    int? bestScore,
    int perfectScoreCount,
    int totalPassed,
    int totalFailed,
    int longestStreak,
  });
}

/// @nodoc
class __$$QuizStatisticsImplCopyWithImpl<$Res>
    extends _$QuizStatisticsCopyWithImpl<$Res, _$QuizStatisticsImpl>
    implements _$$QuizStatisticsImplCopyWith<$Res> {
  __$$QuizStatisticsImplCopyWithImpl(
    _$QuizStatisticsImpl _value,
    $Res Function(_$QuizStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAttempts = null,
    Object? averageScore = null,
    Object? currentStreak = null,
    Object? totalTimeSpent = null,
    Object? subjectBreakdown = null,
    Object? weakTopics = null,
    Object? strongTopics = null,
    Object? lastQuizDate = freezed,
    Object? bestScore = freezed,
    Object? perfectScoreCount = null,
    Object? totalPassed = null,
    Object? totalFailed = null,
    Object? longestStreak = null,
  }) {
    return _then(
      _$QuizStatisticsImpl(
        totalAttempts: null == totalAttempts
            ? _value.totalAttempts
            : totalAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
        averageScore: null == averageScore
            ? _value.averageScore
            : averageScore // ignore: cast_nullable_to_non_nullable
                  as double,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        totalTimeSpent: null == totalTimeSpent
            ? _value.totalTimeSpent
            : totalTimeSpent // ignore: cast_nullable_to_non_nullable
                  as Duration,
        subjectBreakdown: null == subjectBreakdown
            ? _value._subjectBreakdown
            : subjectBreakdown // ignore: cast_nullable_to_non_nullable
                  as Map<String, SubjectStatistics>,
        weakTopics: null == weakTopics
            ? _value._weakTopics
            : weakTopics // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        strongTopics: null == strongTopics
            ? _value._strongTopics
            : strongTopics // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        lastQuizDate: freezed == lastQuizDate
            ? _value.lastQuizDate
            : lastQuizDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        bestScore: freezed == bestScore
            ? _value.bestScore
            : bestScore // ignore: cast_nullable_to_non_nullable
                  as int?,
        perfectScoreCount: null == perfectScoreCount
            ? _value.perfectScoreCount
            : perfectScoreCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPassed: null == totalPassed
            ? _value.totalPassed
            : totalPassed // ignore: cast_nullable_to_non_nullable
                  as int,
        totalFailed: null == totalFailed
            ? _value.totalFailed
            : totalFailed // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$QuizStatisticsImpl extends _QuizStatistics {
  const _$QuizStatisticsImpl({
    required this.totalAttempts,
    required this.averageScore,
    required this.currentStreak,
    required this.totalTimeSpent,
    required final Map<String, SubjectStatistics> subjectBreakdown,
    required final List<String> weakTopics,
    required final List<String> strongTopics,
    this.lastQuizDate,
    this.bestScore,
    this.perfectScoreCount = 0,
    this.totalPassed = 0,
    this.totalFailed = 0,
    this.longestStreak = 0,
  }) : _subjectBreakdown = subjectBreakdown,
       _weakTopics = weakTopics,
       _strongTopics = strongTopics,
       super._();

  /// Total number of quiz attempts across all subjects
  @override
  final int totalAttempts;

  /// Average score across all quizzes (0-100)
  @override
  final double averageScore;

  /// Current consecutive days with at least one quiz
  @override
  final int currentStreak;

  /// Total time spent on quizzes across all attempts
  @override
  final Duration totalTimeSpent;

  /// Statistics broken down by subject
  final Map<String, SubjectStatistics> _subjectBreakdown;

  /// Statistics broken down by subject
  @override
  Map<String, SubjectStatistics> get subjectBreakdown {
    if (_subjectBreakdown is EqualUnmodifiableMapView) return _subjectBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_subjectBreakdown);
  }

  /// List of topic IDs where performance is weak (< 60%)
  final List<String> _weakTopics;

  /// List of topic IDs where performance is weak (< 60%)
  @override
  List<String> get weakTopics {
    if (_weakTopics is EqualUnmodifiableListView) return _weakTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weakTopics);
  }

  /// List of topic IDs where performance is strong (>= 80%)
  final List<String> _strongTopics;

  /// List of topic IDs where performance is strong (>= 80%)
  @override
  List<String> get strongTopics {
    if (_strongTopics is EqualUnmodifiableListView) return _strongTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_strongTopics);
  }

  /// Date of the most recent quiz attempt
  @override
  final DateTime? lastQuizDate;

  /// Highest score achieved across all quizzes (0-100)
  @override
  final int? bestScore;

  /// Number of quizzes with 100% score
  @override
  @JsonKey()
  final int perfectScoreCount;

  /// Total number of passed quizzes
  @override
  @JsonKey()
  final int totalPassed;

  /// Total number of failed quizzes
  @override
  @JsonKey()
  final int totalFailed;

  /// Longest streak achieved (consecutive days)
  @override
  @JsonKey()
  final int longestStreak;

  @override
  String toString() {
    return 'QuizStatistics(totalAttempts: $totalAttempts, averageScore: $averageScore, currentStreak: $currentStreak, totalTimeSpent: $totalTimeSpent, subjectBreakdown: $subjectBreakdown, weakTopics: $weakTopics, strongTopics: $strongTopics, lastQuizDate: $lastQuizDate, bestScore: $bestScore, perfectScoreCount: $perfectScoreCount, totalPassed: $totalPassed, totalFailed: $totalFailed, longestStreak: $longestStreak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizStatisticsImpl &&
            (identical(other.totalAttempts, totalAttempts) ||
                other.totalAttempts == totalAttempts) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.totalTimeSpent, totalTimeSpent) ||
                other.totalTimeSpent == totalTimeSpent) &&
            const DeepCollectionEquality().equals(
              other._subjectBreakdown,
              _subjectBreakdown,
            ) &&
            const DeepCollectionEquality().equals(
              other._weakTopics,
              _weakTopics,
            ) &&
            const DeepCollectionEquality().equals(
              other._strongTopics,
              _strongTopics,
            ) &&
            (identical(other.lastQuizDate, lastQuizDate) ||
                other.lastQuizDate == lastQuizDate) &&
            (identical(other.bestScore, bestScore) ||
                other.bestScore == bestScore) &&
            (identical(other.perfectScoreCount, perfectScoreCount) ||
                other.perfectScoreCount == perfectScoreCount) &&
            (identical(other.totalPassed, totalPassed) ||
                other.totalPassed == totalPassed) &&
            (identical(other.totalFailed, totalFailed) ||
                other.totalFailed == totalFailed) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalAttempts,
    averageScore,
    currentStreak,
    totalTimeSpent,
    const DeepCollectionEquality().hash(_subjectBreakdown),
    const DeepCollectionEquality().hash(_weakTopics),
    const DeepCollectionEquality().hash(_strongTopics),
    lastQuizDate,
    bestScore,
    perfectScoreCount,
    totalPassed,
    totalFailed,
    longestStreak,
  );

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizStatisticsImplCopyWith<_$QuizStatisticsImpl> get copyWith =>
      __$$QuizStatisticsImplCopyWithImpl<_$QuizStatisticsImpl>(
        this,
        _$identity,
      );
}

abstract class _QuizStatistics extends QuizStatistics {
  const factory _QuizStatistics({
    required final int totalAttempts,
    required final double averageScore,
    required final int currentStreak,
    required final Duration totalTimeSpent,
    required final Map<String, SubjectStatistics> subjectBreakdown,
    required final List<String> weakTopics,
    required final List<String> strongTopics,
    final DateTime? lastQuizDate,
    final int? bestScore,
    final int perfectScoreCount,
    final int totalPassed,
    final int totalFailed,
    final int longestStreak,
  }) = _$QuizStatisticsImpl;
  const _QuizStatistics._() : super._();

  /// Total number of quiz attempts across all subjects
  @override
  int get totalAttempts;

  /// Average score across all quizzes (0-100)
  @override
  double get averageScore;

  /// Current consecutive days with at least one quiz
  @override
  int get currentStreak;

  /// Total time spent on quizzes across all attempts
  @override
  Duration get totalTimeSpent;

  /// Statistics broken down by subject
  @override
  Map<String, SubjectStatistics> get subjectBreakdown;

  /// List of topic IDs where performance is weak (< 60%)
  @override
  List<String> get weakTopics;

  /// List of topic IDs where performance is strong (>= 80%)
  @override
  List<String> get strongTopics;

  /// Date of the most recent quiz attempt
  @override
  DateTime? get lastQuizDate;

  /// Highest score achieved across all quizzes (0-100)
  @override
  int? get bestScore;

  /// Number of quizzes with 100% score
  @override
  int get perfectScoreCount;

  /// Total number of passed quizzes
  @override
  int get totalPassed;

  /// Total number of failed quizzes
  @override
  int get totalFailed;

  /// Longest streak achieved (consecutive days)
  @override
  int get longestStreak;

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizStatisticsImplCopyWith<_$QuizStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
