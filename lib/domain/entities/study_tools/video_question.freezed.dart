// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VideoQuestion _$VideoQuestionFromJson(Map<String, dynamic> json) {
  return _VideoQuestion.fromJson(json);
}

/// @nodoc
mixin _$VideoQuestion {
  String get id => throw _privateConstructorUsedError;
  String get videoId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  String? get answer => throw _privateConstructorUsedError;
  QuestionStatus get status => throw _privateConstructorUsedError;
  int? get timestampSeconds => throw _privateConstructorUsedError;
  int get upvotes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this VideoQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoQuestionCopyWith<VideoQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoQuestionCopyWith<$Res> {
  factory $VideoQuestionCopyWith(
    VideoQuestion value,
    $Res Function(VideoQuestion) then,
  ) = _$VideoQuestionCopyWithImpl<$Res, VideoQuestion>;
  @useResult
  $Res call({
    String id,
    String videoId,
    String profileId,
    String question,
    String? answer,
    QuestionStatus status,
    int? timestampSeconds,
    int upvotes,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$VideoQuestionCopyWithImpl<$Res, $Val extends VideoQuestion>
    implements $VideoQuestionCopyWith<$Res> {
  _$VideoQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? profileId = null,
    Object? question = null,
    Object? answer = freezed,
    Object? status = null,
    Object? timestampSeconds = freezed,
    Object? upvotes = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            question: null == question
                ? _value.question
                : question // ignore: cast_nullable_to_non_nullable
                      as String,
            answer: freezed == answer
                ? _value.answer
                : answer // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as QuestionStatus,
            timestampSeconds: freezed == timestampSeconds
                ? _value.timestampSeconds
                : timestampSeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
            upvotes: null == upvotes
                ? _value.upvotes
                : upvotes // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VideoQuestionImplCopyWith<$Res>
    implements $VideoQuestionCopyWith<$Res> {
  factory _$$VideoQuestionImplCopyWith(
    _$VideoQuestionImpl value,
    $Res Function(_$VideoQuestionImpl) then,
  ) = __$$VideoQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String videoId,
    String profileId,
    String question,
    String? answer,
    QuestionStatus status,
    int? timestampSeconds,
    int upvotes,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$VideoQuestionImplCopyWithImpl<$Res>
    extends _$VideoQuestionCopyWithImpl<$Res, _$VideoQuestionImpl>
    implements _$$VideoQuestionImplCopyWith<$Res> {
  __$$VideoQuestionImplCopyWithImpl(
    _$VideoQuestionImpl _value,
    $Res Function(_$VideoQuestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VideoQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? profileId = null,
    Object? question = null,
    Object? answer = freezed,
    Object? status = null,
    Object? timestampSeconds = freezed,
    Object? upvotes = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$VideoQuestionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        videoId: null == videoId
            ? _value.videoId
            : videoId // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        question: null == question
            ? _value.question
            : question // ignore: cast_nullable_to_non_nullable
                  as String,
        answer: freezed == answer
            ? _value.answer
            : answer // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as QuestionStatus,
        timestampSeconds: freezed == timestampSeconds
            ? _value.timestampSeconds
            : timestampSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        upvotes: null == upvotes
            ? _value.upvotes
            : upvotes // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoQuestionImpl extends _VideoQuestion {
  const _$VideoQuestionImpl({
    required this.id,
    required this.videoId,
    required this.profileId,
    required this.question,
    this.answer,
    this.status = QuestionStatus.pending,
    this.timestampSeconds,
    this.upvotes = 0,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  factory _$VideoQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String videoId;
  @override
  final String profileId;
  @override
  final String question;
  @override
  final String? answer;
  @override
  @JsonKey()
  final QuestionStatus status;
  @override
  final int? timestampSeconds;
  @override
  @JsonKey()
  final int upvotes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'VideoQuestion(id: $id, videoId: $videoId, profileId: $profileId, question: $question, answer: $answer, status: $status, timestampSeconds: $timestampSeconds, upvotes: $upvotes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timestampSeconds, timestampSeconds) ||
                other.timestampSeconds == timestampSeconds) &&
            (identical(other.upvotes, upvotes) || other.upvotes == upvotes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    videoId,
    profileId,
    question,
    answer,
    status,
    timestampSeconds,
    upvotes,
    createdAt,
    updatedAt,
  );

  /// Create a copy of VideoQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoQuestionImplCopyWith<_$VideoQuestionImpl> get copyWith =>
      __$$VideoQuestionImplCopyWithImpl<_$VideoQuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoQuestionImplToJson(this);
  }
}

abstract class _VideoQuestion extends VideoQuestion {
  const factory _VideoQuestion({
    required final String id,
    required final String videoId,
    required final String profileId,
    required final String question,
    final String? answer,
    final QuestionStatus status,
    final int? timestampSeconds,
    final int upvotes,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$VideoQuestionImpl;
  const _VideoQuestion._() : super._();

  factory _VideoQuestion.fromJson(Map<String, dynamic> json) =
      _$VideoQuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get videoId;
  @override
  String get profileId;
  @override
  String get question;
  @override
  String? get answer;
  @override
  QuestionStatus get status;
  @override
  int? get timestampSeconds;
  @override
  int get upvotes;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of VideoQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoQuestionImplCopyWith<_$VideoQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
