// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Video _$VideoFromJson(Map<String, dynamic> json) {
  return _Video.fromJson(json);
}

/// @nodoc
mixin _$Video {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get youtubeId => throw _privateConstructorUsedError;
  String get youtubeUrl => throw _privateConstructorUsedError;
  String get thumbnailUrl => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  String get durationDisplay => throw _privateConstructorUsedError;
  String get channelName => throw _privateConstructorUsedError;
  String get channelId => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get topicId => throw _privateConstructorUsedError;
  String get difficulty => throw _privateConstructorUsedError;
  List<String> get examRelevance => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  DateTime get dateAdded => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this Video to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoCopyWith<Video> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoCopyWith<$Res> {
  factory $VideoCopyWith(Video value, $Res Function(Video) then) =
      _$VideoCopyWithImpl<$Res, Video>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String youtubeId,
    String youtubeUrl,
    String thumbnailUrl,
    int duration,
    String durationDisplay,
    String channelName,
    String channelId,
    String language,
    String topicId,
    String difficulty,
    List<String> examRelevance,
    double rating,
    int viewCount,
    List<String> tags,
    DateTime dateAdded,
    DateTime lastUpdated,
  });
}

/// @nodoc
class _$VideoCopyWithImpl<$Res, $Val extends Video>
    implements $VideoCopyWith<$Res> {
  _$VideoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? youtubeId = null,
    Object? youtubeUrl = null,
    Object? thumbnailUrl = null,
    Object? duration = null,
    Object? durationDisplay = null,
    Object? channelName = null,
    Object? channelId = null,
    Object? language = null,
    Object? topicId = null,
    Object? difficulty = null,
    Object? examRelevance = null,
    Object? rating = null,
    Object? viewCount = null,
    Object? tags = null,
    Object? dateAdded = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            youtubeId: null == youtubeId
                ? _value.youtubeId
                : youtubeId // ignore: cast_nullable_to_non_nullable
                      as String,
            youtubeUrl: null == youtubeUrl
                ? _value.youtubeUrl
                : youtubeUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnailUrl: null == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            durationDisplay: null == durationDisplay
                ? _value.durationDisplay
                : durationDisplay // ignore: cast_nullable_to_non_nullable
                      as String,
            channelName: null == channelName
                ? _value.channelName
                : channelName // ignore: cast_nullable_to_non_nullable
                      as String,
            channelId: null == channelId
                ? _value.channelId
                : channelId // ignore: cast_nullable_to_non_nullable
                      as String,
            language: null == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as String,
            topicId: null == topicId
                ? _value.topicId
                : topicId // ignore: cast_nullable_to_non_nullable
                      as String,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as String,
            examRelevance: null == examRelevance
                ? _value.examRelevance
                : examRelevance // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            viewCount: null == viewCount
                ? _value.viewCount
                : viewCount // ignore: cast_nullable_to_non_nullable
                      as int,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            dateAdded: null == dateAdded
                ? _value.dateAdded
                : dateAdded // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VideoImplCopyWith<$Res> implements $VideoCopyWith<$Res> {
  factory _$$VideoImplCopyWith(
    _$VideoImpl value,
    $Res Function(_$VideoImpl) then,
  ) = __$$VideoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String youtubeId,
    String youtubeUrl,
    String thumbnailUrl,
    int duration,
    String durationDisplay,
    String channelName,
    String channelId,
    String language,
    String topicId,
    String difficulty,
    List<String> examRelevance,
    double rating,
    int viewCount,
    List<String> tags,
    DateTime dateAdded,
    DateTime lastUpdated,
  });
}

/// @nodoc
class __$$VideoImplCopyWithImpl<$Res>
    extends _$VideoCopyWithImpl<$Res, _$VideoImpl>
    implements _$$VideoImplCopyWith<$Res> {
  __$$VideoImplCopyWithImpl(
    _$VideoImpl _value,
    $Res Function(_$VideoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? youtubeId = null,
    Object? youtubeUrl = null,
    Object? thumbnailUrl = null,
    Object? duration = null,
    Object? durationDisplay = null,
    Object? channelName = null,
    Object? channelId = null,
    Object? language = null,
    Object? topicId = null,
    Object? difficulty = null,
    Object? examRelevance = null,
    Object? rating = null,
    Object? viewCount = null,
    Object? tags = null,
    Object? dateAdded = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$VideoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        youtubeId: null == youtubeId
            ? _value.youtubeId
            : youtubeId // ignore: cast_nullable_to_non_nullable
                  as String,
        youtubeUrl: null == youtubeUrl
            ? _value.youtubeUrl
            : youtubeUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailUrl: null == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        durationDisplay: null == durationDisplay
            ? _value.durationDisplay
            : durationDisplay // ignore: cast_nullable_to_non_nullable
                  as String,
        channelName: null == channelName
            ? _value.channelName
            : channelName // ignore: cast_nullable_to_non_nullable
                  as String,
        channelId: null == channelId
            ? _value.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String,
        language: null == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as String,
        topicId: null == topicId
            ? _value.topicId
            : topicId // ignore: cast_nullable_to_non_nullable
                  as String,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as String,
        examRelevance: null == examRelevance
            ? _value._examRelevance
            : examRelevance // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        viewCount: null == viewCount
            ? _value.viewCount
            : viewCount // ignore: cast_nullable_to_non_nullable
                  as int,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        dateAdded: null == dateAdded
            ? _value.dateAdded
            : dateAdded // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoImpl extends _Video {
  const _$VideoImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeId,
    required this.youtubeUrl,
    required this.thumbnailUrl,
    required this.duration,
    required this.durationDisplay,
    required this.channelName,
    required this.channelId,
    required this.language,
    required this.topicId,
    required this.difficulty,
    required final List<String> examRelevance,
    required this.rating,
    required this.viewCount,
    required final List<String> tags,
    required this.dateAdded,
    required this.lastUpdated,
  }) : _examRelevance = examRelevance,
       _tags = tags,
       super._();

  factory _$VideoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String youtubeId;
  @override
  final String youtubeUrl;
  @override
  final String thumbnailUrl;
  @override
  final int duration;
  @override
  final String durationDisplay;
  @override
  final String channelName;
  @override
  final String channelId;
  @override
  final String language;
  @override
  final String topicId;
  @override
  final String difficulty;
  final List<String> _examRelevance;
  @override
  List<String> get examRelevance {
    if (_examRelevance is EqualUnmodifiableListView) return _examRelevance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_examRelevance);
  }

  @override
  final double rating;
  @override
  final int viewCount;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final DateTime dateAdded;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'Video(id: $id, title: $title, description: $description, youtubeId: $youtubeId, youtubeUrl: $youtubeUrl, thumbnailUrl: $thumbnailUrl, duration: $duration, durationDisplay: $durationDisplay, channelName: $channelName, channelId: $channelId, language: $language, topicId: $topicId, difficulty: $difficulty, examRelevance: $examRelevance, rating: $rating, viewCount: $viewCount, tags: $tags, dateAdded: $dateAdded, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.youtubeId, youtubeId) ||
                other.youtubeId == youtubeId) &&
            (identical(other.youtubeUrl, youtubeUrl) ||
                other.youtubeUrl == youtubeUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.durationDisplay, durationDisplay) ||
                other.durationDisplay == durationDisplay) &&
            (identical(other.channelName, channelName) ||
                other.channelName == channelName) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(
              other._examRelevance,
              _examRelevance,
            ) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.dateAdded, dateAdded) ||
                other.dateAdded == dateAdded) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    youtubeId,
    youtubeUrl,
    thumbnailUrl,
    duration,
    durationDisplay,
    channelName,
    channelId,
    language,
    topicId,
    difficulty,
    const DeepCollectionEquality().hash(_examRelevance),
    rating,
    viewCount,
    const DeepCollectionEquality().hash(_tags),
    dateAdded,
    lastUpdated,
  ]);

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoImplCopyWith<_$VideoImpl> get copyWith =>
      __$$VideoImplCopyWithImpl<_$VideoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoImplToJson(this);
  }
}

abstract class _Video extends Video {
  const factory _Video({
    required final String id,
    required final String title,
    required final String description,
    required final String youtubeId,
    required final String youtubeUrl,
    required final String thumbnailUrl,
    required final int duration,
    required final String durationDisplay,
    required final String channelName,
    required final String channelId,
    required final String language,
    required final String topicId,
    required final String difficulty,
    required final List<String> examRelevance,
    required final double rating,
    required final int viewCount,
    required final List<String> tags,
    required final DateTime dateAdded,
    required final DateTime lastUpdated,
  }) = _$VideoImpl;
  const _Video._() : super._();

  factory _Video.fromJson(Map<String, dynamic> json) = _$VideoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get youtubeId;
  @override
  String get youtubeUrl;
  @override
  String get thumbnailUrl;
  @override
  int get duration;
  @override
  String get durationDisplay;
  @override
  String get channelName;
  @override
  String get channelId;
  @override
  String get language;
  @override
  String get topicId;
  @override
  String get difficulty;
  @override
  List<String> get examRelevance;
  @override
  double get rating;
  @override
  int get viewCount;
  @override
  List<String> get tags;
  @override
  DateTime get dateAdded;
  @override
  DateTime get lastUpdated;

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoImplCopyWith<_$VideoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
