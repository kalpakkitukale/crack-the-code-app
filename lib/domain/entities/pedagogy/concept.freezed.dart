// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'concept.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Concept _$ConceptFromJson(Map<String, dynamic> json) {
  return _Concept.fromJson(json);
}

/// @nodoc
mixin _$Concept {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get gradeLevel => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get chapterId => throw _privateConstructorUsedError;
  List<String> get prerequisiteIds => throw _privateConstructorUsedError;
  List<String> get dependentIds => throw _privateConstructorUsedError;
  List<String> get videoIds => throw _privateConstructorUsedError;
  List<String> get questionIds => throw _privateConstructorUsedError;
  int get estimatedMinutes => throw _privateConstructorUsedError;
  String get difficulty => throw _privateConstructorUsedError;
  List<String> get keywords => throw _privateConstructorUsedError;

  /// Serializes this Concept to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Concept
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConceptCopyWith<Concept> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConceptCopyWith<$Res> {
  factory $ConceptCopyWith(Concept value, $Res Function(Concept) then) =
      _$ConceptCopyWithImpl<$Res, Concept>;
  @useResult
  $Res call({
    String id,
    String name,
    int gradeLevel,
    String subject,
    String chapterId,
    List<String> prerequisiteIds,
    List<String> dependentIds,
    List<String> videoIds,
    List<String> questionIds,
    int estimatedMinutes,
    String difficulty,
    List<String> keywords,
  });
}

/// @nodoc
class _$ConceptCopyWithImpl<$Res, $Val extends Concept>
    implements $ConceptCopyWith<$Res> {
  _$ConceptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Concept
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? gradeLevel = null,
    Object? subject = null,
    Object? chapterId = null,
    Object? prerequisiteIds = null,
    Object? dependentIds = null,
    Object? videoIds = null,
    Object? questionIds = null,
    Object? estimatedMinutes = null,
    Object? difficulty = null,
    Object? keywords = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            gradeLevel: null == gradeLevel
                ? _value.gradeLevel
                : gradeLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            subject: null == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as String,
            chapterId: null == chapterId
                ? _value.chapterId
                : chapterId // ignore: cast_nullable_to_non_nullable
                      as String,
            prerequisiteIds: null == prerequisiteIds
                ? _value.prerequisiteIds
                : prerequisiteIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            dependentIds: null == dependentIds
                ? _value.dependentIds
                : dependentIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            videoIds: null == videoIds
                ? _value.videoIds
                : videoIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            questionIds: null == questionIds
                ? _value.questionIds
                : questionIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            estimatedMinutes: null == estimatedMinutes
                ? _value.estimatedMinutes
                : estimatedMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as String,
            keywords: null == keywords
                ? _value.keywords
                : keywords // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConceptImplCopyWith<$Res> implements $ConceptCopyWith<$Res> {
  factory _$$ConceptImplCopyWith(
    _$ConceptImpl value,
    $Res Function(_$ConceptImpl) then,
  ) = __$$ConceptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int gradeLevel,
    String subject,
    String chapterId,
    List<String> prerequisiteIds,
    List<String> dependentIds,
    List<String> videoIds,
    List<String> questionIds,
    int estimatedMinutes,
    String difficulty,
    List<String> keywords,
  });
}

/// @nodoc
class __$$ConceptImplCopyWithImpl<$Res>
    extends _$ConceptCopyWithImpl<$Res, _$ConceptImpl>
    implements _$$ConceptImplCopyWith<$Res> {
  __$$ConceptImplCopyWithImpl(
    _$ConceptImpl _value,
    $Res Function(_$ConceptImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Concept
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? gradeLevel = null,
    Object? subject = null,
    Object? chapterId = null,
    Object? prerequisiteIds = null,
    Object? dependentIds = null,
    Object? videoIds = null,
    Object? questionIds = null,
    Object? estimatedMinutes = null,
    Object? difficulty = null,
    Object? keywords = null,
  }) {
    return _then(
      _$ConceptImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        gradeLevel: null == gradeLevel
            ? _value.gradeLevel
            : gradeLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        subject: null == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String,
        chapterId: null == chapterId
            ? _value.chapterId
            : chapterId // ignore: cast_nullable_to_non_nullable
                  as String,
        prerequisiteIds: null == prerequisiteIds
            ? _value._prerequisiteIds
            : prerequisiteIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        dependentIds: null == dependentIds
            ? _value._dependentIds
            : dependentIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        videoIds: null == videoIds
            ? _value._videoIds
            : videoIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        questionIds: null == questionIds
            ? _value._questionIds
            : questionIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        estimatedMinutes: null == estimatedMinutes
            ? _value.estimatedMinutes
            : estimatedMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as String,
        keywords: null == keywords
            ? _value._keywords
            : keywords // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConceptImpl extends _Concept {
  const _$ConceptImpl({
    required this.id,
    required this.name,
    required this.gradeLevel,
    required this.subject,
    required this.chapterId,
    required final List<String> prerequisiteIds,
    required final List<String> dependentIds,
    required final List<String> videoIds,
    required final List<String> questionIds,
    this.estimatedMinutes = 15,
    this.difficulty = 'intermediate',
    final List<String> keywords = const [],
  }) : _prerequisiteIds = prerequisiteIds,
       _dependentIds = dependentIds,
       _videoIds = videoIds,
       _questionIds = questionIds,
       _keywords = keywords,
       super._();

  factory _$ConceptImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConceptImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int gradeLevel;
  @override
  final String subject;
  @override
  final String chapterId;
  final List<String> _prerequisiteIds;
  @override
  List<String> get prerequisiteIds {
    if (_prerequisiteIds is EqualUnmodifiableListView) return _prerequisiteIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prerequisiteIds);
  }

  final List<String> _dependentIds;
  @override
  List<String> get dependentIds {
    if (_dependentIds is EqualUnmodifiableListView) return _dependentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dependentIds);
  }

  final List<String> _videoIds;
  @override
  List<String> get videoIds {
    if (_videoIds is EqualUnmodifiableListView) return _videoIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videoIds);
  }

  final List<String> _questionIds;
  @override
  List<String> get questionIds {
    if (_questionIds is EqualUnmodifiableListView) return _questionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questionIds);
  }

  @override
  @JsonKey()
  final int estimatedMinutes;
  @override
  @JsonKey()
  final String difficulty;
  final List<String> _keywords;
  @override
  @JsonKey()
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  String toString() {
    return 'Concept(id: $id, name: $name, gradeLevel: $gradeLevel, subject: $subject, chapterId: $chapterId, prerequisiteIds: $prerequisiteIds, dependentIds: $dependentIds, videoIds: $videoIds, questionIds: $questionIds, estimatedMinutes: $estimatedMinutes, difficulty: $difficulty, keywords: $keywords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConceptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            const DeepCollectionEquality().equals(
              other._prerequisiteIds,
              _prerequisiteIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._dependentIds,
              _dependentIds,
            ) &&
            const DeepCollectionEquality().equals(other._videoIds, _videoIds) &&
            const DeepCollectionEquality().equals(
              other._questionIds,
              _questionIds,
            ) &&
            (identical(other.estimatedMinutes, estimatedMinutes) ||
                other.estimatedMinutes == estimatedMinutes) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    gradeLevel,
    subject,
    chapterId,
    const DeepCollectionEquality().hash(_prerequisiteIds),
    const DeepCollectionEquality().hash(_dependentIds),
    const DeepCollectionEquality().hash(_videoIds),
    const DeepCollectionEquality().hash(_questionIds),
    estimatedMinutes,
    difficulty,
    const DeepCollectionEquality().hash(_keywords),
  );

  /// Create a copy of Concept
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConceptImplCopyWith<_$ConceptImpl> get copyWith =>
      __$$ConceptImplCopyWithImpl<_$ConceptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConceptImplToJson(this);
  }
}

abstract class _Concept extends Concept {
  const factory _Concept({
    required final String id,
    required final String name,
    required final int gradeLevel,
    required final String subject,
    required final String chapterId,
    required final List<String> prerequisiteIds,
    required final List<String> dependentIds,
    required final List<String> videoIds,
    required final List<String> questionIds,
    final int estimatedMinutes,
    final String difficulty,
    final List<String> keywords,
  }) = _$ConceptImpl;
  const _Concept._() : super._();

  factory _Concept.fromJson(Map<String, dynamic> json) = _$ConceptImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get gradeLevel;
  @override
  String get subject;
  @override
  String get chapterId;
  @override
  List<String> get prerequisiteIds;
  @override
  List<String> get dependentIds;
  @override
  List<String> get videoIds;
  @override
  List<String> get questionIds;
  @override
  int get estimatedMinutes;
  @override
  String get difficulty;
  @override
  List<String> get keywords;

  /// Create a copy of Concept
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConceptImplCopyWith<_$ConceptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
