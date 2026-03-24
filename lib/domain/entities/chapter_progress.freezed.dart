// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChapterProgress _$ChapterProgressFromJson(Map<String, dynamic> json) {
  return _ChapterProgress.fromJson(json);
}

/// @nodoc
mixin _$ChapterProgress {
  String get chapterId => throw _privateConstructorUsedError;
  String get chapterName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get totalVideos => throw _privateConstructorUsedError;
  int get completedVideos => throw _privateConstructorUsedError;
  int get inProgressVideos => throw _privateConstructorUsedError;
  int get totalWatchTimeSeconds => throw _privateConstructorUsedError;
  DateTime? get lastWatchedAt => throw _privateConstructorUsedError;

  /// Serializes this ChapterProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChapterProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChapterProgressCopyWith<ChapterProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterProgressCopyWith<$Res> {
  factory $ChapterProgressCopyWith(
    ChapterProgress value,
    $Res Function(ChapterProgress) then,
  ) = _$ChapterProgressCopyWithImpl<$Res, ChapterProgress>;
  @useResult
  $Res call({
    String chapterId,
    String chapterName,
    String? description,
    int totalVideos,
    int completedVideos,
    int inProgressVideos,
    int totalWatchTimeSeconds,
    DateTime? lastWatchedAt,
  });
}

/// @nodoc
class _$ChapterProgressCopyWithImpl<$Res, $Val extends ChapterProgress>
    implements $ChapterProgressCopyWith<$Res> {
  _$ChapterProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChapterProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chapterId = null,
    Object? chapterName = null,
    Object? description = freezed,
    Object? totalVideos = null,
    Object? completedVideos = null,
    Object? inProgressVideos = null,
    Object? totalWatchTimeSeconds = null,
    Object? lastWatchedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            chapterId: null == chapterId
                ? _value.chapterId
                : chapterId // ignore: cast_nullable_to_non_nullable
                      as String,
            chapterName: null == chapterName
                ? _value.chapterName
                : chapterName // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalVideos: null == totalVideos
                ? _value.totalVideos
                : totalVideos // ignore: cast_nullable_to_non_nullable
                      as int,
            completedVideos: null == completedVideos
                ? _value.completedVideos
                : completedVideos // ignore: cast_nullable_to_non_nullable
                      as int,
            inProgressVideos: null == inProgressVideos
                ? _value.inProgressVideos
                : inProgressVideos // ignore: cast_nullable_to_non_nullable
                      as int,
            totalWatchTimeSeconds: null == totalWatchTimeSeconds
                ? _value.totalWatchTimeSeconds
                : totalWatchTimeSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            lastWatchedAt: freezed == lastWatchedAt
                ? _value.lastWatchedAt
                : lastWatchedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChapterProgressImplCopyWith<$Res>
    implements $ChapterProgressCopyWith<$Res> {
  factory _$$ChapterProgressImplCopyWith(
    _$ChapterProgressImpl value,
    $Res Function(_$ChapterProgressImpl) then,
  ) = __$$ChapterProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String chapterId,
    String chapterName,
    String? description,
    int totalVideos,
    int completedVideos,
    int inProgressVideos,
    int totalWatchTimeSeconds,
    DateTime? lastWatchedAt,
  });
}

/// @nodoc
class __$$ChapterProgressImplCopyWithImpl<$Res>
    extends _$ChapterProgressCopyWithImpl<$Res, _$ChapterProgressImpl>
    implements _$$ChapterProgressImplCopyWith<$Res> {
  __$$ChapterProgressImplCopyWithImpl(
    _$ChapterProgressImpl _value,
    $Res Function(_$ChapterProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChapterProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chapterId = null,
    Object? chapterName = null,
    Object? description = freezed,
    Object? totalVideos = null,
    Object? completedVideos = null,
    Object? inProgressVideos = null,
    Object? totalWatchTimeSeconds = null,
    Object? lastWatchedAt = freezed,
  }) {
    return _then(
      _$ChapterProgressImpl(
        chapterId: null == chapterId
            ? _value.chapterId
            : chapterId // ignore: cast_nullable_to_non_nullable
                  as String,
        chapterName: null == chapterName
            ? _value.chapterName
            : chapterName // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalVideos: null == totalVideos
            ? _value.totalVideos
            : totalVideos // ignore: cast_nullable_to_non_nullable
                  as int,
        completedVideos: null == completedVideos
            ? _value.completedVideos
            : completedVideos // ignore: cast_nullable_to_non_nullable
                  as int,
        inProgressVideos: null == inProgressVideos
            ? _value.inProgressVideos
            : inProgressVideos // ignore: cast_nullable_to_non_nullable
                  as int,
        totalWatchTimeSeconds: null == totalWatchTimeSeconds
            ? _value.totalWatchTimeSeconds
            : totalWatchTimeSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        lastWatchedAt: freezed == lastWatchedAt
            ? _value.lastWatchedAt
            : lastWatchedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChapterProgressImpl extends _ChapterProgress {
  const _$ChapterProgressImpl({
    required this.chapterId,
    required this.chapterName,
    this.description,
    required this.totalVideos,
    required this.completedVideos,
    required this.inProgressVideos,
    this.totalWatchTimeSeconds = 0,
    this.lastWatchedAt,
  }) : super._();

  factory _$ChapterProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterProgressImplFromJson(json);

  @override
  final String chapterId;
  @override
  final String chapterName;
  @override
  final String? description;
  @override
  final int totalVideos;
  @override
  final int completedVideos;
  @override
  final int inProgressVideos;
  @override
  @JsonKey()
  final int totalWatchTimeSeconds;
  @override
  final DateTime? lastWatchedAt;

  @override
  String toString() {
    return 'ChapterProgress(chapterId: $chapterId, chapterName: $chapterName, description: $description, totalVideos: $totalVideos, completedVideos: $completedVideos, inProgressVideos: $inProgressVideos, totalWatchTimeSeconds: $totalWatchTimeSeconds, lastWatchedAt: $lastWatchedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterProgressImpl &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.chapterName, chapterName) ||
                other.chapterName == chapterName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.totalVideos, totalVideos) ||
                other.totalVideos == totalVideos) &&
            (identical(other.completedVideos, completedVideos) ||
                other.completedVideos == completedVideos) &&
            (identical(other.inProgressVideos, inProgressVideos) ||
                other.inProgressVideos == inProgressVideos) &&
            (identical(other.totalWatchTimeSeconds, totalWatchTimeSeconds) ||
                other.totalWatchTimeSeconds == totalWatchTimeSeconds) &&
            (identical(other.lastWatchedAt, lastWatchedAt) ||
                other.lastWatchedAt == lastWatchedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    chapterId,
    chapterName,
    description,
    totalVideos,
    completedVideos,
    inProgressVideos,
    totalWatchTimeSeconds,
    lastWatchedAt,
  );

  /// Create a copy of ChapterProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChapterProgressImplCopyWith<_$ChapterProgressImpl> get copyWith =>
      __$$ChapterProgressImplCopyWithImpl<_$ChapterProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterProgressImplToJson(this);
  }
}

abstract class _ChapterProgress extends ChapterProgress {
  const factory _ChapterProgress({
    required final String chapterId,
    required final String chapterName,
    final String? description,
    required final int totalVideos,
    required final int completedVideos,
    required final int inProgressVideos,
    final int totalWatchTimeSeconds,
    final DateTime? lastWatchedAt,
  }) = _$ChapterProgressImpl;
  const _ChapterProgress._() : super._();

  factory _ChapterProgress.fromJson(Map<String, dynamic> json) =
      _$ChapterProgressImpl.fromJson;

  @override
  String get chapterId;
  @override
  String get chapterName;
  @override
  String? get description;
  @override
  int get totalVideos;
  @override
  int get completedVideos;
  @override
  int get inProgressVideos;
  @override
  int get totalWatchTimeSeconds;
  @override
  DateTime? get lastWatchedAt;

  /// Create a copy of ChapterProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChapterProgressImplCopyWith<_$ChapterProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
