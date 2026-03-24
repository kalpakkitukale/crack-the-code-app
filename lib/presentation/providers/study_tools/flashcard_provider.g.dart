// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$flashcardDaoHash() => r'0654b5bb9e2ff7ec73d79261954a8029b2f07e2f';

/// Provider for FlashcardDao
///
/// Copied from [flashcardDao].
@ProviderFor(flashcardDao)
final flashcardDaoProvider = AutoDisposeProvider<FlashcardDao>.internal(
  flashcardDao,
  name: r'flashcardDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$flashcardDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FlashcardDaoRef = AutoDisposeProviderRef<FlashcardDao>;
String _$flashcardRepositoryHash() =>
    r'7bb1a3deafc5ea0caf75d46b58c2027cceb3b926';

/// Provider for FlashcardRepository
///
/// Copied from [flashcardRepository].
@ProviderFor(flashcardRepository)
final flashcardRepositoryProvider =
    AutoDisposeProvider<FlashcardRepository>.internal(
      flashcardRepository,
      name: r'flashcardRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$flashcardRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FlashcardRepositoryRef = AutoDisposeProviderRef<FlashcardRepository>;
String _$topicFlashcardsHash() => r'afb16613f2cd60fefdf8f8b0a02214599c724b5f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for flashcard deck by topic ID
///
/// Copied from [topicFlashcards].
@ProviderFor(topicFlashcards)
const topicFlashcardsProvider = TopicFlashcardsFamily();

/// Provider for flashcard deck by topic ID
///
/// Copied from [topicFlashcards].
class TopicFlashcardsFamily extends Family<AsyncValue<FlashcardDeck?>> {
  /// Provider for flashcard deck by topic ID
  ///
  /// Copied from [topicFlashcards].
  const TopicFlashcardsFamily();

  /// Provider for flashcard deck by topic ID
  ///
  /// Copied from [topicFlashcards].
  TopicFlashcardsProvider call(String topicId) {
    return TopicFlashcardsProvider(topicId);
  }

  @override
  TopicFlashcardsProvider getProviderOverride(
    covariant TopicFlashcardsProvider provider,
  ) {
    return call(provider.topicId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'topicFlashcardsProvider';
}

/// Provider for flashcard deck by topic ID
///
/// Copied from [topicFlashcards].
class TopicFlashcardsProvider
    extends AutoDisposeFutureProvider<FlashcardDeck?> {
  /// Provider for flashcard deck by topic ID
  ///
  /// Copied from [topicFlashcards].
  TopicFlashcardsProvider(String topicId)
    : this._internal(
        (ref) => topicFlashcards(ref as TopicFlashcardsRef, topicId),
        from: topicFlashcardsProvider,
        name: r'topicFlashcardsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$topicFlashcardsHash,
        dependencies: TopicFlashcardsFamily._dependencies,
        allTransitiveDependencies:
            TopicFlashcardsFamily._allTransitiveDependencies,
        topicId: topicId,
      );

  TopicFlashcardsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.topicId,
  }) : super.internal();

  final String topicId;

  @override
  Override overrideWith(
    FutureOr<FlashcardDeck?> Function(TopicFlashcardsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TopicFlashcardsProvider._internal(
        (ref) => create(ref as TopicFlashcardsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        topicId: topicId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FlashcardDeck?> createElement() {
    return _TopicFlashcardsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopicFlashcardsProvider && other.topicId == topicId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, topicId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TopicFlashcardsRef on AutoDisposeFutureProviderRef<FlashcardDeck?> {
  /// The parameter `topicId` of this provider.
  String get topicId;
}

class _TopicFlashcardsProviderElement
    extends AutoDisposeFutureProviderElement<FlashcardDeck?>
    with TopicFlashcardsRef {
  _TopicFlashcardsProviderElement(super.provider);

  @override
  String get topicId => (origin as TopicFlashcardsProvider).topicId;
}

String _$flashcardDeckHash() => r'17607c7c1b1b72e5a00c6fa027009a0b0ca07cdf';

/// Provider for flashcard deck by ID
///
/// Copied from [flashcardDeck].
@ProviderFor(flashcardDeck)
const flashcardDeckProvider = FlashcardDeckFamily();

/// Provider for flashcard deck by ID
///
/// Copied from [flashcardDeck].
class FlashcardDeckFamily extends Family<AsyncValue<FlashcardDeck?>> {
  /// Provider for flashcard deck by ID
  ///
  /// Copied from [flashcardDeck].
  const FlashcardDeckFamily();

  /// Provider for flashcard deck by ID
  ///
  /// Copied from [flashcardDeck].
  FlashcardDeckProvider call(String deckId) {
    return FlashcardDeckProvider(deckId);
  }

  @override
  FlashcardDeckProvider getProviderOverride(
    covariant FlashcardDeckProvider provider,
  ) {
    return call(provider.deckId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'flashcardDeckProvider';
}

/// Provider for flashcard deck by ID
///
/// Copied from [flashcardDeck].
class FlashcardDeckProvider extends AutoDisposeFutureProvider<FlashcardDeck?> {
  /// Provider for flashcard deck by ID
  ///
  /// Copied from [flashcardDeck].
  FlashcardDeckProvider(String deckId)
    : this._internal(
        (ref) => flashcardDeck(ref as FlashcardDeckRef, deckId),
        from: flashcardDeckProvider,
        name: r'flashcardDeckProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$flashcardDeckHash,
        dependencies: FlashcardDeckFamily._dependencies,
        allTransitiveDependencies:
            FlashcardDeckFamily._allTransitiveDependencies,
        deckId: deckId,
      );

  FlashcardDeckProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.deckId,
  }) : super.internal();

  final String deckId;

  @override
  Override overrideWith(
    FutureOr<FlashcardDeck?> Function(FlashcardDeckRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FlashcardDeckProvider._internal(
        (ref) => create(ref as FlashcardDeckRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        deckId: deckId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FlashcardDeck?> createElement() {
    return _FlashcardDeckProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FlashcardDeckProvider && other.deckId == deckId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, deckId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FlashcardDeckRef on AutoDisposeFutureProviderRef<FlashcardDeck?> {
  /// The parameter `deckId` of this provider.
  String get deckId;
}

class _FlashcardDeckProviderElement
    extends AutoDisposeFutureProviderElement<FlashcardDeck?>
    with FlashcardDeckRef {
  _FlashcardDeckProviderElement(super.provider);

  @override
  String get deckId => (origin as FlashcardDeckProvider).deckId;
}

String _$chapterFlashcardsHash() => r'b3f50311088fd1d4d9858e60470190a5a5e2ede1';

/// Provider for flashcard decks by chapter ID with subject context
///
/// Copied from [chapterFlashcards].
@ProviderFor(chapterFlashcards)
const chapterFlashcardsProvider = ChapterFlashcardsFamily();

/// Provider for flashcard decks by chapter ID with subject context
///
/// Copied from [chapterFlashcards].
class ChapterFlashcardsFamily extends Family<AsyncValue<List<FlashcardDeck>>> {
  /// Provider for flashcard decks by chapter ID with subject context
  ///
  /// Copied from [chapterFlashcards].
  const ChapterFlashcardsFamily();

  /// Provider for flashcard decks by chapter ID with subject context
  ///
  /// Copied from [chapterFlashcards].
  ChapterFlashcardsProvider call(String chapterId, {String? subjectId}) {
    return ChapterFlashcardsProvider(chapterId, subjectId: subjectId);
  }

  @override
  ChapterFlashcardsProvider getProviderOverride(
    covariant ChapterFlashcardsProvider provider,
  ) {
    return call(provider.chapterId, subjectId: provider.subjectId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chapterFlashcardsProvider';
}

/// Provider for flashcard decks by chapter ID with subject context
///
/// Copied from [chapterFlashcards].
class ChapterFlashcardsProvider
    extends AutoDisposeFutureProvider<List<FlashcardDeck>> {
  /// Provider for flashcard decks by chapter ID with subject context
  ///
  /// Copied from [chapterFlashcards].
  ChapterFlashcardsProvider(String chapterId, {String? subjectId})
    : this._internal(
        (ref) => chapterFlashcards(
          ref as ChapterFlashcardsRef,
          chapterId,
          subjectId: subjectId,
        ),
        from: chapterFlashcardsProvider,
        name: r'chapterFlashcardsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chapterFlashcardsHash,
        dependencies: ChapterFlashcardsFamily._dependencies,
        allTransitiveDependencies:
            ChapterFlashcardsFamily._allTransitiveDependencies,
        chapterId: chapterId,
        subjectId: subjectId,
      );

  ChapterFlashcardsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterId,
    required this.subjectId,
  }) : super.internal();

  final String chapterId;
  final String? subjectId;

  @override
  Override overrideWith(
    FutureOr<List<FlashcardDeck>> Function(ChapterFlashcardsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterFlashcardsProvider._internal(
        (ref) => create(ref as ChapterFlashcardsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapterId: chapterId,
        subjectId: subjectId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<FlashcardDeck>> createElement() {
    return _ChapterFlashcardsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterFlashcardsProvider &&
        other.chapterId == chapterId &&
        other.subjectId == subjectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterFlashcardsRef
    on AutoDisposeFutureProviderRef<List<FlashcardDeck>> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `subjectId` of this provider.
  String? get subjectId;
}

class _ChapterFlashcardsProviderElement
    extends AutoDisposeFutureProviderElement<List<FlashcardDeck>>
    with ChapterFlashcardsRef {
  _ChapterFlashcardsProviderElement(super.provider);

  @override
  String get chapterId => (origin as ChapterFlashcardsProvider).chapterId;
  @override
  String? get subjectId => (origin as ChapterFlashcardsProvider).subjectId;
}

String _$deckProgressHash() => r'3e820422ec94417cd27e6c8601d3da329ae4a4c4';

/// Provider for deck progress
///
/// Copied from [deckProgress].
@ProviderFor(deckProgress)
const deckProgressProvider = DeckProgressFamily();

/// Provider for deck progress
///
/// Copied from [deckProgress].
class DeckProgressFamily extends Family<AsyncValue<DeckProgress>> {
  /// Provider for deck progress
  ///
  /// Copied from [deckProgress].
  const DeckProgressFamily();

  /// Provider for deck progress
  ///
  /// Copied from [deckProgress].
  DeckProgressProvider call(String deckId) {
    return DeckProgressProvider(deckId);
  }

  @override
  DeckProgressProvider getProviderOverride(
    covariant DeckProgressProvider provider,
  ) {
    return call(provider.deckId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deckProgressProvider';
}

/// Provider for deck progress
///
/// Copied from [deckProgress].
class DeckProgressProvider extends AutoDisposeFutureProvider<DeckProgress> {
  /// Provider for deck progress
  ///
  /// Copied from [deckProgress].
  DeckProgressProvider(String deckId)
    : this._internal(
        (ref) => deckProgress(ref as DeckProgressRef, deckId),
        from: deckProgressProvider,
        name: r'deckProgressProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deckProgressHash,
        dependencies: DeckProgressFamily._dependencies,
        allTransitiveDependencies:
            DeckProgressFamily._allTransitiveDependencies,
        deckId: deckId,
      );

  DeckProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.deckId,
  }) : super.internal();

  final String deckId;

  @override
  Override overrideWith(
    FutureOr<DeckProgress> Function(DeckProgressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeckProgressProvider._internal(
        (ref) => create(ref as DeckProgressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        deckId: deckId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DeckProgress> createElement() {
    return _DeckProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeckProgressProvider && other.deckId == deckId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, deckId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeckProgressRef on AutoDisposeFutureProviderRef<DeckProgress> {
  /// The parameter `deckId` of this provider.
  String get deckId;
}

class _DeckProgressProviderElement
    extends AutoDisposeFutureProviderElement<DeckProgress>
    with DeckProgressRef {
  _DeckProgressProviderElement(super.provider);

  @override
  String get deckId => (origin as DeckProgressProvider).deckId;
}

String _$dueCardsHash() => r'faf0b3987fa5ba5de2bb082e668f4091192bb467';

/// Provider for due cards
///
/// Copied from [dueCards].
@ProviderFor(dueCards)
final dueCardsProvider =
    AutoDisposeFutureProvider<List<FlashcardProgress>>.internal(
      dueCards,
      name: r'dueCardsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dueCardsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DueCardsRef = AutoDisposeFutureProviderRef<List<FlashcardProgress>>;
String _$flashcardStudySessionHash() =>
    r'dc072a3585c57b16a836ce619d1f056c6ca9228d';

abstract class _$FlashcardStudySession
    extends BuildlessAutoDisposeNotifier<FlashcardStudyState> {
  late final String deckId;

  FlashcardStudyState build(String deckId);
}

/// Notifier for flashcard study session
///
/// Copied from [FlashcardStudySession].
@ProviderFor(FlashcardStudySession)
const flashcardStudySessionProvider = FlashcardStudySessionFamily();

/// Notifier for flashcard study session
///
/// Copied from [FlashcardStudySession].
class FlashcardStudySessionFamily extends Family<FlashcardStudyState> {
  /// Notifier for flashcard study session
  ///
  /// Copied from [FlashcardStudySession].
  const FlashcardStudySessionFamily();

  /// Notifier for flashcard study session
  ///
  /// Copied from [FlashcardStudySession].
  FlashcardStudySessionProvider call(String deckId) {
    return FlashcardStudySessionProvider(deckId);
  }

  @override
  FlashcardStudySessionProvider getProviderOverride(
    covariant FlashcardStudySessionProvider provider,
  ) {
    return call(provider.deckId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'flashcardStudySessionProvider';
}

/// Notifier for flashcard study session
///
/// Copied from [FlashcardStudySession].
class FlashcardStudySessionProvider
    extends
        AutoDisposeNotifierProviderImpl<
          FlashcardStudySession,
          FlashcardStudyState
        > {
  /// Notifier for flashcard study session
  ///
  /// Copied from [FlashcardStudySession].
  FlashcardStudySessionProvider(String deckId)
    : this._internal(
        () => FlashcardStudySession()..deckId = deckId,
        from: flashcardStudySessionProvider,
        name: r'flashcardStudySessionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$flashcardStudySessionHash,
        dependencies: FlashcardStudySessionFamily._dependencies,
        allTransitiveDependencies:
            FlashcardStudySessionFamily._allTransitiveDependencies,
        deckId: deckId,
      );

  FlashcardStudySessionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.deckId,
  }) : super.internal();

  final String deckId;

  @override
  FlashcardStudyState runNotifierBuild(
    covariant FlashcardStudySession notifier,
  ) {
    return notifier.build(deckId);
  }

  @override
  Override overrideWith(FlashcardStudySession Function() create) {
    return ProviderOverride(
      origin: this,
      override: FlashcardStudySessionProvider._internal(
        () => create()..deckId = deckId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        deckId: deckId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<FlashcardStudySession, FlashcardStudyState>
  createElement() {
    return _FlashcardStudySessionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FlashcardStudySessionProvider && other.deckId == deckId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, deckId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FlashcardStudySessionRef
    on AutoDisposeNotifierProviderRef<FlashcardStudyState> {
  /// The parameter `deckId` of this provider.
  String get deckId;
}

class _FlashcardStudySessionProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          FlashcardStudySession,
          FlashcardStudyState
        >
    with FlashcardStudySessionRef {
  _FlashcardStudySessionProviderElement(super.provider);

  @override
  String get deckId => (origin as FlashcardStudySessionProvider).deckId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
