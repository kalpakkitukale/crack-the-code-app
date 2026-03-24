// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Quiz {
  String get id => throw _privateConstructorUsedError;
  QuizLevel get level => throw _privateConstructorUsedError;
  String get entityId => throw _privateConstructorUsedError;
  List<String> get questionIds => throw _privateConstructorUsedError;
  int get timeLimit => throw _privateConstructorUsedError;
  double get passingScore => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  Map<String, dynamic>? get config => throw _privateConstructorUsedError;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizCopyWith<Quiz> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizCopyWith<$Res> {
  factory $QuizCopyWith(Quiz value, $Res Function(Quiz) then) =
      _$QuizCopyWithImpl<$Res, Quiz>;
  @useResult
  $Res call({
    String id,
    QuizLevel level,
    String entityId,
    List<String> questionIds,
    int timeLimit,
    double passingScore,
    String? title,
    Map<String, dynamic>? config,
  });
}

/// @nodoc
class _$QuizCopyWithImpl<$Res, $Val extends Quiz>
    implements $QuizCopyWith<$Res> {
  _$QuizCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? level = null,
    Object? entityId = null,
    Object? questionIds = null,
    Object? timeLimit = null,
    Object? passingScore = null,
    Object? title = freezed,
    Object? config = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as QuizLevel,
            entityId: null == entityId
                ? _value.entityId
                : entityId // ignore: cast_nullable_to_non_nullable
                      as String,
            questionIds: null == questionIds
                ? _value.questionIds
                : questionIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            timeLimit: null == timeLimit
                ? _value.timeLimit
                : timeLimit // ignore: cast_nullable_to_non_nullable
                      as int,
            passingScore: null == passingScore
                ? _value.passingScore
                : passingScore // ignore: cast_nullable_to_non_nullable
                      as double,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            config: freezed == config
                ? _value.config
                : config // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizImplCopyWith<$Res> implements $QuizCopyWith<$Res> {
  factory _$$QuizImplCopyWith(
    _$QuizImpl value,
    $Res Function(_$QuizImpl) then,
  ) = __$$QuizImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    QuizLevel level,
    String entityId,
    List<String> questionIds,
    int timeLimit,
    double passingScore,
    String? title,
    Map<String, dynamic>? config,
  });
}

/// @nodoc
class __$$QuizImplCopyWithImpl<$Res>
    extends _$QuizCopyWithImpl<$Res, _$QuizImpl>
    implements _$$QuizImplCopyWith<$Res> {
  __$$QuizImplCopyWithImpl(_$QuizImpl _value, $Res Function(_$QuizImpl) _then)
    : super(_value, _then);

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? level = null,
    Object? entityId = null,
    Object? questionIds = null,
    Object? timeLimit = null,
    Object? passingScore = null,
    Object? title = freezed,
    Object? config = freezed,
  }) {
    return _then(
      _$QuizImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as QuizLevel,
        entityId: null == entityId
            ? _value.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        questionIds: null == questionIds
            ? _value._questionIds
            : questionIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        timeLimit: null == timeLimit
            ? _value.timeLimit
            : timeLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        passingScore: null == passingScore
            ? _value.passingScore
            : passingScore // ignore: cast_nullable_to_non_nullable
                  as double,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        config: freezed == config
            ? _value._config
            : config // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$QuizImpl extends _Quiz {
  const _$QuizImpl({
    required this.id,
    required this.level,
    required this.entityId,
    required final List<String> questionIds,
    required this.timeLimit,
    this.passingScore = 0.75,
    this.title,
    final Map<String, dynamic>? config,
  }) : _questionIds = questionIds,
       _config = config,
       super._();

  @override
  final String id;
  @override
  final QuizLevel level;
  @override
  final String entityId;
  final List<String> _questionIds;
  @override
  List<String> get questionIds {
    if (_questionIds is EqualUnmodifiableListView) return _questionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questionIds);
  }

  @override
  final int timeLimit;
  @override
  @JsonKey()
  final double passingScore;
  @override
  final String? title;
  final Map<String, dynamic>? _config;
  @override
  Map<String, dynamic>? get config {
    final value = _config;
    if (value == null) return null;
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Quiz(id: $id, level: $level, entityId: $entityId, questionIds: $questionIds, timeLimit: $timeLimit, passingScore: $passingScore, title: $title, config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            const DeepCollectionEquality().equals(
              other._questionIds,
              _questionIds,
            ) &&
            (identical(other.timeLimit, timeLimit) ||
                other.timeLimit == timeLimit) &&
            (identical(other.passingScore, passingScore) ||
                other.passingScore == passingScore) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._config, _config));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    level,
    entityId,
    const DeepCollectionEquality().hash(_questionIds),
    timeLimit,
    passingScore,
    title,
    const DeepCollectionEquality().hash(_config),
  );

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizImplCopyWith<_$QuizImpl> get copyWith =>
      __$$QuizImplCopyWithImpl<_$QuizImpl>(this, _$identity);
}

abstract class _Quiz extends Quiz {
  const factory _Quiz({
    required final String id,
    required final QuizLevel level,
    required final String entityId,
    required final List<String> questionIds,
    required final int timeLimit,
    final double passingScore,
    final String? title,
    final Map<String, dynamic>? config,
  }) = _$QuizImpl;
  const _Quiz._() : super._();

  @override
  String get id;
  @override
  QuizLevel get level;
  @override
  String get entityId;
  @override
  List<String> get questionIds;
  @override
  int get timeLimit;
  @override
  double get passingScore;
  @override
  String? get title;
  @override
  Map<String, dynamic>? get config;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizImplCopyWith<_$QuizImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
