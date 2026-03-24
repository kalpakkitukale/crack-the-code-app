// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoSummaryDaoHash() => r'b717bc2b43e862f3811c25c50de13c80986b079c';

/// Provider for VideoSummaryDao
///
/// Copied from [videoSummaryDao].
@ProviderFor(videoSummaryDao)
final videoSummaryDaoProvider = AutoDisposeProvider<VideoSummaryDao>.internal(
  videoSummaryDao,
  name: r'videoSummaryDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$videoSummaryDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VideoSummaryDaoRef = AutoDisposeProviderRef<VideoSummaryDao>;
String _$summaryRepositoryHash() => r'17a95d7d1838cb7027c0d0a8b2413870b5ef1d1a';

/// Provider for SummaryRepository
///
/// Copied from [summaryRepository].
@ProviderFor(summaryRepository)
final summaryRepositoryProvider =
    AutoDisposeProvider<SummaryRepository>.internal(
      summaryRepository,
      name: r'summaryRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$summaryRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SummaryRepositoryRef = AutoDisposeProviderRef<SummaryRepository>;
String _$videoSummaryHash() => r'bc4c38e75e573d243ac2bc47bcf2e61179f6d324';

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

/// Provider for video summary by video ID with context
///
/// Copied from [videoSummary].
@ProviderFor(videoSummary)
const videoSummaryProvider = VideoSummaryFamily();

/// Provider for video summary by video ID with context
///
/// Copied from [videoSummary].
class VideoSummaryFamily extends Family<AsyncValue<VideoSummary?>> {
  /// Provider for video summary by video ID with context
  ///
  /// Copied from [videoSummary].
  const VideoSummaryFamily();

  /// Provider for video summary by video ID with context
  ///
  /// Copied from [videoSummary].
  VideoSummaryProvider call(
    String videoId, {
    String? subjectId,
    String? chapterId,
  }) {
    return VideoSummaryProvider(
      videoId,
      subjectId: subjectId,
      chapterId: chapterId,
    );
  }

  @override
  VideoSummaryProvider getProviderOverride(
    covariant VideoSummaryProvider provider,
  ) {
    return call(
      provider.videoId,
      subjectId: provider.subjectId,
      chapterId: provider.chapterId,
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
  String? get name => r'videoSummaryProvider';
}

/// Provider for video summary by video ID with context
///
/// Copied from [videoSummary].
class VideoSummaryProvider extends AutoDisposeFutureProvider<VideoSummary?> {
  /// Provider for video summary by video ID with context
  ///
  /// Copied from [videoSummary].
  VideoSummaryProvider(String videoId, {String? subjectId, String? chapterId})
    : this._internal(
        (ref) => videoSummary(
          ref as VideoSummaryRef,
          videoId,
          subjectId: subjectId,
          chapterId: chapterId,
        ),
        from: videoSummaryProvider,
        name: r'videoSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$videoSummaryHash,
        dependencies: VideoSummaryFamily._dependencies,
        allTransitiveDependencies:
            VideoSummaryFamily._allTransitiveDependencies,
        videoId: videoId,
        subjectId: subjectId,
        chapterId: chapterId,
      );

  VideoSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.videoId,
    required this.subjectId,
    required this.chapterId,
  }) : super.internal();

  final String videoId;
  final String? subjectId;
  final String? chapterId;

  @override
  Override overrideWith(
    FutureOr<VideoSummary?> Function(VideoSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VideoSummaryProvider._internal(
        (ref) => create(ref as VideoSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        videoId: videoId,
        subjectId: subjectId,
        chapterId: chapterId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<VideoSummary?> createElement() {
    return _VideoSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoSummaryProvider &&
        other.videoId == videoId &&
        other.subjectId == subjectId &&
        other.chapterId == chapterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, videoId.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VideoSummaryRef on AutoDisposeFutureProviderRef<VideoSummary?> {
  /// The parameter `videoId` of this provider.
  String get videoId;

  /// The parameter `subjectId` of this provider.
  String? get subjectId;

  /// The parameter `chapterId` of this provider.
  String? get chapterId;
}

class _VideoSummaryProviderElement
    extends AutoDisposeFutureProviderElement<VideoSummary?>
    with VideoSummaryRef {
  _VideoSummaryProviderElement(super.provider);

  @override
  String get videoId => (origin as VideoSummaryProvider).videoId;
  @override
  String? get subjectId => (origin as VideoSummaryProvider).subjectId;
  @override
  String? get chapterId => (origin as VideoSummaryProvider).chapterId;
}

String _$videoSummaryNotifierHash() =>
    r'91b58ddb8e9dcc055c8df9827e68f6686a73a37c';

abstract class _$VideoSummaryNotifier
    extends BuildlessAutoDisposeAsyncNotifier<VideoSummary?> {
  late final String videoId;

  FutureOr<VideoSummary?> build(String videoId);
}

/// Notifier for managing video summaries
///
/// Copied from [VideoSummaryNotifier].
@ProviderFor(VideoSummaryNotifier)
const videoSummaryNotifierProvider = VideoSummaryNotifierFamily();

/// Notifier for managing video summaries
///
/// Copied from [VideoSummaryNotifier].
class VideoSummaryNotifierFamily extends Family<AsyncValue<VideoSummary?>> {
  /// Notifier for managing video summaries
  ///
  /// Copied from [VideoSummaryNotifier].
  const VideoSummaryNotifierFamily();

  /// Notifier for managing video summaries
  ///
  /// Copied from [VideoSummaryNotifier].
  VideoSummaryNotifierProvider call(String videoId) {
    return VideoSummaryNotifierProvider(videoId);
  }

  @override
  VideoSummaryNotifierProvider getProviderOverride(
    covariant VideoSummaryNotifierProvider provider,
  ) {
    return call(provider.videoId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'videoSummaryNotifierProvider';
}

/// Notifier for managing video summaries
///
/// Copied from [VideoSummaryNotifier].
class VideoSummaryNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          VideoSummaryNotifier,
          VideoSummary?
        > {
  /// Notifier for managing video summaries
  ///
  /// Copied from [VideoSummaryNotifier].
  VideoSummaryNotifierProvider(String videoId)
    : this._internal(
        () => VideoSummaryNotifier()..videoId = videoId,
        from: videoSummaryNotifierProvider,
        name: r'videoSummaryNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$videoSummaryNotifierHash,
        dependencies: VideoSummaryNotifierFamily._dependencies,
        allTransitiveDependencies:
            VideoSummaryNotifierFamily._allTransitiveDependencies,
        videoId: videoId,
      );

  VideoSummaryNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.videoId,
  }) : super.internal();

  final String videoId;

  @override
  FutureOr<VideoSummary?> runNotifierBuild(
    covariant VideoSummaryNotifier notifier,
  ) {
    return notifier.build(videoId);
  }

  @override
  Override overrideWith(VideoSummaryNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: VideoSummaryNotifierProvider._internal(
        () => create()..videoId = videoId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        videoId: videoId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VideoSummaryNotifier, VideoSummary?>
  createElement() {
    return _VideoSummaryNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoSummaryNotifierProvider && other.videoId == videoId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, videoId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VideoSummaryNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<VideoSummary?> {
  /// The parameter `videoId` of this provider.
  String get videoId;
}

class _VideoSummaryNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          VideoSummaryNotifier,
          VideoSummary?
        >
    with VideoSummaryNotifierRef {
  _VideoSummaryNotifierProviderElement(super.provider);

  @override
  String get videoId => (origin as VideoSummaryNotifierProvider).videoId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
