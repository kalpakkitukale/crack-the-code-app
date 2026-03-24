// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_checkpoint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VideoCheckpoint _$VideoCheckpointFromJson(Map<String, dynamic> json) {
  return _VideoCheckpoint.fromJson(json);
}

/// @nodoc
mixin _$VideoCheckpoint {
  String get id => throw _privateConstructorUsedError;
  String get videoId => throw _privateConstructorUsedError;
  int get timestampSeconds => throw _privateConstructorUsedError;
  String get questionId => throw _privateConstructorUsedError;
  int get replayStartSeconds => throw _privateConstructorUsedError;
  int get replayEndSeconds => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  bool? get answeredCorrectly => throw _privateConstructorUsedError;
  DateTime? get answeredAt => throw _privateConstructorUsedError;

  /// Serializes this VideoCheckpoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoCheckpoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoCheckpointCopyWith<VideoCheckpoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoCheckpointCopyWith<$Res> {
  factory $VideoCheckpointCopyWith(
    VideoCheckpoint value,
    $Res Function(VideoCheckpoint) then,
  ) = _$VideoCheckpointCopyWithImpl<$Res, VideoCheckpoint>;
  @useResult
  $Res call({
    String id,
    String videoId,
    int timestampSeconds,
    String questionId,
    int replayStartSeconds,
    int replayEndSeconds,
    bool completed,
    bool? answeredCorrectly,
    DateTime? answeredAt,
  });
}

/// @nodoc
class _$VideoCheckpointCopyWithImpl<$Res, $Val extends VideoCheckpoint>
    implements $VideoCheckpointCopyWith<$Res> {
  _$VideoCheckpointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoCheckpoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? timestampSeconds = null,
    Object? questionId = null,
    Object? replayStartSeconds = null,
    Object? replayEndSeconds = null,
    Object? completed = null,
    Object? answeredCorrectly = freezed,
    Object? answeredAt = freezed,
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
            timestampSeconds: null == timestampSeconds
                ? _value.timestampSeconds
                : timestampSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            questionId: null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                      as String,
            replayStartSeconds: null == replayStartSeconds
                ? _value.replayStartSeconds
                : replayStartSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            replayEndSeconds: null == replayEndSeconds
                ? _value.replayEndSeconds
                : replayEndSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
            answeredCorrectly: freezed == answeredCorrectly
                ? _value.answeredCorrectly
                : answeredCorrectly // ignore: cast_nullable_to_non_nullable
                      as bool?,
            answeredAt: freezed == answeredAt
                ? _value.answeredAt
                : answeredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VideoCheckpointImplCopyWith<$Res>
    implements $VideoCheckpointCopyWith<$Res> {
  factory _$$VideoCheckpointImplCopyWith(
    _$VideoCheckpointImpl value,
    $Res Function(_$VideoCheckpointImpl) then,
  ) = __$$VideoCheckpointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String videoId,
    int timestampSeconds,
    String questionId,
    int replayStartSeconds,
    int replayEndSeconds,
    bool completed,
    bool? answeredCorrectly,
    DateTime? answeredAt,
  });
}

/// @nodoc
class __$$VideoCheckpointImplCopyWithImpl<$Res>
    extends _$VideoCheckpointCopyWithImpl<$Res, _$VideoCheckpointImpl>
    implements _$$VideoCheckpointImplCopyWith<$Res> {
  __$$VideoCheckpointImplCopyWithImpl(
    _$VideoCheckpointImpl _value,
    $Res Function(_$VideoCheckpointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VideoCheckpoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? timestampSeconds = null,
    Object? questionId = null,
    Object? replayStartSeconds = null,
    Object? replayEndSeconds = null,
    Object? completed = null,
    Object? answeredCorrectly = freezed,
    Object? answeredAt = freezed,
  }) {
    return _then(
      _$VideoCheckpointImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        videoId: null == videoId
            ? _value.videoId
            : videoId // ignore: cast_nullable_to_non_nullable
                  as String,
        timestampSeconds: null == timestampSeconds
            ? _value.timestampSeconds
            : timestampSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        questionId: null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        replayStartSeconds: null == replayStartSeconds
            ? _value.replayStartSeconds
            : replayStartSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        replayEndSeconds: null == replayEndSeconds
            ? _value.replayEndSeconds
            : replayEndSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
        answeredCorrectly: freezed == answeredCorrectly
            ? _value.answeredCorrectly
            : answeredCorrectly // ignore: cast_nullable_to_non_nullable
                  as bool?,
        answeredAt: freezed == answeredAt
            ? _value.answeredAt
            : answeredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoCheckpointImpl extends _VideoCheckpoint {
  const _$VideoCheckpointImpl({
    required this.id,
    required this.videoId,
    required this.timestampSeconds,
    required this.questionId,
    required this.replayStartSeconds,
    required this.replayEndSeconds,
    this.completed = false,
    this.answeredCorrectly,
    this.answeredAt,
  }) : super._();

  factory _$VideoCheckpointImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoCheckpointImplFromJson(json);

  @override
  final String id;
  @override
  final String videoId;
  @override
  final int timestampSeconds;
  @override
  final String questionId;
  @override
  final int replayStartSeconds;
  @override
  final int replayEndSeconds;
  @override
  @JsonKey()
  final bool completed;
  @override
  final bool? answeredCorrectly;
  @override
  final DateTime? answeredAt;

  @override
  String toString() {
    return 'VideoCheckpoint(id: $id, videoId: $videoId, timestampSeconds: $timestampSeconds, questionId: $questionId, replayStartSeconds: $replayStartSeconds, replayEndSeconds: $replayEndSeconds, completed: $completed, answeredCorrectly: $answeredCorrectly, answeredAt: $answeredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoCheckpointImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.timestampSeconds, timestampSeconds) ||
                other.timestampSeconds == timestampSeconds) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.replayStartSeconds, replayStartSeconds) ||
                other.replayStartSeconds == replayStartSeconds) &&
            (identical(other.replayEndSeconds, replayEndSeconds) ||
                other.replayEndSeconds == replayEndSeconds) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.answeredCorrectly, answeredCorrectly) ||
                other.answeredCorrectly == answeredCorrectly) &&
            (identical(other.answeredAt, answeredAt) ||
                other.answeredAt == answeredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    videoId,
    timestampSeconds,
    questionId,
    replayStartSeconds,
    replayEndSeconds,
    completed,
    answeredCorrectly,
    answeredAt,
  );

  /// Create a copy of VideoCheckpoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoCheckpointImplCopyWith<_$VideoCheckpointImpl> get copyWith =>
      __$$VideoCheckpointImplCopyWithImpl<_$VideoCheckpointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoCheckpointImplToJson(this);
  }
}

abstract class _VideoCheckpoint extends VideoCheckpoint {
  const factory _VideoCheckpoint({
    required final String id,
    required final String videoId,
    required final int timestampSeconds,
    required final String questionId,
    required final int replayStartSeconds,
    required final int replayEndSeconds,
    final bool completed,
    final bool? answeredCorrectly,
    final DateTime? answeredAt,
  }) = _$VideoCheckpointImpl;
  const _VideoCheckpoint._() : super._();

  factory _VideoCheckpoint.fromJson(Map<String, dynamic> json) =
      _$VideoCheckpointImpl.fromJson;

  @override
  String get id;
  @override
  String get videoId;
  @override
  int get timestampSeconds;
  @override
  String get questionId;
  @override
  int get replayStartSeconds;
  @override
  int get replayEndSeconds;
  @override
  bool get completed;
  @override
  bool? get answeredCorrectly;
  @override
  DateTime? get answeredAt;

  /// Create a copy of VideoCheckpoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoCheckpointImplCopyWith<_$VideoCheckpointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
