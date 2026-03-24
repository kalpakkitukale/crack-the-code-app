// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mind_map_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MindMapNodeImpl _$$MindMapNodeImplFromJson(Map<String, dynamic> json) =>
    _$MindMapNodeImpl(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      label: json['label'] as String,
      description: json['description'] as String?,
      parentId: json['parentId'] as String?,
      positionX: (json['positionX'] as num?)?.toDouble() ?? 0.0,
      positionY: (json['positionY'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] as String?,
      nodeType:
          $enumDecodeNullable(_$MindMapNodeTypeEnumMap, json['nodeType']) ??
          MindMapNodeType.detail,
      segment: json['segment'] as String,
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MindMapNodeImplToJson(_$MindMapNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapterId': instance.chapterId,
      'label': instance.label,
      'description': instance.description,
      'parentId': instance.parentId,
      'positionX': instance.positionX,
      'positionY': instance.positionY,
      'color': instance.color,
      'nodeType': _$MindMapNodeTypeEnumMap[instance.nodeType]!,
      'segment': instance.segment,
      'orderIndex': instance.orderIndex,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$MindMapNodeTypeEnumMap = {
  MindMapNodeType.root: 'root',
  MindMapNodeType.mainTopic: 'mainTopic',
  MindMapNodeType.subTopic: 'subTopic',
  MindMapNodeType.detail: 'detail',
  MindMapNodeType.example: 'example',
};

_$MindMapImpl _$$MindMapImplFromJson(Map<String, dynamic> json) =>
    _$MindMapImpl(
      chapterId: json['chapterId'] as String,
      segment: json['segment'] as String,
      nodes: (json['nodes'] as List<dynamic>)
          .map((e) => MindMapNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MindMapImplToJson(_$MindMapImpl instance) =>
    <String, dynamic>{
      'chapterId': instance.chapterId,
      'segment': instance.segment,
      'nodes': instance.nodes,
    };
