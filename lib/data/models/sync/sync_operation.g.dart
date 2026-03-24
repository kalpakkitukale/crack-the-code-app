// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncOperation _$SyncOperationFromJson(Map<String, dynamic> json) =>
    SyncOperation(
      id: json['id'] as String,
      type: $enumDecode(_$SyncOperationTypeEnumMap, json['type']),
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      payload: json['payload'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      lastError: json['lastError'] as String?,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SyncOperationToJson(SyncOperation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$SyncOperationTypeEnumMap[instance.type]!,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'payload': instance.payload,
      'createdAt': instance.createdAt.toIso8601String(),
      'retryCount': instance.retryCount,
      'lastError': instance.lastError,
      'priority': instance.priority,
    };

const _$SyncOperationTypeEnumMap = {
  SyncOperationType.create: 'create',
  SyncOperationType.update: 'update',
  SyncOperationType.delete: 'delete',
};

SyncBatch _$SyncBatchFromJson(Map<String, dynamic> json) => SyncBatch(
  id: json['id'] as String,
  operations: (json['operations'] as List<dynamic>)
      .map((e) => SyncOperation.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  status:
      $enumDecodeNullable(_$SyncBatchStatusEnumMap, json['status']) ??
      SyncBatchStatus.pending,
  completedCount: (json['completedCount'] as num?)?.toInt() ?? 0,
  error: json['error'] as String?,
);

Map<String, dynamic> _$SyncBatchToJson(SyncBatch instance) => <String, dynamic>{
  'id': instance.id,
  'operations': instance.operations,
  'createdAt': instance.createdAt.toIso8601String(),
  'status': _$SyncBatchStatusEnumMap[instance.status]!,
  'completedCount': instance.completedCount,
  'error': instance.error,
};

const _$SyncBatchStatusEnumMap = {
  SyncBatchStatus.pending: 'pending',
  SyncBatchStatus.processing: 'processing',
  SyncBatchStatus.completed: 'completed',
  SyncBatchStatus.failed: 'failed',
};
