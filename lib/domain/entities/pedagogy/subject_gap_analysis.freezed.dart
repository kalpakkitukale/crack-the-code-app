// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subject_gap_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SubjectGapAnalysis _$SubjectGapAnalysisFromJson(Map<String, dynamic> json) {
  return _SubjectGapAnalysis.fromJson(json);
}

/// @nodoc
mixin _$SubjectGapAnalysis {
  String get studentId => throw _privateConstructorUsedError;
  String get subjectId => throw _privateConstructorUsedError;
  String get subjectName => throw _privateConstructorUsedError;
  int get targetGrade => throw _privateConstructorUsedError;
  double get overallReadiness => throw _privateConstructorUsedError;
  Map<int, double> get gradeBreakdown => throw _privateConstructorUsedError;
  List<ConceptGap> get gaps => throw _privateConstructorUsedError;
  int get estimatedFixMinutes => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  LearningPath? get recommendedPath => throw _privateConstructorUsedError;
  DateTime? get analyzedAt => throw _privateConstructorUsedError;

  /// Serializes this SubjectGapAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubjectGapAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubjectGapAnalysisCopyWith<SubjectGapAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubjectGapAnalysisCopyWith<$Res> {
  factory $SubjectGapAnalysisCopyWith(
    SubjectGapAnalysis value,
    $Res Function(SubjectGapAnalysis) then,
  ) = _$SubjectGapAnalysisCopyWithImpl<$Res, SubjectGapAnalysis>;
  @useResult
  $Res call({
    String studentId,
    String subjectId,
    String subjectName,
    int targetGrade,
    double overallReadiness,
    Map<int, double> gradeBreakdown,
    List<ConceptGap> gaps,
    int estimatedFixMinutes,
    @JsonKey(includeFromJson: false, includeToJson: false)
    LearningPath? recommendedPath,
    DateTime? analyzedAt,
  });

  $LearningPathCopyWith<$Res>? get recommendedPath;
}

/// @nodoc
class _$SubjectGapAnalysisCopyWithImpl<$Res, $Val extends SubjectGapAnalysis>
    implements $SubjectGapAnalysisCopyWith<$Res> {
  _$SubjectGapAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubjectGapAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? subjectId = null,
    Object? subjectName = null,
    Object? targetGrade = null,
    Object? overallReadiness = null,
    Object? gradeBreakdown = null,
    Object? gaps = null,
    Object? estimatedFixMinutes = null,
    Object? recommendedPath = freezed,
    Object? analyzedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            subjectId: null == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                      as String,
            subjectName: null == subjectName
                ? _value.subjectName
                : subjectName // ignore: cast_nullable_to_non_nullable
                      as String,
            targetGrade: null == targetGrade
                ? _value.targetGrade
                : targetGrade // ignore: cast_nullable_to_non_nullable
                      as int,
            overallReadiness: null == overallReadiness
                ? _value.overallReadiness
                : overallReadiness // ignore: cast_nullable_to_non_nullable
                      as double,
            gradeBreakdown: null == gradeBreakdown
                ? _value.gradeBreakdown
                : gradeBreakdown // ignore: cast_nullable_to_non_nullable
                      as Map<int, double>,
            gaps: null == gaps
                ? _value.gaps
                : gaps // ignore: cast_nullable_to_non_nullable
                      as List<ConceptGap>,
            estimatedFixMinutes: null == estimatedFixMinutes
                ? _value.estimatedFixMinutes
                : estimatedFixMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            recommendedPath: freezed == recommendedPath
                ? _value.recommendedPath
                : recommendedPath // ignore: cast_nullable_to_non_nullable
                      as LearningPath?,
            analyzedAt: freezed == analyzedAt
                ? _value.analyzedAt
                : analyzedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of SubjectGapAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LearningPathCopyWith<$Res>? get recommendedPath {
    if (_value.recommendedPath == null) {
      return null;
    }

    return $LearningPathCopyWith<$Res>(_value.recommendedPath!, (value) {
      return _then(_value.copyWith(recommendedPath: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SubjectGapAnalysisImplCopyWith<$Res>
    implements $SubjectGapAnalysisCopyWith<$Res> {
  factory _$$SubjectGapAnalysisImplCopyWith(
    _$SubjectGapAnalysisImpl value,
    $Res Function(_$SubjectGapAnalysisImpl) then,
  ) = __$$SubjectGapAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String studentId,
    String subjectId,
    String subjectName,
    int targetGrade,
    double overallReadiness,
    Map<int, double> gradeBreakdown,
    List<ConceptGap> gaps,
    int estimatedFixMinutes,
    @JsonKey(includeFromJson: false, includeToJson: false)
    LearningPath? recommendedPath,
    DateTime? analyzedAt,
  });

  @override
  $LearningPathCopyWith<$Res>? get recommendedPath;
}

/// @nodoc
class __$$SubjectGapAnalysisImplCopyWithImpl<$Res>
    extends _$SubjectGapAnalysisCopyWithImpl<$Res, _$SubjectGapAnalysisImpl>
    implements _$$SubjectGapAnalysisImplCopyWith<$Res> {
  __$$SubjectGapAnalysisImplCopyWithImpl(
    _$SubjectGapAnalysisImpl _value,
    $Res Function(_$SubjectGapAnalysisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubjectGapAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? subjectId = null,
    Object? subjectName = null,
    Object? targetGrade = null,
    Object? overallReadiness = null,
    Object? gradeBreakdown = null,
    Object? gaps = null,
    Object? estimatedFixMinutes = null,
    Object? recommendedPath = freezed,
    Object? analyzedAt = freezed,
  }) {
    return _then(
      _$SubjectGapAnalysisImpl(
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        subjectId: null == subjectId
            ? _value.subjectId
            : subjectId // ignore: cast_nullable_to_non_nullable
                  as String,
        subjectName: null == subjectName
            ? _value.subjectName
            : subjectName // ignore: cast_nullable_to_non_nullable
                  as String,
        targetGrade: null == targetGrade
            ? _value.targetGrade
            : targetGrade // ignore: cast_nullable_to_non_nullable
                  as int,
        overallReadiness: null == overallReadiness
            ? _value.overallReadiness
            : overallReadiness // ignore: cast_nullable_to_non_nullable
                  as double,
        gradeBreakdown: null == gradeBreakdown
            ? _value._gradeBreakdown
            : gradeBreakdown // ignore: cast_nullable_to_non_nullable
                  as Map<int, double>,
        gaps: null == gaps
            ? _value._gaps
            : gaps // ignore: cast_nullable_to_non_nullable
                  as List<ConceptGap>,
        estimatedFixMinutes: null == estimatedFixMinutes
            ? _value.estimatedFixMinutes
            : estimatedFixMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        recommendedPath: freezed == recommendedPath
            ? _value.recommendedPath
            : recommendedPath // ignore: cast_nullable_to_non_nullable
                  as LearningPath?,
        analyzedAt: freezed == analyzedAt
            ? _value.analyzedAt
            : analyzedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubjectGapAnalysisImpl extends _SubjectGapAnalysis {
  const _$SubjectGapAnalysisImpl({
    required this.studentId,
    required this.subjectId,
    required this.subjectName,
    required this.targetGrade,
    required this.overallReadiness,
    required final Map<int, double> gradeBreakdown,
    required final List<ConceptGap> gaps,
    required this.estimatedFixMinutes,
    @JsonKey(includeFromJson: false, includeToJson: false) this.recommendedPath,
    this.analyzedAt,
  }) : _gradeBreakdown = gradeBreakdown,
       _gaps = gaps,
       super._();

  factory _$SubjectGapAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubjectGapAnalysisImplFromJson(json);

  @override
  final String studentId;
  @override
  final String subjectId;
  @override
  final String subjectName;
  @override
  final int targetGrade;
  @override
  final double overallReadiness;
  final Map<int, double> _gradeBreakdown;
  @override
  Map<int, double> get gradeBreakdown {
    if (_gradeBreakdown is EqualUnmodifiableMapView) return _gradeBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_gradeBreakdown);
  }

  final List<ConceptGap> _gaps;
  @override
  List<ConceptGap> get gaps {
    if (_gaps is EqualUnmodifiableListView) return _gaps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gaps);
  }

  @override
  final int estimatedFixMinutes;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final LearningPath? recommendedPath;
  @override
  final DateTime? analyzedAt;

  @override
  String toString() {
    return 'SubjectGapAnalysis(studentId: $studentId, subjectId: $subjectId, subjectName: $subjectName, targetGrade: $targetGrade, overallReadiness: $overallReadiness, gradeBreakdown: $gradeBreakdown, gaps: $gaps, estimatedFixMinutes: $estimatedFixMinutes, recommendedPath: $recommendedPath, analyzedAt: $analyzedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubjectGapAnalysisImpl &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            (identical(other.subjectName, subjectName) ||
                other.subjectName == subjectName) &&
            (identical(other.targetGrade, targetGrade) ||
                other.targetGrade == targetGrade) &&
            (identical(other.overallReadiness, overallReadiness) ||
                other.overallReadiness == overallReadiness) &&
            const DeepCollectionEquality().equals(
              other._gradeBreakdown,
              _gradeBreakdown,
            ) &&
            const DeepCollectionEquality().equals(other._gaps, _gaps) &&
            (identical(other.estimatedFixMinutes, estimatedFixMinutes) ||
                other.estimatedFixMinutes == estimatedFixMinutes) &&
            (identical(other.recommendedPath, recommendedPath) ||
                other.recommendedPath == recommendedPath) &&
            (identical(other.analyzedAt, analyzedAt) ||
                other.analyzedAt == analyzedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    studentId,
    subjectId,
    subjectName,
    targetGrade,
    overallReadiness,
    const DeepCollectionEquality().hash(_gradeBreakdown),
    const DeepCollectionEquality().hash(_gaps),
    estimatedFixMinutes,
    recommendedPath,
    analyzedAt,
  );

  /// Create a copy of SubjectGapAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubjectGapAnalysisImplCopyWith<_$SubjectGapAnalysisImpl> get copyWith =>
      __$$SubjectGapAnalysisImplCopyWithImpl<_$SubjectGapAnalysisImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SubjectGapAnalysisImplToJson(this);
  }
}

abstract class _SubjectGapAnalysis extends SubjectGapAnalysis {
  const factory _SubjectGapAnalysis({
    required final String studentId,
    required final String subjectId,
    required final String subjectName,
    required final int targetGrade,
    required final double overallReadiness,
    required final Map<int, double> gradeBreakdown,
    required final List<ConceptGap> gaps,
    required final int estimatedFixMinutes,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final LearningPath? recommendedPath,
    final DateTime? analyzedAt,
  }) = _$SubjectGapAnalysisImpl;
  const _SubjectGapAnalysis._() : super._();

  factory _SubjectGapAnalysis.fromJson(Map<String, dynamic> json) =
      _$SubjectGapAnalysisImpl.fromJson;

  @override
  String get studentId;
  @override
  String get subjectId;
  @override
  String get subjectName;
  @override
  int get targetGrade;
  @override
  double get overallReadiness;
  @override
  Map<int, double> get gradeBreakdown;
  @override
  List<ConceptGap> get gaps;
  @override
  int get estimatedFixMinutes;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  LearningPath? get recommendedPath;
  @override
  DateTime? get analyzedAt;

  /// Create a copy of SubjectGapAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubjectGapAnalysisImplCopyWith<_$SubjectGapAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
