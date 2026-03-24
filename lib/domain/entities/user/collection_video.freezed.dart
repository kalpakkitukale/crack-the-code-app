// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CollectionVideo {
  String get id => throw _privateConstructorUsedError;
  String get collectionId => throw _privateConstructorUsedError;
  String get videoId => throw _privateConstructorUsedError;
  String get videoTitle => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;
  String? get channelName => throw _privateConstructorUsedError;
  DateTime get addedAt => throw _privateConstructorUsedError;

  /// Create a copy of CollectionVideo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CollectionVideoCopyWith<CollectionVideo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionVideoCopyWith<$Res> {
  factory $CollectionVideoCopyWith(
    CollectionVideo value,
    $Res Function(CollectionVideo) then,
  ) = _$CollectionVideoCopyWithImpl<$Res, CollectionVideo>;
  @useResult
  $Res call({
    String id,
    String collectionId,
    String videoId,
    String videoTitle,
    String? thumbnailUrl,
    int? duration,
    String? channelName,
    DateTime addedAt,
  });
}

/// @nodoc
class _$CollectionVideoCopyWithImpl<$Res, $Val extends CollectionVideo>
    implements $CollectionVideoCopyWith<$Res> {
  _$CollectionVideoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CollectionVideo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? collectionId = null,
    Object? videoId = null,
    Object? videoTitle = null,
    Object? thumbnailUrl = freezed,
    Object? duration = freezed,
    Object? channelName = freezed,
    Object? addedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            collectionId: null == collectionId
                ? _value.collectionId
                : collectionId // ignore: cast_nullable_to_non_nullable
                      as String,
            videoId: null == videoId
                ? _value.videoId
                : videoId // ignore: cast_nullable_to_non_nullable
                      as String,
            videoTitle: null == videoTitle
                ? _value.videoTitle
                : videoTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int?,
            channelName: freezed == channelName
                ? _value.channelName
                : channelName // ignore: cast_nullable_to_non_nullable
                      as String?,
            addedAt: null == addedAt
                ? _value.addedAt
                : addedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CollectionVideoImplCopyWith<$Res>
    implements $CollectionVideoCopyWith<$Res> {
  factory _$$CollectionVideoImplCopyWith(
    _$CollectionVideoImpl value,
    $Res Function(_$CollectionVideoImpl) then,
  ) = __$$CollectionVideoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String collectionId,
    String videoId,
    String videoTitle,
    String? thumbnailUrl,
    int? duration,
    String? channelName,
    DateTime addedAt,
  });
}

/// @nodoc
class __$$CollectionVideoImplCopyWithImpl<$Res>
    extends _$CollectionVideoCopyWithImpl<$Res, _$CollectionVideoImpl>
    implements _$$CollectionVideoImplCopyWith<$Res> {
  __$$CollectionVideoImplCopyWithImpl(
    _$CollectionVideoImpl _value,
    $Res Function(_$CollectionVideoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CollectionVideo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? collectionId = null,
    Object? videoId = null,
    Object? videoTitle = null,
    Object? thumbnailUrl = freezed,
    Object? duration = freezed,
    Object? channelName = freezed,
    Object? addedAt = null,
  }) {
    return _then(
      _$CollectionVideoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        collectionId: null == collectionId
            ? _value.collectionId
            : collectionId // ignore: cast_nullable_to_non_nullable
                  as String,
        videoId: null == videoId
            ? _value.videoId
            : videoId // ignore: cast_nullable_to_non_nullable
                  as String,
        videoTitle: null == videoTitle
            ? _value.videoTitle
            : videoTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelName: freezed == channelName
            ? _value.channelName
            : channelName // ignore: cast_nullable_to_non_nullable
                  as String?,
        addedAt: null == addedAt
            ? _value.addedAt
            : addedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$CollectionVideoImpl extends _CollectionVideo {
  const _$CollectionVideoImpl({
    required this.id,
    required this.collectionId,
    required this.videoId,
    required this.videoTitle,
    this.thumbnailUrl,
    this.duration,
    this.channelName,
    required this.addedAt,
  }) : super._();

  @override
  final String id;
  @override
  final String collectionId;
  @override
  final String videoId;
  @override
  final String videoTitle;
  @override
  final String? thumbnailUrl;
  @override
  final int? duration;
  @override
  final String? channelName;
  @override
  final DateTime addedAt;

  @override
  String toString() {
    return 'CollectionVideo(id: $id, collectionId: $collectionId, videoId: $videoId, videoTitle: $videoTitle, thumbnailUrl: $thumbnailUrl, duration: $duration, channelName: $channelName, addedAt: $addedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionVideoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.collectionId, collectionId) ||
                other.collectionId == collectionId) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.videoTitle, videoTitle) ||
                other.videoTitle == videoTitle) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.channelName, channelName) ||
                other.channelName == channelName) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    collectionId,
    videoId,
    videoTitle,
    thumbnailUrl,
    duration,
    channelName,
    addedAt,
  );

  /// Create a copy of CollectionVideo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionVideoImplCopyWith<_$CollectionVideoImpl> get copyWith =>
      __$$CollectionVideoImplCopyWithImpl<_$CollectionVideoImpl>(
        this,
        _$identity,
      );
}

abstract class _CollectionVideo extends CollectionVideo {
  const factory _CollectionVideo({
    required final String id,
    required final String collectionId,
    required final String videoId,
    required final String videoTitle,
    final String? thumbnailUrl,
    final int? duration,
    final String? channelName,
    required final DateTime addedAt,
  }) = _$CollectionVideoImpl;
  const _CollectionVideo._() : super._();

  @override
  String get id;
  @override
  String get collectionId;
  @override
  String get videoId;
  @override
  String get videoTitle;
  @override
  String? get thumbnailUrl;
  @override
  int? get duration;
  @override
  String? get channelName;
  @override
  DateTime get addedAt;

  /// Create a copy of CollectionVideo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectionVideoImplCopyWith<_$CollectionVideoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
