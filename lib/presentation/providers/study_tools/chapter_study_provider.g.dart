// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_study_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chapterHasStudyToolsHash() =>
    r'3d74f3db553c8e701035fd28fafad065065a5d92';

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

/// Provider for checking if a chapter has study tools available
///
/// Copied from [chapterHasStudyTools].
@ProviderFor(chapterHasStudyTools)
const chapterHasStudyToolsProvider = ChapterHasStudyToolsFamily();

/// Provider for checking if a chapter has study tools available
///
/// Copied from [chapterHasStudyTools].
class ChapterHasStudyToolsFamily extends Family<AsyncValue<bool>> {
  /// Provider for checking if a chapter has study tools available
  ///
  /// Copied from [chapterHasStudyTools].
  const ChapterHasStudyToolsFamily();

  /// Provider for checking if a chapter has study tools available
  ///
  /// Copied from [chapterHasStudyTools].
  ChapterHasStudyToolsProvider call(String chapterId, String subjectId) {
    return ChapterHasStudyToolsProvider(chapterId, subjectId);
  }

  @override
  ChapterHasStudyToolsProvider getProviderOverride(
    covariant ChapterHasStudyToolsProvider provider,
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
  String? get name => r'chapterHasStudyToolsProvider';
}

/// Provider for checking if a chapter has study tools available
///
/// Copied from [chapterHasStudyTools].
class ChapterHasStudyToolsProvider extends AutoDisposeFutureProvider<bool> {
  /// Provider for checking if a chapter has study tools available
  ///
  /// Copied from [chapterHasStudyTools].
  ChapterHasStudyToolsProvider(String chapterId, String subjectId)
    : this._internal(
        (ref) => chapterHasStudyTools(
          ref as ChapterHasStudyToolsRef,
          chapterId,
          subjectId,
        ),
        from: chapterHasStudyToolsProvider,
        name: r'chapterHasStudyToolsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chapterHasStudyToolsHash,
        dependencies: ChapterHasStudyToolsFamily._dependencies,
        allTransitiveDependencies:
            ChapterHasStudyToolsFamily._allTransitiveDependencies,
        chapterId: chapterId,
        subjectId: subjectId,
      );

  ChapterHasStudyToolsProvider._internal(
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
    FutureOr<bool> Function(ChapterHasStudyToolsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterHasStudyToolsProvider._internal(
        (ref) => create(ref as ChapterHasStudyToolsRef),
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
    return _ChapterHasStudyToolsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterHasStudyToolsProvider &&
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
mixin ChapterHasStudyToolsRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `subjectId` of this provider.
  String get subjectId;
}

class _ChapterHasStudyToolsProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with ChapterHasStudyToolsRef {
  _ChapterHasStudyToolsProviderElement(super.provider);

  @override
  String get chapterId => (origin as ChapterHasStudyToolsProvider).chapterId;
  @override
  String get subjectId => (origin as ChapterHasStudyToolsProvider).subjectId;
}

String _$chapterStudyStatsHash() => r'3163f2bd6efb9700f3db80b1efd48430cb74b062';

abstract class _$ChapterStudyStats
    extends BuildlessAutoDisposeAsyncNotifier<ChapterStudyData> {
  late final String chapterId;
  late final String subjectId;

  FutureOr<ChapterStudyData> build(String chapterId, String subjectId);
}

/// Provider for aggregated chapter study stats
///
/// Copied from [ChapterStudyStats].
@ProviderFor(ChapterStudyStats)
const chapterStudyStatsProvider = ChapterStudyStatsFamily();

/// Provider for aggregated chapter study stats
///
/// Copied from [ChapterStudyStats].
class ChapterStudyStatsFamily extends Family<AsyncValue<ChapterStudyData>> {
  /// Provider for aggregated chapter study stats
  ///
  /// Copied from [ChapterStudyStats].
  const ChapterStudyStatsFamily();

  /// Provider for aggregated chapter study stats
  ///
  /// Copied from [ChapterStudyStats].
  ChapterStudyStatsProvider call(String chapterId, String subjectId) {
    return ChapterStudyStatsProvider(chapterId, subjectId);
  }

  @override
  ChapterStudyStatsProvider getProviderOverride(
    covariant ChapterStudyStatsProvider provider,
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
  String? get name => r'chapterStudyStatsProvider';
}

/// Provider for aggregated chapter study stats
///
/// Copied from [ChapterStudyStats].
class ChapterStudyStatsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ChapterStudyStats,
          ChapterStudyData
        > {
  /// Provider for aggregated chapter study stats
  ///
  /// Copied from [ChapterStudyStats].
  ChapterStudyStatsProvider(String chapterId, String subjectId)
    : this._internal(
        () => ChapterStudyStats()
          ..chapterId = chapterId
          ..subjectId = subjectId,
        from: chapterStudyStatsProvider,
        name: r'chapterStudyStatsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chapterStudyStatsHash,
        dependencies: ChapterStudyStatsFamily._dependencies,
        allTransitiveDependencies:
            ChapterStudyStatsFamily._allTransitiveDependencies,
        chapterId: chapterId,
        subjectId: subjectId,
      );

  ChapterStudyStatsProvider._internal(
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
  FutureOr<ChapterStudyData> runNotifierBuild(
    covariant ChapterStudyStats notifier,
  ) {
    return notifier.build(chapterId, subjectId);
  }

  @override
  Override overrideWith(ChapterStudyStats Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChapterStudyStatsProvider._internal(
        () => create()
          ..chapterId = chapterId
          ..subjectId = subjectId,
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
  AutoDisposeAsyncNotifierProviderElement<ChapterStudyStats, ChapterStudyData>
  createElement() {
    return _ChapterStudyStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterStudyStatsProvider &&
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
mixin ChapterStudyStatsRef
    on AutoDisposeAsyncNotifierProviderRef<ChapterStudyData> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `subjectId` of this provider.
  String get subjectId;
}

class _ChapterStudyStatsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ChapterStudyStats,
          ChapterStudyData
        >
    with ChapterStudyStatsRef {
  _ChapterStudyStatsProviderElement(super.provider);

  @override
  String get chapterId => (origin as ChapterStudyStatsProvider).chapterId;
  @override
  String get subjectId => (origin as ChapterStudyStatsProvider).subjectId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
