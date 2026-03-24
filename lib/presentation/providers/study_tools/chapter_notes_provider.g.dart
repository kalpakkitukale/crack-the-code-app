// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_notes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chapterNotesDaoHash() => r'a4b06648b899ad76948956c02e63158b7b4dfc56';

/// Provider for ChapterNotesDao
///
/// Copied from [chapterNotesDao].
@ProviderFor(chapterNotesDao)
final chapterNotesDaoProvider = AutoDisposeProvider<ChapterNotesDao>.internal(
  chapterNotesDao,
  name: r'chapterNotesDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chapterNotesDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChapterNotesDaoRef = AutoDisposeProviderRef<ChapterNotesDao>;
String _$chapterNotesRepositoryHash() =>
    r'2208e5840905a89b6aa2c63c620ec07e9a5f6958';

/// Provider for ChapterNotesRepository
///
/// Copied from [chapterNotesRepository].
@ProviderFor(chapterNotesRepository)
final chapterNotesRepositoryProvider =
    AutoDisposeProvider<ChapterNotesRepository>.internal(
      chapterNotesRepository,
      name: r'chapterNotesRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chapterNotesRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChapterNotesRepositoryRef =
    AutoDisposeProviderRef<ChapterNotesRepository>;
String _$chapterNotesHash() => r'7fdb780f7985f2690ea0a987e01f5441c186cbab';

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

/// Provider for all chapter notes (curated + personal)
///
/// Copied from [chapterNotes].
@ProviderFor(chapterNotes)
const chapterNotesProvider = ChapterNotesFamily();

/// Provider for all chapter notes (curated + personal)
///
/// Copied from [chapterNotes].
class ChapterNotesFamily extends Family<AsyncValue<ChapterNotesData>> {
  /// Provider for all chapter notes (curated + personal)
  ///
  /// Copied from [chapterNotes].
  const ChapterNotesFamily();

  /// Provider for all chapter notes (curated + personal)
  ///
  /// Copied from [chapterNotes].
  ChapterNotesProvider call(
    String chapterId,
    String subjectId,
    String profileId,
  ) {
    return ChapterNotesProvider(chapterId, subjectId, profileId);
  }

  @override
  ChapterNotesProvider getProviderOverride(
    covariant ChapterNotesProvider provider,
  ) {
    return call(provider.chapterId, provider.subjectId, provider.profileId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chapterNotesProvider';
}

/// Provider for all chapter notes (curated + personal)
///
/// Copied from [chapterNotes].
class ChapterNotesProvider extends AutoDisposeFutureProvider<ChapterNotesData> {
  /// Provider for all chapter notes (curated + personal)
  ///
  /// Copied from [chapterNotes].
  ChapterNotesProvider(String chapterId, String subjectId, String profileId)
    : this._internal(
        (ref) => chapterNotes(
          ref as ChapterNotesRef,
          chapterId,
          subjectId,
          profileId,
        ),
        from: chapterNotesProvider,
        name: r'chapterNotesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chapterNotesHash,
        dependencies: ChapterNotesFamily._dependencies,
        allTransitiveDependencies:
            ChapterNotesFamily._allTransitiveDependencies,
        chapterId: chapterId,
        subjectId: subjectId,
        profileId: profileId,
      );

  ChapterNotesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterId,
    required this.subjectId,
    required this.profileId,
  }) : super.internal();

  final String chapterId;
  final String subjectId;
  final String profileId;

  @override
  Override overrideWith(
    FutureOr<ChapterNotesData> Function(ChapterNotesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterNotesProvider._internal(
        (ref) => create(ref as ChapterNotesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapterId: chapterId,
        subjectId: subjectId,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ChapterNotesData> createElement() {
    return _ChapterNotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterNotesProvider &&
        other.chapterId == chapterId &&
        other.subjectId == subjectId &&
        other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterNotesRef on AutoDisposeFutureProviderRef<ChapterNotesData> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `subjectId` of this provider.
  String get subjectId;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _ChapterNotesProviderElement
    extends AutoDisposeFutureProviderElement<ChapterNotesData>
    with ChapterNotesRef {
  _ChapterNotesProviderElement(super.provider);

  @override
  String get chapterId => (origin as ChapterNotesProvider).chapterId;
  @override
  String get subjectId => (origin as ChapterNotesProvider).subjectId;
  @override
  String get profileId => (origin as ChapterNotesProvider).profileId;
}

String _$chapterNotesCountHash() => r'cdb83deb21b0e4eca75f263b4af78a7db1935af7';

/// Provider for notes count
///
/// Copied from [chapterNotesCount].
@ProviderFor(chapterNotesCount)
const chapterNotesCountProvider = ChapterNotesCountFamily();

/// Provider for notes count
///
/// Copied from [chapterNotesCount].
class ChapterNotesCountFamily
    extends Family<AsyncValue<({int curated, int personal})>> {
  /// Provider for notes count
  ///
  /// Copied from [chapterNotesCount].
  const ChapterNotesCountFamily();

  /// Provider for notes count
  ///
  /// Copied from [chapterNotesCount].
  ChapterNotesCountProvider call(
    String chapterId,
    String subjectId,
    String profileId,
  ) {
    return ChapterNotesCountProvider(chapterId, subjectId, profileId);
  }

  @override
  ChapterNotesCountProvider getProviderOverride(
    covariant ChapterNotesCountProvider provider,
  ) {
    return call(provider.chapterId, provider.subjectId, provider.profileId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chapterNotesCountProvider';
}

/// Provider for notes count
///
/// Copied from [chapterNotesCount].
class ChapterNotesCountProvider
    extends AutoDisposeFutureProvider<({int curated, int personal})> {
  /// Provider for notes count
  ///
  /// Copied from [chapterNotesCount].
  ChapterNotesCountProvider(
    String chapterId,
    String subjectId,
    String profileId,
  ) : this._internal(
        (ref) => chapterNotesCount(
          ref as ChapterNotesCountRef,
          chapterId,
          subjectId,
          profileId,
        ),
        from: chapterNotesCountProvider,
        name: r'chapterNotesCountProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chapterNotesCountHash,
        dependencies: ChapterNotesCountFamily._dependencies,
        allTransitiveDependencies:
            ChapterNotesCountFamily._allTransitiveDependencies,
        chapterId: chapterId,
        subjectId: subjectId,
        profileId: profileId,
      );

  ChapterNotesCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterId,
    required this.subjectId,
    required this.profileId,
  }) : super.internal();

  final String chapterId;
  final String subjectId;
  final String profileId;

  @override
  Override overrideWith(
    FutureOr<({int curated, int personal})> Function(
      ChapterNotesCountRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterNotesCountProvider._internal(
        (ref) => create(ref as ChapterNotesCountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapterId: chapterId,
        subjectId: subjectId,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<({int curated, int personal})>
  createElement() {
    return _ChapterNotesCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterNotesCountProvider &&
        other.chapterId == chapterId &&
        other.subjectId == subjectId &&
        other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterNotesCountRef
    on AutoDisposeFutureProviderRef<({int curated, int personal})> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `subjectId` of this provider.
  String get subjectId;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _ChapterNotesCountProviderElement
    extends AutoDisposeFutureProviderElement<({int curated, int personal})>
    with ChapterNotesCountRef {
  _ChapterNotesCountProviderElement(super.provider);

  @override
  String get chapterId => (origin as ChapterNotesCountProvider).chapterId;
  @override
  String get subjectId => (origin as ChapterNotesCountProvider).subjectId;
  @override
  String get profileId => (origin as ChapterNotesCountProvider).profileId;
}

String _$searchChapterNotesHash() =>
    r'8d164046e2f41e8a46369b1b39b51ee896570df0';

/// Provider for searching notes
///
/// Copied from [searchChapterNotes].
@ProviderFor(searchChapterNotes)
const searchChapterNotesProvider = SearchChapterNotesFamily();

/// Provider for searching notes
///
/// Copied from [searchChapterNotes].
class SearchChapterNotesFamily extends Family<AsyncValue<List<ChapterNote>>> {
  /// Provider for searching notes
  ///
  /// Copied from [searchChapterNotes].
  const SearchChapterNotesFamily();

  /// Provider for searching notes
  ///
  /// Copied from [searchChapterNotes].
  SearchChapterNotesProvider call(
    String chapterId,
    String subjectId,
    String profileId,
    String query,
  ) {
    return SearchChapterNotesProvider(chapterId, subjectId, profileId, query);
  }

  @override
  SearchChapterNotesProvider getProviderOverride(
    covariant SearchChapterNotesProvider provider,
  ) {
    return call(
      provider.chapterId,
      provider.subjectId,
      provider.profileId,
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchChapterNotesProvider';
}

/// Provider for searching notes
///
/// Copied from [searchChapterNotes].
class SearchChapterNotesProvider
    extends AutoDisposeFutureProvider<List<ChapterNote>> {
  /// Provider for searching notes
  ///
  /// Copied from [searchChapterNotes].
  SearchChapterNotesProvider(
    String chapterId,
    String subjectId,
    String profileId,
    String query,
  ) : this._internal(
        (ref) => searchChapterNotes(
          ref as SearchChapterNotesRef,
          chapterId,
          subjectId,
          profileId,
          query,
        ),
        from: searchChapterNotesProvider,
        name: r'searchChapterNotesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchChapterNotesHash,
        dependencies: SearchChapterNotesFamily._dependencies,
        allTransitiveDependencies:
            SearchChapterNotesFamily._allTransitiveDependencies,
        chapterId: chapterId,
        subjectId: subjectId,
        profileId: profileId,
        query: query,
      );

  SearchChapterNotesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterId,
    required this.subjectId,
    required this.profileId,
    required this.query,
  }) : super.internal();

  final String chapterId;
  final String subjectId;
  final String profileId;
  final String query;

  @override
  Override overrideWith(
    FutureOr<List<ChapterNote>> Function(SearchChapterNotesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchChapterNotesProvider._internal(
        (ref) => create(ref as SearchChapterNotesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapterId: chapterId,
        subjectId: subjectId,
        profileId: profileId,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ChapterNote>> createElement() {
    return _SearchChapterNotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchChapterNotesProvider &&
        other.chapterId == chapterId &&
        other.subjectId == subjectId &&
        other.profileId == profileId &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchChapterNotesRef on AutoDisposeFutureProviderRef<List<ChapterNote>> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `subjectId` of this provider.
  String get subjectId;

  /// The parameter `profileId` of this provider.
  String get profileId;

  /// The parameter `query` of this provider.
  String get query;
}

class _SearchChapterNotesProviderElement
    extends AutoDisposeFutureProviderElement<List<ChapterNote>>
    with SearchChapterNotesRef {
  _SearchChapterNotesProviderElement(super.provider);

  @override
  String get chapterId => (origin as SearchChapterNotesProvider).chapterId;
  @override
  String get subjectId => (origin as SearchChapterNotesProvider).subjectId;
  @override
  String get profileId => (origin as SearchChapterNotesProvider).profileId;
  @override
  String get query => (origin as SearchChapterNotesProvider).query;
}

String _$personalNotesNotifierHash() =>
    r'7b78354d1609069c85db8645c488b8049637d575';

abstract class _$PersonalNotesNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<ChapterNote>> {
  late final String chapterId;
  late final String profileId;

  FutureOr<List<ChapterNote>> build(String chapterId, String profileId);
}

/// Notifier for managing personal notes (CRUD operations)
///
/// Copied from [PersonalNotesNotifier].
@ProviderFor(PersonalNotesNotifier)
const personalNotesNotifierProvider = PersonalNotesNotifierFamily();

/// Notifier for managing personal notes (CRUD operations)
///
/// Copied from [PersonalNotesNotifier].
class PersonalNotesNotifierFamily
    extends Family<AsyncValue<List<ChapterNote>>> {
  /// Notifier for managing personal notes (CRUD operations)
  ///
  /// Copied from [PersonalNotesNotifier].
  const PersonalNotesNotifierFamily();

  /// Notifier for managing personal notes (CRUD operations)
  ///
  /// Copied from [PersonalNotesNotifier].
  PersonalNotesNotifierProvider call(String chapterId, String profileId) {
    return PersonalNotesNotifierProvider(chapterId, profileId);
  }

  @override
  PersonalNotesNotifierProvider getProviderOverride(
    covariant PersonalNotesNotifierProvider provider,
  ) {
    return call(provider.chapterId, provider.profileId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'personalNotesNotifierProvider';
}

/// Notifier for managing personal notes (CRUD operations)
///
/// Copied from [PersonalNotesNotifier].
class PersonalNotesNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          PersonalNotesNotifier,
          List<ChapterNote>
        > {
  /// Notifier for managing personal notes (CRUD operations)
  ///
  /// Copied from [PersonalNotesNotifier].
  PersonalNotesNotifierProvider(String chapterId, String profileId)
    : this._internal(
        () => PersonalNotesNotifier()
          ..chapterId = chapterId
          ..profileId = profileId,
        from: personalNotesNotifierProvider,
        name: r'personalNotesNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$personalNotesNotifierHash,
        dependencies: PersonalNotesNotifierFamily._dependencies,
        allTransitiveDependencies:
            PersonalNotesNotifierFamily._allTransitiveDependencies,
        chapterId: chapterId,
        profileId: profileId,
      );

  PersonalNotesNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterId,
    required this.profileId,
  }) : super.internal();

  final String chapterId;
  final String profileId;

  @override
  FutureOr<List<ChapterNote>> runNotifierBuild(
    covariant PersonalNotesNotifier notifier,
  ) {
    return notifier.build(chapterId, profileId);
  }

  @override
  Override overrideWith(PersonalNotesNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PersonalNotesNotifierProvider._internal(
        () => create()
          ..chapterId = chapterId
          ..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapterId: chapterId,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    PersonalNotesNotifier,
    List<ChapterNote>
  >
  createElement() {
    return _PersonalNotesNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonalNotesNotifierProvider &&
        other.chapterId == chapterId &&
        other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PersonalNotesNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<ChapterNote>> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _PersonalNotesNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PersonalNotesNotifier,
          List<ChapterNote>
        >
    with PersonalNotesNotifierRef {
  _PersonalNotesNotifierProviderElement(super.provider);

  @override
  String get chapterId => (origin as PersonalNotesNotifierProvider).chapterId;
  @override
  String get profileId => (origin as PersonalNotesNotifierProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
