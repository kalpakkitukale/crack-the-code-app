// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mind_map_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MindMapNode _$MindMapNodeFromJson(Map<String, dynamic> json) {
  return _MindMapNode.fromJson(json);
}

/// @nodoc
mixin _$MindMapNode {
  String get id => throw _privateConstructorUsedError;
  String get chapterId => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  double get positionX => throw _privateConstructorUsedError;
  double get positionY => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  MindMapNodeType get nodeType => throw _privateConstructorUsedError;
  String get segment => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MindMapNode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MindMapNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MindMapNodeCopyWith<MindMapNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MindMapNodeCopyWith<$Res> {
  factory $MindMapNodeCopyWith(
    MindMapNode value,
    $Res Function(MindMapNode) then,
  ) = _$MindMapNodeCopyWithImpl<$Res, MindMapNode>;
  @useResult
  $Res call({
    String id,
    String chapterId,
    String label,
    String? description,
    String? parentId,
    double positionX,
    double positionY,
    String? color,
    MindMapNodeType nodeType,
    String segment,
    int orderIndex,
    DateTime createdAt,
  });
}

/// @nodoc
class _$MindMapNodeCopyWithImpl<$Res, $Val extends MindMapNode>
    implements $MindMapNodeCopyWith<$Res> {
  _$MindMapNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MindMapNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? label = null,
    Object? description = freezed,
    Object? parentId = freezed,
    Object? positionX = null,
    Object? positionY = null,
    Object? color = freezed,
    Object? nodeType = null,
    Object? segment = null,
    Object? orderIndex = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            chapterId: null == chapterId
                ? _value.chapterId
                : chapterId // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            positionX: null == positionX
                ? _value.positionX
                : positionX // ignore: cast_nullable_to_non_nullable
                      as double,
            positionY: null == positionY
                ? _value.positionY
                : positionY // ignore: cast_nullable_to_non_nullable
                      as double,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            nodeType: null == nodeType
                ? _value.nodeType
                : nodeType // ignore: cast_nullable_to_non_nullable
                      as MindMapNodeType,
            segment: null == segment
                ? _value.segment
                : segment // ignore: cast_nullable_to_non_nullable
                      as String,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MindMapNodeImplCopyWith<$Res>
    implements $MindMapNodeCopyWith<$Res> {
  factory _$$MindMapNodeImplCopyWith(
    _$MindMapNodeImpl value,
    $Res Function(_$MindMapNodeImpl) then,
  ) = __$$MindMapNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String chapterId,
    String label,
    String? description,
    String? parentId,
    double positionX,
    double positionY,
    String? color,
    MindMapNodeType nodeType,
    String segment,
    int orderIndex,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$MindMapNodeImplCopyWithImpl<$Res>
    extends _$MindMapNodeCopyWithImpl<$Res, _$MindMapNodeImpl>
    implements _$$MindMapNodeImplCopyWith<$Res> {
  __$$MindMapNodeImplCopyWithImpl(
    _$MindMapNodeImpl _value,
    $Res Function(_$MindMapNodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MindMapNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? label = null,
    Object? description = freezed,
    Object? parentId = freezed,
    Object? positionX = null,
    Object? positionY = null,
    Object? color = freezed,
    Object? nodeType = null,
    Object? segment = null,
    Object? orderIndex = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$MindMapNodeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        chapterId: null == chapterId
            ? _value.chapterId
            : chapterId // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        positionX: null == positionX
            ? _value.positionX
            : positionX // ignore: cast_nullable_to_non_nullable
                  as double,
        positionY: null == positionY
            ? _value.positionY
            : positionY // ignore: cast_nullable_to_non_nullable
                  as double,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        nodeType: null == nodeType
            ? _value.nodeType
            : nodeType // ignore: cast_nullable_to_non_nullable
                  as MindMapNodeType,
        segment: null == segment
            ? _value.segment
            : segment // ignore: cast_nullable_to_non_nullable
                  as String,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MindMapNodeImpl extends _MindMapNode {
  const _$MindMapNodeImpl({
    required this.id,
    required this.chapterId,
    required this.label,
    this.description,
    this.parentId,
    this.positionX = 0.0,
    this.positionY = 0.0,
    this.color,
    this.nodeType = MindMapNodeType.detail,
    required this.segment,
    this.orderIndex = 0,
    required this.createdAt,
  }) : super._();

  factory _$MindMapNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$MindMapNodeImplFromJson(json);

  @override
  final String id;
  @override
  final String chapterId;
  @override
  final String label;
  @override
  final String? description;
  @override
  final String? parentId;
  @override
  @JsonKey()
  final double positionX;
  @override
  @JsonKey()
  final double positionY;
  @override
  final String? color;
  @override
  @JsonKey()
  final MindMapNodeType nodeType;
  @override
  final String segment;
  @override
  @JsonKey()
  final int orderIndex;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MindMapNode(id: $id, chapterId: $chapterId, label: $label, description: $description, parentId: $parentId, positionX: $positionX, positionY: $positionY, color: $color, nodeType: $nodeType, segment: $segment, orderIndex: $orderIndex, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MindMapNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.positionX, positionX) ||
                other.positionX == positionX) &&
            (identical(other.positionY, positionY) ||
                other.positionY == positionY) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.nodeType, nodeType) ||
                other.nodeType == nodeType) &&
            (identical(other.segment, segment) || other.segment == segment) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    chapterId,
    label,
    description,
    parentId,
    positionX,
    positionY,
    color,
    nodeType,
    segment,
    orderIndex,
    createdAt,
  );

  /// Create a copy of MindMapNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MindMapNodeImplCopyWith<_$MindMapNodeImpl> get copyWith =>
      __$$MindMapNodeImplCopyWithImpl<_$MindMapNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MindMapNodeImplToJson(this);
  }
}

abstract class _MindMapNode extends MindMapNode {
  const factory _MindMapNode({
    required final String id,
    required final String chapterId,
    required final String label,
    final String? description,
    final String? parentId,
    final double positionX,
    final double positionY,
    final String? color,
    final MindMapNodeType nodeType,
    required final String segment,
    final int orderIndex,
    required final DateTime createdAt,
  }) = _$MindMapNodeImpl;
  const _MindMapNode._() : super._();

  factory _MindMapNode.fromJson(Map<String, dynamic> json) =
      _$MindMapNodeImpl.fromJson;

  @override
  String get id;
  @override
  String get chapterId;
  @override
  String get label;
  @override
  String? get description;
  @override
  String? get parentId;
  @override
  double get positionX;
  @override
  double get positionY;
  @override
  String? get color;
  @override
  MindMapNodeType get nodeType;
  @override
  String get segment;
  @override
  int get orderIndex;
  @override
  DateTime get createdAt;

  /// Create a copy of MindMapNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MindMapNodeImplCopyWith<_$MindMapNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MindMap _$MindMapFromJson(Map<String, dynamic> json) {
  return _MindMap.fromJson(json);
}

/// @nodoc
mixin _$MindMap {
  String get chapterId => throw _privateConstructorUsedError;
  String get segment => throw _privateConstructorUsedError;
  List<MindMapNode> get nodes => throw _privateConstructorUsedError;

  /// Serializes this MindMap to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MindMap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MindMapCopyWith<MindMap> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MindMapCopyWith<$Res> {
  factory $MindMapCopyWith(MindMap value, $Res Function(MindMap) then) =
      _$MindMapCopyWithImpl<$Res, MindMap>;
  @useResult
  $Res call({String chapterId, String segment, List<MindMapNode> nodes});
}

/// @nodoc
class _$MindMapCopyWithImpl<$Res, $Val extends MindMap>
    implements $MindMapCopyWith<$Res> {
  _$MindMapCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MindMap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chapterId = null,
    Object? segment = null,
    Object? nodes = null,
  }) {
    return _then(
      _value.copyWith(
            chapterId: null == chapterId
                ? _value.chapterId
                : chapterId // ignore: cast_nullable_to_non_nullable
                      as String,
            segment: null == segment
                ? _value.segment
                : segment // ignore: cast_nullable_to_non_nullable
                      as String,
            nodes: null == nodes
                ? _value.nodes
                : nodes // ignore: cast_nullable_to_non_nullable
                      as List<MindMapNode>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MindMapImplCopyWith<$Res> implements $MindMapCopyWith<$Res> {
  factory _$$MindMapImplCopyWith(
    _$MindMapImpl value,
    $Res Function(_$MindMapImpl) then,
  ) = __$$MindMapImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String chapterId, String segment, List<MindMapNode> nodes});
}

/// @nodoc
class __$$MindMapImplCopyWithImpl<$Res>
    extends _$MindMapCopyWithImpl<$Res, _$MindMapImpl>
    implements _$$MindMapImplCopyWith<$Res> {
  __$$MindMapImplCopyWithImpl(
    _$MindMapImpl _value,
    $Res Function(_$MindMapImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MindMap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chapterId = null,
    Object? segment = null,
    Object? nodes = null,
  }) {
    return _then(
      _$MindMapImpl(
        chapterId: null == chapterId
            ? _value.chapterId
            : chapterId // ignore: cast_nullable_to_non_nullable
                  as String,
        segment: null == segment
            ? _value.segment
            : segment // ignore: cast_nullable_to_non_nullable
                  as String,
        nodes: null == nodes
            ? _value._nodes
            : nodes // ignore: cast_nullable_to_non_nullable
                  as List<MindMapNode>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MindMapImpl extends _MindMap {
  const _$MindMapImpl({
    required this.chapterId,
    required this.segment,
    required final List<MindMapNode> nodes,
  }) : _nodes = nodes,
       super._();

  factory _$MindMapImpl.fromJson(Map<String, dynamic> json) =>
      _$$MindMapImplFromJson(json);

  @override
  final String chapterId;
  @override
  final String segment;
  final List<MindMapNode> _nodes;
  @override
  List<MindMapNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  @override
  String toString() {
    return 'MindMap(chapterId: $chapterId, segment: $segment, nodes: $nodes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MindMapImpl &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.segment, segment) || other.segment == segment) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    chapterId,
    segment,
    const DeepCollectionEquality().hash(_nodes),
  );

  /// Create a copy of MindMap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MindMapImplCopyWith<_$MindMapImpl> get copyWith =>
      __$$MindMapImplCopyWithImpl<_$MindMapImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MindMapImplToJson(this);
  }
}

abstract class _MindMap extends MindMap {
  const factory _MindMap({
    required final String chapterId,
    required final String segment,
    required final List<MindMapNode> nodes,
  }) = _$MindMapImpl;
  const _MindMap._() : super._();

  factory _MindMap.fromJson(Map<String, dynamic> json) = _$MindMapImpl.fromJson;

  @override
  String get chapterId;
  @override
  String get segment;
  @override
  List<MindMapNode> get nodes;

  /// Create a copy of MindMap
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MindMapImplCopyWith<_$MindMapImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
