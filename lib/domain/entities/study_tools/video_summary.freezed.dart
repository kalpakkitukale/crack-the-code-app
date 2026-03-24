// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VideoSummary _$VideoSummaryFromJson(Map<String, dynamic> json) {
  return _VideoSummary.fromJson(json);
}

/// @nodoc
mixin _$VideoSummary {
  String get id => throw _privateConstructorUsedError;
  String get videoId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get keyPoints => throw _privateConstructorUsedError;
  SummarySource get source => throw _privateConstructorUsedError;
  String get segment => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this VideoSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoSummaryCopyWith<VideoSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoSummaryCopyWith<$Res> {
  factory $VideoSummaryCopyWith(
    VideoSummary value,
    $Res Function(VideoSummary) then,
  ) = _$VideoSummaryCopyWithImpl<$Res, VideoSummary>;
  @useResult
  $Res call({
    String id,
    String videoId,
    String content,
    List<String> keyPoints,
    SummarySource source,
    String segment,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$VideoSummaryCopyWithImpl<$Res, $Val extends VideoSummary>
    implements $VideoSummaryCopyWith<$Res> {
  _$VideoSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? content = null,
    Object? keyPoints = null,
    Object? source = null,
    Object? segment = null,
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
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            keyPoints: null == keyPoints
                ? _value.keyPoints
                : keyPoints // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as SummarySource,
            segment: null == segment
                ? _value.segment
                : segment // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$VideoSummaryImplCopyWith<$Res>
    implements $VideoSummaryCopyWith<$Res> {
  factory _$$VideoSummaryImplCopyWith(
    _$VideoSummaryImpl value,
    $Res Function(_$VideoSummaryImpl) then,
  ) = __$$VideoSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String videoId,
    String content,
    List<String> keyPoints,
    SummarySource source,
    String segment,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$VideoSummaryImplCopyWithImpl<$Res>
    extends _$VideoSummaryCopyWithImpl<$Res, _$VideoSummaryImpl>
    implements _$$VideoSummaryImplCopyWith<$Res> {
  __$$VideoSummaryImplCopyWithImpl(
    _$VideoSummaryImpl _value,
    $Res Function(_$VideoSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VideoSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? content = null,
    Object? keyPoints = null,
    Object? source = null,
    Object? segment = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$VideoSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        videoId: null == videoId
            ? _value.videoId
            : videoId // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        keyPoints: null == keyPoints
            ? _value._keyPoints
            : keyPoints // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as SummarySource,
        segment: null == segment
            ? _value.segment
            : segment // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$VideoSummaryImpl extends _VideoSummary {
  const _$VideoSummaryImpl({
    required this.id,
    required this.videoId,
    required this.content,
    final List<String> keyPoints = const [],
    this.source = SummarySource.manual,
    required this.segment,
    required this.createdAt,
    required this.updatedAt,
  }) : _keyPoints = keyPoints,
       super._();

  factory _$VideoSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String videoId;
  @override
  final String content;
  final List<String> _keyPoints;
  @override
  @JsonKey()
  List<String> get keyPoints {
    if (_keyPoints is EqualUnmodifiableListView) return _keyPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keyPoints);
  }

  @override
  @JsonKey()
  final SummarySource source;
  @override
  final String segment;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'VideoSummary(id: $id, videoId: $videoId, content: $content, keyPoints: $keyPoints, source: $source, segment: $segment, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(
              other._keyPoints,
              _keyPoints,
            ) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.segment, segment) || other.segment == segment) &&
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
    content,
    const DeepCollectionEquality().hash(_keyPoints),
    source,
    segment,
    createdAt,
    updatedAt,
  );

  /// Create a copy of VideoSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoSummaryImplCopyWith<_$VideoSummaryImpl> get copyWith =>
      __$$VideoSummaryImplCopyWithImpl<_$VideoSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoSummaryImplToJson(this);
  }
}

abstract class _VideoSummary extends VideoSummary {
  const factory _VideoSummary({
    required final String id,
    required final String videoId,
    required final String content,
    final List<String> keyPoints,
    final SummarySource source,
    required final String segment,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$VideoSummaryImpl;
  const _VideoSummary._() : super._();

  factory _VideoSummary.fromJson(Map<String, dynamic> json) =
      _$VideoSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get videoId;
  @override
  String get content;
  @override
  List<String> get keyPoints;
  @override
  SummarySource get source;
  @override
  String get segment;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of VideoSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoSummaryImplCopyWith<_$VideoSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
