// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flashcard_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FlashcardProgress _$FlashcardProgressFromJson(Map<String, dynamic> json) {
  return _FlashcardProgress.fromJson(json);
}

/// @nodoc
mixin _$FlashcardProgress {
  String get id => throw _privateConstructorUsedError;
  String get cardId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  bool get known => throw _privateConstructorUsedError;
  double get easeFactor => throw _privateConstructorUsedError;
  int get intervalDays => throw _privateConstructorUsedError;
  DateTime? get nextReviewDate => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  int get correctCount => throw _privateConstructorUsedError;
  DateTime? get lastReviewedAt => throw _privateConstructorUsedError;

  /// Serializes this FlashcardProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlashcardProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlashcardProgressCopyWith<FlashcardProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlashcardProgressCopyWith<$Res> {
  factory $FlashcardProgressCopyWith(
    FlashcardProgress value,
    $Res Function(FlashcardProgress) then,
  ) = _$FlashcardProgressCopyWithImpl<$Res, FlashcardProgress>;
  @useResult
  $Res call({
    String id,
    String cardId,
    String profileId,
    bool known,
    double easeFactor,
    int intervalDays,
    DateTime? nextReviewDate,
    int reviewCount,
    int correctCount,
    DateTime? lastReviewedAt,
  });
}

/// @nodoc
class _$FlashcardProgressCopyWithImpl<$Res, $Val extends FlashcardProgress>
    implements $FlashcardProgressCopyWith<$Res> {
  _$FlashcardProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlashcardProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cardId = null,
    Object? profileId = null,
    Object? known = null,
    Object? easeFactor = null,
    Object? intervalDays = null,
    Object? nextReviewDate = freezed,
    Object? reviewCount = null,
    Object? correctCount = null,
    Object? lastReviewedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            cardId: null == cardId
                ? _value.cardId
                : cardId // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            known: null == known
                ? _value.known
                : known // ignore: cast_nullable_to_non_nullable
                      as bool,
            easeFactor: null == easeFactor
                ? _value.easeFactor
                : easeFactor // ignore: cast_nullable_to_non_nullable
                      as double,
            intervalDays: null == intervalDays
                ? _value.intervalDays
                : intervalDays // ignore: cast_nullable_to_non_nullable
                      as int,
            nextReviewDate: freezed == nextReviewDate
                ? _value.nextReviewDate
                : nextReviewDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            reviewCount: null == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                      as int,
            correctCount: null == correctCount
                ? _value.correctCount
                : correctCount // ignore: cast_nullable_to_non_nullable
                      as int,
            lastReviewedAt: freezed == lastReviewedAt
                ? _value.lastReviewedAt
                : lastReviewedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FlashcardProgressImplCopyWith<$Res>
    implements $FlashcardProgressCopyWith<$Res> {
  factory _$$FlashcardProgressImplCopyWith(
    _$FlashcardProgressImpl value,
    $Res Function(_$FlashcardProgressImpl) then,
  ) = __$$FlashcardProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String cardId,
    String profileId,
    bool known,
    double easeFactor,
    int intervalDays,
    DateTime? nextReviewDate,
    int reviewCount,
    int correctCount,
    DateTime? lastReviewedAt,
  });
}

/// @nodoc
class __$$FlashcardProgressImplCopyWithImpl<$Res>
    extends _$FlashcardProgressCopyWithImpl<$Res, _$FlashcardProgressImpl>
    implements _$$FlashcardProgressImplCopyWith<$Res> {
  __$$FlashcardProgressImplCopyWithImpl(
    _$FlashcardProgressImpl _value,
    $Res Function(_$FlashcardProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlashcardProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cardId = null,
    Object? profileId = null,
    Object? known = null,
    Object? easeFactor = null,
    Object? intervalDays = null,
    Object? nextReviewDate = freezed,
    Object? reviewCount = null,
    Object? correctCount = null,
    Object? lastReviewedAt = freezed,
  }) {
    return _then(
      _$FlashcardProgressImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        cardId: null == cardId
            ? _value.cardId
            : cardId // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        known: null == known
            ? _value.known
            : known // ignore: cast_nullable_to_non_nullable
                  as bool,
        easeFactor: null == easeFactor
            ? _value.easeFactor
            : easeFactor // ignore: cast_nullable_to_non_nullable
                  as double,
        intervalDays: null == intervalDays
            ? _value.intervalDays
            : intervalDays // ignore: cast_nullable_to_non_nullable
                  as int,
        nextReviewDate: freezed == nextReviewDate
            ? _value.nextReviewDate
            : nextReviewDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewCount: null == reviewCount
            ? _value.reviewCount
            : reviewCount // ignore: cast_nullable_to_non_nullable
                  as int,
        correctCount: null == correctCount
            ? _value.correctCount
            : correctCount // ignore: cast_nullable_to_non_nullable
                  as int,
        lastReviewedAt: freezed == lastReviewedAt
            ? _value.lastReviewedAt
            : lastReviewedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FlashcardProgressImpl extends _FlashcardProgress {
  const _$FlashcardProgressImpl({
    required this.id,
    required this.cardId,
    required this.profileId,
    this.known = false,
    this.easeFactor = 2.5,
    this.intervalDays = 1,
    this.nextReviewDate,
    this.reviewCount = 0,
    this.correctCount = 0,
    this.lastReviewedAt,
  }) : super._();

  factory _$FlashcardProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlashcardProgressImplFromJson(json);

  @override
  final String id;
  @override
  final String cardId;
  @override
  final String profileId;
  @override
  @JsonKey()
  final bool known;
  @override
  @JsonKey()
  final double easeFactor;
  @override
  @JsonKey()
  final int intervalDays;
  @override
  final DateTime? nextReviewDate;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  @JsonKey()
  final int correctCount;
  @override
  final DateTime? lastReviewedAt;

  @override
  String toString() {
    return 'FlashcardProgress(id: $id, cardId: $cardId, profileId: $profileId, known: $known, easeFactor: $easeFactor, intervalDays: $intervalDays, nextReviewDate: $nextReviewDate, reviewCount: $reviewCount, correctCount: $correctCount, lastReviewedAt: $lastReviewedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlashcardProgressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.known, known) || other.known == known) &&
            (identical(other.easeFactor, easeFactor) ||
                other.easeFactor == easeFactor) &&
            (identical(other.intervalDays, intervalDays) ||
                other.intervalDays == intervalDays) &&
            (identical(other.nextReviewDate, nextReviewDate) ||
                other.nextReviewDate == nextReviewDate) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.correctCount, correctCount) ||
                other.correctCount == correctCount) &&
            (identical(other.lastReviewedAt, lastReviewedAt) ||
                other.lastReviewedAt == lastReviewedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    cardId,
    profileId,
    known,
    easeFactor,
    intervalDays,
    nextReviewDate,
    reviewCount,
    correctCount,
    lastReviewedAt,
  );

  /// Create a copy of FlashcardProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlashcardProgressImplCopyWith<_$FlashcardProgressImpl> get copyWith =>
      __$$FlashcardProgressImplCopyWithImpl<_$FlashcardProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FlashcardProgressImplToJson(this);
  }
}

abstract class _FlashcardProgress extends FlashcardProgress {
  const factory _FlashcardProgress({
    required final String id,
    required final String cardId,
    required final String profileId,
    final bool known,
    final double easeFactor,
    final int intervalDays,
    final DateTime? nextReviewDate,
    final int reviewCount,
    final int correctCount,
    final DateTime? lastReviewedAt,
  }) = _$FlashcardProgressImpl;
  const _FlashcardProgress._() : super._();

  factory _FlashcardProgress.fromJson(Map<String, dynamic> json) =
      _$FlashcardProgressImpl.fromJson;

  @override
  String get id;
  @override
  String get cardId;
  @override
  String get profileId;
  @override
  bool get known;
  @override
  double get easeFactor;
  @override
  int get intervalDays;
  @override
  DateTime? get nextReviewDate;
  @override
  int get reviewCount;
  @override
  int get correctCount;
  @override
  DateTime? get lastReviewedAt;

  /// Create a copy of FlashcardProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlashcardProgressImplCopyWith<_$FlashcardProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FlashcardStudySession _$FlashcardStudySessionFromJson(
  Map<String, dynamic> json,
) {
  return _FlashcardStudySession.fromJson(json);
}

/// @nodoc
mixin _$FlashcardStudySession {
  String get deckId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  int get totalCards => throw _privateConstructorUsedError;
  int get knownCards => throw _privateConstructorUsedError;
  int get unknownCards => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  DateTime get completedAt => throw _privateConstructorUsedError;

  /// Serializes this FlashcardStudySession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlashcardStudySession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlashcardStudySessionCopyWith<FlashcardStudySession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlashcardStudySessionCopyWith<$Res> {
  factory $FlashcardStudySessionCopyWith(
    FlashcardStudySession value,
    $Res Function(FlashcardStudySession) then,
  ) = _$FlashcardStudySessionCopyWithImpl<$Res, FlashcardStudySession>;
  @useResult
  $Res call({
    String deckId,
    String profileId,
    int totalCards,
    int knownCards,
    int unknownCards,
    Duration duration,
    DateTime completedAt,
  });
}

/// @nodoc
class _$FlashcardStudySessionCopyWithImpl<
  $Res,
  $Val extends FlashcardStudySession
>
    implements $FlashcardStudySessionCopyWith<$Res> {
  _$FlashcardStudySessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlashcardStudySession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deckId = null,
    Object? profileId = null,
    Object? totalCards = null,
    Object? knownCards = null,
    Object? unknownCards = null,
    Object? duration = null,
    Object? completedAt = null,
  }) {
    return _then(
      _value.copyWith(
            deckId: null == deckId
                ? _value.deckId
                : deckId // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            totalCards: null == totalCards
                ? _value.totalCards
                : totalCards // ignore: cast_nullable_to_non_nullable
                      as int,
            knownCards: null == knownCards
                ? _value.knownCards
                : knownCards // ignore: cast_nullable_to_non_nullable
                      as int,
            unknownCards: null == unknownCards
                ? _value.unknownCards
                : unknownCards // ignore: cast_nullable_to_non_nullable
                      as int,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            completedAt: null == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FlashcardStudySessionImplCopyWith<$Res>
    implements $FlashcardStudySessionCopyWith<$Res> {
  factory _$$FlashcardStudySessionImplCopyWith(
    _$FlashcardStudySessionImpl value,
    $Res Function(_$FlashcardStudySessionImpl) then,
  ) = __$$FlashcardStudySessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String deckId,
    String profileId,
    int totalCards,
    int knownCards,
    int unknownCards,
    Duration duration,
    DateTime completedAt,
  });
}

/// @nodoc
class __$$FlashcardStudySessionImplCopyWithImpl<$Res>
    extends
        _$FlashcardStudySessionCopyWithImpl<$Res, _$FlashcardStudySessionImpl>
    implements _$$FlashcardStudySessionImplCopyWith<$Res> {
  __$$FlashcardStudySessionImplCopyWithImpl(
    _$FlashcardStudySessionImpl _value,
    $Res Function(_$FlashcardStudySessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlashcardStudySession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deckId = null,
    Object? profileId = null,
    Object? totalCards = null,
    Object? knownCards = null,
    Object? unknownCards = null,
    Object? duration = null,
    Object? completedAt = null,
  }) {
    return _then(
      _$FlashcardStudySessionImpl(
        deckId: null == deckId
            ? _value.deckId
            : deckId // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalCards: null == totalCards
            ? _value.totalCards
            : totalCards // ignore: cast_nullable_to_non_nullable
                  as int,
        knownCards: null == knownCards
            ? _value.knownCards
            : knownCards // ignore: cast_nullable_to_non_nullable
                  as int,
        unknownCards: null == unknownCards
            ? _value.unknownCards
            : unknownCards // ignore: cast_nullable_to_non_nullable
                  as int,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        completedAt: null == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FlashcardStudySessionImpl extends _FlashcardStudySession {
  const _$FlashcardStudySessionImpl({
    required this.deckId,
    required this.profileId,
    required this.totalCards,
    required this.knownCards,
    required this.unknownCards,
    required this.duration,
    required this.completedAt,
  }) : super._();

  factory _$FlashcardStudySessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlashcardStudySessionImplFromJson(json);

  @override
  final String deckId;
  @override
  final String profileId;
  @override
  final int totalCards;
  @override
  final int knownCards;
  @override
  final int unknownCards;
  @override
  final Duration duration;
  @override
  final DateTime completedAt;

  @override
  String toString() {
    return 'FlashcardStudySession(deckId: $deckId, profileId: $profileId, totalCards: $totalCards, knownCards: $knownCards, unknownCards: $unknownCards, duration: $duration, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlashcardStudySessionImpl &&
            (identical(other.deckId, deckId) || other.deckId == deckId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.totalCards, totalCards) ||
                other.totalCards == totalCards) &&
            (identical(other.knownCards, knownCards) ||
                other.knownCards == knownCards) &&
            (identical(other.unknownCards, unknownCards) ||
                other.unknownCards == unknownCards) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    deckId,
    profileId,
    totalCards,
    knownCards,
    unknownCards,
    duration,
    completedAt,
  );

  /// Create a copy of FlashcardStudySession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlashcardStudySessionImplCopyWith<_$FlashcardStudySessionImpl>
  get copyWith =>
      __$$FlashcardStudySessionImplCopyWithImpl<_$FlashcardStudySessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FlashcardStudySessionImplToJson(this);
  }
}

abstract class _FlashcardStudySession extends FlashcardStudySession {
  const factory _FlashcardStudySession({
    required final String deckId,
    required final String profileId,
    required final int totalCards,
    required final int knownCards,
    required final int unknownCards,
    required final Duration duration,
    required final DateTime completedAt,
  }) = _$FlashcardStudySessionImpl;
  const _FlashcardStudySession._() : super._();

  factory _FlashcardStudySession.fromJson(Map<String, dynamic> json) =
      _$FlashcardStudySessionImpl.fromJson;

  @override
  String get deckId;
  @override
  String get profileId;
  @override
  int get totalCards;
  @override
  int get knownCards;
  @override
  int get unknownCards;
  @override
  Duration get duration;
  @override
  DateTime get completedAt;

  /// Create a copy of FlashcardStudySession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlashcardStudySessionImplCopyWith<_$FlashcardStudySessionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

DeckProgress _$DeckProgressFromJson(Map<String, dynamic> json) {
  return _DeckProgress.fromJson(json);
}

/// @nodoc
mixin _$DeckProgress {
  String get deckId => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  int get totalCards => throw _privateConstructorUsedError;
  int get reviewedCards => throw _privateConstructorUsedError;
  int get masteredCards => throw _privateConstructorUsedError;
  int get dueCards => throw _privateConstructorUsedError;
  double get averageAccuracy => throw _privateConstructorUsedError;
  DateTime? get lastStudiedAt => throw _privateConstructorUsedError;

  /// Serializes this DeckProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeckProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeckProgressCopyWith<DeckProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeckProgressCopyWith<$Res> {
  factory $DeckProgressCopyWith(
    DeckProgress value,
    $Res Function(DeckProgress) then,
  ) = _$DeckProgressCopyWithImpl<$Res, DeckProgress>;
  @useResult
  $Res call({
    String deckId,
    String profileId,
    int totalCards,
    int reviewedCards,
    int masteredCards,
    int dueCards,
    double averageAccuracy,
    DateTime? lastStudiedAt,
  });
}

/// @nodoc
class _$DeckProgressCopyWithImpl<$Res, $Val extends DeckProgress>
    implements $DeckProgressCopyWith<$Res> {
  _$DeckProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeckProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deckId = null,
    Object? profileId = null,
    Object? totalCards = null,
    Object? reviewedCards = null,
    Object? masteredCards = null,
    Object? dueCards = null,
    Object? averageAccuracy = null,
    Object? lastStudiedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            deckId: null == deckId
                ? _value.deckId
                : deckId // ignore: cast_nullable_to_non_nullable
                      as String,
            profileId: null == profileId
                ? _value.profileId
                : profileId // ignore: cast_nullable_to_non_nullable
                      as String,
            totalCards: null == totalCards
                ? _value.totalCards
                : totalCards // ignore: cast_nullable_to_non_nullable
                      as int,
            reviewedCards: null == reviewedCards
                ? _value.reviewedCards
                : reviewedCards // ignore: cast_nullable_to_non_nullable
                      as int,
            masteredCards: null == masteredCards
                ? _value.masteredCards
                : masteredCards // ignore: cast_nullable_to_non_nullable
                      as int,
            dueCards: null == dueCards
                ? _value.dueCards
                : dueCards // ignore: cast_nullable_to_non_nullable
                      as int,
            averageAccuracy: null == averageAccuracy
                ? _value.averageAccuracy
                : averageAccuracy // ignore: cast_nullable_to_non_nullable
                      as double,
            lastStudiedAt: freezed == lastStudiedAt
                ? _value.lastStudiedAt
                : lastStudiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeckProgressImplCopyWith<$Res>
    implements $DeckProgressCopyWith<$Res> {
  factory _$$DeckProgressImplCopyWith(
    _$DeckProgressImpl value,
    $Res Function(_$DeckProgressImpl) then,
  ) = __$$DeckProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String deckId,
    String profileId,
    int totalCards,
    int reviewedCards,
    int masteredCards,
    int dueCards,
    double averageAccuracy,
    DateTime? lastStudiedAt,
  });
}

/// @nodoc
class __$$DeckProgressImplCopyWithImpl<$Res>
    extends _$DeckProgressCopyWithImpl<$Res, _$DeckProgressImpl>
    implements _$$DeckProgressImplCopyWith<$Res> {
  __$$DeckProgressImplCopyWithImpl(
    _$DeckProgressImpl _value,
    $Res Function(_$DeckProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeckProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deckId = null,
    Object? profileId = null,
    Object? totalCards = null,
    Object? reviewedCards = null,
    Object? masteredCards = null,
    Object? dueCards = null,
    Object? averageAccuracy = null,
    Object? lastStudiedAt = freezed,
  }) {
    return _then(
      _$DeckProgressImpl(
        deckId: null == deckId
            ? _value.deckId
            : deckId // ignore: cast_nullable_to_non_nullable
                  as String,
        profileId: null == profileId
            ? _value.profileId
            : profileId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalCards: null == totalCards
            ? _value.totalCards
            : totalCards // ignore: cast_nullable_to_non_nullable
                  as int,
        reviewedCards: null == reviewedCards
            ? _value.reviewedCards
            : reviewedCards // ignore: cast_nullable_to_non_nullable
                  as int,
        masteredCards: null == masteredCards
            ? _value.masteredCards
            : masteredCards // ignore: cast_nullable_to_non_nullable
                  as int,
        dueCards: null == dueCards
            ? _value.dueCards
            : dueCards // ignore: cast_nullable_to_non_nullable
                  as int,
        averageAccuracy: null == averageAccuracy
            ? _value.averageAccuracy
            : averageAccuracy // ignore: cast_nullable_to_non_nullable
                  as double,
        lastStudiedAt: freezed == lastStudiedAt
            ? _value.lastStudiedAt
            : lastStudiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeckProgressImpl extends _DeckProgress {
  const _$DeckProgressImpl({
    required this.deckId,
    required this.profileId,
    required this.totalCards,
    required this.reviewedCards,
    required this.masteredCards,
    required this.dueCards,
    required this.averageAccuracy,
    this.lastStudiedAt,
  }) : super._();

  factory _$DeckProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeckProgressImplFromJson(json);

  @override
  final String deckId;
  @override
  final String profileId;
  @override
  final int totalCards;
  @override
  final int reviewedCards;
  @override
  final int masteredCards;
  @override
  final int dueCards;
  @override
  final double averageAccuracy;
  @override
  final DateTime? lastStudiedAt;

  @override
  String toString() {
    return 'DeckProgress(deckId: $deckId, profileId: $profileId, totalCards: $totalCards, reviewedCards: $reviewedCards, masteredCards: $masteredCards, dueCards: $dueCards, averageAccuracy: $averageAccuracy, lastStudiedAt: $lastStudiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeckProgressImpl &&
            (identical(other.deckId, deckId) || other.deckId == deckId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.totalCards, totalCards) ||
                other.totalCards == totalCards) &&
            (identical(other.reviewedCards, reviewedCards) ||
                other.reviewedCards == reviewedCards) &&
            (identical(other.masteredCards, masteredCards) ||
                other.masteredCards == masteredCards) &&
            (identical(other.dueCards, dueCards) ||
                other.dueCards == dueCards) &&
            (identical(other.averageAccuracy, averageAccuracy) ||
                other.averageAccuracy == averageAccuracy) &&
            (identical(other.lastStudiedAt, lastStudiedAt) ||
                other.lastStudiedAt == lastStudiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    deckId,
    profileId,
    totalCards,
    reviewedCards,
    masteredCards,
    dueCards,
    averageAccuracy,
    lastStudiedAt,
  );

  /// Create a copy of DeckProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeckProgressImplCopyWith<_$DeckProgressImpl> get copyWith =>
      __$$DeckProgressImplCopyWithImpl<_$DeckProgressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeckProgressImplToJson(this);
  }
}

abstract class _DeckProgress extends DeckProgress {
  const factory _DeckProgress({
    required final String deckId,
    required final String profileId,
    required final int totalCards,
    required final int reviewedCards,
    required final int masteredCards,
    required final int dueCards,
    required final double averageAccuracy,
    final DateTime? lastStudiedAt,
  }) = _$DeckProgressImpl;
  const _DeckProgress._() : super._();

  factory _DeckProgress.fromJson(Map<String, dynamic> json) =
      _$DeckProgressImpl.fromJson;

  @override
  String get deckId;
  @override
  String get profileId;
  @override
  int get totalCards;
  @override
  int get reviewedCards;
  @override
  int get masteredCards;
  @override
  int get dueCards;
  @override
  double get averageAccuracy;
  @override
  DateTime? get lastStudiedAt;

  /// Create a copy of DeckProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeckProgressImplCopyWith<_$DeckProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
