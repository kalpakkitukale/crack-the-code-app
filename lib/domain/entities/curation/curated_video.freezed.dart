// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'curated_video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CuratedVideo {
  String get id => throw _privateConstructorUsedError;
  String get videoId => throw _privateConstructorUsedError;
  String get topicId => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  double get qualityScore => throw _privateConstructorUsedError;
  CurationMetrics get metrics => throw _privateConstructorUsedError;
  DateTime get curatedAt => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get curatedBy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Create a copy of CuratedVideo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CuratedVideoCopyWith<CuratedVideo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CuratedVideoCopyWith<$Res> {
  factory $CuratedVideoCopyWith(
    CuratedVideo value,
    $Res Function(CuratedVideo) then,
  ) = _$CuratedVideoCopyWithImpl<$Res, CuratedVideo>;
  @useResult
  $Res call({
    String id,
    String videoId,
    String topicId,
    int rank,
    double qualityScore,
    CurationMetrics metrics,
    DateTime curatedAt,
    DateTime lastUpdated,
    bool isActive,
    String? curatedBy,
    String? notes,
  });

  $CurationMetricsCopyWith<$Res> get metrics;
}

/// @nodoc
class _$CuratedVideoCopyWithImpl<$Res, $Val extends CuratedVideo>
    implements $CuratedVideoCopyWith<$Res> {
  _$CuratedVideoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CuratedVideo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? topicId = null,
    Object? rank = null,
    Object? qualityScore = null,
    Object? metrics = null,
    Object? curatedAt = null,
    Object? lastUpdated = null,
    Object? isActive = null,
    Object? curatedBy = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            videoId: null == videoId
                ? _value.videoId
                : videoId // ignore: cast_nullable_to_non_nullable
                      as String,
            topicId: null == topicId
                ? _value.topicId
                : topicId // ignore: cast_nullable_to_non_nullable
                      as String,
            rank: null == rank
                ? _value.rank
                : rank // ignore: cast_nullable_to_non_nullable
                      as int,
            qualityScore: null == qualityScore
                ? _value.qualityScore
                : qualityScore // ignore: cast_nullable_to_non_nullable
                      as double,
            metrics: null == metrics
                ? _value.metrics
                : metrics // ignore: cast_nullable_to_non_nullable
                      as CurationMetrics,
            curatedAt: null == curatedAt
                ? _value.curatedAt
                : curatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            curatedBy: freezed == curatedBy
                ? _value.curatedBy
                : curatedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of CuratedVideo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurationMetricsCopyWith<$Res> get metrics {
    return $CurationMetricsCopyWith<$Res>(_value.metrics, (value) {
      return _then(_value.copyWith(metrics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CuratedVideoImplCopyWith<$Res>
    implements $CuratedVideoCopyWith<$Res> {
  factory _$$CuratedVideoImplCopyWith(
    _$CuratedVideoImpl value,
    $Res Function(_$CuratedVideoImpl) then,
  ) = __$$CuratedVideoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String videoId,
    String topicId,
    int rank,
    double qualityScore,
    CurationMetrics metrics,
    DateTime curatedAt,
    DateTime lastUpdated,
    bool isActive,
    String? curatedBy,
    String? notes,
  });

  @override
  $CurationMetricsCopyWith<$Res> get metrics;
}

/// @nodoc
class __$$CuratedVideoImplCopyWithImpl<$Res>
    extends _$CuratedVideoCopyWithImpl<$Res, _$CuratedVideoImpl>
    implements _$$CuratedVideoImplCopyWith<$Res> {
  __$$CuratedVideoImplCopyWithImpl(
    _$CuratedVideoImpl _value,
    $Res Function(_$CuratedVideoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CuratedVideo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? topicId = null,
    Object? rank = null,
    Object? qualityScore = null,
    Object? metrics = null,
    Object? curatedAt = null,
    Object? lastUpdated = null,
    Object? isActive = null,
    Object? curatedBy = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$CuratedVideoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        videoId: null == videoId
            ? _value.videoId
            : videoId // ignore: cast_nullable_to_non_nullable
                  as String,
        topicId: null == topicId
            ? _value.topicId
            : topicId // ignore: cast_nullable_to_non_nullable
                  as String,
        rank: null == rank
            ? _value.rank
            : rank // ignore: cast_nullable_to_non_nullable
                  as int,
        qualityScore: null == qualityScore
            ? _value.qualityScore
            : qualityScore // ignore: cast_nullable_to_non_nullable
                  as double,
        metrics: null == metrics
            ? _value.metrics
            : metrics // ignore: cast_nullable_to_non_nullable
                  as CurationMetrics,
        curatedAt: null == curatedAt
            ? _value.curatedAt
            : curatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        curatedBy: freezed == curatedBy
            ? _value.curatedBy
            : curatedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CuratedVideoImpl extends _CuratedVideo {
  const _$CuratedVideoImpl({
    required this.id,
    required this.videoId,
    required this.topicId,
    required this.rank,
    required this.qualityScore,
    required this.metrics,
    required this.curatedAt,
    required this.lastUpdated,
    this.isActive = true,
    this.curatedBy,
    this.notes,
  }) : super._();

  @override
  final String id;
  @override
  final String videoId;
  @override
  final String topicId;
  @override
  final int rank;
  @override
  final double qualityScore;
  @override
  final CurationMetrics metrics;
  @override
  final DateTime curatedAt;
  @override
  final DateTime lastUpdated;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? curatedBy;
  @override
  final String? notes;

  @override
  String toString() {
    return 'CuratedVideo(id: $id, videoId: $videoId, topicId: $topicId, rank: $rank, qualityScore: $qualityScore, metrics: $metrics, curatedAt: $curatedAt, lastUpdated: $lastUpdated, isActive: $isActive, curatedBy: $curatedBy, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CuratedVideoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.qualityScore, qualityScore) ||
                other.qualityScore == qualityScore) &&
            (identical(other.metrics, metrics) || other.metrics == metrics) &&
            (identical(other.curatedAt, curatedAt) ||
                other.curatedAt == curatedAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.curatedBy, curatedBy) ||
                other.curatedBy == curatedBy) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    videoId,
    topicId,
    rank,
    qualityScore,
    metrics,
    curatedAt,
    lastUpdated,
    isActive,
    curatedBy,
    notes,
  );

  /// Create a copy of CuratedVideo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CuratedVideoImplCopyWith<_$CuratedVideoImpl> get copyWith =>
      __$$CuratedVideoImplCopyWithImpl<_$CuratedVideoImpl>(this, _$identity);
}

abstract class _CuratedVideo extends CuratedVideo {
  const factory _CuratedVideo({
    required final String id,
    required final String videoId,
    required final String topicId,
    required final int rank,
    required final double qualityScore,
    required final CurationMetrics metrics,
    required final DateTime curatedAt,
    required final DateTime lastUpdated,
    final bool isActive,
    final String? curatedBy,
    final String? notes,
  }) = _$CuratedVideoImpl;
  const _CuratedVideo._() : super._();

  @override
  String get id;
  @override
  String get videoId;
  @override
  String get topicId;
  @override
  int get rank;
  @override
  double get qualityScore;
  @override
  CurationMetrics get metrics;
  @override
  DateTime get curatedAt;
  @override
  DateTime get lastUpdated;
  @override
  bool get isActive;
  @override
  String? get curatedBy;
  @override
  String? get notes;

  /// Create a copy of CuratedVideo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CuratedVideoImplCopyWith<_$CuratedVideoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CurationMetrics {
  double get contentQuality => throw _privateConstructorUsedError;
  double get audioQuality => throw _privateConstructorUsedError;
  double get videoQuality => throw _privateConstructorUsedError;
  double get explanationClarity => throw _privateConstructorUsedError;
  double get studentEngagement => throw _privateConstructorUsedError;
  int get studentViews => throw _privateConstructorUsedError;
  int get studentLikes => throw _privateConstructorUsedError;
  int get studentCompletions => throw _privateConstructorUsedError;
  double get averageWatchPercentage => throw _privateConstructorUsedError;
  double get averageQuizScore => throw _privateConstructorUsedError;

  /// Create a copy of CurationMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurationMetricsCopyWith<CurationMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurationMetricsCopyWith<$Res> {
  factory $CurationMetricsCopyWith(
    CurationMetrics value,
    $Res Function(CurationMetrics) then,
  ) = _$CurationMetricsCopyWithImpl<$Res, CurationMetrics>;
  @useResult
  $Res call({
    double contentQuality,
    double audioQuality,
    double videoQuality,
    double explanationClarity,
    double studentEngagement,
    int studentViews,
    int studentLikes,
    int studentCompletions,
    double averageWatchPercentage,
    double averageQuizScore,
  });
}

/// @nodoc
class _$CurationMetricsCopyWithImpl<$Res, $Val extends CurationMetrics>
    implements $CurationMetricsCopyWith<$Res> {
  _$CurationMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurationMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentQuality = null,
    Object? audioQuality = null,
    Object? videoQuality = null,
    Object? explanationClarity = null,
    Object? studentEngagement = null,
    Object? studentViews = null,
    Object? studentLikes = null,
    Object? studentCompletions = null,
    Object? averageWatchPercentage = null,
    Object? averageQuizScore = null,
  }) {
    return _then(
      _value.copyWith(
            contentQuality: null == contentQuality
                ? _value.contentQuality
                : contentQuality // ignore: cast_nullable_to_non_nullable
                      as double,
            audioQuality: null == audioQuality
                ? _value.audioQuality
                : audioQuality // ignore: cast_nullable_to_non_nullable
                      as double,
            videoQuality: null == videoQuality
                ? _value.videoQuality
                : videoQuality // ignore: cast_nullable_to_non_nullable
                      as double,
            explanationClarity: null == explanationClarity
                ? _value.explanationClarity
                : explanationClarity // ignore: cast_nullable_to_non_nullable
                      as double,
            studentEngagement: null == studentEngagement
                ? _value.studentEngagement
                : studentEngagement // ignore: cast_nullable_to_non_nullable
                      as double,
            studentViews: null == studentViews
                ? _value.studentViews
                : studentViews // ignore: cast_nullable_to_non_nullable
                      as int,
            studentLikes: null == studentLikes
                ? _value.studentLikes
                : studentLikes // ignore: cast_nullable_to_non_nullable
                      as int,
            studentCompletions: null == studentCompletions
                ? _value.studentCompletions
                : studentCompletions // ignore: cast_nullable_to_non_nullable
                      as int,
            averageWatchPercentage: null == averageWatchPercentage
                ? _value.averageWatchPercentage
                : averageWatchPercentage // ignore: cast_nullable_to_non_nullable
                      as double,
            averageQuizScore: null == averageQuizScore
                ? _value.averageQuizScore
                : averageQuizScore // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CurationMetricsImplCopyWith<$Res>
    implements $CurationMetricsCopyWith<$Res> {
  factory _$$CurationMetricsImplCopyWith(
    _$CurationMetricsImpl value,
    $Res Function(_$CurationMetricsImpl) then,
  ) = __$$CurationMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double contentQuality,
    double audioQuality,
    double videoQuality,
    double explanationClarity,
    double studentEngagement,
    int studentViews,
    int studentLikes,
    int studentCompletions,
    double averageWatchPercentage,
    double averageQuizScore,
  });
}

/// @nodoc
class __$$CurationMetricsImplCopyWithImpl<$Res>
    extends _$CurationMetricsCopyWithImpl<$Res, _$CurationMetricsImpl>
    implements _$$CurationMetricsImplCopyWith<$Res> {
  __$$CurationMetricsImplCopyWithImpl(
    _$CurationMetricsImpl _value,
    $Res Function(_$CurationMetricsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CurationMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentQuality = null,
    Object? audioQuality = null,
    Object? videoQuality = null,
    Object? explanationClarity = null,
    Object? studentEngagement = null,
    Object? studentViews = null,
    Object? studentLikes = null,
    Object? studentCompletions = null,
    Object? averageWatchPercentage = null,
    Object? averageQuizScore = null,
  }) {
    return _then(
      _$CurationMetricsImpl(
        contentQuality: null == contentQuality
            ? _value.contentQuality
            : contentQuality // ignore: cast_nullable_to_non_nullable
                  as double,
        audioQuality: null == audioQuality
            ? _value.audioQuality
            : audioQuality // ignore: cast_nullable_to_non_nullable
                  as double,
        videoQuality: null == videoQuality
            ? _value.videoQuality
            : videoQuality // ignore: cast_nullable_to_non_nullable
                  as double,
        explanationClarity: null == explanationClarity
            ? _value.explanationClarity
            : explanationClarity // ignore: cast_nullable_to_non_nullable
                  as double,
        studentEngagement: null == studentEngagement
            ? _value.studentEngagement
            : studentEngagement // ignore: cast_nullable_to_non_nullable
                  as double,
        studentViews: null == studentViews
            ? _value.studentViews
            : studentViews // ignore: cast_nullable_to_non_nullable
                  as int,
        studentLikes: null == studentLikes
            ? _value.studentLikes
            : studentLikes // ignore: cast_nullable_to_non_nullable
                  as int,
        studentCompletions: null == studentCompletions
            ? _value.studentCompletions
            : studentCompletions // ignore: cast_nullable_to_non_nullable
                  as int,
        averageWatchPercentage: null == averageWatchPercentage
            ? _value.averageWatchPercentage
            : averageWatchPercentage // ignore: cast_nullable_to_non_nullable
                  as double,
        averageQuizScore: null == averageQuizScore
            ? _value.averageQuizScore
            : averageQuizScore // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$CurationMetricsImpl extends _CurationMetrics {
  const _$CurationMetricsImpl({
    required this.contentQuality,
    required this.audioQuality,
    required this.videoQuality,
    required this.explanationClarity,
    required this.studentEngagement,
    this.studentViews = 0,
    this.studentLikes = 0,
    this.studentCompletions = 0,
    this.averageWatchPercentage = 0.0,
    this.averageQuizScore = 0.0,
  }) : super._();

  @override
  final double contentQuality;
  @override
  final double audioQuality;
  @override
  final double videoQuality;
  @override
  final double explanationClarity;
  @override
  final double studentEngagement;
  @override
  @JsonKey()
  final int studentViews;
  @override
  @JsonKey()
  final int studentLikes;
  @override
  @JsonKey()
  final int studentCompletions;
  @override
  @JsonKey()
  final double averageWatchPercentage;
  @override
  @JsonKey()
  final double averageQuizScore;

  @override
  String toString() {
    return 'CurationMetrics(contentQuality: $contentQuality, audioQuality: $audioQuality, videoQuality: $videoQuality, explanationClarity: $explanationClarity, studentEngagement: $studentEngagement, studentViews: $studentViews, studentLikes: $studentLikes, studentCompletions: $studentCompletions, averageWatchPercentage: $averageWatchPercentage, averageQuizScore: $averageQuizScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurationMetricsImpl &&
            (identical(other.contentQuality, contentQuality) ||
                other.contentQuality == contentQuality) &&
            (identical(other.audioQuality, audioQuality) ||
                other.audioQuality == audioQuality) &&
            (identical(other.videoQuality, videoQuality) ||
                other.videoQuality == videoQuality) &&
            (identical(other.explanationClarity, explanationClarity) ||
                other.explanationClarity == explanationClarity) &&
            (identical(other.studentEngagement, studentEngagement) ||
                other.studentEngagement == studentEngagement) &&
            (identical(other.studentViews, studentViews) ||
                other.studentViews == studentViews) &&
            (identical(other.studentLikes, studentLikes) ||
                other.studentLikes == studentLikes) &&
            (identical(other.studentCompletions, studentCompletions) ||
                other.studentCompletions == studentCompletions) &&
            (identical(other.averageWatchPercentage, averageWatchPercentage) ||
                other.averageWatchPercentage == averageWatchPercentage) &&
            (identical(other.averageQuizScore, averageQuizScore) ||
                other.averageQuizScore == averageQuizScore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    contentQuality,
    audioQuality,
    videoQuality,
    explanationClarity,
    studentEngagement,
    studentViews,
    studentLikes,
    studentCompletions,
    averageWatchPercentage,
    averageQuizScore,
  );

  /// Create a copy of CurationMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurationMetricsImplCopyWith<_$CurationMetricsImpl> get copyWith =>
      __$$CurationMetricsImplCopyWithImpl<_$CurationMetricsImpl>(
        this,
        _$identity,
      );
}

abstract class _CurationMetrics extends CurationMetrics {
  const factory _CurationMetrics({
    required final double contentQuality,
    required final double audioQuality,
    required final double videoQuality,
    required final double explanationClarity,
    required final double studentEngagement,
    final int studentViews,
    final int studentLikes,
    final int studentCompletions,
    final double averageWatchPercentage,
    final double averageQuizScore,
  }) = _$CurationMetricsImpl;
  const _CurationMetrics._() : super._();

  @override
  double get contentQuality;
  @override
  double get audioQuality;
  @override
  double get videoQuality;
  @override
  double get explanationClarity;
  @override
  double get studentEngagement;
  @override
  int get studentViews;
  @override
  int get studentLikes;
  @override
  int get studentCompletions;
  @override
  double get averageWatchPercentage;
  @override
  double get averageQuizScore;

  /// Create a copy of CurationMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurationMetricsImplCopyWith<_$CurationMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
