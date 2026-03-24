// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChapterNote _$ChapterNoteFromJson(Map<String, dynamic> json) {
  return _ChapterNote.fromJson(json);
}

/// @nodoc
mixin _$ChapterNote {
  String get id => throw _privateConstructorUsedError;
  String get chapterId => throw _privateConstructorUsedError;

  /// Profile ID of the note owner. Null for curated notes (shared), non-null for personal notes
  String? get profileId => throw _privateConstructorUsedError;

  /// Subject ID for JSON lookup (curated notes)
  String? get subjectId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isPinned => throw _privateConstructorUsedError;
  NoteType get noteType => throw _privateConstructorUsedError;
  String get segment => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChapterNote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChapterNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChapterNoteCopyWith<ChapterNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterNoteCopyWith<$Res> {
  factory $ChapterNoteCopyWith(
    ChapterNote value,
    $Res Function(ChapterNote) then,
  ) = _$ChapterNoteCopyWithImpl<$Res, ChapterNote>;
  @useResult
  $Res call({
    String id,
    String chapterId,
    String? profileId,
    String? subjectId,
    String content,
    String? title,
    List<String> tags,
    bool isPinned,
    NoteType noteType,
    String segment,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ChapterNoteCopyWithImpl<$Res, $Val extends ChapterNote>
    implements $ChapterNoteCopyWith<$Res> {
  _$ChapterNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChapterNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? profileId = freezed,
    Object? subjectId = freezed,
    Object? content = null,
    Object? title = freezed,
    Object? tags = null,
    Object? isPinned = null,
    Object? noteType = null,
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
            chapterId: null == chapterId
                ? _value.chapterId
                : chapterId // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: freezed == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String?,
            subjectId: freezed == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isPinned: null == isPinned
                ? _value.isPinned
                : isPinned // ignore: cast_nullable_to_non_nullable
                      as bool,
            noteType: null == noteType
                ? _value.noteType
                : noteType // ignore: cast_nullable_to_non_nullable
                      as NoteType,
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
abstract class _$$ChapterNoteImplCopyWith<$Res>
    implements $ChapterNoteCopyWith<$Res> {
  factory _$$ChapterNoteImplCopyWith(
    _$ChapterNoteImpl value,
    $Res Function(_$ChapterNoteImpl) then,
  ) = __$$ChapterNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String chapterId,
    String? profileId,
    String? subjectId,
    String content,
    String? title,
    List<String> tags,
    bool isPinned,
    NoteType noteType,
    String segment,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$ChapterNoteImplCopyWithImpl<$Res>
    extends _$ChapterNoteCopyWithImpl<$Res, _$ChapterNoteImpl>
    implements _$$ChapterNoteImplCopyWith<$Res> {
  __$$ChapterNoteImplCopyWithImpl(
    _$ChapterNoteImpl _value,
    $Res Function(_$ChapterNoteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChapterNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? profileId = freezed,
    Object? subjectId = freezed,
    Object? content = null,
    Object? title = freezed,
    Object? tags = null,
    Object? isPinned = null,
    Object? noteType = null,
    Object? segment = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ChapterNoteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        chapterId: null == chapterId
            ? _value.chapterId
            : chapterId // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: freezed == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String?,
        subjectId: freezed == subjectId
            ? _value.subjectId
            : subjectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isPinned: null == isPinned
            ? _value.isPinned
            : isPinned // ignore: cast_nullable_to_non_nullable
                  as bool,
        noteType: null == noteType
            ? _value.noteType
            : noteType // ignore: cast_nullable_to_non_nullable
                  as NoteType,
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
class _$ChapterNoteImpl extends _ChapterNote {
  const _$ChapterNoteImpl({
    required this.id,
    required this.chapterId,
    this.profileId,
    this.subjectId,
    required this.content,
    this.title,
    final List<String> tags = const [],
    this.isPinned = false,
    this.noteType = NoteType.personal,
    required this.segment,
    required this.createdAt,
    required this.updatedAt,
  }) : _tags = tags,
       super._();

  factory _$ChapterNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterNoteImplFromJson(json);

  @override
  final String id;
  @override
  final String chapterId;

  /// Profile ID of the note owner. Null for curated notes (shared), non-null for personal notes
  @override
  final String? profileId;

  /// Subject ID for JSON lookup (curated notes)
  @override
  final String? subjectId;
  @override
  final String content;
  @override
  final String? title;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isPinned;
  @override
  @JsonKey()
  final NoteType noteType;
  @override
  final String segment;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ChapterNote(id: $id, chapterId: $chapterId, profileId: $profileId, subjectId: $subjectId, content: $content, title: $title, tags: $tags, isPinned: $isPinned, noteType: $noteType, segment: $segment, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterNoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.noteType, noteType) ||
                other.noteType == noteType) &&
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
    chapterId,
    profileId,
    subjectId,
    content,
    title,
    const DeepCollectionEquality().hash(_tags),
    isPinned,
    noteType,
    segment,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ChapterNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChapterNoteImplCopyWith<_$ChapterNoteImpl> get copyWith =>
      __$$ChapterNoteImplCopyWithImpl<_$ChapterNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterNoteImplToJson(this);
  }
}

abstract class _ChapterNote extends ChapterNote {
  const factory _ChapterNote({
    required final String id,
    required final String chapterId,
    final String? profileId,
    final String? subjectId,
    required final String content,
    final String? title,
    final List<String> tags,
    final bool isPinned,
    final NoteType noteType,
    required final String segment,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$ChapterNoteImpl;
  const _ChapterNote._() : super._();

  factory _ChapterNote.fromJson(Map<String, dynamic> json) =
      _$ChapterNoteImpl.fromJson;

  @override
  String get id;
  @override
  String get chapterId;

  /// Profile ID of the note owner. Null for curated notes (shared), non-null for personal notes
  @override
  String? get profileId;

  /// Subject ID for JSON lookup (curated notes)
  @override
  String? get subjectId;
  @override
  String get content;
  @override
  String? get title;
  @override
  List<String> get tags;
  @override
  bool get isPinned;
  @override
  NoteType get noteType;
  @override
  String get segment;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ChapterNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChapterNoteImplCopyWith<_$ChapterNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
