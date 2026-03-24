// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_learning_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VideoLearningSession _$VideoLearningSessionFromJson(Map<String, dynamic> json) {
  return _VideoLearningSession.fromJson(json);
}

/// @nodoc
mixin _$VideoLearningSession {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get videoId => throw _privateConstructorUsedError;
  String get conceptId => throw _privateConstructorUsedError; // Pre-Quiz state
  bool get preQuizCompleted => throw _privateConstructorUsedError;
  double? get preQuizScore => throw _privateConstructorUsedError;
  List<String> get preQuizGaps =>
      throw _privateConstructorUsedError; // Checkpoints state
  List<VideoCheckpoint> get checkpoints => throw _privateConstructorUsedError;
  int get currentCheckpointIndex => throw _privateConstructorUsedError;
  int get checkpointsCorrect => throw _privateConstructorUsedError;
  int get checkpointsAttempted =>
      throw _privateConstructorUsedError; // Video watching state
  int get watchDurationSeconds => throw _privateConstructorUsedError;
  bool get videoCompleted =>
      throw _privateConstructorUsedError; // Post-Quiz state
  bool get postQuizCompleted => throw _privateConstructorUsedError;
  double? get postQuizScore =>
      throw _privateConstructorUsedError; // Session timestamps
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this VideoLearningSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoLearningSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoLearningSessionCopyWith<VideoLearningSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoLearningSessionCopyWith<$Res> {
  factory $VideoLearningSessionCopyWith(
    VideoLearningSession value,
    $Res Function(VideoLearningSession) then,
  ) = _$VideoLearningSessionCopyWithImpl<$Res, VideoLearningSession>;
  @useResult
  $Res call({
    String id,
    String studentId,
    String videoId,
    String conceptId,
    bool preQuizCompleted,
    double? preQuizScore,
    List<String> preQuizGaps,
    List<VideoCheckpoint> checkpoints,
    int currentCheckpointIndex,
    int checkpointsCorrect,
    int checkpointsAttempted,
    int watchDurationSeconds,
    bool videoCompleted,
    bool postQuizCompleted,
    double? postQuizScore,
    DateTime startedAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$VideoLearningSessionCopyWithImpl<
  $Res,
  $Val extends VideoLearningSession
>
    implements $VideoLearningSessionCopyWith<$Res> {
  _$VideoLearningSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoLearningSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? videoId = null,
    Object? conceptId = null,
    Object? preQuizCompleted = null,
    Object? preQuizScore = freezed,
    Object? preQuizGaps = null,
    Object? checkpoints = null,
    Object? currentCheckpointIndex = null,
    Object? checkpointsCorrect = null,
    Object? checkpointsAttempted = null,
    Object? watchDurationSeconds = null,
    Object? videoCompleted = null,
    Object? postQuizCompleted = null,
    Object? postQuizScore = freezed,
    Object? startedAt = null,
    Object? completedAt = freezed,
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
            videoId: null == videoId
                ? _value.videoId
                : videoId // ignore: cast_nullable_to_non_nullable
                      as String,
            conceptId: null == conceptId
                ? _value.conceptId
                : conceptId // ignore: cast_nullable_to_non_nullable
                      as String,
            preQuizCompleted: null == preQuizCompleted
                ? _value.preQuizCompleted
                : preQuizCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            preQuizScore: freezed == preQuizScore
                ? _value.preQuizScore
                : preQuizScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            preQuizGaps: null == preQuizGaps
                ? _value.preQuizGaps
                : preQuizGaps // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            checkpoints: null == checkpoints
                ? _value.checkpoints
                : checkpoints // ignore: cast_nullable_to_non_nullable
                      as List<VideoCheckpoint>,
            currentCheckpointIndex: null == currentCheckpointIndex
                ? _value.currentCheckpointIndex
                : currentCheckpointIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            checkpointsCorrect: null == checkpointsCorrect
                ? _value.checkpointsCorrect
                : checkpointsCorrect // ignore: cast_nullable_to_non_nullable
                      as int,
            checkpointsAttempted: null == checkpointsAttempted
                ? _value.checkpointsAttempted
                : checkpointsAttempted // ignore: cast_nullable_to_non_nullable
                      as int,
            watchDurationSeconds: null == watchDurationSeconds
                ? _value.watchDurationSeconds
                : watchDurationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            videoCompleted: null == videoCompleted
                ? _value.videoCompleted
                : videoCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            postQuizCompleted: null == postQuizCompleted
                ? _value.postQuizCompleted
                : postQuizCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            postQuizScore: freezed == postQuizScore
                ? _value.postQuizScore
                : postQuizScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VideoLearningSessionImplCopyWith<$Res>
    implements $VideoLearningSessionCopyWith<$Res> {
  factory _$$VideoLearningSessionImplCopyWith(
    _$VideoLearningSessionImpl value,
    $Res Function(_$VideoLearningSessionImpl) then,
  ) = __$$VideoLearningSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String studentId,
    String videoId,
    String conceptId,
    bool preQuizCompleted,
    double? preQuizScore,
    List<String> preQuizGaps,
    List<VideoCheckpoint> checkpoints,
    int currentCheckpointIndex,
    int checkpointsCorrect,
    int checkpointsAttempted,
    int watchDurationSeconds,
    bool videoCompleted,
    bool postQuizCompleted,
    double? postQuizScore,
    DateTime startedAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$VideoLearningSessionImplCopyWithImpl<$Res>
    extends _$VideoLearningSessionCopyWithImpl<$Res, _$VideoLearningSessionImpl>
    implements _$$VideoLearningSessionImplCopyWith<$Res> {
  __$$VideoLearningSessionImplCopyWithImpl(
    _$VideoLearningSessionImpl _value,
    $Res Function(_$VideoLearningSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VideoLearningSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? videoId = null,
    Object? conceptId = null,
    Object? preQuizCompleted = null,
    Object? preQuizScore = freezed,
    Object? preQuizGaps = null,
    Object? checkpoints = null,
    Object? currentCheckpointIndex = null,
    Object? checkpointsCorrect = null,
    Object? checkpointsAttempted = null,
    Object? watchDurationSeconds = null,
    Object? videoCompleted = null,
    Object? postQuizCompleted = null,
    Object? postQuizScore = freezed,
    Object? startedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$VideoLearningSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        videoId: null == videoId
            ? _value.videoId
            : videoId // ignore: cast_nullable_to_non_nullable
                  as String,
        conceptId: null == conceptId
            ? _value.conceptId
            : conceptId // ignore: cast_nullable_to_non_nullable
                  as String,
        preQuizCompleted: null == preQuizCompleted
            ? _value.preQuizCompleted
            : preQuizCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        preQuizScore: freezed == preQuizScore
            ? _value.preQuizScore
            : preQuizScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        preQuizGaps: null == preQuizGaps
            ? _value._preQuizGaps
            : preQuizGaps // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        checkpoints: null == checkpoints
            ? _value._checkpoints
            : checkpoints // ignore: cast_nullable_to_non_nullable
                  as List<VideoCheckpoint>,
        currentCheckpointIndex: null == currentCheckpointIndex
            ? _value.currentCheckpointIndex
            : currentCheckpointIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        checkpointsCorrect: null == checkpointsCorrect
            ? _value.checkpointsCorrect
            : checkpointsCorrect // ignore: cast_nullable_to_non_nullable
                  as int,
        checkpointsAttempted: null == checkpointsAttempted
            ? _value.checkpointsAttempted
            : checkpointsAttempted // ignore: cast_nullable_to_non_nullable
                  as int,
        watchDurationSeconds: null == watchDurationSeconds
            ? _value.watchDurationSeconds
            : watchDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        videoCompleted: null == videoCompleted
            ? _value.videoCompleted
            : videoCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        postQuizCompleted: null == postQuizCompleted
            ? _value.postQuizCompleted
            : postQuizCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        postQuizScore: freezed == postQuizScore
            ? _value.postQuizScore
            : postQuizScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoLearningSessionImpl extends _VideoLearningSession {
  const _$VideoLearningSessionImpl({
    required this.id,
    required this.studentId,
    required this.videoId,
    required this.conceptId,
    this.preQuizCompleted = false,
    this.preQuizScore,
    final List<String> preQuizGaps = const [],
    final List<VideoCheckpoint> checkpoints = const [],
    this.currentCheckpointIndex = 0,
    this.checkpointsCorrect = 0,
    this.checkpointsAttempted = 0,
    this.watchDurationSeconds = 0,
    this.videoCompleted = false,
    this.postQuizCompleted = false,
    this.postQuizScore,
    required this.startedAt,
    this.completedAt,
  }) : _preQuizGaps = preQuizGaps,
       _checkpoints = checkpoints,
       super._();

  factory _$VideoLearningSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoLearningSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  final String videoId;
  @override
  final String conceptId;
  // Pre-Quiz state
  @override
  @JsonKey()
  final bool preQuizCompleted;
  @override
  final double? preQuizScore;
  final List<String> _preQuizGaps;
  @override
  @JsonKey()
  List<String> get preQuizGaps {
    if (_preQuizGaps is EqualUnmodifiableListView) return _preQuizGaps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preQuizGaps);
  }

  // Checkpoints state
  final List<VideoCheckpoint> _checkpoints;
  // Checkpoints state
  @override
  @JsonKey()
  List<VideoCheckpoint> get checkpoints {
    if (_checkpoints is EqualUnmodifiableListView) return _checkpoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_checkpoints);
  }

  @override
  @JsonKey()
  final int currentCheckpointIndex;
  @override
  @JsonKey()
  final int checkpointsCorrect;
  @override
  @JsonKey()
  final int checkpointsAttempted;
  // Video watching state
  @override
  @JsonKey()
  final int watchDurationSeconds;
  @override
  @JsonKey()
  final bool videoCompleted;
  // Post-Quiz state
  @override
  @JsonKey()
  final bool postQuizCompleted;
  @override
  final double? postQuizScore;
  // Session timestamps
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'VideoLearningSession(id: $id, studentId: $studentId, videoId: $videoId, conceptId: $conceptId, preQuizCompleted: $preQuizCompleted, preQuizScore: $preQuizScore, preQuizGaps: $preQuizGaps, checkpoints: $checkpoints, currentCheckpointIndex: $currentCheckpointIndex, checkpointsCorrect: $checkpointsCorrect, checkpointsAttempted: $checkpointsAttempted, watchDurationSeconds: $watchDurationSeconds, videoCompleted: $videoCompleted, postQuizCompleted: $postQuizCompleted, postQuizScore: $postQuizScore, startedAt: $startedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoLearningSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.conceptId, conceptId) ||
                other.conceptId == conceptId) &&
            (identical(other.preQuizCompleted, preQuizCompleted) ||
                other.preQuizCompleted == preQuizCompleted) &&
            (identical(other.preQuizScore, preQuizScore) ||
                other.preQuizScore == preQuizScore) &&
            const DeepCollectionEquality().equals(
              other._preQuizGaps,
              _preQuizGaps,
            ) &&
            const DeepCollectionEquality().equals(
              other._checkpoints,
              _checkpoints,
            ) &&
            (identical(other.currentCheckpointIndex, currentCheckpointIndex) ||
                other.currentCheckpointIndex == currentCheckpointIndex) &&
            (identical(other.checkpointsCorrect, checkpointsCorrect) ||
                other.checkpointsCorrect == checkpointsCorrect) &&
            (identical(other.checkpointsAttempted, checkpointsAttempted) ||
                other.checkpointsAttempted == checkpointsAttempted) &&
            (identical(other.watchDurationSeconds, watchDurationSeconds) ||
                other.watchDurationSeconds == watchDurationSeconds) &&
            (identical(other.videoCompleted, videoCompleted) ||
                other.videoCompleted == videoCompleted) &&
            (identical(other.postQuizCompleted, postQuizCompleted) ||
                other.postQuizCompleted == postQuizCompleted) &&
            (identical(other.postQuizScore, postQuizScore) ||
                other.postQuizScore == postQuizScore) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentId,
    videoId,
    conceptId,
    preQuizCompleted,
    preQuizScore,
    const DeepCollectionEquality().hash(_preQuizGaps),
    const DeepCollectionEquality().hash(_checkpoints),
    currentCheckpointIndex,
    checkpointsCorrect,
    checkpointsAttempted,
    watchDurationSeconds,
    videoCompleted,
    postQuizCompleted,
    postQuizScore,
    startedAt,
    completedAt,
  );

  /// Create a copy of VideoLearningSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoLearningSessionImplCopyWith<_$VideoLearningSessionImpl>
  get copyWith =>
      __$$VideoLearningSessionImplCopyWithImpl<_$VideoLearningSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoLearningSessionImplToJson(this);
  }
}

abstract class _VideoLearningSession extends VideoLearningSession {
  const factory _VideoLearningSession({
    required final String id,
    required final String studentId,
    required final String videoId,
    required final String conceptId,
    final bool preQuizCompleted,
    final double? preQuizScore,
    final List<String> preQuizGaps,
    final List<VideoCheckpoint> checkpoints,
    final int currentCheckpointIndex,
    final int checkpointsCorrect,
    final int checkpointsAttempted,
    final int watchDurationSeconds,
    final bool videoCompleted,
    final bool postQuizCompleted,
    final double? postQuizScore,
    required final DateTime startedAt,
    final DateTime? completedAt,
  }) = _$VideoLearningSessionImpl;
  const _VideoLearningSession._() : super._();

  factory _VideoLearningSession.fromJson(Map<String, dynamic> json) =
      _$VideoLearningSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get studentId;
  @override
  String get videoId;
  @override
  String get conceptId; // Pre-Quiz state
  @override
  bool get preQuizCompleted;
  @override
  double? get preQuizScore;
  @override
  List<String> get preQuizGaps; // Checkpoints state
  @override
  List<VideoCheckpoint> get checkpoints;
  @override
  int get currentCheckpointIndex;
  @override
  int get checkpointsCorrect;
  @override
  int get checkpointsAttempted; // Video watching state
  @override
  int get watchDurationSeconds;
  @override
  bool get videoCompleted; // Post-Quiz state
  @override
  bool get postQuizCompleted;
  @override
  double? get postQuizScore; // Session timestamps
  @override
  DateTime get startedAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of VideoLearningSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoLearningSessionImplCopyWith<_$VideoLearningSessionImpl>
  get copyWith => throw _privateConstructorUsedError;
}
