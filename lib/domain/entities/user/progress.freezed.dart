// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Progress {
  String get id => throw _privateConstructorUsedError;
  String get videoId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get channelName => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  int get watchDuration => throw _privateConstructorUsedError;
  int get totalDuration => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  DateTime get lastWatched => throw _privateConstructorUsedError;

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgressCopyWith<Progress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressCopyWith<$Res> {
  factory $ProgressCopyWith(Progress value, $Res Function(Progress) then) =
      _$ProgressCopyWithImpl<$Res, Progress>;
  @useResult
  $Res call({
    String id,
    String videoId,
    String? title,
    String? channelName,
    String? thumbnailUrl,
    int watchDuration,
    int totalDuration,
    bool completed,
    DateTime lastWatched,
  });
}

/// @nodoc
class _$ProgressCopyWithImpl<$Res, $Val extends Progress>
    implements $ProgressCopyWith<$Res> {
  _$ProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? title = freezed,
    Object? channelName = freezed,
    Object? thumbnailUrl = freezed,
    Object? watchDuration = null,
    Object? totalDuration = null,
    Object? completed = null,
    Object? lastWatched = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            videoId: null == videoId
                ? _value.videoId
                : videoId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            channelName: freezed == channelName
                ? _value.channelName
                : channelName // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            watchDuration: null == watchDuration
                ? _value.watchDuration
                : watchDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            totalDuration: null == totalDuration
                ? _value.totalDuration
                : totalDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastWatched: null == lastWatched
                ? _value.lastWatched
                : lastWatched // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProgressImplCopyWith<$Res>
    implements $ProgressCopyWith<$Res> {
  factory _$$ProgressImplCopyWith(
    _$ProgressImpl value,
    $Res Function(_$ProgressImpl) then,
  ) = __$$ProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String videoId,
    String? title,
    String? channelName,
    String? thumbnailUrl,
    int watchDuration,
    int totalDuration,
    bool completed,
    DateTime lastWatched,
  });
}

/// @nodoc
class __$$ProgressImplCopyWithImpl<$Res>
    extends _$ProgressCopyWithImpl<$Res, _$ProgressImpl>
    implements _$$ProgressImplCopyWith<$Res> {
  __$$ProgressImplCopyWithImpl(
    _$ProgressImpl _value,
    $Res Function(_$ProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? title = freezed,
    Object? channelName = freezed,
    Object? thumbnailUrl = freezed,
    Object? watchDuration = null,
    Object? totalDuration = null,
    Object? completed = null,
    Object? lastWatched = null,
  }) {
    return _then(
      _$ProgressImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        videoId: null == videoId
            ? _value.videoId
            : videoId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelName: freezed == channelName
            ? _value.channelName
            : channelName // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        watchDuration: null == watchDuration
            ? _value.watchDuration
            : watchDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        totalDuration: null == totalDuration
            ? _value.totalDuration
            : totalDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastWatched: null == lastWatched
            ? _value.lastWatched
            : lastWatched // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$ProgressImpl extends _Progress {
  const _$ProgressImpl({
    required this.id,
    required this.videoId,
    this.title,
    this.channelName,
    this.thumbnailUrl,
    required this.watchDuration,
    required this.totalDuration,
    required this.completed,
    required this.lastWatched,
  }) : super._();

  @override
  final String id;
  @override
  final String videoId;
  @override
  final String? title;
  @override
  final String? channelName;
  @override
  final String? thumbnailUrl;
  @override
  final int watchDuration;
  @override
  final int totalDuration;
  @override
  final bool completed;
  @override
  final DateTime lastWatched;

  @override
  String toString() {
    return 'Progress(id: $id, videoId: $videoId, title: $title, channelName: $channelName, thumbnailUrl: $thumbnailUrl, watchDuration: $watchDuration, totalDuration: $totalDuration, completed: $completed, lastWatched: $lastWatched)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.channelName, channelName) ||
                other.channelName == channelName) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.watchDuration, watchDuration) ||
                other.watchDuration == watchDuration) &&
            (identical(other.totalDuration, totalDuration) ||
                other.totalDuration == totalDuration) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.lastWatched, lastWatched) ||
                other.lastWatched == lastWatched));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    videoId,
    title,
    channelName,
    thumbnailUrl,
    watchDuration,
    totalDuration,
    completed,
    lastWatched,
  );

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressImplCopyWith<_$ProgressImpl> get copyWith =>
      __$$ProgressImplCopyWithImpl<_$ProgressImpl>(this, _$identity);
}

abstract class _Progress extends Progress {
  const factory _Progress({
    required final String id,
    required final String videoId,
    final String? title,
    final String? channelName,
    final String? thumbnailUrl,
    required final int watchDuration,
    required final int totalDuration,
    required final bool completed,
    required final DateTime lastWatched,
  }) = _$ProgressImpl;
  const _Progress._() : super._();

  @override
  String get id;
  @override
  String get videoId;
  @override
  String? get title;
  @override
  String? get channelName;
  @override
  String? get thumbnailUrl;
  @override
  int get watchDuration;
  @override
  int get totalDuration;
  @override
  bool get completed;
  @override
  DateTime get lastWatched;

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgressImplCopyWith<_$ProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
