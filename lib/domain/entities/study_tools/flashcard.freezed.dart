// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flashcard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Flashcard _$FlashcardFromJson(Map<String, dynamic> json) {
  return _Flashcard.fromJson(json);
}

/// @nodoc
mixin _$Flashcard {
  String get id => throw _privateConstructorUsedError;
  String get deckId => throw _privateConstructorUsedError;
  String get front => throw _privateConstructorUsedError;
  String get back => throw _privateConstructorUsedError;
  String? get hint => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  FlashcardDifficulty get difficulty => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Flashcard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Flashcard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlashcardCopyWith<Flashcard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlashcardCopyWith<$Res> {
  factory $FlashcardCopyWith(Flashcard value, $Res Function(Flashcard) then) =
      _$FlashcardCopyWithImpl<$Res, Flashcard>;
  @useResult
  $Res call({
    String id,
    String deckId,
    String front,
    String back,
    String? hint,
    String? imageUrl,
    int orderIndex,
    FlashcardDifficulty difficulty,
    DateTime createdAt,
  });
}

/// @nodoc
class _$FlashcardCopyWithImpl<$Res, $Val extends Flashcard>
    implements $FlashcardCopyWith<$Res> {
  _$FlashcardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Flashcard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deckId = null,
    Object? front = null,
    Object? back = null,
    Object? hint = freezed,
    Object? imageUrl = freezed,
    Object? orderIndex = null,
    Object? difficulty = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            deckId: null == deckId
                ? _value.deckId
                : deckId // ignore: cast_nullable_to_non_nullable
                      as String,
            front: null == front
                ? _value.front
                : front // ignore: cast_nullable_to_non_nullable
                      as String,
            back: null == back
                ? _value.back
                : back // ignore: cast_nullable_to_non_nullable
                      as String,
            hint: freezed == hint
                ? _value.hint
                : hint // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as FlashcardDifficulty,
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
abstract class _$$FlashcardImplCopyWith<$Res>
    implements $FlashcardCopyWith<$Res> {
  factory _$$FlashcardImplCopyWith(
    _$FlashcardImpl value,
    $Res Function(_$FlashcardImpl) then,
  ) = __$$FlashcardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String deckId,
    String front,
    String back,
    String? hint,
    String? imageUrl,
    int orderIndex,
    FlashcardDifficulty difficulty,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$FlashcardImplCopyWithImpl<$Res>
    extends _$FlashcardCopyWithImpl<$Res, _$FlashcardImpl>
    implements _$$FlashcardImplCopyWith<$Res> {
  __$$FlashcardImplCopyWithImpl(
    _$FlashcardImpl _value,
    $Res Function(_$FlashcardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Flashcard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deckId = null,
    Object? front = null,
    Object? back = null,
    Object? hint = freezed,
    Object? imageUrl = freezed,
    Object? orderIndex = null,
    Object? difficulty = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$FlashcardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        deckId: null == deckId
            ? _value.deckId
            : deckId // ignore: cast_nullable_to_non_nullable
                  as String,
        front: null == front
            ? _value.front
            : front // ignore: cast_nullable_to_non_nullable
                  as String,
        back: null == back
            ? _value.back
            : back // ignore: cast_nullable_to_non_nullable
                  as String,
        hint: freezed == hint
            ? _value.hint
            : hint // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as FlashcardDifficulty,
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
class _$FlashcardImpl extends _Flashcard {
  const _$FlashcardImpl({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    this.hint,
    this.imageUrl,
    this.orderIndex = 0,
    this.difficulty = FlashcardDifficulty.medium,
    required this.createdAt,
  }) : super._();

  factory _$FlashcardImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlashcardImplFromJson(json);

  @override
  final String id;
  @override
  final String deckId;
  @override
  final String front;
  @override
  final String back;
  @override
  final String? hint;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final int orderIndex;
  @override
  @JsonKey()
  final FlashcardDifficulty difficulty;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Flashcard(id: $id, deckId: $deckId, front: $front, back: $back, hint: $hint, imageUrl: $imageUrl, orderIndex: $orderIndex, difficulty: $difficulty, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlashcardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deckId, deckId) || other.deckId == deckId) &&
            (identical(other.front, front) || other.front == front) &&
            (identical(other.back, back) || other.back == back) &&
            (identical(other.hint, hint) || other.hint == hint) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    deckId,
    front,
    back,
    hint,
    imageUrl,
    orderIndex,
    difficulty,
    createdAt,
  );

  /// Create a copy of Flashcard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlashcardImplCopyWith<_$FlashcardImpl> get copyWith =>
      __$$FlashcardImplCopyWithImpl<_$FlashcardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlashcardImplToJson(this);
  }
}

abstract class _Flashcard extends Flashcard {
  const factory _Flashcard({
    required final String id,
    required final String deckId,
    required final String front,
    required final String back,
    final String? hint,
    final String? imageUrl,
    final int orderIndex,
    final FlashcardDifficulty difficulty,
    required final DateTime createdAt,
  }) = _$FlashcardImpl;
  const _Flashcard._() : super._();

  factory _Flashcard.fromJson(Map<String, dynamic> json) =
      _$FlashcardImpl.fromJson;

  @override
  String get id;
  @override
  String get deckId;
  @override
  String get front;
  @override
  String get back;
  @override
  String? get hint;
  @override
  String? get imageUrl;
  @override
  int get orderIndex;
  @override
  FlashcardDifficulty get difficulty;
  @override
  DateTime get createdAt;

  /// Create a copy of Flashcard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlashcardImplCopyWith<_$FlashcardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FlashcardDeck _$FlashcardDeckFromJson(Map<String, dynamic> json) {
  return _FlashcardDeck.fromJson(json);
}

/// @nodoc
mixin _$FlashcardDeck {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get topicId => throw _privateConstructorUsedError;
  String? get chapterId => throw _privateConstructorUsedError;
  int get cardCount => throw _privateConstructorUsedError;
  String get segment => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<Flashcard> get cards => throw _privateConstructorUsedError;

  /// Serializes this FlashcardDeck to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlashcardDeck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlashcardDeckCopyWith<FlashcardDeck> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlashcardDeckCopyWith<$Res> {
  factory $FlashcardDeckCopyWith(
    FlashcardDeck value,
    $Res Function(FlashcardDeck) then,
  ) = _$FlashcardDeckCopyWithImpl<$Res, FlashcardDeck>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String? topicId,
    String? chapterId,
    int cardCount,
    String segment,
    DateTime createdAt,
    DateTime updatedAt,
    List<Flashcard> cards,
  });
}

/// @nodoc
class _$FlashcardDeckCopyWithImpl<$Res, $Val extends FlashcardDeck>
    implements $FlashcardDeckCopyWith<$Res> {
  _$FlashcardDeckCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlashcardDeck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? topicId = freezed,
    Object? chapterId = freezed,
    Object? cardCount = null,
    Object? segment = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? cards = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            topicId: freezed == topicId
                ? _value.topicId
                : topicId // ignore: cast_nullable_to_non_nullable
                      as String?,
            chapterId: freezed == chapterId
                ? _value.chapterId
                : chapterId // ignore: cast_nullable_to_non_nullable
                      as String?,
            cardCount: null == cardCount
                ? _value.cardCount
                : cardCount // ignore: cast_nullable_to_non_nullable
                      as int,
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
            cards: null == cards
                ? _value.cards
                : cards // ignore: cast_nullable_to_non_nullable
                      as List<Flashcard>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FlashcardDeckImplCopyWith<$Res>
    implements $FlashcardDeckCopyWith<$Res> {
  factory _$$FlashcardDeckImplCopyWith(
    _$FlashcardDeckImpl value,
    $Res Function(_$FlashcardDeckImpl) then,
  ) = __$$FlashcardDeckImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    String? topicId,
    String? chapterId,
    int cardCount,
    String segment,
    DateTime createdAt,
    DateTime updatedAt,
    List<Flashcard> cards,
  });
}

/// @nodoc
class __$$FlashcardDeckImplCopyWithImpl<$Res>
    extends _$FlashcardDeckCopyWithImpl<$Res, _$FlashcardDeckImpl>
    implements _$$FlashcardDeckImplCopyWith<$Res> {
  __$$FlashcardDeckImplCopyWithImpl(
    _$FlashcardDeckImpl _value,
    $Res Function(_$FlashcardDeckImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlashcardDeck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? topicId = freezed,
    Object? chapterId = freezed,
    Object? cardCount = null,
    Object? segment = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? cards = null,
  }) {
    return _then(
      _$FlashcardDeckImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        topicId: freezed == topicId
            ? _value.topicId
            : topicId // ignore: cast_nullable_to_non_nullable
                  as String?,
        chapterId: freezed == chapterId
            ? _value.chapterId
            : chapterId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cardCount: null == cardCount
            ? _value.cardCount
            : cardCount // ignore: cast_nullable_to_non_nullable
                  as int,
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
        cards: null == cards
            ? _value._cards
            : cards // ignore: cast_nullable_to_non_nullable
                  as List<Flashcard>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FlashcardDeckImpl extends _FlashcardDeck {
  const _$FlashcardDeckImpl({
    required this.id,
    required this.name,
    this.description,
    this.topicId,
    this.chapterId,
    this.cardCount = 0,
    required this.segment,
    required this.createdAt,
    required this.updatedAt,
    final List<Flashcard> cards = const [],
  }) : _cards = cards,
       super._();

  factory _$FlashcardDeckImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlashcardDeckImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? topicId;
  @override
  final String? chapterId;
  @override
  @JsonKey()
  final int cardCount;
  @override
  final String segment;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<Flashcard> _cards;
  @override
  @JsonKey()
  List<Flashcard> get cards {
    if (_cards is EqualUnmodifiableListView) return _cards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cards);
  }

  @override
  String toString() {
    return 'FlashcardDeck(id: $id, name: $name, description: $description, topicId: $topicId, chapterId: $chapterId, cardCount: $cardCount, segment: $segment, createdAt: $createdAt, updatedAt: $updatedAt, cards: $cards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlashcardDeckImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.cardCount, cardCount) ||
                other.cardCount == cardCount) &&
            (identical(other.segment, segment) || other.segment == segment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._cards, _cards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    topicId,
    chapterId,
    cardCount,
    segment,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_cards),
  );

  /// Create a copy of FlashcardDeck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlashcardDeckImplCopyWith<_$FlashcardDeckImpl> get copyWith =>
      __$$FlashcardDeckImplCopyWithImpl<_$FlashcardDeckImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlashcardDeckImplToJson(this);
  }
}

abstract class _FlashcardDeck extends FlashcardDeck {
  const factory _FlashcardDeck({
    required final String id,
    required final String name,
    final String? description,
    final String? topicId,
    final String? chapterId,
    final int cardCount,
    required final String segment,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final List<Flashcard> cards,
  }) = _$FlashcardDeckImpl;
  const _FlashcardDeck._() : super._();

  factory _FlashcardDeck.fromJson(Map<String, dynamic> json) =
      _$FlashcardDeckImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get topicId;
  @override
  String? get chapterId;
  @override
  int get cardCount;
  @override
  String get segment;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<Flashcard> get cards;

  /// Create a copy of FlashcardDeck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlashcardDeckImplCopyWith<_$FlashcardDeckImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
