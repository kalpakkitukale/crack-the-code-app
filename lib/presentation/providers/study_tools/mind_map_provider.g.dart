// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mind_map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mindMapDaoHash() => r'a78d09e183f26def6beacb9608cdbba9b33459b8';

/// Provider for MindMapDao
///
/// Copied from [mindMapDao].
@ProviderFor(mindMapDao)
final mindMapDaoProvider = AutoDisposeProvider<MindMapDao>.internal(
  mindMapDao,
  name: r'mindMapDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mindMapDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MindMapDaoRef = AutoDisposeProviderRef<MindMapDao>;
String _$mindMapRepositoryHash() => r'cf9b498978a04f96f42c38bf55043da277ede569';

/// Provider for MindMapRepository
///
/// Copied from [mindMapRepository].
@ProviderFor(mindMapRepository)
final mindMapRepositoryProvider =
    AutoDisposeProvider<MindMapRepository>.internal(
      mindMapRepository,
      name: r'mindMapRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mindMapRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MindMapRepositoryRef = AutoDisposeProviderRef<MindMapRepository>;
String _$chapterMindMapHash() => r'4024d94c53d44c23e3c64e14c1ace76b1a54c6cd';

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

/// Provider for mind map by chapter ID with subject context
///
/// Copied from [chapterMindMap].
@ProviderFor(chapterMindMap)
const chapterMindMapProvider = ChapterMindMapFamily();

/// Provider for mind map by chapter ID with subject context
///
/// Copied from [chapterMindMap].
class ChapterMindMapFamily extends Family<AsyncValue<MindMap?>> {
  /// Provider for mind map by chapter ID with subject context
  ///
  /// Copied from [chapterMindMap].
  const ChapterMindMapFamily();

  /// Provider for mind map by chapter ID with subject context
  ///
  /// Copied from [chapterMindMap].
  ChapterMindMapProvider call(String chapterId, {String? subjectId}) {
    return ChapterMindMapProvider(chapterId, subjectId: subjectId);
  }

  @override
  ChapterMindMapProvider getProviderOverride(
    covariant ChapterMindMapProvider provider,
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
  String? get name => r'chapterMindMapProvider';
}

/// Provider for mind map by chapter ID with subject context
///
/// Copied from [chapterMindMap].
class ChapterMindMapProvider extends AutoDisposeFutureProvider<MindMap?> {
  /// Provider for mind map by chapter ID with subject context
  ///
  /// Copied from [chapterMindMap].
  ChapterMindMapProvider(String chapterId, {String? subjectId})
    : this._internal(
        (ref) => chapterMindMap(
          ref as ChapterMindMapRef,
          chapterId,
          subjectId: subjectId,
        ),
        from: chapterMindMapProvider,
        name: r'chapterMindMapProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chapterMindMapHash,
        dependencies: ChapterMindMapFamily._dependencies,
        allTransitiveDependencies:
            ChapterMindMapFamily._allTransitiveDependencies,
        chapterId: chapterId,
        subjectId: subjectId,
      );

  ChapterMindMapProvider._internal(
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
    FutureOr<MindMap?> Function(ChapterMindMapRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterMindMapProvider._internal(
        (ref) => create(ref as ChapterMindMapRef),
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
  AutoDisposeFutureProviderElement<MindMap?> createElement() {
    return _ChapterMindMapProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterMindMapProvider &&
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
mixin ChapterMindMapRef on AutoDisposeFutureProviderRef<MindMap?> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `subjectId` of this provider.
  String? get subjectId;
}

class _ChapterMindMapProviderElement
    extends AutoDisposeFutureProviderElement<MindMap?>
    with ChapterMindMapRef {
  _ChapterMindMapProviderElement(super.provider);

  @override
  String get chapterId => (origin as ChapterMindMapProvider).chapterId;
  @override
  String? get subjectId => (origin as ChapterMindMapProvider).subjectId;
}

String _$chapterMindMapNodesHash() =>
    r'54f28624ead689a1cb3c9c576e7728e0455e697f';

/// Provider for mind map nodes by chapter ID with subject context
///
/// Copied from [chapterMindMapNodes].
@ProviderFor(chapterMindMapNodes)
const chapterMindMapNodesProvider = ChapterMindMapNodesFamily();

/// Provider for mind map nodes by chapter ID with subject context
///
/// Copied from [chapterMindMapNodes].
class ChapterMindMapNodesFamily extends Family<AsyncValue<List<MindMapNode>>> {
  /// Provider for mind map nodes by chapter ID with subject context
  ///
  /// Copied from [chapterMindMapNodes].
  const ChapterMindMapNodesFamily();

  /// Provider for mind map nodes by chapter ID with subject context
  ///
  /// Copied from [chapterMindMapNodes].
  ChapterMindMapNodesProvider call(String chapterId, {String? subjectId}) {
    return ChapterMindMapNodesProvider(chapterId, subjectId: subjectId);
  }

  @override
  ChapterMindMapNodesProvider getProviderOverride(
    covariant ChapterMindMapNodesProvider provider,
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
  String? get name => r'chapterMindMapNodesProvider';
}

/// Provider for mind map nodes by chapter ID with subject context
///
/// Copied from [chapterMindMapNodes].
class ChapterMindMapNodesProvider
    extends AutoDisposeFutureProvider<List<MindMapNode>> {
  /// Provider for mind map nodes by chapter ID with subject context
  ///
  /// Copied from [chapterMindMapNodes].
  ChapterMindMapNodesProvider(String chapterId, {String? subjectId})
    : this._internal(
        (ref) => chapterMindMapNodes(
          ref as ChapterMindMapNodesRef,
          chapterId,
          subjectId: subjectId,
        ),
        from: chapterMindMapNodesProvider,
        name: r'chapterMindMapNodesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chapterMindMapNodesHash,
        dependencies: ChapterMindMapNodesFamily._dependencies,
        allTransitiveDependencies:
            ChapterMindMapNodesFamily._allTransitiveDependencies,
        chapterId: chapterId,
        subjectId: subjectId,
      );

  ChapterMindMapNodesProvider._internal(
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
    FutureOr<List<MindMapNode>> Function(ChapterMindMapNodesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterMindMapNodesProvider._internal(
        (ref) => create(ref as ChapterMindMapNodesRef),
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
  AutoDisposeFutureProviderElement<List<MindMapNode>> createElement() {
    return _ChapterMindMapNodesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterMindMapNodesProvider &&
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
mixin ChapterMindMapNodesRef
    on AutoDisposeFutureProviderRef<List<MindMapNode>> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;

  /// The parameter `subjectId` of this provider.
  String? get subjectId;
}

class _ChapterMindMapNodesProviderElement
    extends AutoDisposeFutureProviderElement<List<MindMapNode>>
    with ChapterMindMapNodesRef {
  _ChapterMindMapNodesProviderElement(super.provider);

  @override
  String get chapterId => (origin as ChapterMindMapNodesProvider).chapterId;
  @override
  String? get subjectId => (origin as ChapterMindMapNodesProvider).subjectId;
}

String _$mindMapNotifierHash() => r'467f524c46afd12e924986706e071d1c031e8025';

abstract class _$MindMapNotifier
    extends BuildlessAutoDisposeAsyncNotifier<MindMap?> {
  late final String chapterId;

  FutureOr<MindMap?> build(String chapterId);
}

/// Notifier for managing mind map state
///
/// Copied from [MindMapNotifier].
@ProviderFor(MindMapNotifier)
const mindMapNotifierProvider = MindMapNotifierFamily();

/// Notifier for managing mind map state
///
/// Copied from [MindMapNotifier].
class MindMapNotifierFamily extends Family<AsyncValue<MindMap?>> {
  /// Notifier for managing mind map state
  ///
  /// Copied from [MindMapNotifier].
  const MindMapNotifierFamily();

  /// Notifier for managing mind map state
  ///
  /// Copied from [MindMapNotifier].
  MindMapNotifierProvider call(String chapterId) {
    return MindMapNotifierProvider(chapterId);
  }

  @override
  MindMapNotifierProvider getProviderOverride(
    covariant MindMapNotifierProvider provider,
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
  String? get name => r'mindMapNotifierProvider';
}

/// Notifier for managing mind map state
///
/// Copied from [MindMapNotifier].
class MindMapNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MindMapNotifier, MindMap?> {
  /// Notifier for managing mind map state
  ///
  /// Copied from [MindMapNotifier].
  MindMapNotifierProvider(String chapterId)
    : this._internal(
        () => MindMapNotifier()..chapterId = chapterId,
        from: mindMapNotifierProvider,
        name: r'mindMapNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$mindMapNotifierHash,
        dependencies: MindMapNotifierFamily._dependencies,
        allTransitiveDependencies:
            MindMapNotifierFamily._allTransitiveDependencies,
        chapterId: chapterId,
      );

  MindMapNotifierProvider._internal(
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
  FutureOr<MindMap?> runNotifierBuild(covariant MindMapNotifier notifier) {
    return notifier.build(chapterId);
  }

  @override
  Override overrideWith(MindMapNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MindMapNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<MindMapNotifier, MindMap?>
  createElement() {
    return _MindMapNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MindMapNotifierProvider && other.chapterId == chapterId;
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
mixin MindMapNotifierRef on AutoDisposeAsyncNotifierProviderRef<MindMap?> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;
}

class _MindMapNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MindMapNotifier, MindMap?>
    with MindMapNotifierRef {
  _MindMapNotifierProviderElement(super.provider);

  @override
  String get chapterId => (origin as MindMapNotifierProvider).chapterId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
