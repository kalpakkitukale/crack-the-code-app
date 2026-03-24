// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chapterSummaryDaoHash() => r'a6ebbfecf6ae531779262761ac3f7d8840dd4580';

/// Provider for ChapterSummaryDao
///
/// Copied from [chapterSummaryDao].
@ProviderFor(chapterSummaryDao)
final chapterSummaryDaoProvider =
    AutoDisposeProvider<ChapterSummaryDao>.internal(
      chapterSummaryDao,
      name: r'chapterSummaryDaoProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chapterSummaryDaoHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChapterSummaryDaoRef = AutoDisposeProviderRef<ChapterSummaryDao>;
String _$chapterSummaryRepositoryHash() =>
    r'b9191829e396d805cb45ab491ec1ffe58ddf1173';

/// Provider for ChapterSummaryRepository
///
/// Copied from [chapterSummaryRepository].
@ProviderFor(chapterSummaryRepository)
final chapterSummaryRepositoryProvider =
    AutoDisposeProvider<ChapterSummaryRepository>.internal(
      chapterSummaryRepository,
      name: r'chapterSummaryRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chapterSummaryRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChapterSummaryRepositoryRef =
    AutoDisposeProviderRef<ChapterSummaryRepository>;
String _$chapterSummaryHash() => r'0010ec43a67db37e2ad9cbb96ffb026380969941';

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

/// Provider for chapter summary by chapter ID and subject ID
///
/// Copied from [chapterSummary].
@ProviderFor(chapterSummary)
const chapterSummaryProvider = ChapterSummaryFamily();

/// Provider for chapter summary by chapter ID and subject ID
///
/// Copied from [chapterSummary].
class ChapterSummaryFamily extends Family<AsyncValue<ChapterSummary?>> {
  /// Provider for chapter summary by chapter ID and subject ID
  ///
  /// Copied from [chapterSummary].
  const ChapterSummaryFamily();

  /// Provider for chapter summary by chapter ID and subject ID
  ///
  /// Copied from [chapterSummary].
  ChapterSummaryProvider call(String chapterId, String subjectId) {
    return ChapterSummaryProvider(chapterId, subjectId);
  }

  @override
  ChapterSummaryProvider getProviderOverride(
    covariant ChapterSummaryProvider provider,
  ) {
    return call(provider.chapterId, provider.subjectId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chapterSummaryProvider';
}

/// Provider for chapter summary by chapter ID and subject ID
///
/// Copied from [chapterSummary].
class ChapterSummaryProvider
    extends AutoDisposeFutureProvider<ChapterSummary?> {
  /// Provider for chapter summary by chapter ID and subject ID
  ///
  /// Copied from [chapterSummary].
  ChapterSummaryProvider(String chapterId, String subjectId)
    : this._internal(
        (ref) => chapterSummary(ref as ChapterSummaryRef, chapterId, subjectId),
        from: chapterSummaryProvider,
        name: r'chapterSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chapterSummaryHash,
        dependencies: ChapterSummaryFamily._dependencies,
        allTransitiveDependencies:
            ChapterSummaryFamily._allTransitiveDependencies,
        chapterId: chapterId,
        subjectId: subjectId,
      );

  ChapterSummaryProvider._internal(
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
  final String subjectId;

  @override
  Override overrideWith(
    FutureOr<ChapterSummary?> Function(ChapterSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterSummaryProvider._internal(
        (ref) => create(ref as ChapterSummaryRef),
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
  AutoDisposeFutureProviderElement<ChapterSummary?> createElement() {
    return _ChapterSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterSummaryProvider &&
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
mixin ChapterSummaryRef on AutoDisposeFutureProviderRef<ChapterSummary?> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `subjectId` of this provider.
  String get subjectId;
}

class _ChapterSummaryProviderElement
    extends AutoDisposeFutureProviderElement<ChapterSummary?>
    with ChapterSummaryRef {
  _ChapterSummaryProviderElement(super.provider);

  @override
  String get chapterId => (origin as ChapterSummaryProvider).chapterId;
  @override
  String get subjectId => (origin as ChapterSummaryProvider).subjectId;
}

String _$hasChapterSummaryHash() => r'26da473d403acb21e88dd8c8efb454daa76cfaa0';

/// Provider to check if a chapter has a summary
///
/// Copied from [hasChapterSummary].
@ProviderFor(hasChapterSummary)
const hasChapterSummaryProvider = HasChapterSummaryFamily();

/// Provider to check if a chapter has a summary
///
/// Copied from [hasChapterSummary].
class HasChapterSummaryFamily extends Family<AsyncValue<bool>> {
  /// Provider to check if a chapter has a summary
  ///
  /// Copied from [hasChapterSummary].
  const HasChapterSummaryFamily();

  /// Provider to check if a chapter has a summary
  ///
  /// Copied from [hasChapterSummary].
  HasChapterSummaryProvider call(String chapterId, String subjectId) {
    return HasChapterSummaryProvider(chapterId, subjectId);
  }

  @override
  HasChapterSummaryProvider getProviderOverride(
    covariant HasChapterSummaryProvider provider,
  ) {
    return call(provider.chapterId, provider.subjectId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hasChapterSummaryProvider';
}

/// Provider to check if a chapter has a summary
///
/// Copied from [hasChapterSummary].
class HasChapterSummaryProvider extends AutoDisposeFutureProvider<bool> {
  /// Provider to check if a chapter has a summary
  ///
  /// Copied from [hasChapterSummary].
  HasChapterSummaryProvider(String chapterId, String subjectId)
    : this._internal(
        (ref) => hasChapterSummary(
          ref as HasChapterSummaryRef,
          chapterId,
          subjectId,
        ),
        from: hasChapterSummaryProvider,
        name: r'hasChapterSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$hasChapterSummaryHash,
        dependencies: HasChapterSummaryFamily._dependencies,
        allTransitiveDependencies:
            HasChapterSummaryFamily._allTransitiveDependencies,
        chapterId: chapterId,
        subjectId: subjectId,
      );

  HasChapterSummaryProvider._internal(
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
  final String subjectId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(HasChapterSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasChapterSummaryProvider._internal(
        (ref) => create(ref as HasChapterSummaryRef),
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
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _HasChapterSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasChapterSummaryProvider &&
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
mixin HasChapterSummaryRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `subjectId` of this provider.
  String get subjectId;
}

class _HasChapterSummaryProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with HasChapterSummaryRef {
  _HasChapterSummaryProviderElement(super.provider);

  @override
  String get chapterId => (origin as HasChapterSummaryProvider).chapterId;
  @override
  String get subjectId => (origin as HasChapterSummaryProvider).subjectId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
