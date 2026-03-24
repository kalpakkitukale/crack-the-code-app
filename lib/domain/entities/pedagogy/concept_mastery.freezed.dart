// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'concept_mastery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConceptMastery _$ConceptMasteryFromJson(Map<String, dynamic> json) {
  return _ConceptMastery.fromJson(json);
}

/// @nodoc
mixin _$ConceptMastery {
  String get id => throw _privateConstructorUsedError;
  String get conceptId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  double get masteryScore => throw _privateConstructorUsedError;
  MasteryLevel get level => throw _privateConstructorUsedError;
  DateTime get lastAssessed => throw _privateConstructorUsedError;
  int get totalAttempts => throw _privateConstructorUsedError;
  bool get isGap => throw _privateConstructorUsedError;
  DateTime? get nextReviewDate => throw _privateConstructorUsedError;
  int get reviewStreak => throw _privateConstructorUsedError;
  double? get preQuizScore => throw _privateConstructorUsedError;
  double? get checkpointScore => throw _privateConstructorUsedError;
  double? get postQuizScore => throw _privateConstructorUsedError;
  double? get practiceScore => throw _privateConstructorUsedError;
  double? get spacedRepScore => throw _privateConstructorUsedError;
  int? get gradeLevel => throw _privateConstructorUsedError;

  /// Serializes this ConceptMastery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConceptMastery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConceptMasteryCopyWith<ConceptMastery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConceptMasteryCopyWith<$Res> {
  factory $ConceptMasteryCopyWith(
    ConceptMastery value,
    $Res Function(ConceptMastery) then,
  ) = _$ConceptMasteryCopyWithImpl<$Res, ConceptMastery>;
  @useResult
  $Res call({
    String id,
    String conceptId,
    String studentId,
    double masteryScore,
    MasteryLevel level,
    DateTime lastAssessed,
    int totalAttempts,
    bool isGap,
    DateTime? nextReviewDate,
    int reviewStreak,
    double? preQuizScore,
    double? checkpointScore,
    double? postQuizScore,
    double? practiceScore,
    double? spacedRepScore,
    int? gradeLevel,
  });
}

/// @nodoc
class _$ConceptMasteryCopyWithImpl<$Res, $Val extends ConceptMastery>
    implements $ConceptMasteryCopyWith<$Res> {
  _$ConceptMasteryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConceptMastery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conceptId = null,
    Object? studentId = null,
    Object? masteryScore = null,
    Object? level = null,
    Object? lastAssessed = null,
    Object? totalAttempts = null,
    Object? isGap = null,
    Object? nextReviewDate = freezed,
    Object? reviewStreak = null,
    Object? preQuizScore = freezed,
    Object? checkpointScore = freezed,
    Object? postQuizScore = freezed,
    Object? practiceScore = freezed,
    Object? spacedRepScore = freezed,
    Object? gradeLevel = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            conceptId: null == conceptId
                ? _value.conceptId
                : conceptId // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            masteryScore: null == masteryScore
                ? _value.masteryScore
                : masteryScore // ignore: cast_nullable_to_non_nullable
                      as double,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as MasteryLevel,
            lastAssessed: null == lastAssessed
                ? _value.lastAssessed
                : lastAssessed // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalAttempts: null == totalAttempts
                ? _value.totalAttempts
                : totalAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
            isGap: null == isGap
                ? _value.isGap
                : isGap // ignore: cast_nullable_to_non_nullable
                      as bool,
            nextReviewDate: freezed == nextReviewDate
                ? _value.nextReviewDate
                : nextReviewDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            reviewStreak: null == reviewStreak
                ? _value.reviewStreak
                : reviewStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            preQuizScore: freezed == preQuizScore
                ? _value.preQuizScore
                : preQuizScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            checkpointScore: freezed == checkpointScore
                ? _value.checkpointScore
                : checkpointScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            postQuizScore: freezed == postQuizScore
                ? _value.postQuizScore
                : postQuizScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            practiceScore: freezed == practiceScore
                ? _value.practiceScore
                : practiceScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            spacedRepScore: freezed == spacedRepScore
                ? _value.spacedRepScore
                : spacedRepScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            gradeLevel: freezed == gradeLevel
                ? _value.gradeLevel
                : gradeLevel // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConceptMasteryImplCopyWith<$Res>
    implements $ConceptMasteryCopyWith<$Res> {
  factory _$$ConceptMasteryImplCopyWith(
    _$ConceptMasteryImpl value,
    $Res Function(_$ConceptMasteryImpl) then,
  ) = __$$ConceptMasteryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String conceptId,
    String studentId,
    double masteryScore,
    MasteryLevel level,
    DateTime lastAssessed,
    int totalAttempts,
    bool isGap,
    DateTime? nextReviewDate,
    int reviewStreak,
    double? preQuizScore,
    double? checkpointScore,
    double? postQuizScore,
    double? practiceScore,
    double? spacedRepScore,
    int? gradeLevel,
  });
}

/// @nodoc
class __$$ConceptMasteryImplCopyWithImpl<$Res>
    extends _$ConceptMasteryCopyWithImpl<$Res, _$ConceptMasteryImpl>
    implements _$$ConceptMasteryImplCopyWith<$Res> {
  __$$ConceptMasteryImplCopyWithImpl(
    _$ConceptMasteryImpl _value,
    $Res Function(_$ConceptMasteryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConceptMastery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conceptId = null,
    Object? studentId = null,
    Object? masteryScore = null,
    Object? level = null,
    Object? lastAssessed = null,
    Object? totalAttempts = null,
    Object? isGap = null,
    Object? nextReviewDate = freezed,
    Object? reviewStreak = null,
    Object? preQuizScore = freezed,
    Object? checkpointScore = freezed,
    Object? postQuizScore = freezed,
    Object? practiceScore = freezed,
    Object? spacedRepScore = freezed,
    Object? gradeLevel = freezed,
  }) {
    return _then(
      _$ConceptMasteryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        conceptId: null == conceptId
            ? _value.conceptId
            : conceptId // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        masteryScore: null == masteryScore
            ? _value.masteryScore
            : masteryScore // ignore: cast_nullable_to_non_nullable
                  as double,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as MasteryLevel,
        lastAssessed: null == lastAssessed
            ? _value.lastAssessed
            : lastAssessed // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalAttempts: null == totalAttempts
            ? _value.totalAttempts
            : totalAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
        isGap: null == isGap
            ? _value.isGap
            : isGap // ignore: cast_nullable_to_non_nullable
                  as bool,
        nextReviewDate: freezed == nextReviewDate
            ? _value.nextReviewDate
            : nextReviewDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewStreak: null == reviewStreak
            ? _value.reviewStreak
            : reviewStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        preQuizScore: freezed == preQuizScore
            ? _value.preQuizScore
            : preQuizScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        checkpointScore: freezed == checkpointScore
            ? _value.checkpointScore
            : checkpointScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        postQuizScore: freezed == postQuizScore
            ? _value.postQuizScore
            : postQuizScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        practiceScore: freezed == practiceScore
            ? _value.practiceScore
            : practiceScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        spacedRepScore: freezed == spacedRepScore
            ? _value.spacedRepScore
            : spacedRepScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        gradeLevel: freezed == gradeLevel
            ? _value.gradeLevel
            : gradeLevel // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConceptMasteryImpl extends _ConceptMastery {
  const _$ConceptMasteryImpl({
    required this.id,
    required this.conceptId,
    required this.studentId,
    required this.masteryScore,
    required this.level,
    required this.lastAssessed,
    required this.totalAttempts,
    this.isGap = false,
    this.nextReviewDate,
    this.reviewStreak = 0,
    this.preQuizScore,
    this.checkpointScore,
    this.postQuizScore,
    this.practiceScore,
    this.spacedRepScore,
    this.gradeLevel,
  }) : super._();

  factory _$ConceptMasteryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConceptMasteryImplFromJson(json);

  @override
  final String id;
  @override
  final String conceptId;
  @override
  final String studentId;
  @override
  final double masteryScore;
  @override
  final MasteryLevel level;
  @override
  final DateTime lastAssessed;
  @override
  final int totalAttempts;
  @override
  @JsonKey()
  final bool isGap;
  @override
  final DateTime? nextReviewDate;
  @override
  @JsonKey()
  final int reviewStreak;
  @override
  final double? preQuizScore;
  @override
  final double? checkpointScore;
  @override
  final double? postQuizScore;
  @override
  final double? practiceScore;
  @override
  final double? spacedRepScore;
  @override
  final int? gradeLevel;

  @override
  String toString() {
    return 'ConceptMastery(id: $id, conceptId: $conceptId, studentId: $studentId, masteryScore: $masteryScore, level: $level, lastAssessed: $lastAssessed, totalAttempts: $totalAttempts, isGap: $isGap, nextReviewDate: $nextReviewDate, reviewStreak: $reviewStreak, preQuizScore: $preQuizScore, checkpointScore: $checkpointScore, postQuizScore: $postQuizScore, practiceScore: $practiceScore, spacedRepScore: $spacedRepScore, gradeLevel: $gradeLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConceptMasteryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conceptId, conceptId) ||
                other.conceptId == conceptId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.masteryScore, masteryScore) ||
                other.masteryScore == masteryScore) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.lastAssessed, lastAssessed) ||
                other.lastAssessed == lastAssessed) &&
            (identical(other.totalAttempts, totalAttempts) ||
                other.totalAttempts == totalAttempts) &&
            (identical(other.isGap, isGap) || other.isGap == isGap) &&
            (identical(other.nextReviewDate, nextReviewDate) ||
                other.nextReviewDate == nextReviewDate) &&
            (identical(other.reviewStreak, reviewStreak) ||
                other.reviewStreak == reviewStreak) &&
            (identical(other.preQuizScore, preQuizScore) ||
                other.preQuizScore == preQuizScore) &&
            (identical(other.checkpointScore, checkpointScore) ||
                other.checkpointScore == checkpointScore) &&
            (identical(other.postQuizScore, postQuizScore) ||
                other.postQuizScore == postQuizScore) &&
            (identical(other.practiceScore, practiceScore) ||
                other.practiceScore == practiceScore) &&
            (identical(other.spacedRepScore, spacedRepScore) ||
                other.spacedRepScore == spacedRepScore) &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    conceptId,
    studentId,
    masteryScore,
    level,
    lastAssessed,
    totalAttempts,
    isGap,
    nextReviewDate,
    reviewStreak,
    preQuizScore,
    checkpointScore,
    postQuizScore,
    practiceScore,
    spacedRepScore,
    gradeLevel,
  );

  /// Create a copy of ConceptMastery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConceptMasteryImplCopyWith<_$ConceptMasteryImpl> get copyWith =>
      __$$ConceptMasteryImplCopyWithImpl<_$ConceptMasteryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConceptMasteryImplToJson(this);
  }
}

abstract class _ConceptMastery extends ConceptMastery {
  const factory _ConceptMastery({
    required final String id,
    required final String conceptId,
    required final String studentId,
    required final double masteryScore,
    required final MasteryLevel level,
    required final DateTime lastAssessed,
    required final int totalAttempts,
    final bool isGap,
    final DateTime? nextReviewDate,
    final int reviewStreak,
    final double? preQuizScore,
    final double? checkpointScore,
    final double? postQuizScore,
    final double? practiceScore,
    final double? spacedRepScore,
    final int? gradeLevel,
  }) = _$ConceptMasteryImpl;
  const _ConceptMastery._() : super._();

  factory _ConceptMastery.fromJson(Map<String, dynamic> json) =
      _$ConceptMasteryImpl.fromJson;

  @override
  String get id;
  @override
  String get conceptId;
  @override
  String get studentId;
  @override
  double get masteryScore;
  @override
  MasteryLevel get level;
  @override
  DateTime get lastAssessed;
  @override
  int get totalAttempts;
  @override
  bool get isGap;
  @override
  DateTime? get nextReviewDate;
  @override
  int get reviewStreak;
  @override
  double? get preQuizScore;
  @override
  double? get checkpointScore;
  @override
  double? get postQuizScore;
  @override
  double? get practiceScore;
  @override
  double? get spacedRepScore;
  @override
  int? get gradeLevel;

  /// Create a copy of ConceptMastery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConceptMasteryImplCopyWith<_$ConceptMasteryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
