// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncState _$SyncStateFromJson(Map<String, dynamic> json) => SyncState(
  id: json['id'] as String,
  dataType: json['dataType'] as String,
  status:
      $enumDecodeNullable(_$SyncStatusEnumMap, json['status']) ??
      SyncStatus.idle,
  lastSyncTime: json['lastSyncTime'] == null
      ? null
      : DateTime.parse(json['lastSyncTime'] as String),
  lastAttemptTime: json['lastAttemptTime'] == null
      ? null
      : DateTime.parse(json['lastAttemptTime'] as String),
  version: json['version'] as String?,
  pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
  lastError: json['lastError'] as String?,
  failureCount: (json['failureCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SyncStateToJson(SyncState instance) => <String, dynamic>{
  'id': instance.id,
  'dataType': instance.dataType,
  'status': _$SyncStatusEnumMap[instance.status]!,
  'lastSyncTime': instance.lastSyncTime?.toIso8601String(),
  'lastAttemptTime': instance.lastAttemptTime?.toIso8601String(),
  'version': instance.version,
  'pendingCount': instance.pendingCount,
  'lastError': instance.lastError,
  'failureCount': instance.failureCount,
};

const _$SyncStatusEnumMap = {
  SyncStatus.idle: 'idle',
  SyncStatus.syncing: 'syncing',
  SyncStatus.error: 'error',
  SyncStatus.pending: 'pending',
};

AppSyncState _$AppSyncStateFromJson(Map<String, dynamic> json) => AppSyncState(
  content: SyncState.fromJson(json['content'] as Map<String, dynamic>),
  userData: SyncState.fromJson(json['userData'] as Map<String, dynamic>),
  lastFullSync: json['lastFullSync'] == null
      ? null
      : DateTime.parse(json['lastFullSync'] as String),
);

Map<String, dynamic> _$AppSyncStateToJson(AppSyncState instance) =>
    <String, dynamic>{
      'content': instance.content,
      'userData': instance.userData,
      'lastFullSync': instance.lastFullSync?.toIso8601String(),
    };
