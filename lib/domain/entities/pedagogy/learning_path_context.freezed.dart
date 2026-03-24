// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_path_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LearningPathContext {
  String get pathId => throw _privateConstructorUsedError;
  String get nodeId => throw _privateConstructorUsedError;
  PathNodeType get nodeType => throw _privateConstructorUsedError;
  String? get previousRoute => throw _privateConstructorUsedError;

  /// Create a copy of LearningPathContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningPathContextCopyWith<LearningPathContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPathContextCopyWith<$Res> {
  factory $LearningPathContextCopyWith(
    LearningPathContext value,
    $Res Function(LearningPathContext) then,
  ) = _$LearningPathContextCopyWithImpl<$Res, LearningPathContext>;
  @useResult
  $Res call({
    String pathId,
    String nodeId,
    PathNodeType nodeType,
    String? previousRoute,
  });
}

/// @nodoc
class _$LearningPathContextCopyWithImpl<$Res, $Val extends LearningPathContext>
    implements $LearningPathContextCopyWith<$Res> {
  _$LearningPathContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningPathContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pathId = null,
    Object? nodeId = null,
    Object? nodeType = null,
    Object? previousRoute = freezed,
  }) {
    return _then(
      _value.copyWith(
            pathId: null == pathId
                ? _value.pathId
                : pathId // ignore: cast_nullable_to_non_nullable
                      as String,
            nodeId: null == nodeId
                ? _value.nodeId
                : nodeId // ignore: cast_nullable_to_non_nullable
                      as String,
            nodeType: null == nodeType
                ? _value.nodeType
                : nodeType // ignore: cast_nullable_to_non_nullable
                      as PathNodeType,
            previousRoute: freezed == previousRoute
                ? _value.previousRoute
                : previousRoute // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LearningPathContextImplCopyWith<$Res>
    implements $LearningPathContextCopyWith<$Res> {
  factory _$$LearningPathContextImplCopyWith(
    _$LearningPathContextImpl value,
    $Res Function(_$LearningPathContextImpl) then,
  ) = __$$LearningPathContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String pathId,
    String nodeId,
    PathNodeType nodeType,
    String? previousRoute,
  });
}

/// @nodoc
class __$$LearningPathContextImplCopyWithImpl<$Res>
    extends _$LearningPathContextCopyWithImpl<$Res, _$LearningPathContextImpl>
    implements _$$LearningPathContextImplCopyWith<$Res> {
  __$$LearningPathContextImplCopyWithImpl(
    _$LearningPathContextImpl _value,
    $Res Function(_$LearningPathContextImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LearningPathContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pathId = null,
    Object? nodeId = null,
    Object? nodeType = null,
    Object? previousRoute = freezed,
  }) {
    return _then(
      _$LearningPathContextImpl(
        pathId: null == pathId
            ? _value.pathId
            : pathId // ignore: cast_nullable_to_non_nullable
                  as String,
        nodeId: null == nodeId
            ? _value.nodeId
            : nodeId // ignore: cast_nullable_to_non_nullable
                  as String,
        nodeType: null == nodeType
            ? _value.nodeType
            : nodeType // ignore: cast_nullable_to_non_nullable
                  as PathNodeType,
        previousRoute: freezed == previousRoute
            ? _value.previousRoute
            : previousRoute // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$LearningPathContextImpl implements _LearningPathContext {
  const _$LearningPathContextImpl({
    required this.pathId,
    required this.nodeId,
    required this.nodeType,
    this.previousRoute,
  });

  @override
  final String pathId;
  @override
  final String nodeId;
  @override
  final PathNodeType nodeType;
  @override
  final String? previousRoute;

  @override
  String toString() {
    return 'LearningPathContext(pathId: $pathId, nodeId: $nodeId, nodeType: $nodeType, previousRoute: $previousRoute)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningPathContextImpl &&
            (identical(other.pathId, pathId) || other.pathId == pathId) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.nodeType, nodeType) ||
                other.nodeType == nodeType) &&
            (identical(other.previousRoute, previousRoute) ||
                other.previousRoute == previousRoute));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, pathId, nodeId, nodeType, previousRoute);

  /// Create a copy of LearningPathContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningPathContextImplCopyWith<_$LearningPathContextImpl> get copyWith =>
      __$$LearningPathContextImplCopyWithImpl<_$LearningPathContextImpl>(
        this,
        _$identity,
      );
}

abstract class _LearningPathContext implements LearningPathContext {
  const factory _LearningPathContext({
    required final String pathId,
    required final String nodeId,
    required final PathNodeType nodeType,
    final String? previousRoute,
  }) = _$LearningPathContextImpl;

  @override
  String get pathId;
  @override
  String get nodeId;
  @override
  PathNodeType get nodeType;
  @override
  String? get previousRoute;

  /// Create a copy of LearningPathContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningPathContextImplCopyWith<_$LearningPathContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CompletionResult {
  bool get completed => throw _privateConstructorUsedError;
  String get nodeId => throw _privateConstructorUsedError;
  double? get score =>
      throw _privateConstructorUsedError; // 0.0 - 100.0 for quizzes, 0.0 - 1.0 for videos
  int? get timeSpent => throw _privateConstructorUsedError; // seconds
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Create a copy of CompletionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompletionResultCopyWith<CompletionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletionResultCopyWith<$Res> {
  factory $CompletionResultCopyWith(
    CompletionResult value,
    $Res Function(CompletionResult) then,
  ) = _$CompletionResultCopyWithImpl<$Res, CompletionResult>;
  @useResult
  $Res call({
    bool completed,
    String nodeId,
    double? score,
    int? timeSpent,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$CompletionResultCopyWithImpl<$Res, $Val extends CompletionResult>
    implements $CompletionResultCopyWith<$Res> {
  _$CompletionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompletionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completed = null,
    Object? nodeId = null,
    Object? score = freezed,
    Object? timeSpent = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
            nodeId: null == nodeId
                ? _value.nodeId
                : nodeId // ignore: cast_nullable_to_non_nullable
                      as String,
            score: freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as double?,
            timeSpent: freezed == timeSpent
                ? _value.timeSpent
                : timeSpent // ignore: cast_nullable_to_non_nullable
                      as int?,
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
abstract class _$$CompletionResultImplCopyWith<$Res>
    implements $CompletionResultCopyWith<$Res> {
  factory _$$CompletionResultImplCopyWith(
    _$CompletionResultImpl value,
    $Res Function(_$CompletionResultImpl) then,
  ) = __$$CompletionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool completed,
    String nodeId,
    double? score,
    int? timeSpent,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$CompletionResultImplCopyWithImpl<$Res>
    extends _$CompletionResultCopyWithImpl<$Res, _$CompletionResultImpl>
    implements _$$CompletionResultImplCopyWith<$Res> {
  __$$CompletionResultImplCopyWithImpl(
    _$CompletionResultImpl _value,
    $Res Function(_$CompletionResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompletionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completed = null,
    Object? nodeId = null,
    Object? score = freezed,
    Object? timeSpent = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$CompletionResultImpl(
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
        nodeId: null == nodeId
            ? _value.nodeId
            : nodeId // ignore: cast_nullable_to_non_nullable
                  as String,
        score: freezed == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double?,
        timeSpent: freezed == timeSpent
            ? _value.timeSpent
            : timeSpent // ignore: cast_nullable_to_non_nullable
                  as int?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$CompletionResultImpl extends _CompletionResult {
  const _$CompletionResultImpl({
    required this.completed,
    required this.nodeId,
    this.score,
    this.timeSpent,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata,
       super._();

  @override
  final bool completed;
  @override
  final String nodeId;
  @override
  final double? score;
  // 0.0 - 100.0 for quizzes, 0.0 - 1.0 for videos
  @override
  final int? timeSpent;
  // seconds
  final Map<String, dynamic>? _metadata;
  // seconds
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
    return 'CompletionResult(completed: $completed, nodeId: $nodeId, score: $score, timeSpent: $timeSpent, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletionResultImpl &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.timeSpent, timeSpent) ||
                other.timeSpent == timeSpent) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    completed,
    nodeId,
    score,
    timeSpent,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of CompletionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletionResultImplCopyWith<_$CompletionResultImpl> get copyWith =>
      __$$CompletionResultImplCopyWithImpl<_$CompletionResultImpl>(
        this,
        _$identity,
      );
}

abstract class _CompletionResult extends CompletionResult {
  const factory _CompletionResult({
    required final bool completed,
    required final String nodeId,
    final double? score,
    final int? timeSpent,
    final Map<String, dynamic>? metadata,
  }) = _$CompletionResultImpl;
  const _CompletionResult._() : super._();

  @override
  bool get completed;
  @override
  String get nodeId;
  @override
  double? get score; // 0.0 - 100.0 for quizzes, 0.0 - 1.0 for videos
  @override
  int? get timeSpent; // seconds
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of CompletionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletionResultImplCopyWith<_$CompletionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
