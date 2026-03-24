// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qa_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoQADaoHash() => r'8347def90ab521132b42eaf761960d34c255d331';

/// Provider for VideoQADao
///
/// Copied from [videoQADao].
@ProviderFor(videoQADao)
final videoQADaoProvider = AutoDisposeProvider<VideoQADao>.internal(
  videoQADao,
  name: r'videoQADaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$videoQADaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VideoQADaoRef = AutoDisposeProviderRef<VideoQADao>;
String _$qaRepositoryHash() => r'a442ef460e3ea2208d92eec0a3d24b510a8181f4';

/// Provider for QARepository
///
/// Copied from [qaRepository].
@ProviderFor(qaRepository)
final qaRepositoryProvider = AutoDisposeProvider<QARepository>.internal(
  qaRepository,
  name: r'qaRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$qaRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QaRepositoryRef = AutoDisposeProviderRef<QARepository>;
String _$videoQuestionCountHash() =>
    r'3ceef43b4a5de325ec081611ab4a61731e010e50';

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

/// Provider for question count
///
/// Copied from [videoQuestionCount].
@ProviderFor(videoQuestionCount)
const videoQuestionCountProvider = VideoQuestionCountFamily();

/// Provider for question count
///
/// Copied from [videoQuestionCount].
class VideoQuestionCountFamily extends Family<AsyncValue<int>> {
  /// Provider for question count
  ///
  /// Copied from [videoQuestionCount].
  const VideoQuestionCountFamily();

  /// Provider for question count
  ///
  /// Copied from [videoQuestionCount].
  VideoQuestionCountProvider call(
    String videoId, {
    String? subjectId,
    String? chapterId,
  }) {
    return VideoQuestionCountProvider(
      videoId,
      subjectId: subjectId,
      chapterId: chapterId,
    );
  }

  @override
  VideoQuestionCountProvider getProviderOverride(
    covariant VideoQuestionCountProvider provider,
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
  String? get name => r'videoQuestionCountProvider';
}

/// Provider for question count
///
/// Copied from [videoQuestionCount].
class VideoQuestionCountProvider extends AutoDisposeFutureProvider<int> {
  /// Provider for question count
  ///
  /// Copied from [videoQuestionCount].
  VideoQuestionCountProvider(
    String videoId, {
    String? subjectId,
    String? chapterId,
  }) : this._internal(
         (ref) => videoQuestionCount(
           ref as VideoQuestionCountRef,
           videoId,
           subjectId: subjectId,
           chapterId: chapterId,
         ),
         from: videoQuestionCountProvider,
         name: r'videoQuestionCountProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$videoQuestionCountHash,
         dependencies: VideoQuestionCountFamily._dependencies,
         allTransitiveDependencies:
             VideoQuestionCountFamily._allTransitiveDependencies,
         videoId: videoId,
         subjectId: subjectId,
         chapterId: chapterId,
       );

  VideoQuestionCountProvider._internal(
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
    FutureOr<int> Function(VideoQuestionCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VideoQuestionCountProvider._internal(
        (ref) => create(ref as VideoQuestionCountRef),
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
  AutoDisposeFutureProviderElement<int> createElement() {
    return _VideoQuestionCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoQuestionCountProvider &&
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
mixin VideoQuestionCountRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `videoId` of this provider.
  String get videoId;

  /// The parameter `subjectId` of this provider.
  String? get subjectId;

  /// The parameter `chapterId` of this provider.
  String? get chapterId;
}

class _VideoQuestionCountProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with VideoQuestionCountRef {
  _VideoQuestionCountProviderElement(super.provider);

  @override
  String get videoId => (origin as VideoQuestionCountProvider).videoId;
  @override
  String? get subjectId => (origin as VideoQuestionCountProvider).subjectId;
  @override
  String? get chapterId => (origin as VideoQuestionCountProvider).chapterId;
}

String _$videoQuestionsHash() => r'5110b7d7ef274d52697e5be8e944181e46058c43';

abstract class _$VideoQuestions
    extends BuildlessAutoDisposeAsyncNotifier<List<VideoQuestion>> {
  late final String videoId;

  FutureOr<List<VideoQuestion>> build(String videoId);
}

/// Notifier for managing video FAQs (read-only from JSON)
///
/// Copied from [VideoQuestions].
@ProviderFor(VideoQuestions)
const videoQuestionsProvider = VideoQuestionsFamily();

/// Notifier for managing video FAQs (read-only from JSON)
///
/// Copied from [VideoQuestions].
class VideoQuestionsFamily extends Family<AsyncValue<List<VideoQuestion>>> {
  /// Notifier for managing video FAQs (read-only from JSON)
  ///
  /// Copied from [VideoQuestions].
  const VideoQuestionsFamily();

  /// Notifier for managing video FAQs (read-only from JSON)
  ///
  /// Copied from [VideoQuestions].
  VideoQuestionsProvider call(String videoId) {
    return VideoQuestionsProvider(videoId);
  }

  @override
  VideoQuestionsProvider getProviderOverride(
    covariant VideoQuestionsProvider provider,
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
  String? get name => r'videoQuestionsProvider';
}

/// Notifier for managing video FAQs (read-only from JSON)
///
/// Copied from [VideoQuestions].
class VideoQuestionsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          VideoQuestions,
          List<VideoQuestion>
        > {
  /// Notifier for managing video FAQs (read-only from JSON)
  ///
  /// Copied from [VideoQuestions].
  VideoQuestionsProvider(String videoId)
    : this._internal(
        () => VideoQuestions()..videoId = videoId,
        from: videoQuestionsProvider,
        name: r'videoQuestionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$videoQuestionsHash,
        dependencies: VideoQuestionsFamily._dependencies,
        allTransitiveDependencies:
            VideoQuestionsFamily._allTransitiveDependencies,
        videoId: videoId,
      );

  VideoQuestionsProvider._internal(
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
  FutureOr<List<VideoQuestion>> runNotifierBuild(
    covariant VideoQuestions notifier,
  ) {
    return notifier.build(videoId);
  }

  @override
  Override overrideWith(VideoQuestions Function() create) {
    return ProviderOverride(
      origin: this,
      override: VideoQuestionsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<VideoQuestions, List<VideoQuestion>>
  createElement() {
    return _VideoQuestionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoQuestionsProvider && other.videoId == videoId;
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
mixin VideoQuestionsRef
    on AutoDisposeAsyncNotifierProviderRef<List<VideoQuestion>> {
  /// The parameter `videoId` of this provider.
  String get videoId;
}

class _VideoQuestionsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          VideoQuestions,
          List<VideoQuestion>
        >
    with VideoQuestionsRef {
  _VideoQuestionsProviderElement(super.provider);

  @override
  String get videoId => (origin as VideoQuestionsProvider).videoId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
