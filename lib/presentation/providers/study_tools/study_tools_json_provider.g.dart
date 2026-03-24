// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_tools_json_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$studyToolsJsonDataSourceHash() =>
    r'a112507c8df0f3d23d4cdaee9c2221e29f1b43cc';

/// Provider for StudyToolsJsonDataSource (singleton)
///
/// Copied from [studyToolsJsonDataSource].
@ProviderFor(studyToolsJsonDataSource)
final studyToolsJsonDataSourceProvider =
    Provider<StudyToolsJsonDataSource>.internal(
      studyToolsJsonDataSource,
      name: r'studyToolsJsonDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$studyToolsJsonDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StudyToolsJsonDataSourceRef = ProviderRef<StudyToolsJsonDataSource>;
String _$preloadChapterStudyToolsHash() =>
    r'3dbeaa040d9b1f6a6e7236738c9288f99481b69a';

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

/// Provider to preload all study tools for a chapter
///
/// Copied from [preloadChapterStudyTools].
@ProviderFor(preloadChapterStudyTools)
const preloadChapterStudyToolsProvider = PreloadChapterStudyToolsFamily();

/// Provider to preload all study tools for a chapter
///
/// Copied from [preloadChapterStudyTools].
class PreloadChapterStudyToolsFamily extends Family<AsyncValue<void>> {
  /// Provider to preload all study tools for a chapter
  ///
  /// Copied from [preloadChapterStudyTools].
  const PreloadChapterStudyToolsFamily();

  /// Provider to preload all study tools for a chapter
  ///
  /// Copied from [preloadChapterStudyTools].
  PreloadChapterStudyToolsProvider call(String subjectId, String chapterId) {
    return PreloadChapterStudyToolsProvider(subjectId, chapterId);
  }

  @override
  PreloadChapterStudyToolsProvider getProviderOverride(
    covariant PreloadChapterStudyToolsProvider provider,
  ) {
    return call(provider.subjectId, provider.chapterId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'preloadChapterStudyToolsProvider';
}

/// Provider to preload all study tools for a chapter
///
/// Copied from [preloadChapterStudyTools].
class PreloadChapterStudyToolsProvider extends AutoDisposeFutureProvider<void> {
  /// Provider to preload all study tools for a chapter
  ///
  /// Copied from [preloadChapterStudyTools].
  PreloadChapterStudyToolsProvider(String subjectId, String chapterId)
    : this._internal(
        (ref) => preloadChapterStudyTools(
          ref as PreloadChapterStudyToolsRef,
          subjectId,
          chapterId,
        ),
        from: preloadChapterStudyToolsProvider,
        name: r'preloadChapterStudyToolsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$preloadChapterStudyToolsHash,
        dependencies: PreloadChapterStudyToolsFamily._dependencies,
        allTransitiveDependencies:
            PreloadChapterStudyToolsFamily._allTransitiveDependencies,
        subjectId: subjectId,
        chapterId: chapterId,
      );

  PreloadChapterStudyToolsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subjectId,
    required this.chapterId,
  }) : super.internal();

  final String subjectId;
  final String chapterId;

  @override
  Override overrideWith(
    FutureOr<void> Function(PreloadChapterStudyToolsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PreloadChapterStudyToolsProvider._internal(
        (ref) => create(ref as PreloadChapterStudyToolsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subjectId: subjectId,
        chapterId: chapterId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _PreloadChapterStudyToolsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PreloadChapterStudyToolsProvider &&
        other.subjectId == subjectId &&
        other.chapterId == chapterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PreloadChapterStudyToolsRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `subjectId` of this provider.
  String get subjectId;

  /// The parameter `chapterId` of this provider.
  String get chapterId;
}

class _PreloadChapterStudyToolsProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with PreloadChapterStudyToolsRef {
  _PreloadChapterStudyToolsProviderElement(super.provider);

  @override
  String get subjectId =>
      (origin as PreloadChapterStudyToolsProvider).subjectId;
  @override
  String get chapterId =>
      (origin as PreloadChapterStudyToolsProvider).chapterId;
}

String _$studyToolsCacheStatsHash() =>
    r'cb8b733eff639416a3d444f01194b83422d420f1';

/// Provider to get cache statistics
///
/// Copied from [studyToolsCacheStats].
@ProviderFor(studyToolsCacheStats)
final studyToolsCacheStatsProvider =
    AutoDisposeProvider<Map<String, int>>.internal(
      studyToolsCacheStats,
      name: r'studyToolsCacheStatsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$studyToolsCacheStatsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StudyToolsCacheStatsRef = AutoDisposeProviderRef<Map<String, int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
