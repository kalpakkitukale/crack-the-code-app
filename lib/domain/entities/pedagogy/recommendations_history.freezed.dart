// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendations_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecommendationsHistory _$RecommendationsHistoryFromJson(
  Map<String, dynamic> json,
) {
  return _RecommendationsHistory.fromJson(json);
}

/// @nodoc
mixin _$RecommendationsHistory {
  String get id => throw _privateConstructorUsedError;
  String get quizAttemptId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get subjectId => throw _privateConstructorUsedError;
  String? get topicId => throw _privateConstructorUsedError;
  AssessmentType get assessmentType =>
      throw _privateConstructorUsedError; // Recommendation data
  List<QuizRecommendation> get recommendations =>
      throw _privateConstructorUsedError;
  int get totalRecommendations => throw _privateConstructorUsedError;
  int get criticalGaps => throw _privateConstructorUsedError;
  int get severeGaps => throw _privateConstructorUsedError;
  int get estimatedMinutesToFix =>
      throw _privateConstructorUsedError; // Metadata
  DateTime get generatedAt => throw _privateConstructorUsedError;
  DateTime? get viewedAt => throw _privateConstructorUsedError;
  DateTime? get lastAccessedAt => throw _privateConstructorUsedError;
  int get viewCount =>
      throw _privateConstructorUsedError; // Learning path tracking
  String? get learningPathId => throw _privateConstructorUsedError;
  bool get learningPathStarted => throw _privateConstructorUsedError;
  DateTime? get learningPathStartedAt => throw _privateConstructorUsedError;
  bool get learningPathCompleted => throw _privateConstructorUsedError;
  DateTime? get learningPathCompletedAt =>
      throw _privateConstructorUsedError; // Video tracking
  List<String> get viewedVideoIds => throw _privateConstructorUsedError;
  List<String> get dismissedRecommendationIds =>
      throw _privateConstructorUsedError;

  /// Serializes this RecommendationsHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationsHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationsHistoryCopyWith<RecommendationsHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationsHistoryCopyWith<$Res> {
  factory $RecommendationsHistoryCopyWith(
    RecommendationsHistory value,
    $Res Function(RecommendationsHistory) then,
  ) = _$RecommendationsHistoryCopyWithImpl<$Res, RecommendationsHistory>;
  @useResult
  $Res call({
    String id,
    String quizAttemptId,
    String userId,
    String subjectId,
    String? topicId,
    AssessmentType assessmentType,
    List<QuizRecommendation> recommendations,
    int totalRecommendations,
    int criticalGaps,
    int severeGaps,
    int estimatedMinutesToFix,
    DateTime generatedAt,
    DateTime? viewedAt,
    DateTime? lastAccessedAt,
    int viewCount,
    String? learningPathId,
    bool learningPathStarted,
    DateTime? learningPathStartedAt,
    bool learningPathCompleted,
    DateTime? learningPathCompletedAt,
    List<String> viewedVideoIds,
    List<String> dismissedRecommendationIds,
  });
}

/// @nodoc
class _$RecommendationsHistoryCopyWithImpl<
  $Res,
  $Val extends RecommendationsHistory
>
    implements $RecommendationsHistoryCopyWith<$Res> {
  _$RecommendationsHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationsHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizAttemptId = null,
    Object? userId = null,
    Object? subjectId = null,
    Object? topicId = freezed,
    Object? assessmentType = null,
    Object? recommendations = null,
    Object? totalRecommendations = null,
    Object? criticalGaps = null,
    Object? severeGaps = null,
    Object? estimatedMinutesToFix = null,
    Object? generatedAt = null,
    Object? viewedAt = freezed,
    Object? lastAccessedAt = freezed,
    Object? viewCount = null,
    Object? learningPathId = freezed,
    Object? learningPathStarted = null,
    Object? learningPathStartedAt = freezed,
    Object? learningPathCompleted = null,
    Object? learningPathCompletedAt = freezed,
    Object? viewedVideoIds = null,
    Object? dismissedRecommendationIds = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            quizAttemptId: null == quizAttemptId
                ? _value.quizAttemptId
                : quizAttemptId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            subjectId: null == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                      as String,
            topicId: freezed == topicId
                ? _value.topicId
                : topicId // ignore: cast_nullable_to_non_nullable
                      as String?,
            assessmentType: null == assessmentType
                ? _value.assessmentType
                : assessmentType // ignore: cast_nullable_to_non_nullable
                      as AssessmentType,
            recommendations: null == recommendations
                ? _value.recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                      as List<QuizRecommendation>,
            totalRecommendations: null == totalRecommendations
                ? _value.totalRecommendations
                : totalRecommendations // ignore: cast_nullable_to_non_nullable
                      as int,
            criticalGaps: null == criticalGaps
                ? _value.criticalGaps
                : criticalGaps // ignore: cast_nullable_to_non_nullable
                      as int,
            severeGaps: null == severeGaps
                ? _value.severeGaps
                : severeGaps // ignore: cast_nullable_to_non_nullable
                      as int,
            estimatedMinutesToFix: null == estimatedMinutesToFix
                ? _value.estimatedMinutesToFix
                : estimatedMinutesToFix // ignore: cast_nullable_to_non_nullable
                      as int,
            generatedAt: null == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            viewedAt: freezed == viewedAt
                ? _value.viewedAt
                : viewedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastAccessedAt: freezed == lastAccessedAt
                ? _value.lastAccessedAt
                : lastAccessedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            viewCount: null == viewCount
                ? _value.viewCount
                : viewCount // ignore: cast_nullable_to_non_nullable
                      as int,
            learningPathId: freezed == learningPathId
                ? _value.learningPathId
                : learningPathId // ignore: cast_nullable_to_non_nullable
                      as String?,
            learningPathStarted: null == learningPathStarted
                ? _value.learningPathStarted
                : learningPathStarted // ignore: cast_nullable_to_non_nullable
                      as bool,
            learningPathStartedAt: freezed == learningPathStartedAt
                ? _value.learningPathStartedAt
                : learningPathStartedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            learningPathCompleted: null == learningPathCompleted
                ? _value.learningPathCompleted
                : learningPathCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            learningPathCompletedAt: freezed == learningPathCompletedAt
                ? _value.learningPathCompletedAt
                : learningPathCompletedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            viewedVideoIds: null == viewedVideoIds
                ? _value.viewedVideoIds
                : viewedVideoIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            dismissedRecommendationIds: null == dismissedRecommendationIds
                ? _value.dismissedRecommendationIds
                : dismissedRecommendationIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecommendationsHistoryImplCopyWith<$Res>
    implements $RecommendationsHistoryCopyWith<$Res> {
  factory _$$RecommendationsHistoryImplCopyWith(
    _$RecommendationsHistoryImpl value,
    $Res Function(_$RecommendationsHistoryImpl) then,
  ) = __$$RecommendationsHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String quizAttemptId,
    String userId,
    String subjectId,
    String? topicId,
    AssessmentType assessmentType,
    List<QuizRecommendation> recommendations,
    int totalRecommendations,
    int criticalGaps,
    int severeGaps,
    int estimatedMinutesToFix,
    DateTime generatedAt,
    DateTime? viewedAt,
    DateTime? lastAccessedAt,
    int viewCount,
    String? learningPathId,
    bool learningPathStarted,
    DateTime? learningPathStartedAt,
    bool learningPathCompleted,
    DateTime? learningPathCompletedAt,
    List<String> viewedVideoIds,
    List<String> dismissedRecommendationIds,
  });
}

/// @nodoc
class __$$RecommendationsHistoryImplCopyWithImpl<$Res>
    extends
        _$RecommendationsHistoryCopyWithImpl<$Res, _$RecommendationsHistoryImpl>
    implements _$$RecommendationsHistoryImplCopyWith<$Res> {
  __$$RecommendationsHistoryImplCopyWithImpl(
    _$RecommendationsHistoryImpl _value,
    $Res Function(_$RecommendationsHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationsHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizAttemptId = null,
    Object? userId = null,
    Object? subjectId = null,
    Object? topicId = freezed,
    Object? assessmentType = null,
    Object? recommendations = null,
    Object? totalRecommendations = null,
    Object? criticalGaps = null,
    Object? severeGaps = null,
    Object? estimatedMinutesToFix = null,
    Object? generatedAt = null,
    Object? viewedAt = freezed,
    Object? lastAccessedAt = freezed,
    Object? viewCount = null,
    Object? learningPathId = freezed,
    Object? learningPathStarted = null,
    Object? learningPathStartedAt = freezed,
    Object? learningPathCompleted = null,
    Object? learningPathCompletedAt = freezed,
    Object? viewedVideoIds = null,
    Object? dismissedRecommendationIds = null,
  }) {
    return _then(
      _$RecommendationsHistoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        quizAttemptId: null == quizAttemptId
            ? _value.quizAttemptId
            : quizAttemptId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        subjectId: null == subjectId
            ? _value.subjectId
            : subjectId // ignore: cast_nullable_to_non_nullable
                  as String,
        topicId: freezed == topicId
            ? _value.topicId
            : topicId // ignore: cast_nullable_to_non_nullable
                  as String?,
        assessmentType: null == assessmentType
            ? _value.assessmentType
            : assessmentType // ignore: cast_nullable_to_non_nullable
                  as AssessmentType,
        recommendations: null == recommendations
            ? _value._recommendations
            : recommendations // ignore: cast_nullable_to_non_nullable
                  as List<QuizRecommendation>,
        totalRecommendations: null == totalRecommendations
            ? _value.totalRecommendations
            : totalRecommendations // ignore: cast_nullable_to_non_nullable
                  as int,
        criticalGaps: null == criticalGaps
            ? _value.criticalGaps
            : criticalGaps // ignore: cast_nullable_to_non_nullable
                  as int,
        severeGaps: null == severeGaps
            ? _value.severeGaps
            : severeGaps // ignore: cast_nullable_to_non_nullable
                  as int,
        estimatedMinutesToFix: null == estimatedMinutesToFix
            ? _value.estimatedMinutesToFix
            : estimatedMinutesToFix // ignore: cast_nullable_to_non_nullable
                  as int,
        generatedAt: null == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        viewedAt: freezed == viewedAt
            ? _value.viewedAt
            : viewedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastAccessedAt: freezed == lastAccessedAt
            ? _value.lastAccessedAt
            : lastAccessedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        viewCount: null == viewCount
            ? _value.viewCount
            : viewCount // ignore: cast_nullable_to_non_nullable
                  as int,
        learningPathId: freezed == learningPathId
            ? _value.learningPathId
            : learningPathId // ignore: cast_nullable_to_non_nullable
                  as String?,
        learningPathStarted: null == learningPathStarted
            ? _value.learningPathStarted
            : learningPathStarted // ignore: cast_nullable_to_non_nullable
                  as bool,
        learningPathStartedAt: freezed == learningPathStartedAt
            ? _value.learningPathStartedAt
            : learningPathStartedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        learningPathCompleted: null == learningPathCompleted
            ? _value.learningPathCompleted
            : learningPathCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        learningPathCompletedAt: freezed == learningPathCompletedAt
            ? _value.learningPathCompletedAt
            : learningPathCompletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        viewedVideoIds: null == viewedVideoIds
            ? _value._viewedVideoIds
            : viewedVideoIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        dismissedRecommendationIds: null == dismissedRecommendationIds
            ? _value._dismissedRecommendationIds
            : dismissedRecommendationIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationsHistoryImpl extends _RecommendationsHistory {
  const _$RecommendationsHistoryImpl({
    required this.id,
    required this.quizAttemptId,
    required this.userId,
    required this.subjectId,
    this.topicId,
    required this.assessmentType,
    required final List<QuizRecommendation> recommendations,
    required this.totalRecommendations,
    required this.criticalGaps,
    required this.severeGaps,
    required this.estimatedMinutesToFix,
    required this.generatedAt,
    this.viewedAt,
    this.lastAccessedAt,
    this.viewCount = 0,
    this.learningPathId,
    this.learningPathStarted = false,
    this.learningPathStartedAt,
    this.learningPathCompleted = false,
    this.learningPathCompletedAt,
    final List<String> viewedVideoIds = const [],
    final List<String> dismissedRecommendationIds = const [],
  }) : _recommendations = recommendations,
       _viewedVideoIds = viewedVideoIds,
       _dismissedRecommendationIds = dismissedRecommendationIds,
       super._();

  factory _$RecommendationsHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationsHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final String quizAttemptId;
  @override
  final String userId;
  @override
  final String subjectId;
  @override
  final String? topicId;
  @override
  final AssessmentType assessmentType;
  // Recommendation data
  final List<QuizRecommendation> _recommendations;
  // Recommendation data
  @override
  List<QuizRecommendation> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  final int totalRecommendations;
  @override
  final int criticalGaps;
  @override
  final int severeGaps;
  @override
  final int estimatedMinutesToFix;
  // Metadata
  @override
  final DateTime generatedAt;
  @override
  final DateTime? viewedAt;
  @override
  final DateTime? lastAccessedAt;
  @override
  @JsonKey()
  final int viewCount;
  // Learning path tracking
  @override
  final String? learningPathId;
  @override
  @JsonKey()
  final bool learningPathStarted;
  @override
  final DateTime? learningPathStartedAt;
  @override
  @JsonKey()
  final bool learningPathCompleted;
  @override
  final DateTime? learningPathCompletedAt;
  // Video tracking
  final List<String> _viewedVideoIds;
  // Video tracking
  @override
  @JsonKey()
  List<String> get viewedVideoIds {
    if (_viewedVideoIds is EqualUnmodifiableListView) return _viewedVideoIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_viewedVideoIds);
  }

  final List<String> _dismissedRecommendationIds;
  @override
  @JsonKey()
  List<String> get dismissedRecommendationIds {
    if (_dismissedRecommendationIds is EqualUnmodifiableListView)
      return _dismissedRecommendationIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dismissedRecommendationIds);
  }

  @override
  String toString() {
    return 'RecommendationsHistory(id: $id, quizAttemptId: $quizAttemptId, userId: $userId, subjectId: $subjectId, topicId: $topicId, assessmentType: $assessmentType, recommendations: $recommendations, totalRecommendations: $totalRecommendations, criticalGaps: $criticalGaps, severeGaps: $severeGaps, estimatedMinutesToFix: $estimatedMinutesToFix, generatedAt: $generatedAt, viewedAt: $viewedAt, lastAccessedAt: $lastAccessedAt, viewCount: $viewCount, learningPathId: $learningPathId, learningPathStarted: $learningPathStarted, learningPathStartedAt: $learningPathStartedAt, learningPathCompleted: $learningPathCompleted, learningPathCompletedAt: $learningPathCompletedAt, viewedVideoIds: $viewedVideoIds, dismissedRecommendationIds: $dismissedRecommendationIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationsHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quizAttemptId, quizAttemptId) ||
                other.quizAttemptId == quizAttemptId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.assessmentType, assessmentType) ||
                other.assessmentType == assessmentType) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ) &&
            (identical(other.totalRecommendations, totalRecommendations) ||
                other.totalRecommendations == totalRecommendations) &&
            (identical(other.criticalGaps, criticalGaps) ||
                other.criticalGaps == criticalGaps) &&
            (identical(other.severeGaps, severeGaps) ||
                other.severeGaps == severeGaps) &&
            (identical(other.estimatedMinutesToFix, estimatedMinutesToFix) ||
                other.estimatedMinutesToFix == estimatedMinutesToFix) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.viewedAt, viewedAt) ||
                other.viewedAt == viewedAt) &&
            (identical(other.lastAccessedAt, lastAccessedAt) ||
                other.lastAccessedAt == lastAccessedAt) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.learningPathId, learningPathId) ||
                other.learningPathId == learningPathId) &&
            (identical(other.learningPathStarted, learningPathStarted) ||
                other.learningPathStarted == learningPathStarted) &&
            (identical(other.learningPathStartedAt, learningPathStartedAt) ||
                other.learningPathStartedAt == learningPathStartedAt) &&
            (identical(other.learningPathCompleted, learningPathCompleted) ||
                other.learningPathCompleted == learningPathCompleted) &&
            (identical(
                  other.learningPathCompletedAt,
                  learningPathCompletedAt,
                ) ||
                other.learningPathCompletedAt == learningPathCompletedAt) &&
            const DeepCollectionEquality().equals(
              other._viewedVideoIds,
              _viewedVideoIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._dismissedRecommendationIds,
              _dismissedRecommendationIds,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    quizAttemptId,
    userId,
    subjectId,
    topicId,
    assessmentType,
    const DeepCollectionEquality().hash(_recommendations),
    totalRecommendations,
    criticalGaps,
    severeGaps,
    estimatedMinutesToFix,
    generatedAt,
    viewedAt,
    lastAccessedAt,
    viewCount,
    learningPathId,
    learningPathStarted,
    learningPathStartedAt,
    learningPathCompleted,
    learningPathCompletedAt,
    const DeepCollectionEquality().hash(_viewedVideoIds),
    const DeepCollectionEquality().hash(_dismissedRecommendationIds),
  ]);

  /// Create a copy of RecommendationsHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationsHistoryImplCopyWith<_$RecommendationsHistoryImpl>
  get copyWith =>
      __$$RecommendationsHistoryImplCopyWithImpl<_$RecommendationsHistoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationsHistoryImplToJson(this);
  }
}

abstract class _RecommendationsHistory extends RecommendationsHistory {
  const factory _RecommendationsHistory({
    required final String id,
    required final String quizAttemptId,
    required final String userId,
    required final String subjectId,
    final String? topicId,
    required final AssessmentType assessmentType,
    required final List<QuizRecommendation> recommendations,
    required final int totalRecommendations,
    required final int criticalGaps,
    required final int severeGaps,
    required final int estimatedMinutesToFix,
    required final DateTime generatedAt,
    final DateTime? viewedAt,
    final DateTime? lastAccessedAt,
    final int viewCount,
    final String? learningPathId,
    final bool learningPathStarted,
    final DateTime? learningPathStartedAt,
    final bool learningPathCompleted,
    final DateTime? learningPathCompletedAt,
    final List<String> viewedVideoIds,
    final List<String> dismissedRecommendationIds,
  }) = _$RecommendationsHistoryImpl;
  const _RecommendationsHistory._() : super._();

  factory _RecommendationsHistory.fromJson(Map<String, dynamic> json) =
      _$RecommendationsHistoryImpl.fromJson;

  @override
  String get id;
  @override
  String get quizAttemptId;
  @override
  String get userId;
  @override
  String get subjectId;
  @override
  String? get topicId;
  @override
  AssessmentType get assessmentType; // Recommendation data
  @override
  List<QuizRecommendation> get recommendations;
  @override
  int get totalRecommendations;
  @override
  int get criticalGaps;
  @override
  int get severeGaps;
  @override
  int get estimatedMinutesToFix; // Metadata
  @override
  DateTime get generatedAt;
  @override
  DateTime? get viewedAt;
  @override
  DateTime? get lastAccessedAt;
  @override
  int get viewCount; // Learning path tracking
  @override
  String? get learningPathId;
  @override
  bool get learningPathStarted;
  @override
  DateTime? get learningPathStartedAt;
  @override
  bool get learningPathCompleted;
  @override
  DateTime? get learningPathCompletedAt; // Video tracking
  @override
  List<String> get viewedVideoIds;
  @override
  List<String> get dismissedRecommendationIds;

  /// Create a copy of RecommendationsHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationsHistoryImplCopyWith<_$RecommendationsHistoryImpl>
  get copyWith => throw _privateConstructorUsedError;
}
