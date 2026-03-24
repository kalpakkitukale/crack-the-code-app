// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'concept_gap.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConceptGap _$ConceptGapFromJson(Map<String, dynamic> json) {
  return _ConceptGap.fromJson(json);
}

/// @nodoc
mixin _$ConceptGap {
  String get id => throw _privateConstructorUsedError;
  String get conceptId => throw _privateConstructorUsedError;
  String get conceptName => throw _privateConstructorUsedError;
  int get gradeLevel => throw _privateConstructorUsedError;
  double get currentMastery => throw _privateConstructorUsedError;
  int get priorityScore => throw _privateConstructorUsedError;
  List<String> get blockedConcepts => throw _privateConstructorUsedError;
  List<String> get recommendedVideoIds => throw _privateConstructorUsedError;
  int get estimatedFixMinutes => throw _privateConstructorUsedError;
  String? get subject => throw _privateConstructorUsedError;
  String? get chapterId => throw _privateConstructorUsedError;

  /// Serializes this ConceptGap to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConceptGap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConceptGapCopyWith<ConceptGap> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConceptGapCopyWith<$Res> {
  factory $ConceptGapCopyWith(
    ConceptGap value,
    $Res Function(ConceptGap) then,
  ) = _$ConceptGapCopyWithImpl<$Res, ConceptGap>;
  @useResult
  $Res call({
    String id,
    String conceptId,
    String conceptName,
    int gradeLevel,
    double currentMastery,
    int priorityScore,
    List<String> blockedConcepts,
    List<String> recommendedVideoIds,
    int estimatedFixMinutes,
    String? subject,
    String? chapterId,
  });
}

/// @nodoc
class _$ConceptGapCopyWithImpl<$Res, $Val extends ConceptGap>
    implements $ConceptGapCopyWith<$Res> {
  _$ConceptGapCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConceptGap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conceptId = null,
    Object? conceptName = null,
    Object? gradeLevel = null,
    Object? currentMastery = null,
    Object? priorityScore = null,
    Object? blockedConcepts = null,
    Object? recommendedVideoIds = null,
    Object? estimatedFixMinutes = null,
    Object? subject = freezed,
    Object? chapterId = freezed,
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
            conceptName: null == conceptName
                ? _value.conceptName
                : conceptName // ignore: cast_nullable_to_non_nullable
                      as String,
            gradeLevel: null == gradeLevel
                ? _value.gradeLevel
                : gradeLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            currentMastery: null == currentMastery
                ? _value.currentMastery
                : currentMastery // ignore: cast_nullable_to_non_nullable
                      as double,
            priorityScore: null == priorityScore
                ? _value.priorityScore
                : priorityScore // ignore: cast_nullable_to_non_nullable
                      as int,
            blockedConcepts: null == blockedConcepts
                ? _value.blockedConcepts
                : blockedConcepts // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            recommendedVideoIds: null == recommendedVideoIds
                ? _value.recommendedVideoIds
                : recommendedVideoIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            estimatedFixMinutes: null == estimatedFixMinutes
                ? _value.estimatedFixMinutes
                : estimatedFixMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            subject: freezed == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as String?,
            chapterId: freezed == chapterId
                ? _value.chapterId
                : chapterId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConceptGapImplCopyWith<$Res>
    implements $ConceptGapCopyWith<$Res> {
  factory _$$ConceptGapImplCopyWith(
    _$ConceptGapImpl value,
    $Res Function(_$ConceptGapImpl) then,
  ) = __$$ConceptGapImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String conceptId,
    String conceptName,
    int gradeLevel,
    double currentMastery,
    int priorityScore,
    List<String> blockedConcepts,
    List<String> recommendedVideoIds,
    int estimatedFixMinutes,
    String? subject,
    String? chapterId,
  });
}

/// @nodoc
class __$$ConceptGapImplCopyWithImpl<$Res>
    extends _$ConceptGapCopyWithImpl<$Res, _$ConceptGapImpl>
    implements _$$ConceptGapImplCopyWith<$Res> {
  __$$ConceptGapImplCopyWithImpl(
    _$ConceptGapImpl _value,
    $Res Function(_$ConceptGapImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConceptGap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conceptId = null,
    Object? conceptName = null,
    Object? gradeLevel = null,
    Object? currentMastery = null,
    Object? priorityScore = null,
    Object? blockedConcepts = null,
    Object? recommendedVideoIds = null,
    Object? estimatedFixMinutes = null,
    Object? subject = freezed,
    Object? chapterId = freezed,
  }) {
    return _then(
      _$ConceptGapImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        conceptId: null == conceptId
            ? _value.conceptId
            : conceptId // ignore: cast_nullable_to_non_nullable
                  as String,
        conceptName: null == conceptName
            ? _value.conceptName
            : conceptName // ignore: cast_nullable_to_non_nullable
                  as String,
        gradeLevel: null == gradeLevel
            ? _value.gradeLevel
            : gradeLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        currentMastery: null == currentMastery
            ? _value.currentMastery
            : currentMastery // ignore: cast_nullable_to_non_nullable
                  as double,
        priorityScore: null == priorityScore
            ? _value.priorityScore
            : priorityScore // ignore: cast_nullable_to_non_nullable
                  as int,
        blockedConcepts: null == blockedConcepts
            ? _value._blockedConcepts
            : blockedConcepts // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        recommendedVideoIds: null == recommendedVideoIds
            ? _value._recommendedVideoIds
            : recommendedVideoIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        estimatedFixMinutes: null == estimatedFixMinutes
            ? _value.estimatedFixMinutes
            : estimatedFixMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        subject: freezed == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String?,
        chapterId: freezed == chapterId
            ? _value.chapterId
            : chapterId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConceptGapImpl extends _ConceptGap {
  const _$ConceptGapImpl({
    required this.id,
    required this.conceptId,
    required this.conceptName,
    required this.gradeLevel,
    required this.currentMastery,
    required this.priorityScore,
    required final List<String> blockedConcepts,
    required final List<String> recommendedVideoIds,
    required this.estimatedFixMinutes,
    this.subject,
    this.chapterId,
  }) : _blockedConcepts = blockedConcepts,
       _recommendedVideoIds = recommendedVideoIds,
       super._();

  factory _$ConceptGapImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConceptGapImplFromJson(json);

  @override
  final String id;
  @override
  final String conceptId;
  @override
  final String conceptName;
  @override
  final int gradeLevel;
  @override
  final double currentMastery;
  @override
  final int priorityScore;
  final List<String> _blockedConcepts;
  @override
  List<String> get blockedConcepts {
    if (_blockedConcepts is EqualUnmodifiableListView) return _blockedConcepts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blockedConcepts);
  }

  final List<String> _recommendedVideoIds;
  @override
  List<String> get recommendedVideoIds {
    if (_recommendedVideoIds is EqualUnmodifiableListView)
      return _recommendedVideoIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedVideoIds);
  }

  @override
  final int estimatedFixMinutes;
  @override
  final String? subject;
  @override
  final String? chapterId;

  @override
  String toString() {
    return 'ConceptGap(id: $id, conceptId: $conceptId, conceptName: $conceptName, gradeLevel: $gradeLevel, currentMastery: $currentMastery, priorityScore: $priorityScore, blockedConcepts: $blockedConcepts, recommendedVideoIds: $recommendedVideoIds, estimatedFixMinutes: $estimatedFixMinutes, subject: $subject, chapterId: $chapterId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConceptGapImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conceptId, conceptId) ||
                other.conceptId == conceptId) &&
            (identical(other.conceptName, conceptName) ||
                other.conceptName == conceptName) &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.currentMastery, currentMastery) ||
                other.currentMastery == currentMastery) &&
            (identical(other.priorityScore, priorityScore) ||
                other.priorityScore == priorityScore) &&
            const DeepCollectionEquality().equals(
              other._blockedConcepts,
              _blockedConcepts,
            ) &&
            const DeepCollectionEquality().equals(
              other._recommendedVideoIds,
              _recommendedVideoIds,
            ) &&
            (identical(other.estimatedFixMinutes, estimatedFixMinutes) ||
                other.estimatedFixMinutes == estimatedFixMinutes) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    conceptId,
    conceptName,
    gradeLevel,
    currentMastery,
    priorityScore,
    const DeepCollectionEquality().hash(_blockedConcepts),
    const DeepCollectionEquality().hash(_recommendedVideoIds),
    estimatedFixMinutes,
    subject,
    chapterId,
  );

  /// Create a copy of ConceptGap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConceptGapImplCopyWith<_$ConceptGapImpl> get copyWith =>
      __$$ConceptGapImplCopyWithImpl<_$ConceptGapImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConceptGapImplToJson(this);
  }
}

abstract class _ConceptGap extends ConceptGap {
  const factory _ConceptGap({
    required final String id,
    required final String conceptId,
    required final String conceptName,
    required final int gradeLevel,
    required final double currentMastery,
    required final int priorityScore,
    required final List<String> blockedConcepts,
    required final List<String> recommendedVideoIds,
    required final int estimatedFixMinutes,
    final String? subject,
    final String? chapterId,
  }) = _$ConceptGapImpl;
  const _ConceptGap._() : super._();

  factory _ConceptGap.fromJson(Map<String, dynamic> json) =
      _$ConceptGapImpl.fromJson;

  @override
  String get id;
  @override
  String get conceptId;
  @override
  String get conceptName;
  @override
  int get gradeLevel;
  @override
  double get currentMastery;
  @override
  int get priorityScore;
  @override
  List<String> get blockedConcepts;
  @override
  List<String> get recommendedVideoIds;
  @override
  int get estimatedFixMinutes;
  @override
  String? get subject;
  @override
  String? get chapterId;

  /// Create a copy of ConceptGap
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConceptGapImplCopyWith<_$ConceptGapImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
