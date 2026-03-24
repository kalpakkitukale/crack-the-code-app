// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Badge _$BadgeFromJson(Map<String, dynamic> json) {
  return _Badge.fromJson(json);
}

/// @nodoc
mixin _$Badge {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get iconPath => throw _privateConstructorUsedError;
  BadgeCategory get category => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _conditionFromJson, toJson: _conditionToJson)
  BadgeCondition get condition => throw _privateConstructorUsedError;
  int get xpBonus => throw _privateConstructorUsedError;

  /// Serializes this Badge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BadgeCopyWith<Badge> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeCopyWith<$Res> {
  factory $BadgeCopyWith(Badge value, $Res Function(Badge) then) =
      _$BadgeCopyWithImpl<$Res, Badge>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String iconPath,
    BadgeCategory category,
    @JsonKey(fromJson: _conditionFromJson, toJson: _conditionToJson)
    BadgeCondition condition,
    int xpBonus,
  });
}

/// @nodoc
class _$BadgeCopyWithImpl<$Res, $Val extends Badge>
    implements $BadgeCopyWith<$Res> {
  _$BadgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? iconPath = null,
    Object? category = null,
    Object? condition = null,
    Object? xpBonus = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            iconPath: null == iconPath
                ? _value.iconPath
                : iconPath // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as BadgeCategory,
            condition: null == condition
                ? _value.condition
                : condition // ignore: cast_nullable_to_non_nullable
                      as BadgeCondition,
            xpBonus: null == xpBonus
                ? _value.xpBonus
                : xpBonus // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BadgeImplCopyWith<$Res> implements $BadgeCopyWith<$Res> {
  factory _$$BadgeImplCopyWith(
    _$BadgeImpl value,
    $Res Function(_$BadgeImpl) then,
  ) = __$$BadgeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String iconPath,
    BadgeCategory category,
    @JsonKey(fromJson: _conditionFromJson, toJson: _conditionToJson)
    BadgeCondition condition,
    int xpBonus,
  });
}

/// @nodoc
class __$$BadgeImplCopyWithImpl<$Res>
    extends _$BadgeCopyWithImpl<$Res, _$BadgeImpl>
    implements _$$BadgeImplCopyWith<$Res> {
  __$$BadgeImplCopyWithImpl(
    _$BadgeImpl _value,
    $Res Function(_$BadgeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? iconPath = null,
    Object? category = null,
    Object? condition = null,
    Object? xpBonus = null,
  }) {
    return _then(
      _$BadgeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        iconPath: null == iconPath
            ? _value.iconPath
            : iconPath // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as BadgeCategory,
        condition: null == condition
            ? _value.condition
            : condition // ignore: cast_nullable_to_non_nullable
                  as BadgeCondition,
        xpBonus: null == xpBonus
            ? _value.xpBonus
            : xpBonus // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BadgeImpl extends _Badge {
  const _$BadgeImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.category,
    @JsonKey(fromJson: _conditionFromJson, toJson: _conditionToJson)
    required this.condition,
    this.xpBonus = 0,
  }) : super._();

  factory _$BadgeImpl.fromJson(Map<String, dynamic> json) =>
      _$$BadgeImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String iconPath;
  @override
  final BadgeCategory category;
  @override
  @JsonKey(fromJson: _conditionFromJson, toJson: _conditionToJson)
  final BadgeCondition condition;
  @override
  @JsonKey()
  final int xpBonus;

  @override
  String toString() {
    return 'Badge(id: $id, name: $name, description: $description, iconPath: $iconPath, category: $category, condition: $condition, xpBonus: $xpBonus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadgeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconPath, iconPath) ||
                other.iconPath == iconPath) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.xpBonus, xpBonus) || other.xpBonus == xpBonus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    iconPath,
    category,
    condition,
    xpBonus,
  );

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadgeImplCopyWith<_$BadgeImpl> get copyWith =>
      __$$BadgeImplCopyWithImpl<_$BadgeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BadgeImplToJson(this);
  }
}

abstract class _Badge extends Badge {
  const factory _Badge({
    required final String id,
    required final String name,
    required final String description,
    required final String iconPath,
    required final BadgeCategory category,
    @JsonKey(fromJson: _conditionFromJson, toJson: _conditionToJson)
    required final BadgeCondition condition,
    final int xpBonus,
  }) = _$BadgeImpl;
  const _Badge._() : super._();

  factory _Badge.fromJson(Map<String, dynamic> json) = _$BadgeImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get iconPath;
  @override
  BadgeCategory get category;
  @override
  @JsonKey(fromJson: _conditionFromJson, toJson: _conditionToJson)
  BadgeCondition get condition;
  @override
  int get xpBonus;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadgeImplCopyWith<_$BadgeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BadgeProgress _$BadgeProgressFromJson(Map<String, dynamic> json) {
  return _BadgeProgress.fromJson(json);
}

/// @nodoc
mixin _$BadgeProgress {
  String get badgeId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  Badge get badge => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError; // 0.0 - 1.0
  bool get isUnlocked => throw _privateConstructorUsedError;
  DateTime? get unlockedAt => throw _privateConstructorUsedError;

  /// Serializes this BadgeProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BadgeProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BadgeProgressCopyWith<BadgeProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeProgressCopyWith<$Res> {
  factory $BadgeProgressCopyWith(
    BadgeProgress value,
    $Res Function(BadgeProgress) then,
  ) = _$BadgeProgressCopyWithImpl<$Res, BadgeProgress>;
  @useResult
  $Res call({
    String badgeId,
    String studentId,
    Badge badge,
    double progress,
    bool isUnlocked,
    DateTime? unlockedAt,
  });

  $BadgeCopyWith<$Res> get badge;
}

/// @nodoc
class _$BadgeProgressCopyWithImpl<$Res, $Val extends BadgeProgress>
    implements $BadgeProgressCopyWith<$Res> {
  _$BadgeProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BadgeProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? badgeId = null,
    Object? studentId = null,
    Object? badge = null,
    Object? progress = null,
    Object? isUnlocked = null,
    Object? unlockedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            badgeId: null == badgeId
                ? _value.badgeId
                : badgeId // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            badge: null == badge
                ? _value.badge
                : badge // ignore: cast_nullable_to_non_nullable
                      as Badge,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
            isUnlocked: null == isUnlocked
                ? _value.isUnlocked
                : isUnlocked // ignore: cast_nullable_to_non_nullable
                      as bool,
            unlockedAt: freezed == unlockedAt
                ? _value.unlockedAt
                : unlockedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of BadgeProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BadgeCopyWith<$Res> get badge {
    return $BadgeCopyWith<$Res>(_value.badge, (value) {
      return _then(_value.copyWith(badge: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BadgeProgressImplCopyWith<$Res>
    implements $BadgeProgressCopyWith<$Res> {
  factory _$$BadgeProgressImplCopyWith(
    _$BadgeProgressImpl value,
    $Res Function(_$BadgeProgressImpl) then,
  ) = __$$BadgeProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String badgeId,
    String studentId,
    Badge badge,
    double progress,
    bool isUnlocked,
    DateTime? unlockedAt,
  });

  @override
  $BadgeCopyWith<$Res> get badge;
}

/// @nodoc
class __$$BadgeProgressImplCopyWithImpl<$Res>
    extends _$BadgeProgressCopyWithImpl<$Res, _$BadgeProgressImpl>
    implements _$$BadgeProgressImplCopyWith<$Res> {
  __$$BadgeProgressImplCopyWithImpl(
    _$BadgeProgressImpl _value,
    $Res Function(_$BadgeProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BadgeProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? badgeId = null,
    Object? studentId = null,
    Object? badge = null,
    Object? progress = null,
    Object? isUnlocked = null,
    Object? unlockedAt = freezed,
  }) {
    return _then(
      _$BadgeProgressImpl(
        badgeId: null == badgeId
            ? _value.badgeId
            : badgeId // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        badge: null == badge
            ? _value.badge
            : badge // ignore: cast_nullable_to_non_nullable
                  as Badge,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        isUnlocked: null == isUnlocked
            ? _value.isUnlocked
            : isUnlocked // ignore: cast_nullable_to_non_nullable
                  as bool,
        unlockedAt: freezed == unlockedAt
            ? _value.unlockedAt
            : unlockedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BadgeProgressImpl extends _BadgeProgress {
  const _$BadgeProgressImpl({
    required this.badgeId,
    required this.studentId,
    required this.badge,
    required this.progress,
    required this.isUnlocked,
    this.unlockedAt,
  }) : super._();

  factory _$BadgeProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$BadgeProgressImplFromJson(json);

  @override
  final String badgeId;
  @override
  final String studentId;
  @override
  final Badge badge;
  @override
  final double progress;
  // 0.0 - 1.0
  @override
  final bool isUnlocked;
  @override
  final DateTime? unlockedAt;

  @override
  String toString() {
    return 'BadgeProgress(badgeId: $badgeId, studentId: $studentId, badge: $badge, progress: $progress, isUnlocked: $isUnlocked, unlockedAt: $unlockedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadgeProgressImpl &&
            (identical(other.badgeId, badgeId) || other.badgeId == badgeId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.badge, badge) || other.badge == badge) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    badgeId,
    studentId,
    badge,
    progress,
    isUnlocked,
    unlockedAt,
  );

  /// Create a copy of BadgeProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadgeProgressImplCopyWith<_$BadgeProgressImpl> get copyWith =>
      __$$BadgeProgressImplCopyWithImpl<_$BadgeProgressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BadgeProgressImplToJson(this);
  }
}

abstract class _BadgeProgress extends BadgeProgress {
  const factory _BadgeProgress({
    required final String badgeId,
    required final String studentId,
    required final Badge badge,
    required final double progress,
    required final bool isUnlocked,
    final DateTime? unlockedAt,
  }) = _$BadgeProgressImpl;
  const _BadgeProgress._() : super._();

  factory _BadgeProgress.fromJson(Map<String, dynamic> json) =
      _$BadgeProgressImpl.fromJson;

  @override
  String get badgeId;
  @override
  String get studentId;
  @override
  Badge get badge;
  @override
  double get progress; // 0.0 - 1.0
  @override
  bool get isUnlocked;
  @override
  DateTime? get unlockedAt;

  /// Create a copy of BadgeProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadgeProgressImplCopyWith<_$BadgeProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
