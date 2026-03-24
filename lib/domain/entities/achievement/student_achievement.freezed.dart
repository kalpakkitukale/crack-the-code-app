// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_achievement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StudentAchievement {
  String get studentId => throw _privateConstructorUsedError;
  String get achievementId => throw _privateConstructorUsedError;
  DateTime get earnedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get context => throw _privateConstructorUsedError;

  /// Create a copy of StudentAchievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentAchievementCopyWith<StudentAchievement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentAchievementCopyWith<$Res> {
  factory $StudentAchievementCopyWith(
    StudentAchievement value,
    $Res Function(StudentAchievement) then,
  ) = _$StudentAchievementCopyWithImpl<$Res, StudentAchievement>;
  @useResult
  $Res call({
    String studentId,
    String achievementId,
    DateTime earnedAt,
    Map<String, dynamic>? context,
  });
}

/// @nodoc
class _$StudentAchievementCopyWithImpl<$Res, $Val extends StudentAchievement>
    implements $StudentAchievementCopyWith<$Res> {
  _$StudentAchievementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentAchievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? achievementId = null,
    Object? earnedAt = null,
    Object? context = freezed,
  }) {
    return _then(
      _value.copyWith(
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            achievementId: null == achievementId
                ? _value.achievementId
                : achievementId // ignore: cast_nullable_to_non_nullable
                      as String,
            earnedAt: null == earnedAt
                ? _value.earnedAt
                : earnedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            context: freezed == context
                ? _value.context
                : context // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentAchievementImplCopyWith<$Res>
    implements $StudentAchievementCopyWith<$Res> {
  factory _$$StudentAchievementImplCopyWith(
    _$StudentAchievementImpl value,
    $Res Function(_$StudentAchievementImpl) then,
  ) = __$$StudentAchievementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String studentId,
    String achievementId,
    DateTime earnedAt,
    Map<String, dynamic>? context,
  });
}

/// @nodoc
class __$$StudentAchievementImplCopyWithImpl<$Res>
    extends _$StudentAchievementCopyWithImpl<$Res, _$StudentAchievementImpl>
    implements _$$StudentAchievementImplCopyWith<$Res> {
  __$$StudentAchievementImplCopyWithImpl(
    _$StudentAchievementImpl _value,
    $Res Function(_$StudentAchievementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentAchievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? achievementId = null,
    Object? earnedAt = null,
    Object? context = freezed,
  }) {
    return _then(
      _$StudentAchievementImpl(
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        achievementId: null == achievementId
            ? _value.achievementId
            : achievementId // ignore: cast_nullable_to_non_nullable
                  as String,
        earnedAt: null == earnedAt
            ? _value.earnedAt
            : earnedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        context: freezed == context
            ? _value._context
            : context // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$StudentAchievementImpl extends _StudentAchievement {
  const _$StudentAchievementImpl({
    required this.studentId,
    required this.achievementId,
    required this.earnedAt,
    final Map<String, dynamic>? context,
  }) : _context = context,
       super._();

  @override
  final String studentId;
  @override
  final String achievementId;
  @override
  final DateTime earnedAt;
  final Map<String, dynamic>? _context;
  @override
  Map<String, dynamic>? get context {
    final value = _context;
    if (value == null) return null;
    if (_context is EqualUnmodifiableMapView) return _context;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'StudentAchievement(studentId: $studentId, achievementId: $achievementId, earnedAt: $earnedAt, context: $context)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentAchievementImpl &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.achievementId, achievementId) ||
                other.achievementId == achievementId) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt) &&
            const DeepCollectionEquality().equals(other._context, _context));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    studentId,
    achievementId,
    earnedAt,
    const DeepCollectionEquality().hash(_context),
  );

  /// Create a copy of StudentAchievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentAchievementImplCopyWith<_$StudentAchievementImpl> get copyWith =>
      __$$StudentAchievementImplCopyWithImpl<_$StudentAchievementImpl>(
        this,
        _$identity,
      );
}

abstract class _StudentAchievement extends StudentAchievement {
  const factory _StudentAchievement({
    required final String studentId,
    required final String achievementId,
    required final DateTime earnedAt,
    final Map<String, dynamic>? context,
  }) = _$StudentAchievementImpl;
  const _StudentAchievement._() : super._();

  @override
  String get studentId;
  @override
  String get achievementId;
  @override
  DateTime get earnedAt;
  @override
  Map<String, dynamic>? get context;

  /// Create a copy of StudentAchievement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentAchievementImplCopyWith<_$StudentAchievementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
