// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Recommendation {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  RecommendationType get type => throw _privateConstructorUsedError;
  String get entityId => throw _privateConstructorUsedError;
  String get entityType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get confidenceScore => throw _privateConstructorUsedError;
  List<String> get reasons => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;
  bool get dismissed => throw _privateConstructorUsedError;
  bool get acted => throw _privateConstructorUsedError;
  DateTime? get dismissedAt => throw _privateConstructorUsedError;
  DateTime? get actedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationCopyWith<Recommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationCopyWith<$Res> {
  factory $RecommendationCopyWith(
    Recommendation value,
    $Res Function(Recommendation) then,
  ) = _$RecommendationCopyWithImpl<$Res, Recommendation>;
  @useResult
  $Res call({
    String id,
    String studentId,
    RecommendationType type,
    String entityId,
    String entityType,
    String title,
    String description,
    double confidenceScore,
    List<String> reasons,
    DateTime generatedAt,
    bool dismissed,
    bool acted,
    DateTime? dismissedAt,
    DateTime? actedAt,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$RecommendationCopyWithImpl<$Res, $Val extends Recommendation>
    implements $RecommendationCopyWith<$Res> {
  _$RecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? type = null,
    Object? entityId = null,
    Object? entityType = null,
    Object? title = null,
    Object? description = null,
    Object? confidenceScore = null,
    Object? reasons = null,
    Object? generatedAt = null,
    Object? dismissed = null,
    Object? acted = null,
    Object? dismissedAt = freezed,
    Object? actedAt = freezed,
    Object? metadata = freezed,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as RecommendationType,
            entityId: null == entityId
                ? _value.entityId
                : entityId // ignore: cast_nullable_to_non_nullable
                      as String,
            entityType: null == entityType
                ? _value.entityType
                : entityType // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            confidenceScore: null == confidenceScore
                ? _value.confidenceScore
                : confidenceScore // ignore: cast_nullable_to_non_nullable
                      as double,
            reasons: null == reasons
                ? _value.reasons
                : reasons // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            generatedAt: null == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dismissed: null == dismissed
                ? _value.dismissed
                : dismissed // ignore: cast_nullable_to_non_nullable
                      as bool,
            acted: null == acted
                ? _value.acted
                : acted // ignore: cast_nullable_to_non_nullable
                      as bool,
            dismissedAt: freezed == dismissedAt
                ? _value.dismissedAt
                : dismissedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            actedAt: freezed == actedAt
                ? _value.actedAt
                : actedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecommendationImplCopyWith<$Res>
    implements $RecommendationCopyWith<$Res> {
  factory _$$RecommendationImplCopyWith(
    _$RecommendationImpl value,
    $Res Function(_$RecommendationImpl) then,
  ) = __$$RecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String studentId,
    RecommendationType type,
    String entityId,
    String entityType,
    String title,
    String description,
    double confidenceScore,
    List<String> reasons,
    DateTime generatedAt,
    bool dismissed,
    bool acted,
    DateTime? dismissedAt,
    DateTime? actedAt,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$RecommendationImplCopyWithImpl<$Res>
    extends _$RecommendationCopyWithImpl<$Res, _$RecommendationImpl>
    implements _$$RecommendationImplCopyWith<$Res> {
  __$$RecommendationImplCopyWithImpl(
    _$RecommendationImpl _value,
    $Res Function(_$RecommendationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? type = null,
    Object? entityId = null,
    Object? entityType = null,
    Object? title = null,
    Object? description = null,
    Object? confidenceScore = null,
    Object? reasons = null,
    Object? generatedAt = null,
    Object? dismissed = null,
    Object? acted = null,
    Object? dismissedAt = freezed,
    Object? actedAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$RecommendationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as RecommendationType,
        entityId: null == entityId
            ? _value.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _value.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        confidenceScore: null == confidenceScore
            ? _value.confidenceScore
            : confidenceScore // ignore: cast_nullable_to_non_nullable
                  as double,
        reasons: null == reasons
            ? _value._reasons
            : reasons // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        generatedAt: null == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dismissed: null == dismissed
            ? _value.dismissed
            : dismissed // ignore: cast_nullable_to_non_nullable
                  as bool,
        acted: null == acted
            ? _value.acted
            : acted // ignore: cast_nullable_to_non_nullable
                  as bool,
        dismissedAt: freezed == dismissedAt
            ? _value.dismissedAt
            : dismissedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        actedAt: freezed == actedAt
            ? _value.actedAt
            : actedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$RecommendationImpl extends _Recommendation {
  const _$RecommendationImpl({
    required this.id,
    required this.studentId,
    required this.type,
    required this.entityId,
    required this.entityType,
    required this.title,
    required this.description,
    required this.confidenceScore,
    required final List<String> reasons,
    required this.generatedAt,
    this.dismissed = false,
    this.acted = false,
    this.dismissedAt,
    this.actedAt,
    final Map<String, dynamic>? metadata,
  }) : _reasons = reasons,
       _metadata = metadata,
       super._();

  @override
  final String id;
  @override
  final String studentId;
  @override
  final RecommendationType type;
  @override
  final String entityId;
  @override
  final String entityType;
  @override
  final String title;
  @override
  final String description;
  @override
  final double confidenceScore;
  final List<String> _reasons;
  @override
  List<String> get reasons {
    if (_reasons is EqualUnmodifiableListView) return _reasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reasons);
  }

  @override
  final DateTime generatedAt;
  @override
  @JsonKey()
  final bool dismissed;
  @override
  @JsonKey()
  final bool acted;
  @override
  final DateTime? dismissedAt;
  @override
  final DateTime? actedAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Recommendation(id: $id, studentId: $studentId, type: $type, entityId: $entityId, entityType: $entityType, title: $title, description: $description, confidenceScore: $confidenceScore, reasons: $reasons, generatedAt: $generatedAt, dismissed: $dismissed, acted: $acted, dismissedAt: $dismissedAt, actedAt: $actedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            const DeepCollectionEquality().equals(other._reasons, _reasons) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.dismissed, dismissed) ||
                other.dismissed == dismissed) &&
            (identical(other.acted, acted) || other.acted == acted) &&
            (identical(other.dismissedAt, dismissedAt) ||
                other.dismissedAt == dismissedAt) &&
            (identical(other.actedAt, actedAt) || other.actedAt == actedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentId,
    type,
    entityId,
    entityType,
    title,
    description,
    confidenceScore,
    const DeepCollectionEquality().hash(_reasons),
    generatedAt,
    dismissed,
    acted,
    dismissedAt,
    actedAt,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationImplCopyWith<_$RecommendationImpl> get copyWith =>
      __$$RecommendationImplCopyWithImpl<_$RecommendationImpl>(
        this,
        _$identity,
      );
}

abstract class _Recommendation extends Recommendation {
  const factory _Recommendation({
    required final String id,
    required final String studentId,
    required final RecommendationType type,
    required final String entityId,
    required final String entityType,
    required final String title,
    required final String description,
    required final double confidenceScore,
    required final List<String> reasons,
    required final DateTime generatedAt,
    final bool dismissed,
    final bool acted,
    final DateTime? dismissedAt,
    final DateTime? actedAt,
    final Map<String, dynamic>? metadata,
  }) = _$RecommendationImpl;
  const _Recommendation._() : super._();

  @override
  String get id;
  @override
  String get studentId;
  @override
  RecommendationType get type;
  @override
  String get entityId;
  @override
  String get entityType;
  @override
  String get title;
  @override
  String get description;
  @override
  double get confidenceScore;
  @override
  List<String> get reasons;
  @override
  DateTime get generatedAt;
  @override
  bool get dismissed;
  @override
  bool get acted;
  @override
  DateTime? get dismissedAt;
  @override
  DateTime? get actedAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationImplCopyWith<_$RecommendationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
