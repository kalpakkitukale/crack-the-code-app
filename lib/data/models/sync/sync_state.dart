/// Sync State Model
/// Tracks synchronization state for content and user data
library;

import 'package:json_annotation/json_annotation.dart';

part 'sync_state.g.dart';

/// State of synchronization for a specific data type
@JsonSerializable()
class SyncState {
  /// Unique identifier for this sync state
  final String id;

  /// Type of data being synced (e.g., "content", "progress", "notes")
  final String dataType;

  /// Current sync status
  final SyncStatus status;

  /// Last successful sync time
  final DateTime? lastSyncTime;

  /// Last sync attempt time
  final DateTime? lastAttemptTime;

  /// Version/checksum of the synced data
  final String? version;

  /// Number of items pending sync
  final int pendingCount;

  /// Error message if last sync failed
  final String? lastError;

  /// Number of consecutive failures
  final int failureCount;

  const SyncState({
    required this.id,
    required this.dataType,
    this.status = SyncStatus.idle,
    this.lastSyncTime,
    this.lastAttemptTime,
    this.version,
    this.pendingCount = 0,
    this.lastError,
    this.failureCount = 0,
  });

  /// Create a copy with updated fields
  SyncState copyWith({
    String? id,
    String? dataType,
    SyncStatus? status,
    DateTime? lastSyncTime,
    DateTime? lastAttemptTime,
    String? version,
    int? pendingCount,
    String? lastError,
    int? failureCount,
  }) {
    return SyncState(
      id: id ?? this.id,
      dataType: dataType ?? this.dataType,
      status: status ?? this.status,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      lastAttemptTime: lastAttemptTime ?? this.lastAttemptTime,
      version: version ?? this.version,
      pendingCount: pendingCount ?? this.pendingCount,
      lastError: lastError ?? this.lastError,
      failureCount: failureCount ?? this.failureCount,
    );
  }

  /// Mark sync as started
  SyncState startSync() {
    return copyWith(
      status: SyncStatus.syncing,
      lastAttemptTime: DateTime.now(),
    );
  }

  /// Mark sync as completed successfully
  SyncState completeSync({String? newVersion}) {
    return copyWith(
      status: SyncStatus.idle,
      lastSyncTime: DateTime.now(),
      version: newVersion,
      pendingCount: 0,
      lastError: null,
      failureCount: 0,
    );
  }

  /// Mark sync as failed
  SyncState failSync(String error) {
    return copyWith(
      status: SyncStatus.error,
      lastError: error,
      failureCount: failureCount + 1,
    );
  }

  /// Check if sync is needed based on time threshold
  bool needsSync({Duration threshold = const Duration(hours: 1)}) {
    if (lastSyncTime == null) return true;
    return DateTime.now().difference(lastSyncTime!) > threshold;
  }

  /// Check if sync should be retried after failure
  bool shouldRetry({int maxRetries = 3}) {
    return status == SyncStatus.error && failureCount < maxRetries;
  }

  factory SyncState.fromJson(Map<String, dynamic> json) =>
      _$SyncStateFromJson(json);

  Map<String, dynamic> toJson() => _$SyncStateToJson(this);

  @override
  String toString() =>
      'SyncState(id: $id, dataType: $dataType, status: $status, pending: $pendingCount)';
}

/// Sync status enum
enum SyncStatus {
  /// No sync in progress
  @JsonValue('idle')
  idle,

  /// Sync in progress
  @JsonValue('syncing')
  syncing,

  /// Sync failed with error
  @JsonValue('error')
  error,

  /// Waiting for network
  @JsonValue('pending')
  pending,
}

/// Extension methods for SyncStatus
extension SyncStatusX on SyncStatus {
  String get displayName {
    switch (this) {
      case SyncStatus.idle:
        return 'Up to date';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.error:
        return 'Sync error';
      case SyncStatus.pending:
        return 'Pending sync';
    }
  }

  bool get isActive => this == SyncStatus.syncing;
  bool get hasError => this == SyncStatus.error;
}

/// Overall sync status for the app
@JsonSerializable()
class AppSyncState {
  /// Content sync state
  final SyncState content;

  /// User data sync state
  final SyncState userData;

  /// Last full sync time
  final DateTime? lastFullSync;

  const AppSyncState({
    required this.content,
    required this.userData,
    this.lastFullSync,
  });

  /// Whether any sync is in progress
  bool get isSyncing =>
      content.status == SyncStatus.syncing ||
      userData.status == SyncStatus.syncing;

  /// Whether any sync has errors
  bool get hasErrors =>
      content.status == SyncStatus.error || userData.status == SyncStatus.error;

  /// Total pending items across all sync types
  int get totalPending => content.pendingCount + userData.pendingCount;

  AppSyncState copyWith({
    SyncState? content,
    SyncState? userData,
    DateTime? lastFullSync,
  }) {
    return AppSyncState(
      content: content ?? this.content,
      userData: userData ?? this.userData,
      lastFullSync: lastFullSync ?? this.lastFullSync,
    );
  }

  factory AppSyncState.fromJson(Map<String, dynamic> json) =>
      _$AppSyncStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppSyncStateToJson(this);

  /// Create initial app sync state
  factory AppSyncState.initial() {
    return AppSyncState(
      content: const SyncState(id: 'content', dataType: 'content'),
      userData: const SyncState(id: 'userData', dataType: 'userData'),
    );
  }
}
