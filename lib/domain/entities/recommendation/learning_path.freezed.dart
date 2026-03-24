// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_path.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LearningPath {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get subjectId => throw _privateConstructorUsedError;
  List<PathNode> get nodes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  PathStatus get status => throw _privateConstructorUsedError;
  int get currentNodeIndex => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Create a copy of LearningPath
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningPathCopyWith<LearningPath> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPathCopyWith<$Res> {
  factory $LearningPathCopyWith(
    LearningPath value,
    $Res Function(LearningPath) then,
  ) = _$LearningPathCopyWithImpl<$Res, LearningPath>;
  @useResult
  $Res call({
    String id,
    String studentId,
    String subjectId,
    List<PathNode> nodes,
    DateTime createdAt,
    DateTime lastUpdated,
    PathStatus status,
    int currentNodeIndex,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$LearningPathCopyWithImpl<$Res, $Val extends LearningPath>
    implements $LearningPathCopyWith<$Res> {
  _$LearningPathCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningPath
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? subjectId = null,
    Object? nodes = null,
    Object? createdAt = null,
    Object? lastUpdated = null,
    Object? status = null,
    Object? currentNodeIndex = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            subjectId: null == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                      as String,
            nodes: null == nodes
                ? _value.nodes
                : nodes // ignore: cast_nullable_to_non_nullable
                      as List<PathNode>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PathStatus,
            currentNodeIndex: null == currentNodeIndex
                ? _value.currentNodeIndex
                : currentNodeIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LearningPathImplCopyWith<$Res>
    implements $LearningPathCopyWith<$Res> {
  factory _$$LearningPathImplCopyWith(
    _$LearningPathImpl value,
    $Res Function(_$LearningPathImpl) then,
  ) = __$$LearningPathImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String studentId,
    String subjectId,
    List<PathNode> nodes,
    DateTime createdAt,
    DateTime lastUpdated,
    PathStatus status,
    int currentNodeIndex,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$LearningPathImplCopyWithImpl<$Res>
    extends _$LearningPathCopyWithImpl<$Res, _$LearningPathImpl>
    implements _$$LearningPathImplCopyWith<$Res> {
  __$$LearningPathImplCopyWithImpl(
    _$LearningPathImpl _value,
    $Res Function(_$LearningPathImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LearningPath
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? subjectId = null,
    Object? nodes = null,
    Object? createdAt = null,
    Object? lastUpdated = null,
    Object? status = null,
    Object? currentNodeIndex = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$LearningPathImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        subjectId: null == subjectId
            ? _value.subjectId
            : subjectId // ignore: cast_nullable_to_non_nullable
                  as String,
        nodes: null == nodes
            ? _value._nodes
            : nodes // ignore: cast_nullable_to_non_nullable
                  as List<PathNode>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PathStatus,
        currentNodeIndex: null == currentNodeIndex
            ? _value.currentNodeIndex
            : currentNodeIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$LearningPathImpl extends _LearningPath {
  const _$LearningPathImpl({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required final List<PathNode> nodes,
    required this.createdAt,
    required this.lastUpdated,
    this.status = PathStatus.active,
    this.currentNodeIndex = 0,
    final Map<String, dynamic>? metadata,
  }) : _nodes = nodes,
       _metadata = metadata,
       super._();

  @override
  final String id;
  @override
  final String studentId;
  @override
  final String subjectId;
  final List<PathNode> _nodes;
  @override
  List<PathNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime lastUpdated;
  @override
  @JsonKey()
  final PathStatus status;
  @override
  @JsonKey()
  final int currentNodeIndex;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'LearningPath(id: $id, studentId: $studentId, subjectId: $subjectId, nodes: $nodes, createdAt: $createdAt, lastUpdated: $lastUpdated, status: $status, currentNodeIndex: $currentNodeIndex, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningPathImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentNodeIndex, currentNodeIndex) ||
                other.currentNodeIndex == currentNodeIndex) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentId,
    subjectId,
    const DeepCollectionEquality().hash(_nodes),
    createdAt,
    lastUpdated,
    status,
    currentNodeIndex,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of LearningPath
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningPathImplCopyWith<_$LearningPathImpl> get copyWith =>
      __$$LearningPathImplCopyWithImpl<_$LearningPathImpl>(this, _$identity);
}

abstract class _LearningPath extends LearningPath {
  const factory _LearningPath({
    required final String id,
    required final String studentId,
    required final String subjectId,
    required final List<PathNode> nodes,
    required final DateTime createdAt,
    required final DateTime lastUpdated,
    final PathStatus status,
    final int currentNodeIndex,
    final Map<String, dynamic>? metadata,
  }) = _$LearningPathImpl;
  const _LearningPath._() : super._();

  @override
  String get id;
  @override
  String get studentId;
  @override
  String get subjectId;
  @override
  List<PathNode> get nodes;
  @override
  DateTime get createdAt;
  @override
  DateTime get lastUpdated;
  @override
  PathStatus get status;
  @override
  int get currentNodeIndex;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of LearningPath
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningPathImplCopyWith<_$LearningPathImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PathNode {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  PathNodeType get type => throw _privateConstructorUsedError;
  String get entityId => throw _privateConstructorUsedError;
  int get estimatedDuration => throw _privateConstructorUsedError;
  String get difficulty => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  bool get locked => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  double? get scorePercentage => throw _privateConstructorUsedError;
  List<String>? get prerequisites => throw _privateConstructorUsedError;

  /// Create a copy of PathNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PathNodeCopyWith<PathNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PathNodeCopyWith<$Res> {
  factory $PathNodeCopyWith(PathNode value, $Res Function(PathNode) then) =
      _$PathNodeCopyWithImpl<$Res, PathNode>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    PathNodeType type,
    String entityId,
    int estimatedDuration,
    String difficulty,
    bool completed,
    bool locked,
    DateTime? completedAt,
    double? scorePercentage,
    List<String>? prerequisites,
  });
}

/// @nodoc
class _$PathNodeCopyWithImpl<$Res, $Val extends PathNode>
    implements $PathNodeCopyWith<$Res> {
  _$PathNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PathNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? entityId = null,
    Object? estimatedDuration = null,
    Object? difficulty = null,
    Object? completed = null,
    Object? locked = null,
    Object? completedAt = freezed,
    Object? scorePercentage = freezed,
    Object? prerequisites = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as PathNodeType,
            entityId: null == entityId
                ? _value.entityId
                : entityId // ignore: cast_nullable_to_non_nullable
                      as String,
            estimatedDuration: null == estimatedDuration
                ? _value.estimatedDuration
                : estimatedDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as String,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
            locked: null == locked
                ? _value.locked
                : locked // ignore: cast_nullable_to_non_nullable
                      as bool,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            scorePercentage: freezed == scorePercentage
                ? _value.scorePercentage
                : scorePercentage // ignore: cast_nullable_to_non_nullable
                      as double?,
            prerequisites: freezed == prerequisites
                ? _value.prerequisites
                : prerequisites // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PathNodeImplCopyWith<$Res>
    implements $PathNodeCopyWith<$Res> {
  factory _$$PathNodeImplCopyWith(
    _$PathNodeImpl value,
    $Res Function(_$PathNodeImpl) then,
  ) = __$$PathNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    PathNodeType type,
    String entityId,
    int estimatedDuration,
    String difficulty,
    bool completed,
    bool locked,
    DateTime? completedAt,
    double? scorePercentage,
    List<String>? prerequisites,
  });
}

/// @nodoc
class __$$PathNodeImplCopyWithImpl<$Res>
    extends _$PathNodeCopyWithImpl<$Res, _$PathNodeImpl>
    implements _$$PathNodeImplCopyWith<$Res> {
  __$$PathNodeImplCopyWithImpl(
    _$PathNodeImpl _value,
    $Res Function(_$PathNodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PathNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? entityId = null,
    Object? estimatedDuration = null,
    Object? difficulty = null,
    Object? completed = null,
    Object? locked = null,
    Object? completedAt = freezed,
    Object? scorePercentage = freezed,
    Object? prerequisites = freezed,
  }) {
    return _then(
      _$PathNodeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as PathNodeType,
        entityId: null == entityId
            ? _value.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        estimatedDuration: null == estimatedDuration
            ? _value.estimatedDuration
            : estimatedDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as String,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
        locked: null == locked
            ? _value.locked
            : locked // ignore: cast_nullable_to_non_nullable
                  as bool,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        scorePercentage: freezed == scorePercentage
            ? _value.scorePercentage
            : scorePercentage // ignore: cast_nullable_to_non_nullable
                  as double?,
        prerequisites: freezed == prerequisites
            ? _value._prerequisites
            : prerequisites // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc

class _$PathNodeImpl extends _PathNode {
  const _$PathNodeImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.entityId,
    required this.estimatedDuration,
    required this.difficulty,
    this.completed = false,
    this.locked = false,
    this.completedAt,
    this.scorePercentage,
    final List<String>? prerequisites,
  }) : _prerequisites = prerequisites,
       super._();

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final PathNodeType type;
  @override
  final String entityId;
  @override
  final int estimatedDuration;
  @override
  final String difficulty;
  @override
  @JsonKey()
  final bool completed;
  @override
  @JsonKey()
  final bool locked;
  @override
  final DateTime? completedAt;
  @override
  final double? scorePercentage;
  final List<String>? _prerequisites;
  @override
  List<String>? get prerequisites {
    final value = _prerequisites;
    if (value == null) return null;
    if (_prerequisites is EqualUnmodifiableListView) return _prerequisites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PathNode(id: $id, title: $title, description: $description, type: $type, entityId: $entityId, estimatedDuration: $estimatedDuration, difficulty: $difficulty, completed: $completed, locked: $locked, completedAt: $completedAt, scorePercentage: $scorePercentage, prerequisites: $prerequisites)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PathNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.locked, locked) || other.locked == locked) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.scorePercentage, scorePercentage) ||
                other.scorePercentage == scorePercentage) &&
            const DeepCollectionEquality().equals(
              other._prerequisites,
              _prerequisites,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    type,
    entityId,
    estimatedDuration,
    difficulty,
    completed,
    locked,
    completedAt,
    scorePercentage,
    const DeepCollectionEquality().hash(_prerequisites),
  );

  /// Create a copy of PathNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PathNodeImplCopyWith<_$PathNodeImpl> get copyWith =>
      __$$PathNodeImplCopyWithImpl<_$PathNodeImpl>(this, _$identity);
}

abstract class _PathNode extends PathNode {
  const factory _PathNode({
    required final String id,
    required final String title,
    required final String description,
    required final PathNodeType type,
    required final String entityId,
    required final int estimatedDuration,
    required final String difficulty,
    final bool completed,
    final bool locked,
    final DateTime? completedAt,
    final double? scorePercentage,
    final List<String>? prerequisites,
  }) = _$PathNodeImpl;
  const _PathNode._() : super._();

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  PathNodeType get type;
  @override
  String get entityId;
  @override
  int get estimatedDuration;
  @override
  String get difficulty;
  @override
  bool get completed;
  @override
  bool get locked;
  @override
  DateTime? get completedAt;
  @override
  double? get scorePercentage;
  @override
  List<String>? get prerequisites;

  /// Create a copy of PathNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PathNodeImplCopyWith<_$PathNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
