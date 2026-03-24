// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuizRecommendation _$QuizRecommendationFromJson(Map<String, dynamic> json) {
  return _QuizRecommendation.fromJson(json);
}

/// @nodoc
mixin _$QuizRecommendation {
  /// The knowledge gap this recommendation addresses
  ConceptGap get gap => throw _privateConstructorUsedError;

  /// Videos recommended to fix this gap (ordered by relevance)
  List<Video> get recommendedVideos => throw _privateConstructorUsedError;

  /// The topic/subject this gap belongs to (for grouping)
  String get topicName => throw _privateConstructorUsedError;

  /// Estimated time to fix this gap by watching recommended videos (minutes)
  int get estimatedFixMinutes => throw _privateConstructorUsedError;

  /// Whether user has dismissed this recommendation
  bool get dismissed => throw _privateConstructorUsedError;

  /// Whether user has acted on this recommendation (started path or browsed videos)
  bool get acted => throw _privateConstructorUsedError;

  /// When this recommendation was generated
  DateTime get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this QuizRecommendation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizRecommendationCopyWith<QuizRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizRecommendationCopyWith<$Res> {
  factory $QuizRecommendationCopyWith(
    QuizRecommendation value,
    $Res Function(QuizRecommendation) then,
  ) = _$QuizRecommendationCopyWithImpl<$Res, QuizRecommendation>;
  @useResult
  $Res call({
    ConceptGap gap,
    List<Video> recommendedVideos,
    String topicName,
    int estimatedFixMinutes,
    bool dismissed,
    bool acted,
    DateTime generatedAt,
  });

  $ConceptGapCopyWith<$Res> get gap;
}

/// @nodoc
class _$QuizRecommendationCopyWithImpl<$Res, $Val extends QuizRecommendation>
    implements $QuizRecommendationCopyWith<$Res> {
  _$QuizRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gap = null,
    Object? recommendedVideos = null,
    Object? topicName = null,
    Object? estimatedFixMinutes = null,
    Object? dismissed = null,
    Object? acted = null,
    Object? generatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            gap: null == gap
                ? _value.gap
                : gap // ignore: cast_nullable_to_non_nullable
                      as ConceptGap,
            recommendedVideos: null == recommendedVideos
                ? _value.recommendedVideos
                : recommendedVideos // ignore: cast_nullable_to_non_nullable
                      as List<Video>,
            topicName: null == topicName
                ? _value.topicName
                : topicName // ignore: cast_nullable_to_non_nullable
                      as String,
            estimatedFixMinutes: null == estimatedFixMinutes
                ? _value.estimatedFixMinutes
                : estimatedFixMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            dismissed: null == dismissed
                ? _value.dismissed
                : dismissed // ignore: cast_nullable_to_non_nullable
                      as bool,
            acted: null == acted
                ? _value.acted
                : acted // ignore: cast_nullable_to_non_nullable
                      as bool,
            generatedAt: null == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of QuizRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConceptGapCopyWith<$Res> get gap {
    return $ConceptGapCopyWith<$Res>(_value.gap, (value) {
      return _then(_value.copyWith(gap: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuizRecommendationImplCopyWith<$Res>
    implements $QuizRecommendationCopyWith<$Res> {
  factory _$$QuizRecommendationImplCopyWith(
    _$QuizRecommendationImpl value,
    $Res Function(_$QuizRecommendationImpl) then,
  ) = __$$QuizRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ConceptGap gap,
    List<Video> recommendedVideos,
    String topicName,
    int estimatedFixMinutes,
    bool dismissed,
    bool acted,
    DateTime generatedAt,
  });

  @override
  $ConceptGapCopyWith<$Res> get gap;
}

/// @nodoc
class __$$QuizRecommendationImplCopyWithImpl<$Res>
    extends _$QuizRecommendationCopyWithImpl<$Res, _$QuizRecommendationImpl>
    implements _$$QuizRecommendationImplCopyWith<$Res> {
  __$$QuizRecommendationImplCopyWithImpl(
    _$QuizRecommendationImpl _value,
    $Res Function(_$QuizRecommendationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gap = null,
    Object? recommendedVideos = null,
    Object? topicName = null,
    Object? estimatedFixMinutes = null,
    Object? dismissed = null,
    Object? acted = null,
    Object? generatedAt = null,
  }) {
    return _then(
      _$QuizRecommendationImpl(
        gap: null == gap
            ? _value.gap
            : gap // ignore: cast_nullable_to_non_nullable
                  as ConceptGap,
        recommendedVideos: null == recommendedVideos
            ? _value._recommendedVideos
            : recommendedVideos // ignore: cast_nullable_to_non_nullable
                  as List<Video>,
        topicName: null == topicName
            ? _value.topicName
            : topicName // ignore: cast_nullable_to_non_nullable
                  as String,
        estimatedFixMinutes: null == estimatedFixMinutes
            ? _value.estimatedFixMinutes
            : estimatedFixMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        dismissed: null == dismissed
            ? _value.dismissed
            : dismissed // ignore: cast_nullable_to_non_nullable
                  as bool,
        acted: null == acted
            ? _value.acted
            : acted // ignore: cast_nullable_to_non_nullable
                  as bool,
        generatedAt: null == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizRecommendationImpl extends _QuizRecommendation {
  const _$QuizRecommendationImpl({
    required this.gap,
    required final List<Video> recommendedVideos,
    required this.topicName,
    required this.estimatedFixMinutes,
    this.dismissed = false,
    this.acted = false,
    required this.generatedAt,
  }) : _recommendedVideos = recommendedVideos,
       super._();

  factory _$QuizRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizRecommendationImplFromJson(json);

  /// The knowledge gap this recommendation addresses
  @override
  final ConceptGap gap;

  /// Videos recommended to fix this gap (ordered by relevance)
  final List<Video> _recommendedVideos;

  /// Videos recommended to fix this gap (ordered by relevance)
  @override
  List<Video> get recommendedVideos {
    if (_recommendedVideos is EqualUnmodifiableListView)
      return _recommendedVideos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedVideos);
  }

  /// The topic/subject this gap belongs to (for grouping)
  @override
  final String topicName;

  /// Estimated time to fix this gap by watching recommended videos (minutes)
  @override
  final int estimatedFixMinutes;

  /// Whether user has dismissed this recommendation
  @override
  @JsonKey()
  final bool dismissed;

  /// Whether user has acted on this recommendation (started path or browsed videos)
  @override
  @JsonKey()
  final bool acted;

  /// When this recommendation was generated
  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'QuizRecommendation(gap: $gap, recommendedVideos: $recommendedVideos, topicName: $topicName, estimatedFixMinutes: $estimatedFixMinutes, dismissed: $dismissed, acted: $acted, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizRecommendationImpl &&
            (identical(other.gap, gap) || other.gap == gap) &&
            const DeepCollectionEquality().equals(
              other._recommendedVideos,
              _recommendedVideos,
            ) &&
            (identical(other.topicName, topicName) ||
                other.topicName == topicName) &&
            (identical(other.estimatedFixMinutes, estimatedFixMinutes) ||
                other.estimatedFixMinutes == estimatedFixMinutes) &&
            (identical(other.dismissed, dismissed) ||
                other.dismissed == dismissed) &&
            (identical(other.acted, acted) || other.acted == acted) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    gap,
    const DeepCollectionEquality().hash(_recommendedVideos),
    topicName,
    estimatedFixMinutes,
    dismissed,
    acted,
    generatedAt,
  );

  /// Create a copy of QuizRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizRecommendationImplCopyWith<_$QuizRecommendationImpl> get copyWith =>
      __$$QuizRecommendationImplCopyWithImpl<_$QuizRecommendationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizRecommendationImplToJson(this);
  }
}

abstract class _QuizRecommendation extends QuizRecommendation {
  const factory _QuizRecommendation({
    required final ConceptGap gap,
    required final List<Video> recommendedVideos,
    required final String topicName,
    required final int estimatedFixMinutes,
    final bool dismissed,
    final bool acted,
    required final DateTime generatedAt,
  }) = _$QuizRecommendationImpl;
  const _QuizRecommendation._() : super._();

  factory _QuizRecommendation.fromJson(Map<String, dynamic> json) =
      _$QuizRecommendationImpl.fromJson;

  /// The knowledge gap this recommendation addresses
  @override
  ConceptGap get gap;

  /// Videos recommended to fix this gap (ordered by relevance)
  @override
  List<Video> get recommendedVideos;

  /// The topic/subject this gap belongs to (for grouping)
  @override
  String get topicName;

  /// Estimated time to fix this gap by watching recommended videos (minutes)
  @override
  int get estimatedFixMinutes;

  /// Whether user has dismissed this recommendation
  @override
  bool get dismissed;

  /// Whether user has acted on this recommendation (started path or browsed videos)
  @override
  bool get acted;

  /// When this recommendation was generated
  @override
  DateTime get generatedAt;

  /// Create a copy of QuizRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizRecommendationImplCopyWith<_$QuizRecommendationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecommendationsBundle _$RecommendationsBundleFromJson(
  Map<String, dynamic> json,
) {
  return _RecommendationsBundle.fromJson(json);
}

/// @nodoc
mixin _$RecommendationsBundle {
  /// ID of the quiz result these recommendations are for
  String get quizResultId => throw _privateConstructorUsedError;

  /// Type of assessment (readiness or knowledge)
  AssessmentType get assessmentType => throw _privateConstructorUsedError;

  /// All recommendations sorted by priority (highest first)
  List<QuizRecommendation> get recommendations =>
      throw _privateConstructorUsedError;

  /// When these recommendations were generated
  DateTime get generatedAt => throw _privateConstructorUsedError;

  /// Total estimated time to fix all gaps (minutes)
  int get totalEstimatedMinutes => throw _privateConstructorUsedError;

  /// Subject name for context
  String? get subjectName => throw _privateConstructorUsedError;

  /// Quiz score percentage for display
  double? get quizScore => throw _privateConstructorUsedError;

  /// Serializes this RecommendationsBundle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationsBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationsBundleCopyWith<RecommendationsBundle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationsBundleCopyWith<$Res> {
  factory $RecommendationsBundleCopyWith(
    RecommendationsBundle value,
    $Res Function(RecommendationsBundle) then,
  ) = _$RecommendationsBundleCopyWithImpl<$Res, RecommendationsBundle>;
  @useResult
  $Res call({
    String quizResultId,
    AssessmentType assessmentType,
    List<QuizRecommendation> recommendations,
    DateTime generatedAt,
    int totalEstimatedMinutes,
    String? subjectName,
    double? quizScore,
  });
}

/// @nodoc
class _$RecommendationsBundleCopyWithImpl<
  $Res,
  $Val extends RecommendationsBundle
>
    implements $RecommendationsBundleCopyWith<$Res> {
  _$RecommendationsBundleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationsBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizResultId = null,
    Object? assessmentType = null,
    Object? recommendations = null,
    Object? generatedAt = null,
    Object? totalEstimatedMinutes = null,
    Object? subjectName = freezed,
    Object? quizScore = freezed,
  }) {
    return _then(
      _value.copyWith(
            quizResultId: null == quizResultId
                ? _value.quizResultId
                : quizResultId // ignore: cast_nullable_to_non_nullable
                      as String,
            assessmentType: null == assessmentType
                ? _value.assessmentType
                : assessmentType // ignore: cast_nullable_to_non_nullable
                      as AssessmentType,
            recommendations: null == recommendations
                ? _value.recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                      as List<QuizRecommendation>,
            generatedAt: null == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalEstimatedMinutes: null == totalEstimatedMinutes
                ? _value.totalEstimatedMinutes
                : totalEstimatedMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            subjectName: freezed == subjectName
                ? _value.subjectName
                : subjectName // ignore: cast_nullable_to_non_nullable
                      as String?,
            quizScore: freezed == quizScore
                ? _value.quizScore
                : quizScore // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecommendationsBundleImplCopyWith<$Res>
    implements $RecommendationsBundleCopyWith<$Res> {
  factory _$$RecommendationsBundleImplCopyWith(
    _$RecommendationsBundleImpl value,
    $Res Function(_$RecommendationsBundleImpl) then,
  ) = __$$RecommendationsBundleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String quizResultId,
    AssessmentType assessmentType,
    List<QuizRecommendation> recommendations,
    DateTime generatedAt,
    int totalEstimatedMinutes,
    String? subjectName,
    double? quizScore,
  });
}

/// @nodoc
class __$$RecommendationsBundleImplCopyWithImpl<$Res>
    extends
        _$RecommendationsBundleCopyWithImpl<$Res, _$RecommendationsBundleImpl>
    implements _$$RecommendationsBundleImplCopyWith<$Res> {
  __$$RecommendationsBundleImplCopyWithImpl(
    _$RecommendationsBundleImpl _value,
    $Res Function(_$RecommendationsBundleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationsBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizResultId = null,
    Object? assessmentType = null,
    Object? recommendations = null,
    Object? generatedAt = null,
    Object? totalEstimatedMinutes = null,
    Object? subjectName = freezed,
    Object? quizScore = freezed,
  }) {
    return _then(
      _$RecommendationsBundleImpl(
        quizResultId: null == quizResultId
            ? _value.quizResultId
            : quizResultId // ignore: cast_nullable_to_non_nullable
                  as String,
        assessmentType: null == assessmentType
            ? _value.assessmentType
            : assessmentType // ignore: cast_nullable_to_non_nullable
                  as AssessmentType,
        recommendations: null == recommendations
            ? _value._recommendations
            : recommendations // ignore: cast_nullable_to_non_nullable
                  as List<QuizRecommendation>,
        generatedAt: null == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalEstimatedMinutes: null == totalEstimatedMinutes
            ? _value.totalEstimatedMinutes
            : totalEstimatedMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        subjectName: freezed == subjectName
            ? _value.subjectName
            : subjectName // ignore: cast_nullable_to_non_nullable
                  as String?,
        quizScore: freezed == quizScore
            ? _value.quizScore
            : quizScore // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationsBundleImpl extends _RecommendationsBundle {
  const _$RecommendationsBundleImpl({
    required this.quizResultId,
    required this.assessmentType,
    required final List<QuizRecommendation> recommendations,
    required this.generatedAt,
    required this.totalEstimatedMinutes,
    this.subjectName,
    this.quizScore,
  }) : _recommendations = recommendations,
       super._();

  factory _$RecommendationsBundleImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationsBundleImplFromJson(json);

  /// ID of the quiz result these recommendations are for
  @override
  final String quizResultId;

  /// Type of assessment (readiness or knowledge)
  @override
  final AssessmentType assessmentType;

  /// All recommendations sorted by priority (highest first)
  final List<QuizRecommendation> _recommendations;

  /// All recommendations sorted by priority (highest first)
  @override
  List<QuizRecommendation> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  /// When these recommendations were generated
  @override
  final DateTime generatedAt;

  /// Total estimated time to fix all gaps (minutes)
  @override
  final int totalEstimatedMinutes;

  /// Subject name for context
  @override
  final String? subjectName;

  /// Quiz score percentage for display
  @override
  final double? quizScore;

  @override
  String toString() {
    return 'RecommendationsBundle(quizResultId: $quizResultId, assessmentType: $assessmentType, recommendations: $recommendations, generatedAt: $generatedAt, totalEstimatedMinutes: $totalEstimatedMinutes, subjectName: $subjectName, quizScore: $quizScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationsBundleImpl &&
            (identical(other.quizResultId, quizResultId) ||
                other.quizResultId == quizResultId) &&
            (identical(other.assessmentType, assessmentType) ||
                other.assessmentType == assessmentType) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.totalEstimatedMinutes, totalEstimatedMinutes) ||
                other.totalEstimatedMinutes == totalEstimatedMinutes) &&
            (identical(other.subjectName, subjectName) ||
                other.subjectName == subjectName) &&
            (identical(other.quizScore, quizScore) ||
                other.quizScore == quizScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    quizResultId,
    assessmentType,
    const DeepCollectionEquality().hash(_recommendations),
    generatedAt,
    totalEstimatedMinutes,
    subjectName,
    quizScore,
  );

  /// Create a copy of RecommendationsBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationsBundleImplCopyWith<_$RecommendationsBundleImpl>
  get copyWith =>
      __$$RecommendationsBundleImplCopyWithImpl<_$RecommendationsBundleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationsBundleImplToJson(this);
  }
}

abstract class _RecommendationsBundle extends RecommendationsBundle {
  const factory _RecommendationsBundle({
    required final String quizResultId,
    required final AssessmentType assessmentType,
    required final List<QuizRecommendation> recommendations,
    required final DateTime generatedAt,
    required final int totalEstimatedMinutes,
    final String? subjectName,
    final double? quizScore,
  }) = _$RecommendationsBundleImpl;
  const _RecommendationsBundle._() : super._();

  factory _RecommendationsBundle.fromJson(Map<String, dynamic> json) =
      _$RecommendationsBundleImpl.fromJson;

  /// ID of the quiz result these recommendations are for
  @override
  String get quizResultId;

  /// Type of assessment (readiness or knowledge)
  @override
  AssessmentType get assessmentType;

  /// All recommendations sorted by priority (highest first)
  @override
  List<QuizRecommendation> get recommendations;

  /// When these recommendations were generated
  @override
  DateTime get generatedAt;

  /// Total estimated time to fix all gaps (minutes)
  @override
  int get totalEstimatedMinutes;

  /// Subject name for context
  @override
  String? get subjectName;

  /// Quiz score percentage for display
  @override
  double? get quizScore;

  /// Create a copy of RecommendationsBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationsBundleImplCopyWith<_$RecommendationsBundleImpl>
  get copyWith => throw _privateConstructorUsedError;
}
