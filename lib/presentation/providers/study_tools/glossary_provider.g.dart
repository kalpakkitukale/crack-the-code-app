// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$glossaryDaoHash() => r'245cd8ded4933225ce56a04c686d1056a6b3fca8';

/// Provider for GlossaryDao
///
/// Copied from [glossaryDao].
@ProviderFor(glossaryDao)
final glossaryDaoProvider = AutoDisposeProvider<GlossaryDao>.internal(
  glossaryDao,
  name: r'glossaryDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$glossaryDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GlossaryDaoRef = AutoDisposeProviderRef<GlossaryDao>;
String _$glossaryRepositoryHash() =>
    r'b0666e22d0d98f7e73e7bbaaae7f796aa3071d4e';

/// Provider for GlossaryRepository
///
/// Copied from [glossaryRepository].
@ProviderFor(glossaryRepository)
final glossaryRepositoryProvider =
    AutoDisposeProvider<GlossaryRepository>.internal(
      glossaryRepository,
      name: r'glossaryRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$glossaryRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GlossaryRepositoryRef = AutoDisposeProviderRef<GlossaryRepository>;
String _$chapterGlossaryHash() => r'f0b6aa0dafe09de2bd7c8ee83ef76bf7cad70c4d';

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

/// Provider for glossary terms by chapter ID with subject context
///
/// Copied from [chapterGlossary].
@ProviderFor(chapterGlossary)
const chapterGlossaryProvider = ChapterGlossaryFamily();

/// Provider for glossary terms by chapter ID with subject context
///
/// Copied from [chapterGlossary].
class ChapterGlossaryFamily extends Family<AsyncValue<List<GlossaryTerm>>> {
  /// Provider for glossary terms by chapter ID with subject context
  ///
  /// Copied from [chapterGlossary].
  const ChapterGlossaryFamily();

  /// Provider for glossary terms by chapter ID with subject context
  ///
  /// Copied from [chapterGlossary].
  ChapterGlossaryProvider call(String chapterId, {String? subjectId}) {
    return ChapterGlossaryProvider(chapterId, subjectId: subjectId);
  }

  @override
  ChapterGlossaryProvider getProviderOverride(
    covariant ChapterGlossaryProvider provider,
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
  String? get name => r'chapterGlossaryProvider';
}

/// Provider for glossary terms by chapter ID with subject context
///
/// Copied from [chapterGlossary].
class ChapterGlossaryProvider
    extends AutoDisposeFutureProvider<List<GlossaryTerm>> {
  /// Provider for glossary terms by chapter ID with subject context
  ///
  /// Copied from [chapterGlossary].
  ChapterGlossaryProvider(String chapterId, {String? subjectId})
    : this._internal(
        (ref) => chapterGlossary(
          ref as ChapterGlossaryRef,
          chapterId,
          subjectId: subjectId,
        ),
        from: chapterGlossaryProvider,
        name: r'chapterGlossaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chapterGlossaryHash,
        dependencies: ChapterGlossaryFamily._dependencies,
        allTransitiveDependencies:
            ChapterGlossaryFamily._allTransitiveDependencies,
        chapterId: chapterId,
        subjectId: subjectId,
      );

  ChapterGlossaryProvider._internal(
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
    FutureOr<List<GlossaryTerm>> Function(ChapterGlossaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterGlossaryProvider._internal(
        (ref) => create(ref as ChapterGlossaryRef),
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
  AutoDisposeFutureProviderElement<List<GlossaryTerm>> createElement() {
    return _ChapterGlossaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterGlossaryProvider &&
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
mixin ChapterGlossaryRef on AutoDisposeFutureProviderRef<List<GlossaryTerm>> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `subjectId` of this provider.
  String? get subjectId;
}

class _ChapterGlossaryProviderElement
    extends AutoDisposeFutureProviderElement<List<GlossaryTerm>>
    with ChapterGlossaryRef {
  _ChapterGlossaryProviderElement(super.provider);

  @override
  String get chapterId => (origin as ChapterGlossaryProvider).chapterId;
  @override
  String? get subjectId => (origin as ChapterGlossaryProvider).subjectId;
}

String _$searchGlossaryHash() => r'9ee1c5f1a153ecf38fc48eaae962d28c883c58af';

/// Provider for searching glossary terms
///
/// Copied from [searchGlossary].
@ProviderFor(searchGlossary)
const searchGlossaryProvider = SearchGlossaryFamily();

/// Provider for searching glossary terms
///
/// Copied from [searchGlossary].
class SearchGlossaryFamily extends Family<AsyncValue<List<GlossaryTerm>>> {
  /// Provider for searching glossary terms
  ///
  /// Copied from [searchGlossary].
  const SearchGlossaryFamily();

  /// Provider for searching glossary terms
  ///
  /// Copied from [searchGlossary].
  SearchGlossaryProvider call(
    String chapterId,
    String query, {
    String? subjectId,
  }) {
    return SearchGlossaryProvider(chapterId, query, subjectId: subjectId);
  }

  @override
  SearchGlossaryProvider getProviderOverride(
    covariant SearchGlossaryProvider provider,
  ) {
    return call(
      provider.chapterId,
      provider.query,
      subjectId: provider.subjectId,
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
  String? get name => r'searchGlossaryProvider';
}

/// Provider for searching glossary terms
///
/// Copied from [searchGlossary].
class SearchGlossaryProvider
    extends AutoDisposeFutureProvider<List<GlossaryTerm>> {
  /// Provider for searching glossary terms
  ///
  /// Copied from [searchGlossary].
  SearchGlossaryProvider(String chapterId, String query, {String? subjectId})
    : this._internal(
        (ref) => searchGlossary(
          ref as SearchGlossaryRef,
          chapterId,
          query,
          subjectId: subjectId,
        ),
        from: searchGlossaryProvider,
        name: r'searchGlossaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchGlossaryHash,
        dependencies: SearchGlossaryFamily._dependencies,
        allTransitiveDependencies:
            SearchGlossaryFamily._allTransitiveDependencies,
        chapterId: chapterId,
        query: query,
        subjectId: subjectId,
      );

  SearchGlossaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterId,
    required this.query,
    required this.subjectId,
  }) : super.internal();

  final String chapterId;
  final String query;
  final String? subjectId;

  @override
  Override overrideWith(
    FutureOr<List<GlossaryTerm>> Function(SearchGlossaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchGlossaryProvider._internal(
        (ref) => create(ref as SearchGlossaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapterId: chapterId,
        query: query,
        subjectId: subjectId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<GlossaryTerm>> createElement() {
    return _SearchGlossaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchGlossaryProvider &&
        other.chapterId == chapterId &&
        other.query == query &&
        other.subjectId == subjectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchGlossaryRef on AutoDisposeFutureProviderRef<List<GlossaryTerm>> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `subjectId` of this provider.
  String? get subjectId;
}

class _SearchGlossaryProviderElement
    extends AutoDisposeFutureProviderElement<List<GlossaryTerm>>
    with SearchGlossaryRef {
  _SearchGlossaryProviderElement(super.provider);

  @override
  String get chapterId => (origin as SearchGlossaryProvider).chapterId;
  @override
  String get query => (origin as SearchGlossaryProvider).query;
  @override
  String? get subjectId => (origin as SearchGlossaryProvider).subjectId;
}

String _$glossaryTermHash() => r'1d8378de1d9e3ac8f93442126572c244ecc34a59';

/// Provider for a single glossary term by ID
///
/// Copied from [glossaryTerm].
@ProviderFor(glossaryTerm)
const glossaryTermProvider = GlossaryTermFamily();

/// Provider for a single glossary term by ID
///
/// Copied from [glossaryTerm].
class GlossaryTermFamily extends Family<AsyncValue<GlossaryTerm?>> {
  /// Provider for a single glossary term by ID
  ///
  /// Copied from [glossaryTerm].
  const GlossaryTermFamily();

  /// Provider for a single glossary term by ID
  ///
  /// Copied from [glossaryTerm].
  GlossaryTermProvider call(String termId) {
    return GlossaryTermProvider(termId);
  }

  @override
  GlossaryTermProvider getProviderOverride(
    covariant GlossaryTermProvider provider,
  ) {
    return call(provider.termId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'glossaryTermProvider';
}

/// Provider for a single glossary term by ID
///
/// Copied from [glossaryTerm].
class GlossaryTermProvider extends AutoDisposeFutureProvider<GlossaryTerm?> {
  /// Provider for a single glossary term by ID
  ///
  /// Copied from [glossaryTerm].
  GlossaryTermProvider(String termId)
    : this._internal(
        (ref) => glossaryTerm(ref as GlossaryTermRef, termId),
        from: glossaryTermProvider,
        name: r'glossaryTermProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$glossaryTermHash,
        dependencies: GlossaryTermFamily._dependencies,
        allTransitiveDependencies:
            GlossaryTermFamily._allTransitiveDependencies,
        termId: termId,
      );

  GlossaryTermProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.termId,
  }) : super.internal();

  final String termId;

  @override
  Override overrideWith(
    FutureOr<GlossaryTerm?> Function(GlossaryTermRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GlossaryTermProvider._internal(
        (ref) => create(ref as GlossaryTermRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        termId: termId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<GlossaryTerm?> createElement() {
    return _GlossaryTermProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GlossaryTermProvider && other.termId == termId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, termId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GlossaryTermRef on AutoDisposeFutureProviderRef<GlossaryTerm?> {
  /// The parameter `termId` of this provider.
  String get termId;
}

class _GlossaryTermProviderElement
    extends AutoDisposeFutureProviderElement<GlossaryTerm?>
    with GlossaryTermRef {
  _GlossaryTermProviderElement(super.provider);

  @override
  String get termId => (origin as GlossaryTermProvider).termId;
}

String _$glossaryNotifierHash() => r'b5ba34a79d514678564178c67322cf651c5e702e';

abstract class _$GlossaryNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<GlossaryTerm>> {
  late final String chapterId;

  FutureOr<List<GlossaryTerm>> build(String chapterId);
}

/// Notifier for managing glossary state with search functionality
///
/// Copied from [GlossaryNotifier].
@ProviderFor(GlossaryNotifier)
const glossaryNotifierProvider = GlossaryNotifierFamily();

/// Notifier for managing glossary state with search functionality
///
/// Copied from [GlossaryNotifier].
class GlossaryNotifierFamily extends Family<AsyncValue<List<GlossaryTerm>>> {
  /// Notifier for managing glossary state with search functionality
  ///
  /// Copied from [GlossaryNotifier].
  const GlossaryNotifierFamily();

  /// Notifier for managing glossary state with search functionality
  ///
  /// Copied from [GlossaryNotifier].
  GlossaryNotifierProvider call(String chapterId) {
    return GlossaryNotifierProvider(chapterId);
  }

  @override
  GlossaryNotifierProvider getProviderOverride(
    covariant GlossaryNotifierProvider provider,
  ) {
    return call(provider.chapterId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'glossaryNotifierProvider';
}

/// Notifier for managing glossary state with search functionality
///
/// Copied from [GlossaryNotifier].
class GlossaryNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          GlossaryNotifier,
          List<GlossaryTerm>
        > {
  /// Notifier for managing glossary state with search functionality
  ///
  /// Copied from [GlossaryNotifier].
  GlossaryNotifierProvider(String chapterId)
    : this._internal(
        () => GlossaryNotifier()..chapterId = chapterId,
        from: glossaryNotifierProvider,
        name: r'glossaryNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$glossaryNotifierHash,
        dependencies: GlossaryNotifierFamily._dependencies,
        allTransitiveDependencies:
            GlossaryNotifierFamily._allTransitiveDependencies,
        chapterId: chapterId,
      );

  GlossaryNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterId,
  }) : super.internal();

  final String chapterId;

  @override
  FutureOr<List<GlossaryTerm>> runNotifierBuild(
    covariant GlossaryNotifier notifier,
  ) {
    return notifier.build(chapterId);
  }

  @override
  Override overrideWith(GlossaryNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: GlossaryNotifierProvider._internal(
        () => create()..chapterId = chapterId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapterId: chapterId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GlossaryNotifier, List<GlossaryTerm>>
  createElement() {
    return _GlossaryNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GlossaryNotifierProvider && other.chapterId == chapterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GlossaryNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<GlossaryTerm>> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;
}

class _GlossaryNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          GlossaryNotifier,
          List<GlossaryTerm>
        >
    with GlossaryNotifierRef {
  _GlossaryNotifierProviderElement(super.provider);

  @override
  String get chapterId => (origin as GlossaryNotifierProvider).chapterId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
