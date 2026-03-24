/// Sync Operation Model
/// Represents individual sync operations for tracking and retry
library;

import 'package:json_annotation/json_annotation.dart';

part 'sync_operation.g.dart';

/// A single sync operation that may need to be retried
@JsonSerializable()
class SyncOperation {
  /// Unique identifier for this operation
  final String id;

  /// Type of operation (create, update, delete)
  final SyncOperationType type;

  /// Entity type being synced (e.g., "note", "bookmark", "progress")
  final String entityType;

  /// Entity ID being synced
  final String entityId;

  /// JSON payload for create/update operations
  final Map<String, dynamic>? payload;

  /// When the operation was created
  final DateTime createdAt;

  /// Number of retry attempts
  final int retryCount;

  /// Last error message if any
  final String? lastError;

  /// Priority (higher = more important)
  final int priority;

  const SyncOperation({
    required this.id,
    required this.type,
    required this.entityType,
    required this.entityId,
    this.payload,
    required this.createdAt,
    this.retryCount = 0,
    this.lastError,
    this.priority = 0,
  });

  /// Create a copy with updated fields
  SyncOperation copyWith({
    String? id,
    SyncOperationType? type,
    String? entityType,
    String? entityId,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
    int? retryCount,
    String? lastError,
    int? priority,
  }) {
    return SyncOperation(
      id: id ?? this.id,
      type: type ?? this.type,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      priority: priority ?? this.priority,
    );
  }

  /// Mark as failed with error
  SyncOperation withError(String error) {
    return copyWith(
      retryCount: retryCount + 1,
      lastError: error,
    );
  }

  /// Whether this operation should be retried
  bool get shouldRetry => retryCount < 5;

  /// How long to wait before retrying (exponential backoff)
  Duration get retryDelay {
    // 1s, 2s, 4s, 8s, 16s
    final seconds = 1 << retryCount;
    return Duration(seconds: seconds.clamp(1, 60));
  }

  factory SyncOperation.fromJson(Map<String, dynamic> json) =>
      _$SyncOperationFromJson(json);

  Map<String, dynamic> toJson() => _$SyncOperationToJson(this);

  @override
  String toString() =>
      'SyncOperation($type $entityType:$entityId, retries: $retryCount)';
}

/// Type of sync operation
enum SyncOperationType {
  /// Create a new entity
  @JsonValue('create')
  create,

  /// Update an existing entity
  @JsonValue('update')
  update,

  /// Delete an entity
  @JsonValue('delete')
  delete,
}

/// A batch of sync operations to be processed together
@JsonSerializable()
class SyncBatch {
  /// Unique identifier for this batch
  final String id;

  /// Operations in this batch
  final List<SyncOperation> operations;

  /// When the batch was created
  final DateTime createdAt;

  /// Status of the batch
  final SyncBatchStatus status;

  /// Number of completed operations
  final int completedCount;

  /// Error message if batch failed
  final String? error;

  const SyncBatch({
    required this.id,
    required this.operations,
    required this.createdAt,
    this.status = SyncBatchStatus.pending,
    this.completedCount = 0,
    this.error,
  });

  /// Total operations in batch
  int get totalCount => operations.length;

  /// Progress percentage
  double get progress =>
      totalCount > 0 ? completedCount / totalCount : 0;

  /// Whether batch is complete
  bool get isComplete =>
      status == SyncBatchStatus.completed ||
      status == SyncBatchStatus.failed;

  SyncBatch copyWith({
    String? id,
    List<SyncOperation>? operations,
    DateTime? createdAt,
    SyncBatchStatus? status,
    int? completedCount,
    String? error,
  }) {
    return SyncBatch(
      id: id ?? this.id,
      operations: operations ?? this.operations,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      completedCount: completedCount ?? this.completedCount,
      error: error ?? this.error,
    );
  }

  factory SyncBatch.fromJson(Map<String, dynamic> json) =>
      _$SyncBatchFromJson(json);

  Map<String, dynamic> toJson() => _$SyncBatchToJson(this);
}

/// Status of a sync batch
enum SyncBatchStatus {
  /// Waiting to be processed
  @JsonValue('pending')
  pending,

  /// Currently being processed
  @JsonValue('processing')
  processing,

  /// All operations completed successfully
  @JsonValue('completed')
  completed,

  /// Some operations failed
  @JsonValue('failed')
  failed,
}

/// Queue of pending sync operations
class SyncQueue {
  final List<SyncOperation> _operations = [];
  final Map<String, SyncOperation> _operationMap = {};

  /// All pending operations
  List<SyncOperation> get operations => List.unmodifiable(_operations);

  /// Number of pending operations
  int get length => _operations.length;

  /// Whether queue is empty
  bool get isEmpty => _operations.isEmpty;

  /// Whether queue has items
  bool get isNotEmpty => _operations.isNotEmpty;

  /// Add an operation to the queue
  void add(SyncOperation operation) {
    // If operation for same entity already exists, update it
    final existingKey = '${operation.entityType}:${operation.entityId}';
    final existing = _operationMap[existingKey];

    if (existing != null) {
      _operations.remove(existing);
      _operationMap.remove(existingKey);
    }

    // Handle delete after create/update - remove both
    if (operation.type == SyncOperationType.delete && existing != null) {
      // If there was a pending create, just remove it (nothing to sync)
      if (existing.type == SyncOperationType.create) {
        return;
      }
      // If there was a pending update, convert to delete
    }

    _operations.add(operation);
    _operationMap[existingKey] = operation;

    // Sort by priority (higher first) then by creation time (older first)
    _operations.sort((a, b) {
      final priorityCompare = b.priority.compareTo(a.priority);
      if (priorityCompare != 0) return priorityCompare;
      return a.createdAt.compareTo(b.createdAt);
    });
  }

  /// Remove an operation from the queue
  void remove(SyncOperation operation) {
    _operations.remove(operation);
    _operationMap.remove('${operation.entityType}:${operation.entityId}');
  }

  /// Get and remove the next operation
  SyncOperation? pop() {
    if (_operations.isEmpty) return null;
    final operation = _operations.removeAt(0);
    _operationMap.remove('${operation.entityType}:${operation.entityId}');
    return operation;
  }

  /// Clear all operations
  void clear() {
    _operations.clear();
    _operationMap.clear();
  }

  /// Get operations for a specific entity type
  List<SyncOperation> forEntityType(String entityType) {
    return _operations.where((op) => op.entityType == entityType).toList();
  }
}
