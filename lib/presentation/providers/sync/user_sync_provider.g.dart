// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$driveSyncDatasourceHash() =>
    r'daebe0b01f6c30da1d6d247ac7b2cde2d629ca5d';

/// Provides the drive sync datasource
///
/// Copied from [driveSyncDatasource].
@ProviderFor(driveSyncDatasource)
final driveSyncDatasourceProvider =
    AutoDisposeProvider<DriveSyncDatasource>.internal(
      driveSyncDatasource,
      name: r'driveSyncDatasourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$driveSyncDatasourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DriveSyncDatasourceRef = AutoDisposeProviderRef<DriveSyncDatasource>;
String _$userSyncRepositoryHash() =>
    r'5f184c7579b6f6429930c056908e18ae3277b2c5';

/// Provides the user sync repository
///
/// Copied from [userSyncRepository].
@ProviderFor(userSyncRepository)
final userSyncRepositoryProvider =
    AutoDisposeProvider<UserSyncRepository>.internal(
      userSyncRepository,
      name: r'userSyncRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userSyncRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserSyncRepositoryRef = AutoDisposeProviderRef<UserSyncRepository>;
String _$userSyncAvailableHash() => r'352680e006e8903c78cb487bd6076f9b34cec65e';

/// Provider for sync availability
///
/// Copied from [userSyncAvailable].
@ProviderFor(userSyncAvailable)
final userSyncAvailableProvider = AutoDisposeProvider<bool>.internal(
  userSyncAvailable,
  name: r'userSyncAvailableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userSyncAvailableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserSyncAvailableRef = AutoDisposeProviderRef<bool>;
String _$pendingSyncCountHash() => r'4a1e07f24d9e1be37ec0e0a79283a843f4fbada2';

/// Provider for pending sync count
///
/// Copied from [pendingSyncCount].
@ProviderFor(pendingSyncCount)
final pendingSyncCountProvider = AutoDisposeProvider<int>.internal(
  pendingSyncCount,
  name: r'pendingSyncCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingSyncCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingSyncCountRef = AutoDisposeProviderRef<int>;
String _$lastSyncTimeHash() => r'7d545093fa76291cd99cc0f75b85d612f5661b6d';

/// Provider for last sync time
///
/// Copied from [lastSyncTime].
@ProviderFor(lastSyncTime)
final lastSyncTimeProvider = AutoDisposeProvider<DateTime?>.internal(
  lastSyncTime,
  name: r'lastSyncTimeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastSyncTimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LastSyncTimeRef = AutoDisposeProviderRef<DateTime?>;
String _$userSyncNotifierHash() => r'05f56fd2025f03270972ea0ed2e6218f0c5063e5';

/// Notifier for user sync state
///
/// Copied from [UserSyncNotifier].
@ProviderFor(UserSyncNotifier)
final userSyncNotifierProvider =
    AutoDisposeNotifierProvider<UserSyncNotifier, UserSyncState>.internal(
      UserSyncNotifier.new,
      name: r'userSyncNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userSyncNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserSyncNotifier = AutoDisposeNotifier<UserSyncState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
