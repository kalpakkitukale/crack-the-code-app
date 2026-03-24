// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subject_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SubjectStatistics {
  /// Unique identifier for the subject
  String get subjectId => throw _privateConstructorUsedError;

  /// Display name of the subject
  String get subjectName => throw _privateConstructorUsedError;

  /// Total number of quiz attempts in this subject
  int get totalAttempts => throw _privateConstructorUsedError;

  /// Average score across all attempts (0-100)
  double get averageScore => throw _privateConstructorUsedError;

  /// Highest score achieved in this subject (0-100)
  int get bestScore => throw _privateConstructorUsedError;

  /// Total time spent on quizzes in this subject
  Duration get totalTimeSpent => throw _privateConstructorUsedError;

  /// List of topic IDs that have been attempted
  List<String> get topicsAttempted => throw _privateConstructorUsedError;

  /// Performance breakdown by topic (topicId -> average score 0-100)
  Map<String, double> get topicPerformance =>
      throw _privateConstructorUsedError;

  /// Date of the most recent attempt in this subject
  DateTime? get lastAttemptDate => throw _privateConstructorUsedError;

  /// Lowest score achieved in this subject (0-100)
  int? get worstScore => throw _privateConstructorUsedError;

  /// Number of passed quizzes in this subject
  int get totalPassed => throw _privateConstructorUsedError;

  /// Number of failed quizzes in this subject
  int get totalFailed => throw _privateConstructorUsedError;

  /// Number of perfect scores (100%) in this subject
  int get perfectScoreCount => throw _privateConstructorUsedError;

  /// Average time per quiz in seconds
  int get averageTimeSeconds => throw _privateConstructorUsedError;

  /// Create a copy of SubjectStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubjectStatisticsCopyWith<SubjectStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubjectStatisticsCopyWith<$Res> {
  factory $SubjectStatisticsCopyWith(
    SubjectStatistics value,
    $Res Function(SubjectStatistics) then,
  ) = _$SubjectStatisticsCopyWithImpl<$Res, SubjectStatistics>;
  @useResult
  $Res call({
    String subjectId,
    String subjectName,
    int totalAttempts,
    double averageScore,
    int bestScore,
    Duration totalTimeSpent,
    List<String> topicsAttempted,
    Map<String, double> topicPerformance,
    DateTime? lastAttemptDate,
    int? worstScore,
    int totalPassed,
    int totalFailed,
    int perfectScoreCount,
    int averageTimeSeconds,
  });
}

/// @nodoc
class _$SubjectStatisticsCopyWithImpl<$Res, $Val extends SubjectStatistics>
    implements $SubjectStatisticsCopyWith<$Res> {
  _$SubjectStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubjectStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subjectId = null,
    Object? subjectName = null,
    Object? totalAttempts = null,
    Object? averageScore = null,
    Object? bestScore = null,
    Object? totalTimeSpent = null,
    Object? topicsAttempted = null,
    Object? topicPerformance = null,
    Object? lastAttemptDate = freezed,
    Object? worstScore = freezed,
    Object? totalPassed = null,
    Object? totalFailed = null,
    Object? perfectScoreCount = null,
    Object? averageTimeSeconds = null,
  }) {
    return _then(
      _value.copyWith(
            subjectId: null == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                      as String,
            subjectName: null == subjectName
                ? _value.subjectName
                : subjectName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAttempts: null == totalAttempts
                ? _value.totalAttempts
                : totalAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
            averageScore: null == averageScore
                ? _value.averageScore
                : averageScore // ignore: cast_nullable_to_non_nullable
                      as double,
            bestScore: null == bestScore
                ? _value.bestScore
                : bestScore // ignore: cast_nullable_to_non_nullable
                      as int,
            totalTimeSpent: null == totalTimeSpent
                ? _value.totalTimeSpent
                : totalTimeSpent // ignore: cast_nullable_to_non_nullable
                      as Duration,
            topicsAttempted: null == topicsAttempted
                ? _value.topicsAttempted
                : topicsAttempted // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            topicPerformance: null == topicPerformance
                ? _value.topicPerformance
                : topicPerformance // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            lastAttemptDate: freezed == lastAttemptDate
                ? _value.lastAttemptDate
                : lastAttemptDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            worstScore: freezed == worstScore
                ? _value.worstScore
                : worstScore // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalPassed: null == totalPassed
                ? _value.totalPassed
                : totalPassed // ignore: cast_nullable_to_non_nullable
                      as int,
            totalFailed: null == totalFailed
                ? _value.totalFailed
                : totalFailed // ignore: cast_nullable_to_non_nullable
                      as int,
            perfectScoreCount: null == perfectScoreCount
                ? _value.perfectScoreCount
                : perfectScoreCount // ignore: cast_nullable_to_non_nullable
                      as int,
            averageTimeSeconds: null == averageTimeSeconds
                ? _value.averageTimeSeconds
                : averageTimeSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubjectStatisticsImplCopyWith<$Res>
    implements $SubjectStatisticsCopyWith<$Res> {
  factory _$$SubjectStatisticsImplCopyWith(
    _$SubjectStatisticsImpl value,
    $Res Function(_$SubjectStatisticsImpl) then,
  ) = __$$SubjectStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String subjectId,
    String subjectName,
    int totalAttempts,
    double averageScore,
    int bestScore,
    Duration totalTimeSpent,
    List<String> topicsAttempted,
    Map<String, double> topicPerformance,
    DateTime? lastAttemptDate,
    int? worstScore,
    int totalPassed,
    int totalFailed,
    int perfectScoreCount,
    int averageTimeSeconds,
  });
}

/// @nodoc
class __$$SubjectStatisticsImplCopyWithImpl<$Res>
    extends _$SubjectStatisticsCopyWithImpl<$Res, _$SubjectStatisticsImpl>
    implements _$$SubjectStatisticsImplCopyWith<$Res> {
  __$$SubjectStatisticsImplCopyWithImpl(
    _$SubjectStatisticsImpl _value,
    $Res Function(_$SubjectStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubjectStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subjectId = null,
    Object? subjectName = null,
    Object? totalAttempts = null,
    Object? averageScore = null,
    Object? bestScore = null,
    Object? totalTimeSpent = null,
    Object? topicsAttempted = null,
    Object? topicPerformance = null,
    Object? lastAttemptDate = freezed,
    Object? worstScore = freezed,
    Object? totalPassed = null,
    Object? totalFailed = null,
    Object? perfectScoreCount = null,
    Object? averageTimeSeconds = null,
  }) {
    return _then(
      _$SubjectStatisticsImpl(
        subjectId: null == subjectId
            ? _value.subjectId
            : subjectId // ignore: cast_nullable_to_non_nullable
                  as String,
        subjectName: null == subjectName
            ? _value.subjectName
            : subjectName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAttempts: null == totalAttempts
            ? _value.totalAttempts
            : totalAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
        averageScore: null == averageScore
            ? _value.averageScore
            : averageScore // ignore: cast_nullable_to_non_nullable
                  as double,
        bestScore: null == bestScore
            ? _value.bestScore
            : bestScore // ignore: cast_nullable_to_non_nullable
                  as int,
        totalTimeSpent: null == totalTimeSpent
            ? _value.totalTimeSpent
            : totalTimeSpent // ignore: cast_nullable_to_non_nullable
                  as Duration,
        topicsAttempted: null == topicsAttempted
            ? _value._topicsAttempted
            : topicsAttempted // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        topicPerformance: null == topicPerformance
            ? _value._topicPerformance
            : topicPerformance // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        lastAttemptDate: freezed == lastAttemptDate
            ? _value.lastAttemptDate
            : lastAttemptDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        worstScore: freezed == worstScore
            ? _value.worstScore
            : worstScore // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalPassed: null == totalPassed
            ? _value.totalPassed
            : totalPassed // ignore: cast_nullable_to_non_nullable
                  as int,
        totalFailed: null == totalFailed
            ? _value.totalFailed
            : totalFailed // ignore: cast_nullable_to_non_nullable
                  as int,
        perfectScoreCount: null == perfectScoreCount
            ? _value.perfectScoreCount
            : perfectScoreCount // ignore: cast_nullable_to_non_nullable
                  as int,
        averageTimeSeconds: null == averageTimeSeconds
            ? _value.averageTimeSeconds
            : averageTimeSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$SubjectStatisticsImpl extends _SubjectStatistics {
  const _$SubjectStatisticsImpl({
    required this.subjectId,
    required this.subjectName,
    required this.totalAttempts,
    required this.averageScore,
    required this.bestScore,
    required this.totalTimeSpent,
    required final List<String> topicsAttempted,
    required final Map<String, double> topicPerformance,
    this.lastAttemptDate,
    this.worstScore,
    this.totalPassed = 0,
    this.totalFailed = 0,
    this.perfectScoreCount = 0,
    this.averageTimeSeconds = 0,
  }) : _topicsAttempted = topicsAttempted,
       _topicPerformance = topicPerformance,
       super._();

  /// Unique identifier for the subject
  @override
  final String subjectId;

  /// Display name of the subject
  @override
  final String subjectName;

  /// Total number of quiz attempts in this subject
  @override
  final int totalAttempts;

  /// Average score across all attempts (0-100)
  @override
  final double averageScore;

  /// Highest score achieved in this subject (0-100)
  @override
  final int bestScore;

  /// Total time spent on quizzes in this subject
  @override
  final Duration totalTimeSpent;

  /// List of topic IDs that have been attempted
  final List<String> _topicsAttempted;

  /// List of topic IDs that have been attempted
  @override
  List<String> get topicsAttempted {
    if (_topicsAttempted is EqualUnmodifiableListView) return _topicsAttempted;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topicsAttempted);
  }

  /// Performance breakdown by topic (topicId -> average score 0-100)
  final Map<String, double> _topicPerformance;

  /// Performance breakdown by topic (topicId -> average score 0-100)
  @override
  Map<String, double> get topicPerformance {
    if (_topicPerformance is EqualUnmodifiableMapView) return _topicPerformance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_topicPerformance);
  }

  /// Date of the most recent attempt in this subject
  @override
  final DateTime? lastAttemptDate;

  /// Lowest score achieved in this subject (0-100)
  @override
  final int? worstScore;

  /// Number of passed quizzes in this subject
  @override
  @JsonKey()
  final int totalPassed;

  /// Number of failed quizzes in this subject
  @override
  @JsonKey()
  final int totalFailed;

  /// Number of perfect scores (100%) in this subject
  @override
  @JsonKey()
  final int perfectScoreCount;

  /// Average time per quiz in seconds
  @override
  @JsonKey()
  final int averageTimeSeconds;

  @override
  String toString() {
    return 'SubjectStatistics(subjectId: $subjectId, subjectName: $subjectName, totalAttempts: $totalAttempts, averageScore: $averageScore, bestScore: $bestScore, totalTimeSpent: $totalTimeSpent, topicsAttempted: $topicsAttempted, topicPerformance: $topicPerformance, lastAttemptDate: $lastAttemptDate, worstScore: $worstScore, totalPassed: $totalPassed, totalFailed: $totalFailed, perfectScoreCount: $perfectScoreCount, averageTimeSeconds: $averageTimeSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubjectStatisticsImpl &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            (identical(other.subjectName, subjectName) ||
                other.subjectName == subjectName) &&
            (identical(other.totalAttempts, totalAttempts) ||
                other.totalAttempts == totalAttempts) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.bestScore, bestScore) ||
                other.bestScore == bestScore) &&
            (identical(other.totalTimeSpent, totalTimeSpent) ||
                other.totalTimeSpent == totalTimeSpent) &&
            const DeepCollectionEquality().equals(
              other._topicsAttempted,
              _topicsAttempted,
            ) &&
            const DeepCollectionEquality().equals(
              other._topicPerformance,
              _topicPerformance,
            ) &&
            (identical(other.lastAttemptDate, lastAttemptDate) ||
                other.lastAttemptDate == lastAttemptDate) &&
            (identical(other.worstScore, worstScore) ||
                other.worstScore == worstScore) &&
            (identical(other.totalPassed, totalPassed) ||
                other.totalPassed == totalPassed) &&
            (identical(other.totalFailed, totalFailed) ||
                other.totalFailed == totalFailed) &&
            (identical(other.perfectScoreCount, perfectScoreCount) ||
                other.perfectScoreCount == perfectScoreCount) &&
            (identical(other.averageTimeSeconds, averageTimeSeconds) ||
                other.averageTimeSeconds == averageTimeSeconds));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    subjectId,
    subjectName,
    totalAttempts,
    averageScore,
    bestScore,
    totalTimeSpent,
    const DeepCollectionEquality().hash(_topicsAttempted),
    const DeepCollectionEquality().hash(_topicPerformance),
    lastAttemptDate,
    worstScore,
    totalPassed,
    totalFailed,
    perfectScoreCount,
    averageTimeSeconds,
  );

  /// Create a copy of SubjectStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubjectStatisticsImplCopyWith<_$SubjectStatisticsImpl> get copyWith =>
      __$$SubjectStatisticsImplCopyWithImpl<_$SubjectStatisticsImpl>(
        this,
        _$identity,
      );
}

abstract class _SubjectStatistics extends SubjectStatistics {
  const factory _SubjectStatistics({
    required final String subjectId,
    required final String subjectName,
    required final int totalAttempts,
    required final double averageScore,
    required final int bestScore,
    required final Duration totalTimeSpent,
    required final List<String> topicsAttempted,
    required final Map<String, double> topicPerformance,
    final DateTime? lastAttemptDate,
    final int? worstScore,
    final int totalPassed,
    final int totalFailed,
    final int perfectScoreCount,
    final int averageTimeSeconds,
  }) = _$SubjectStatisticsImpl;
  const _SubjectStatistics._() : super._();

  /// Unique identifier for the subject
  @override
  String get subjectId;

  /// Display name of the subject
  @override
  String get subjectName;

  /// Total number of quiz attempts in this subject
  @override
  int get totalAttempts;

  /// Average score across all attempts (0-100)
  @override
  double get averageScore;

  /// Highest score achieved in this subject (0-100)
  @override
  int get bestScore;

  /// Total time spent on quizzes in this subject
  @override
  Duration get totalTimeSpent;

  /// List of topic IDs that have been attempted
  @override
  List<String> get topicsAttempted;

  /// Performance breakdown by topic (topicId -> average score 0-100)
  @override
  Map<String, double> get topicPerformance;

  /// Date of the most recent attempt in this subject
  @override
  DateTime? get lastAttemptDate;

  /// Lowest score achieved in this subject (0-100)
  @override
  int? get worstScore;

  /// Number of passed quizzes in this subject
  @override
  int get totalPassed;

  /// Number of failed quizzes in this subject
  @override
  int get totalFailed;

  /// Number of perfect scores (100%) in this subject
  @override
  int get perfectScoreCount;

  /// Average time per quiz in seconds
  @override
  int get averageTimeSeconds;

  /// Create a copy of SubjectStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubjectStatisticsImplCopyWith<_$SubjectStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
