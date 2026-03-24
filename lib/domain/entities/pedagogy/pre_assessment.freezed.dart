// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pre_assessment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PreAssessment _$PreAssessmentFromJson(Map<String, dynamic> json) {
  return _PreAssessment.fromJson(json);
}

/// @nodoc
mixin _$PreAssessment {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get subjectId => throw _privateConstructorUsedError;
  int get targetGrade => throw _privateConstructorUsedError;
  PreAssessmentPhase get currentPhase => throw _privateConstructorUsedError;
  List<String> get questionIds => throw _privateConstructorUsedError;
  Map<String, String> get answers => throw _privateConstructorUsedError;
  int get currentQuestionIndex => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  PreAssessmentResult? get result => throw _privateConstructorUsedError;

  /// Serializes this PreAssessment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PreAssessment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreAssessmentCopyWith<PreAssessment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreAssessmentCopyWith<$Res> {
  factory $PreAssessmentCopyWith(
    PreAssessment value,
    $Res Function(PreAssessment) then,
  ) = _$PreAssessmentCopyWithImpl<$Res, PreAssessment>;
  @useResult
  $Res call({
    String id,
    String studentId,
    String subjectId,
    int targetGrade,
    PreAssessmentPhase currentPhase,
    List<String> questionIds,
    Map<String, String> answers,
    int currentQuestionIndex,
    DateTime startedAt,
    DateTime? completedAt,
    PreAssessmentResult? result,
  });

  $PreAssessmentResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$PreAssessmentCopyWithImpl<$Res, $Val extends PreAssessment>
    implements $PreAssessmentCopyWith<$Res> {
  _$PreAssessmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreAssessment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? subjectId = null,
    Object? targetGrade = null,
    Object? currentPhase = null,
    Object? questionIds = null,
    Object? answers = null,
    Object? currentQuestionIndex = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? result = freezed,
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
            subjectId: null == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                      as String,
            targetGrade: null == targetGrade
                ? _value.targetGrade
                : targetGrade // ignore: cast_nullable_to_non_nullable
                      as int,
            currentPhase: null == currentPhase
                ? _value.currentPhase
                : currentPhase // ignore: cast_nullable_to_non_nullable
                      as PreAssessmentPhase,
            questionIds: null == questionIds
                ? _value.questionIds
                : questionIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            answers: null == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            currentQuestionIndex: null == currentQuestionIndex
                ? _value.currentQuestionIndex
                : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            result: freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as PreAssessmentResult?,
          )
          as $Val,
    );
  }

  /// Create a copy of PreAssessment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PreAssessmentResultCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $PreAssessmentResultCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PreAssessmentImplCopyWith<$Res>
    implements $PreAssessmentCopyWith<$Res> {
  factory _$$PreAssessmentImplCopyWith(
    _$PreAssessmentImpl value,
    $Res Function(_$PreAssessmentImpl) then,
  ) = __$$PreAssessmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String studentId,
    String subjectId,
    int targetGrade,
    PreAssessmentPhase currentPhase,
    List<String> questionIds,
    Map<String, String> answers,
    int currentQuestionIndex,
    DateTime startedAt,
    DateTime? completedAt,
    PreAssessmentResult? result,
  });

  @override
  $PreAssessmentResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$PreAssessmentImplCopyWithImpl<$Res>
    extends _$PreAssessmentCopyWithImpl<$Res, _$PreAssessmentImpl>
    implements _$$PreAssessmentImplCopyWith<$Res> {
  __$$PreAssessmentImplCopyWithImpl(
    _$PreAssessmentImpl _value,
    $Res Function(_$PreAssessmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PreAssessment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? subjectId = null,
    Object? targetGrade = null,
    Object? currentPhase = null,
    Object? questionIds = null,
    Object? answers = null,
    Object? currentQuestionIndex = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? result = freezed,
  }) {
    return _then(
      _$PreAssessmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        subjectId: null == subjectId
            ? _value.subjectId
            : subjectId // ignore: cast_nullable_to_non_nullable
                  as String,
        targetGrade: null == targetGrade
            ? _value.targetGrade
            : targetGrade // ignore: cast_nullable_to_non_nullable
                  as int,
        currentPhase: null == currentPhase
            ? _value.currentPhase
            : currentPhase // ignore: cast_nullable_to_non_nullable
                  as PreAssessmentPhase,
        questionIds: null == questionIds
            ? _value._questionIds
            : questionIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        answers: null == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        currentQuestionIndex: null == currentQuestionIndex
            ? _value.currentQuestionIndex
            : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        result: freezed == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                  as PreAssessmentResult?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PreAssessmentImpl extends _PreAssessment {
  const _$PreAssessmentImpl({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.targetGrade,
    required this.currentPhase,
    final List<String> questionIds = const [],
    final Map<String, String> answers = const {},
    this.currentQuestionIndex = 0,
    required this.startedAt,
    this.completedAt,
    this.result,
  }) : _questionIds = questionIds,
       _answers = answers,
       super._();

  factory _$PreAssessmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreAssessmentImplFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  final String subjectId;
  @override
  final int targetGrade;
  @override
  final PreAssessmentPhase currentPhase;
  final List<String> _questionIds;
  @override
  @JsonKey()
  List<String> get questionIds {
    if (_questionIds is EqualUnmodifiableListView) return _questionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questionIds);
  }

  final Map<String, String> _answers;
  @override
  @JsonKey()
  Map<String, String> get answers {
    if (_answers is EqualUnmodifiableMapView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_answers);
  }

  @override
  @JsonKey()
  final int currentQuestionIndex;
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;
  @override
  final PreAssessmentResult? result;

  @override
  String toString() {
    return 'PreAssessment(id: $id, studentId: $studentId, subjectId: $subjectId, targetGrade: $targetGrade, currentPhase: $currentPhase, questionIds: $questionIds, answers: $answers, currentQuestionIndex: $currentQuestionIndex, startedAt: $startedAt, completedAt: $completedAt, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreAssessmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            (identical(other.targetGrade, targetGrade) ||
                other.targetGrade == targetGrade) &&
            (identical(other.currentPhase, currentPhase) ||
                other.currentPhase == currentPhase) &&
            const DeepCollectionEquality().equals(
              other._questionIds,
              _questionIds,
            ) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(other.currentQuestionIndex, currentQuestionIndex) ||
                other.currentQuestionIndex == currentQuestionIndex) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.result, result) || other.result == result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentId,
    subjectId,
    targetGrade,
    currentPhase,
    const DeepCollectionEquality().hash(_questionIds),
    const DeepCollectionEquality().hash(_answers),
    currentQuestionIndex,
    startedAt,
    completedAt,
    result,
  );

  /// Create a copy of PreAssessment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreAssessmentImplCopyWith<_$PreAssessmentImpl> get copyWith =>
      __$$PreAssessmentImplCopyWithImpl<_$PreAssessmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PreAssessmentImplToJson(this);
  }
}

abstract class _PreAssessment extends PreAssessment {
  const factory _PreAssessment({
    required final String id,
    required final String studentId,
    required final String subjectId,
    required final int targetGrade,
    required final PreAssessmentPhase currentPhase,
    final List<String> questionIds,
    final Map<String, String> answers,
    final int currentQuestionIndex,
    required final DateTime startedAt,
    final DateTime? completedAt,
    final PreAssessmentResult? result,
  }) = _$PreAssessmentImpl;
  const _PreAssessment._() : super._();

  factory _PreAssessment.fromJson(Map<String, dynamic> json) =
      _$PreAssessmentImpl.fromJson;

  @override
  String get id;
  @override
  String get studentId;
  @override
  String get subjectId;
  @override
  int get targetGrade;
  @override
  PreAssessmentPhase get currentPhase;
  @override
  List<String> get questionIds;
  @override
  Map<String, String> get answers;
  @override
  int get currentQuestionIndex;
  @override
  DateTime get startedAt;
  @override
  DateTime? get completedAt;
  @override
  PreAssessmentResult? get result;

  /// Create a copy of PreAssessment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreAssessmentImplCopyWith<_$PreAssessmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PreAssessmentResult _$PreAssessmentResultFromJson(Map<String, dynamic> json) {
  return _PreAssessmentResult.fromJson(json);
}

/// @nodoc
mixin _$PreAssessmentResult {
  String get assessmentId => throw _privateConstructorUsedError;
  double get overallReadiness => throw _privateConstructorUsedError;
  Map<int, double> get gradeScores => throw _privateConstructorUsedError;
  List<ConceptGap> get identifiedGaps => throw _privateConstructorUsedError;
  int get estimatedFixMinutes => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  LearningPath? get recommendedPath => throw _privateConstructorUsedError;
  DateTime? get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this PreAssessmentResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PreAssessmentResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreAssessmentResultCopyWith<PreAssessmentResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreAssessmentResultCopyWith<$Res> {
  factory $PreAssessmentResultCopyWith(
    PreAssessmentResult value,
    $Res Function(PreAssessmentResult) then,
  ) = _$PreAssessmentResultCopyWithImpl<$Res, PreAssessmentResult>;
  @useResult
  $Res call({
    String assessmentId,
    double overallReadiness,
    Map<int, double> gradeScores,
    List<ConceptGap> identifiedGaps,
    int estimatedFixMinutes,
    @JsonKey(includeFromJson: false, includeToJson: false)
    LearningPath? recommendedPath,
    DateTime? generatedAt,
  });

  $LearningPathCopyWith<$Res>? get recommendedPath;
}

/// @nodoc
class _$PreAssessmentResultCopyWithImpl<$Res, $Val extends PreAssessmentResult>
    implements $PreAssessmentResultCopyWith<$Res> {
  _$PreAssessmentResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreAssessmentResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assessmentId = null,
    Object? overallReadiness = null,
    Object? gradeScores = null,
    Object? identifiedGaps = null,
    Object? estimatedFixMinutes = null,
    Object? recommendedPath = freezed,
    Object? generatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            assessmentId: null == assessmentId
                ? _value.assessmentId
                : assessmentId // ignore: cast_nullable_to_non_nullable
                      as String,
            overallReadiness: null == overallReadiness
                ? _value.overallReadiness
                : overallReadiness // ignore: cast_nullable_to_non_nullable
                      as double,
            gradeScores: null == gradeScores
                ? _value.gradeScores
                : gradeScores // ignore: cast_nullable_to_non_nullable
                      as Map<int, double>,
            identifiedGaps: null == identifiedGaps
                ? _value.identifiedGaps
                : identifiedGaps // ignore: cast_nullable_to_non_nullable
                      as List<ConceptGap>,
            estimatedFixMinutes: null == estimatedFixMinutes
                ? _value.estimatedFixMinutes
                : estimatedFixMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            recommendedPath: freezed == recommendedPath
                ? _value.recommendedPath
                : recommendedPath // ignore: cast_nullable_to_non_nullable
                      as LearningPath?,
            generatedAt: freezed == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of PreAssessmentResult
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
abstract class _$$PreAssessmentResultImplCopyWith<$Res>
    implements $PreAssessmentResultCopyWith<$Res> {
  factory _$$PreAssessmentResultImplCopyWith(
    _$PreAssessmentResultImpl value,
    $Res Function(_$PreAssessmentResultImpl) then,
  ) = __$$PreAssessmentResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String assessmentId,
    double overallReadiness,
    Map<int, double> gradeScores,
    List<ConceptGap> identifiedGaps,
    int estimatedFixMinutes,
    @JsonKey(includeFromJson: false, includeToJson: false)
    LearningPath? recommendedPath,
    DateTime? generatedAt,
  });

  @override
  $LearningPathCopyWith<$Res>? get recommendedPath;
}

/// @nodoc
class __$$PreAssessmentResultImplCopyWithImpl<$Res>
    extends _$PreAssessmentResultCopyWithImpl<$Res, _$PreAssessmentResultImpl>
    implements _$$PreAssessmentResultImplCopyWith<$Res> {
  __$$PreAssessmentResultImplCopyWithImpl(
    _$PreAssessmentResultImpl _value,
    $Res Function(_$PreAssessmentResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PreAssessmentResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assessmentId = null,
    Object? overallReadiness = null,
    Object? gradeScores = null,
    Object? identifiedGaps = null,
    Object? estimatedFixMinutes = null,
    Object? recommendedPath = freezed,
    Object? generatedAt = freezed,
  }) {
    return _then(
      _$PreAssessmentResultImpl(
        assessmentId: null == assessmentId
            ? _value.assessmentId
            : assessmentId // ignore: cast_nullable_to_non_nullable
                  as String,
        overallReadiness: null == overallReadiness
            ? _value.overallReadiness
            : overallReadiness // ignore: cast_nullable_to_non_nullable
                  as double,
        gradeScores: null == gradeScores
            ? _value._gradeScores
            : gradeScores // ignore: cast_nullable_to_non_nullable
                  as Map<int, double>,
        identifiedGaps: null == identifiedGaps
            ? _value._identifiedGaps
            : identifiedGaps // ignore: cast_nullable_to_non_nullable
                  as List<ConceptGap>,
        estimatedFixMinutes: null == estimatedFixMinutes
            ? _value.estimatedFixMinutes
            : estimatedFixMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        recommendedPath: freezed == recommendedPath
            ? _value.recommendedPath
            : recommendedPath // ignore: cast_nullable_to_non_nullable
                  as LearningPath?,
        generatedAt: freezed == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PreAssessmentResultImpl extends _PreAssessmentResult {
  const _$PreAssessmentResultImpl({
    required this.assessmentId,
    required this.overallReadiness,
    required final Map<int, double> gradeScores,
    required final List<ConceptGap> identifiedGaps,
    required this.estimatedFixMinutes,
    @JsonKey(includeFromJson: false, includeToJson: false) this.recommendedPath,
    this.generatedAt,
  }) : _gradeScores = gradeScores,
       _identifiedGaps = identifiedGaps,
       super._();

  factory _$PreAssessmentResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreAssessmentResultImplFromJson(json);

  @override
  final String assessmentId;
  @override
  final double overallReadiness;
  final Map<int, double> _gradeScores;
  @override
  Map<int, double> get gradeScores {
    if (_gradeScores is EqualUnmodifiableMapView) return _gradeScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_gradeScores);
  }

  final List<ConceptGap> _identifiedGaps;
  @override
  List<ConceptGap> get identifiedGaps {
    if (_identifiedGaps is EqualUnmodifiableListView) return _identifiedGaps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_identifiedGaps);
  }

  @override
  final int estimatedFixMinutes;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final LearningPath? recommendedPath;
  @override
  final DateTime? generatedAt;

  @override
  String toString() {
    return 'PreAssessmentResult(assessmentId: $assessmentId, overallReadiness: $overallReadiness, gradeScores: $gradeScores, identifiedGaps: $identifiedGaps, estimatedFixMinutes: $estimatedFixMinutes, recommendedPath: $recommendedPath, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreAssessmentResultImpl &&
            (identical(other.assessmentId, assessmentId) ||
                other.assessmentId == assessmentId) &&
            (identical(other.overallReadiness, overallReadiness) ||
                other.overallReadiness == overallReadiness) &&
            const DeepCollectionEquality().equals(
              other._gradeScores,
              _gradeScores,
            ) &&
            const DeepCollectionEquality().equals(
              other._identifiedGaps,
              _identifiedGaps,
            ) &&
            (identical(other.estimatedFixMinutes, estimatedFixMinutes) ||
                other.estimatedFixMinutes == estimatedFixMinutes) &&
            (identical(other.recommendedPath, recommendedPath) ||
                other.recommendedPath == recommendedPath) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    assessmentId,
    overallReadiness,
    const DeepCollectionEquality().hash(_gradeScores),
    const DeepCollectionEquality().hash(_identifiedGaps),
    estimatedFixMinutes,
    recommendedPath,
    generatedAt,
  );

  /// Create a copy of PreAssessmentResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreAssessmentResultImplCopyWith<_$PreAssessmentResultImpl> get copyWith =>
      __$$PreAssessmentResultImplCopyWithImpl<_$PreAssessmentResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PreAssessmentResultImplToJson(this);
  }
}

abstract class _PreAssessmentResult extends PreAssessmentResult {
  const factory _PreAssessmentResult({
    required final String assessmentId,
    required final double overallReadiness,
    required final Map<int, double> gradeScores,
    required final List<ConceptGap> identifiedGaps,
    required final int estimatedFixMinutes,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final LearningPath? recommendedPath,
    final DateTime? generatedAt,
  }) = _$PreAssessmentResultImpl;
  const _PreAssessmentResult._() : super._();

  factory _PreAssessmentResult.fromJson(Map<String, dynamic> json) =
      _$PreAssessmentResultImpl.fromJson;

  @override
  String get assessmentId;
  @override
  double get overallReadiness;
  @override
  Map<int, double> get gradeScores;
  @override
  List<ConceptGap> get identifiedGaps;
  @override
  int get estimatedFixMinutes;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  LearningPath? get recommendedPath;
  @override
  DateTime? get generatedAt;

  /// Create a copy of PreAssessmentResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreAssessmentResultImplCopyWith<_$PreAssessmentResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
