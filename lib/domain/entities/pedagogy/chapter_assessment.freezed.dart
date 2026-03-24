// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_assessment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChapterAssessment _$ChapterAssessmentFromJson(Map<String, dynamic> json) {
  return _ChapterAssessment.fromJson(json);
}

/// @nodoc
mixin _$ChapterAssessment {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get chapterId => throw _privateConstructorUsedError;
  String get chapterName => throw _privateConstructorUsedError;
  String get subjectId => throw _privateConstructorUsedError;
  int get gradeLevel => throw _privateConstructorUsedError;
  List<String> get questionIds => throw _privateConstructorUsedError;
  Map<String, String> get answers => throw _privateConstructorUsedError;
  int get currentQuestionIndex => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  ChapterAssessmentResult? get result => throw _privateConstructorUsedError;

  /// Serializes this ChapterAssessment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChapterAssessment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChapterAssessmentCopyWith<ChapterAssessment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterAssessmentCopyWith<$Res> {
  factory $ChapterAssessmentCopyWith(
    ChapterAssessment value,
    $Res Function(ChapterAssessment) then,
  ) = _$ChapterAssessmentCopyWithImpl<$Res, ChapterAssessment>;
  @useResult
  $Res call({
    String id,
    String studentId,
    String chapterId,
    String chapterName,
    String subjectId,
    int gradeLevel,
    List<String> questionIds,
    Map<String, String> answers,
    int currentQuestionIndex,
    DateTime startedAt,
    DateTime? completedAt,
    ChapterAssessmentResult? result,
  });

  $ChapterAssessmentResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$ChapterAssessmentCopyWithImpl<$Res, $Val extends ChapterAssessment>
    implements $ChapterAssessmentCopyWith<$Res> {
  _$ChapterAssessmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChapterAssessment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? chapterId = null,
    Object? chapterName = null,
    Object? subjectId = null,
    Object? gradeLevel = null,
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
            chapterId: null == chapterId
                ? _value.chapterId
                : chapterId // ignore: cast_nullable_to_non_nullable
                      as String,
            chapterName: null == chapterName
                ? _value.chapterName
                : chapterName // ignore: cast_nullable_to_non_nullable
                      as String,
            subjectId: null == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                      as String,
            gradeLevel: null == gradeLevel
                ? _value.gradeLevel
                : gradeLevel // ignore: cast_nullable_to_non_nullable
                      as int,
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
                      as ChapterAssessmentResult?,
          )
          as $Val,
    );
  }

  /// Create a copy of ChapterAssessment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChapterAssessmentResultCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $ChapterAssessmentResultCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChapterAssessmentImplCopyWith<$Res>
    implements $ChapterAssessmentCopyWith<$Res> {
  factory _$$ChapterAssessmentImplCopyWith(
    _$ChapterAssessmentImpl value,
    $Res Function(_$ChapterAssessmentImpl) then,
  ) = __$$ChapterAssessmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String studentId,
    String chapterId,
    String chapterName,
    String subjectId,
    int gradeLevel,
    List<String> questionIds,
    Map<String, String> answers,
    int currentQuestionIndex,
    DateTime startedAt,
    DateTime? completedAt,
    ChapterAssessmentResult? result,
  });

  @override
  $ChapterAssessmentResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$ChapterAssessmentImplCopyWithImpl<$Res>
    extends _$ChapterAssessmentCopyWithImpl<$Res, _$ChapterAssessmentImpl>
    implements _$$ChapterAssessmentImplCopyWith<$Res> {
  __$$ChapterAssessmentImplCopyWithImpl(
    _$ChapterAssessmentImpl _value,
    $Res Function(_$ChapterAssessmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChapterAssessment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? chapterId = null,
    Object? chapterName = null,
    Object? subjectId = null,
    Object? gradeLevel = null,
    Object? questionIds = null,
    Object? answers = null,
    Object? currentQuestionIndex = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? result = freezed,
  }) {
    return _then(
      _$ChapterAssessmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        chapterId: null == chapterId
            ? _value.chapterId
            : chapterId // ignore: cast_nullable_to_non_nullable
                  as String,
        chapterName: null == chapterName
            ? _value.chapterName
            : chapterName // ignore: cast_nullable_to_non_nullable
                  as String,
        subjectId: null == subjectId
            ? _value.subjectId
            : subjectId // ignore: cast_nullable_to_non_nullable
                  as String,
        gradeLevel: null == gradeLevel
            ? _value.gradeLevel
            : gradeLevel // ignore: cast_nullable_to_non_nullable
                  as int,
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
                  as ChapterAssessmentResult?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChapterAssessmentImpl extends _ChapterAssessment {
  const _$ChapterAssessmentImpl({
    required this.id,
    required this.studentId,
    required this.chapterId,
    required this.chapterName,
    required this.subjectId,
    required this.gradeLevel,
    final List<String> questionIds = const [],
    final Map<String, String> answers = const {},
    this.currentQuestionIndex = 0,
    required this.startedAt,
    this.completedAt,
    this.result,
  }) : _questionIds = questionIds,
       _answers = answers,
       super._();

  factory _$ChapterAssessmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterAssessmentImplFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  final String chapterId;
  @override
  final String chapterName;
  @override
  final String subjectId;
  @override
  final int gradeLevel;
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
  final ChapterAssessmentResult? result;

  @override
  String toString() {
    return 'ChapterAssessment(id: $id, studentId: $studentId, chapterId: $chapterId, chapterName: $chapterName, subjectId: $subjectId, gradeLevel: $gradeLevel, questionIds: $questionIds, answers: $answers, currentQuestionIndex: $currentQuestionIndex, startedAt: $startedAt, completedAt: $completedAt, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterAssessmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.chapterName, chapterName) ||
                other.chapterName == chapterName) &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
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
    chapterId,
    chapterName,
    subjectId,
    gradeLevel,
    const DeepCollectionEquality().hash(_questionIds),
    const DeepCollectionEquality().hash(_answers),
    currentQuestionIndex,
    startedAt,
    completedAt,
    result,
  );

  /// Create a copy of ChapterAssessment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChapterAssessmentImplCopyWith<_$ChapterAssessmentImpl> get copyWith =>
      __$$ChapterAssessmentImplCopyWithImpl<_$ChapterAssessmentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterAssessmentImplToJson(this);
  }
}

abstract class _ChapterAssessment extends ChapterAssessment {
  const factory _ChapterAssessment({
    required final String id,
    required final String studentId,
    required final String chapterId,
    required final String chapterName,
    required final String subjectId,
    required final int gradeLevel,
    final List<String> questionIds,
    final Map<String, String> answers,
    final int currentQuestionIndex,
    required final DateTime startedAt,
    final DateTime? completedAt,
    final ChapterAssessmentResult? result,
  }) = _$ChapterAssessmentImpl;
  const _ChapterAssessment._() : super._();

  factory _ChapterAssessment.fromJson(Map<String, dynamic> json) =
      _$ChapterAssessmentImpl.fromJson;

  @override
  String get id;
  @override
  String get studentId;
  @override
  String get chapterId;
  @override
  String get chapterName;
  @override
  String get subjectId;
  @override
  int get gradeLevel;
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
  ChapterAssessmentResult? get result;

  /// Create a copy of ChapterAssessment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChapterAssessmentImplCopyWith<_$ChapterAssessmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChapterAssessmentResult _$ChapterAssessmentResultFromJson(
  Map<String, dynamic> json,
) {
  return _ChapterAssessmentResult.fromJson(json);
}

/// @nodoc
mixin _$ChapterAssessmentResult {
  String get assessmentId => throw _privateConstructorUsedError;
  String get chapterId => throw _privateConstructorUsedError;
  double get overallScore => throw _privateConstructorUsedError;
  Map<String, double> get conceptScores => throw _privateConstructorUsedError;
  List<ConceptGap> get identifiedGaps => throw _privateConstructorUsedError;
  int get estimatedFixMinutes => throw _privateConstructorUsedError;
  List<String> get recommendedVideoIds => throw _privateConstructorUsedError;
  DateTime? get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChapterAssessmentResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChapterAssessmentResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChapterAssessmentResultCopyWith<ChapterAssessmentResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterAssessmentResultCopyWith<$Res> {
  factory $ChapterAssessmentResultCopyWith(
    ChapterAssessmentResult value,
    $Res Function(ChapterAssessmentResult) then,
  ) = _$ChapterAssessmentResultCopyWithImpl<$Res, ChapterAssessmentResult>;
  @useResult
  $Res call({
    String assessmentId,
    String chapterId,
    double overallScore,
    Map<String, double> conceptScores,
    List<ConceptGap> identifiedGaps,
    int estimatedFixMinutes,
    List<String> recommendedVideoIds,
    DateTime? generatedAt,
  });
}

/// @nodoc
class _$ChapterAssessmentResultCopyWithImpl<
  $Res,
  $Val extends ChapterAssessmentResult
>
    implements $ChapterAssessmentResultCopyWith<$Res> {
  _$ChapterAssessmentResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChapterAssessmentResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assessmentId = null,
    Object? chapterId = null,
    Object? overallScore = null,
    Object? conceptScores = null,
    Object? identifiedGaps = null,
    Object? estimatedFixMinutes = null,
    Object? recommendedVideoIds = null,
    Object? generatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            assessmentId: null == assessmentId
                ? _value.assessmentId
                : assessmentId // ignore: cast_nullable_to_non_nullable
                      as String,
            chapterId: null == chapterId
                ? _value.chapterId
                : chapterId // ignore: cast_nullable_to_non_nullable
                      as String,
            overallScore: null == overallScore
                ? _value.overallScore
                : overallScore // ignore: cast_nullable_to_non_nullable
                      as double,
            conceptScores: null == conceptScores
                ? _value.conceptScores
                : conceptScores // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            identifiedGaps: null == identifiedGaps
                ? _value.identifiedGaps
                : identifiedGaps // ignore: cast_nullable_to_non_nullable
                      as List<ConceptGap>,
            estimatedFixMinutes: null == estimatedFixMinutes
                ? _value.estimatedFixMinutes
                : estimatedFixMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            recommendedVideoIds: null == recommendedVideoIds
                ? _value.recommendedVideoIds
                : recommendedVideoIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            generatedAt: freezed == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChapterAssessmentResultImplCopyWith<$Res>
    implements $ChapterAssessmentResultCopyWith<$Res> {
  factory _$$ChapterAssessmentResultImplCopyWith(
    _$ChapterAssessmentResultImpl value,
    $Res Function(_$ChapterAssessmentResultImpl) then,
  ) = __$$ChapterAssessmentResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String assessmentId,
    String chapterId,
    double overallScore,
    Map<String, double> conceptScores,
    List<ConceptGap> identifiedGaps,
    int estimatedFixMinutes,
    List<String> recommendedVideoIds,
    DateTime? generatedAt,
  });
}

/// @nodoc
class __$$ChapterAssessmentResultImplCopyWithImpl<$Res>
    extends
        _$ChapterAssessmentResultCopyWithImpl<
          $Res,
          _$ChapterAssessmentResultImpl
        >
    implements _$$ChapterAssessmentResultImplCopyWith<$Res> {
  __$$ChapterAssessmentResultImplCopyWithImpl(
    _$ChapterAssessmentResultImpl _value,
    $Res Function(_$ChapterAssessmentResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChapterAssessmentResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assessmentId = null,
    Object? chapterId = null,
    Object? overallScore = null,
    Object? conceptScores = null,
    Object? identifiedGaps = null,
    Object? estimatedFixMinutes = null,
    Object? recommendedVideoIds = null,
    Object? generatedAt = freezed,
  }) {
    return _then(
      _$ChapterAssessmentResultImpl(
        assessmentId: null == assessmentId
            ? _value.assessmentId
            : assessmentId // ignore: cast_nullable_to_non_nullable
                  as String,
        chapterId: null == chapterId
            ? _value.chapterId
            : chapterId // ignore: cast_nullable_to_non_nullable
                  as String,
        overallScore: null == overallScore
            ? _value.overallScore
            : overallScore // ignore: cast_nullable_to_non_nullable
                  as double,
        conceptScores: null == conceptScores
            ? _value._conceptScores
            : conceptScores // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        identifiedGaps: null == identifiedGaps
            ? _value._identifiedGaps
            : identifiedGaps // ignore: cast_nullable_to_non_nullable
                  as List<ConceptGap>,
        estimatedFixMinutes: null == estimatedFixMinutes
            ? _value.estimatedFixMinutes
            : estimatedFixMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        recommendedVideoIds: null == recommendedVideoIds
            ? _value._recommendedVideoIds
            : recommendedVideoIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
class _$ChapterAssessmentResultImpl extends _ChapterAssessmentResult {
  const _$ChapterAssessmentResultImpl({
    required this.assessmentId,
    required this.chapterId,
    required this.overallScore,
    required final Map<String, double> conceptScores,
    required final List<ConceptGap> identifiedGaps,
    required this.estimatedFixMinutes,
    final List<String> recommendedVideoIds = const [],
    this.generatedAt,
  }) : _conceptScores = conceptScores,
       _identifiedGaps = identifiedGaps,
       _recommendedVideoIds = recommendedVideoIds,
       super._();

  factory _$ChapterAssessmentResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterAssessmentResultImplFromJson(json);

  @override
  final String assessmentId;
  @override
  final String chapterId;
  @override
  final double overallScore;
  final Map<String, double> _conceptScores;
  @override
  Map<String, double> get conceptScores {
    if (_conceptScores is EqualUnmodifiableMapView) return _conceptScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_conceptScores);
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
  final List<String> _recommendedVideoIds;
  @override
  @JsonKey()
  List<String> get recommendedVideoIds {
    if (_recommendedVideoIds is EqualUnmodifiableListView)
      return _recommendedVideoIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedVideoIds);
  }

  @override
  final DateTime? generatedAt;

  @override
  String toString() {
    return 'ChapterAssessmentResult(assessmentId: $assessmentId, chapterId: $chapterId, overallScore: $overallScore, conceptScores: $conceptScores, identifiedGaps: $identifiedGaps, estimatedFixMinutes: $estimatedFixMinutes, recommendedVideoIds: $recommendedVideoIds, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterAssessmentResultImpl &&
            (identical(other.assessmentId, assessmentId) ||
                other.assessmentId == assessmentId) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.overallScore, overallScore) ||
                other.overallScore == overallScore) &&
            const DeepCollectionEquality().equals(
              other._conceptScores,
              _conceptScores,
            ) &&
            const DeepCollectionEquality().equals(
              other._identifiedGaps,
              _identifiedGaps,
            ) &&
            (identical(other.estimatedFixMinutes, estimatedFixMinutes) ||
                other.estimatedFixMinutes == estimatedFixMinutes) &&
            const DeepCollectionEquality().equals(
              other._recommendedVideoIds,
              _recommendedVideoIds,
            ) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    assessmentId,
    chapterId,
    overallScore,
    const DeepCollectionEquality().hash(_conceptScores),
    const DeepCollectionEquality().hash(_identifiedGaps),
    estimatedFixMinutes,
    const DeepCollectionEquality().hash(_recommendedVideoIds),
    generatedAt,
  );

  /// Create a copy of ChapterAssessmentResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChapterAssessmentResultImplCopyWith<_$ChapterAssessmentResultImpl>
  get copyWith =>
      __$$ChapterAssessmentResultImplCopyWithImpl<
        _$ChapterAssessmentResultImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterAssessmentResultImplToJson(this);
  }
}

abstract class _ChapterAssessmentResult extends ChapterAssessmentResult {
  const factory _ChapterAssessmentResult({
    required final String assessmentId,
    required final String chapterId,
    required final double overallScore,
    required final Map<String, double> conceptScores,
    required final List<ConceptGap> identifiedGaps,
    required final int estimatedFixMinutes,
    final List<String> recommendedVideoIds,
    final DateTime? generatedAt,
  }) = _$ChapterAssessmentResultImpl;
  const _ChapterAssessmentResult._() : super._();

  factory _ChapterAssessmentResult.fromJson(Map<String, dynamic> json) =
      _$ChapterAssessmentResultImpl.fromJson;

  @override
  String get assessmentId;
  @override
  String get chapterId;
  @override
  double get overallScore;
  @override
  Map<String, double> get conceptScores;
  @override
  List<ConceptGap> get identifiedGaps;
  @override
  int get estimatedFixMinutes;
  @override
  List<String> get recommendedVideoIds;
  @override
  DateTime? get generatedAt;

  /// Create a copy of ChapterAssessmentResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChapterAssessmentResultImplCopyWith<_$ChapterAssessmentResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
