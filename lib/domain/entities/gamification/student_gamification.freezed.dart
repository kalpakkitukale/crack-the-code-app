// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_gamification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudentGamification _$StudentGamificationFromJson(Map<String, dynamic> json) {
  return _StudentGamification.fromJson(json);
}

/// @nodoc
mixin _$StudentGamification {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  int get totalXp => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  DateTime? get lastActiveDate => throw _privateConstructorUsedError;
  List<String> get unlockedBadgeIds => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this StudentGamification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentGamification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentGamificationCopyWith<StudentGamification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentGamificationCopyWith<$Res> {
  factory $StudentGamificationCopyWith(
    StudentGamification value,
    $Res Function(StudentGamification) then,
  ) = _$StudentGamificationCopyWithImpl<$Res, StudentGamification>;
  @useResult
  $Res call({
    String id,
    String studentId,
    int totalXp,
    int level,
    int currentStreak,
    int longestStreak,
    DateTime? lastActiveDate,
    List<String> unlockedBadgeIds,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$StudentGamificationCopyWithImpl<$Res, $Val extends StudentGamification>
    implements $StudentGamificationCopyWith<$Res> {
  _$StudentGamificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentGamification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? totalXp = null,
    Object? level = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastActiveDate = freezed,
    Object? unlockedBadgeIds = null,
    Object? updatedAt = freezed,
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
            totalXp: null == totalXp
                ? _value.totalXp
                : totalXp // ignore: cast_nullable_to_non_nullable
                      as int,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            lastActiveDate: freezed == lastActiveDate
                ? _value.lastActiveDate
                : lastActiveDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            unlockedBadgeIds: null == unlockedBadgeIds
                ? _value.unlockedBadgeIds
                : unlockedBadgeIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentGamificationImplCopyWith<$Res>
    implements $StudentGamificationCopyWith<$Res> {
  factory _$$StudentGamificationImplCopyWith(
    _$StudentGamificationImpl value,
    $Res Function(_$StudentGamificationImpl) then,
  ) = __$$StudentGamificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String studentId,
    int totalXp,
    int level,
    int currentStreak,
    int longestStreak,
    DateTime? lastActiveDate,
    List<String> unlockedBadgeIds,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$StudentGamificationImplCopyWithImpl<$Res>
    extends _$StudentGamificationCopyWithImpl<$Res, _$StudentGamificationImpl>
    implements _$$StudentGamificationImplCopyWith<$Res> {
  __$$StudentGamificationImplCopyWithImpl(
    _$StudentGamificationImpl _value,
    $Res Function(_$StudentGamificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentGamification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? totalXp = null,
    Object? level = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastActiveDate = freezed,
    Object? unlockedBadgeIds = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$StudentGamificationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalXp: null == totalXp
            ? _value.totalXp
            : totalXp // ignore: cast_nullable_to_non_nullable
                  as int,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        lastActiveDate: freezed == lastActiveDate
            ? _value.lastActiveDate
            : lastActiveDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        unlockedBadgeIds: null == unlockedBadgeIds
            ? _value._unlockedBadgeIds
            : unlockedBadgeIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentGamificationImpl extends _StudentGamification {
  const _$StudentGamificationImpl({
    required this.id,
    required this.studentId,
    this.totalXp = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActiveDate,
    final List<String> unlockedBadgeIds = const [],
    this.updatedAt,
  }) : _unlockedBadgeIds = unlockedBadgeIds,
       super._();

  factory _$StudentGamificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentGamificationImplFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  @JsonKey()
  final int totalXp;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int longestStreak;
  @override
  final DateTime? lastActiveDate;
  final List<String> _unlockedBadgeIds;
  @override
  @JsonKey()
  List<String> get unlockedBadgeIds {
    if (_unlockedBadgeIds is EqualUnmodifiableListView)
      return _unlockedBadgeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockedBadgeIds);
  }

  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'StudentGamification(id: $id, studentId: $studentId, totalXp: $totalXp, level: $level, currentStreak: $currentStreak, longestStreak: $longestStreak, lastActiveDate: $lastActiveDate, unlockedBadgeIds: $unlockedBadgeIds, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentGamificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate) &&
            const DeepCollectionEquality().equals(
              other._unlockedBadgeIds,
              _unlockedBadgeIds,
            ) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentId,
    totalXp,
    level,
    currentStreak,
    longestStreak,
    lastActiveDate,
    const DeepCollectionEquality().hash(_unlockedBadgeIds),
    updatedAt,
  );

  /// Create a copy of StudentGamification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentGamificationImplCopyWith<_$StudentGamificationImpl> get copyWith =>
      __$$StudentGamificationImplCopyWithImpl<_$StudentGamificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentGamificationImplToJson(this);
  }
}

abstract class _StudentGamification extends StudentGamification {
  const factory _StudentGamification({
    required final String id,
    required final String studentId,
    final int totalXp,
    final int level,
    final int currentStreak,
    final int longestStreak,
    final DateTime? lastActiveDate,
    final List<String> unlockedBadgeIds,
    final DateTime? updatedAt,
  }) = _$StudentGamificationImpl;
  const _StudentGamification._() : super._();

  factory _StudentGamification.fromJson(Map<String, dynamic> json) =
      _$StudentGamificationImpl.fromJson;

  @override
  String get id;
  @override
  String get studentId;
  @override
  int get totalXp;
  @override
  int get level;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  DateTime? get lastActiveDate;
  @override
  List<String> get unlockedBadgeIds;
  @override
  DateTime? get updatedAt;

  /// Create a copy of StudentGamification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentGamificationImplCopyWith<_$StudentGamificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
