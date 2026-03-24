// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'glossary_term.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GlossaryTerm _$GlossaryTermFromJson(Map<String, dynamic> json) {
  return _GlossaryTerm.fromJson(json);
}

/// @nodoc
mixin _$GlossaryTerm {
  String get id => throw _privateConstructorUsedError;
  String get term => throw _privateConstructorUsedError;
  String get definition => throw _privateConstructorUsedError;
  String? get pronunciation => throw _privateConstructorUsedError;
  String? get exampleUsage => throw _privateConstructorUsedError;
  String get chapterId => throw _privateConstructorUsedError;
  String get segment => throw _privateConstructorUsedError;
  TermDifficulty get difficulty => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get audioUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GlossaryTerm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GlossaryTermCopyWith<GlossaryTerm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlossaryTermCopyWith<$Res> {
  factory $GlossaryTermCopyWith(
    GlossaryTerm value,
    $Res Function(GlossaryTerm) then,
  ) = _$GlossaryTermCopyWithImpl<$Res, GlossaryTerm>;
  @useResult
  $Res call({
    String id,
    String term,
    String definition,
    String? pronunciation,
    String? exampleUsage,
    String chapterId,
    String segment,
    TermDifficulty difficulty,
    String? imageUrl,
    String? audioUrl,
    DateTime createdAt,
  });
}

/// @nodoc
class _$GlossaryTermCopyWithImpl<$Res, $Val extends GlossaryTerm>
    implements $GlossaryTermCopyWith<$Res> {
  _$GlossaryTermCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? term = null,
    Object? definition = null,
    Object? pronunciation = freezed,
    Object? exampleUsage = freezed,
    Object? chapterId = null,
    Object? segment = null,
    Object? difficulty = null,
    Object? imageUrl = freezed,
    Object? audioUrl = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            term: null == term
                ? _value.term
                : term // ignore: cast_nullable_to_non_nullable
                      as String,
            definition: null == definition
                ? _value.definition
                : definition // ignore: cast_nullable_to_non_nullable
                      as String,
            pronunciation: freezed == pronunciation
                ? _value.pronunciation
                : pronunciation // ignore: cast_nullable_to_non_nullable
                      as String?,
            exampleUsage: freezed == exampleUsage
                ? _value.exampleUsage
                : exampleUsage // ignore: cast_nullable_to_non_nullable
                      as String?,
            chapterId: null == chapterId
                ? _value.chapterId
                : chapterId // ignore: cast_nullable_to_non_nullable
                      as String,
            segment: null == segment
                ? _value.segment
                : segment // ignore: cast_nullable_to_non_nullable
                      as String,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as TermDifficulty,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            audioUrl: freezed == audioUrl
                ? _value.audioUrl
                : audioUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GlossaryTermImplCopyWith<$Res>
    implements $GlossaryTermCopyWith<$Res> {
  factory _$$GlossaryTermImplCopyWith(
    _$GlossaryTermImpl value,
    $Res Function(_$GlossaryTermImpl) then,
  ) = __$$GlossaryTermImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String term,
    String definition,
    String? pronunciation,
    String? exampleUsage,
    String chapterId,
    String segment,
    TermDifficulty difficulty,
    String? imageUrl,
    String? audioUrl,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$GlossaryTermImplCopyWithImpl<$Res>
    extends _$GlossaryTermCopyWithImpl<$Res, _$GlossaryTermImpl>
    implements _$$GlossaryTermImplCopyWith<$Res> {
  __$$GlossaryTermImplCopyWithImpl(
    _$GlossaryTermImpl _value,
    $Res Function(_$GlossaryTermImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? term = null,
    Object? definition = null,
    Object? pronunciation = freezed,
    Object? exampleUsage = freezed,
    Object? chapterId = null,
    Object? segment = null,
    Object? difficulty = null,
    Object? imageUrl = freezed,
    Object? audioUrl = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$GlossaryTermImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        term: null == term
            ? _value.term
            : term // ignore: cast_nullable_to_non_nullable
                  as String,
        definition: null == definition
            ? _value.definition
            : definition // ignore: cast_nullable_to_non_nullable
                  as String,
        pronunciation: freezed == pronunciation
            ? _value.pronunciation
            : pronunciation // ignore: cast_nullable_to_non_nullable
                  as String?,
        exampleUsage: freezed == exampleUsage
            ? _value.exampleUsage
            : exampleUsage // ignore: cast_nullable_to_non_nullable
                  as String?,
        chapterId: null == chapterId
            ? _value.chapterId
            : chapterId // ignore: cast_nullable_to_non_nullable
                  as String,
        segment: null == segment
            ? _value.segment
            : segment // ignore: cast_nullable_to_non_nullable
                  as String,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as TermDifficulty,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        audioUrl: freezed == audioUrl
            ? _value.audioUrl
            : audioUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GlossaryTermImpl extends _GlossaryTerm {
  const _$GlossaryTermImpl({
    required this.id,
    required this.term,
    required this.definition,
    this.pronunciation,
    this.exampleUsage,
    required this.chapterId,
    required this.segment,
    this.difficulty = TermDifficulty.medium,
    this.imageUrl,
    this.audioUrl,
    required this.createdAt,
  }) : super._();

  factory _$GlossaryTermImpl.fromJson(Map<String, dynamic> json) =>
      _$$GlossaryTermImplFromJson(json);

  @override
  final String id;
  @override
  final String term;
  @override
  final String definition;
  @override
  final String? pronunciation;
  @override
  final String? exampleUsage;
  @override
  final String chapterId;
  @override
  final String segment;
  @override
  @JsonKey()
  final TermDifficulty difficulty;
  @override
  final String? imageUrl;
  @override
  final String? audioUrl;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'GlossaryTerm(id: $id, term: $term, definition: $definition, pronunciation: $pronunciation, exampleUsage: $exampleUsage, chapterId: $chapterId, segment: $segment, difficulty: $difficulty, imageUrl: $imageUrl, audioUrl: $audioUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlossaryTermImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.term, term) || other.term == term) &&
            (identical(other.definition, definition) ||
                other.definition == definition) &&
            (identical(other.pronunciation, pronunciation) ||
                other.pronunciation == pronunciation) &&
            (identical(other.exampleUsage, exampleUsage) ||
                other.exampleUsage == exampleUsage) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.segment, segment) || other.segment == segment) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    term,
    definition,
    pronunciation,
    exampleUsage,
    chapterId,
    segment,
    difficulty,
    imageUrl,
    audioUrl,
    createdAt,
  );

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GlossaryTermImplCopyWith<_$GlossaryTermImpl> get copyWith =>
      __$$GlossaryTermImplCopyWithImpl<_$GlossaryTermImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GlossaryTermImplToJson(this);
  }
}

abstract class _GlossaryTerm extends GlossaryTerm {
  const factory _GlossaryTerm({
    required final String id,
    required final String term,
    required final String definition,
    final String? pronunciation,
    final String? exampleUsage,
    required final String chapterId,
    required final String segment,
    final TermDifficulty difficulty,
    final String? imageUrl,
    final String? audioUrl,
    required final DateTime createdAt,
  }) = _$GlossaryTermImpl;
  const _GlossaryTerm._() : super._();

  factory _GlossaryTerm.fromJson(Map<String, dynamic> json) =
      _$GlossaryTermImpl.fromJson;

  @override
  String get id;
  @override
  String get term;
  @override
  String get definition;
  @override
  String? get pronunciation;
  @override
  String? get exampleUsage;
  @override
  String get chapterId;
  @override
  String get segment;
  @override
  TermDifficulty get difficulty;
  @override
  String? get imageUrl;
  @override
  String? get audioUrl;
  @override
  DateTime get createdAt;

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GlossaryTermImplCopyWith<_$GlossaryTermImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
