// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contentSyncDatasourceHash() =>
    r'208336df7b01d6269a18324f694902fc3237b410';

/// Provides the content sync datasource
///
/// Copied from [contentSyncDatasource].
@ProviderFor(contentSyncDatasource)
final contentSyncDatasourceProvider =
    AutoDisposeProvider<ContentSyncDatasource>.internal(
      contentSyncDatasource,
      name: r'contentSyncDatasourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$contentSyncDatasourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ContentSyncDatasourceRef =
    AutoDisposeProviderRef<ContentSyncDatasource>;
String _$contentSyncRepositoryHash() =>
    r'a6f46a15b00ea9ad92930f5f696f42ec507537e0';

/// Provides the content sync repository
///
/// Copied from [contentSyncRepository].
@ProviderFor(contentSyncRepository)
final contentSyncRepositoryProvider =
    AutoDisposeProvider<ContentSyncRepository>.internal(
      contentSyncRepository,
      name: r'contentSyncRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$contentSyncRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ContentSyncRepositoryRef =
    AutoDisposeProviderRef<ContentSyncRepository>;
String _$contentUpdatesAvailableHash() =>
    r'27b40b4470c6ef2d2422f8301d0769e942aaed67';

/// Provider for checking if content updates are available
///
/// Copied from [contentUpdatesAvailable].
@ProviderFor(contentUpdatesAvailable)
final contentUpdatesAvailableProvider =
    AutoDisposeFutureProvider<bool>.internal(
      contentUpdatesAvailable,
      name: r'contentUpdatesAvailableProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$contentUpdatesAvailableHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ContentUpdatesAvailableRef = AutoDisposeFutureProviderRef<bool>;
String _$contentSyncNotifierHash() =>
    r'c72a87eac25a616cece86970bd09b0a1f50277d6';

/// Notifier for content sync state
///
/// Copied from [ContentSyncNotifier].
@ProviderFor(ContentSyncNotifier)
final contentSyncNotifierProvider =
    AutoDisposeNotifierProvider<ContentSyncNotifier, ContentSyncState>.internal(
      ContentSyncNotifier.new,
      name: r'contentSyncNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$contentSyncNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ContentSyncNotifier = AutoDisposeNotifier<ContentSyncState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
