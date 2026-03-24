// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Question {
  String get id => throw _privateConstructorUsedError;
  String get questionText => throw _privateConstructorUsedError;
  QuestionType get questionType => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  String get correctAnswer => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;
  List<String> get hints => throw _privateConstructorUsedError;
  String get difficulty => throw _privateConstructorUsedError;
  List<String> get conceptTags => throw _privateConstructorUsedError;
  List<String> get topicIds =>
      throw _privateConstructorUsedError; // Topics this question belongs to
  String? get videoTimestamp => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionCopyWith<Question> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) then) =
      _$QuestionCopyWithImpl<$Res, Question>;
  @useResult
  $Res call({
    String id,
    String questionText,
    QuestionType questionType,
    List<String> options,
    String correctAnswer,
    String explanation,
    List<String> hints,
    String difficulty,
    List<String> conceptTags,
    List<String> topicIds,
    String? videoTimestamp,
    int points,
  });
}

/// @nodoc
class _$QuestionCopyWithImpl<$Res, $Val extends Question>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionText = null,
    Object? questionType = null,
    Object? options = null,
    Object? correctAnswer = null,
    Object? explanation = null,
    Object? hints = null,
    Object? difficulty = null,
    Object? conceptTags = null,
    Object? topicIds = null,
    Object? videoTimestamp = freezed,
    Object? points = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            questionText: null == questionText
                ? _value.questionText
                : questionText // ignore: cast_nullable_to_non_nullable
                      as String,
            questionType: null == questionType
                ? _value.questionType
                : questionType // ignore: cast_nullable_to_non_nullable
                      as QuestionType,
            options: null == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            correctAnswer: null == correctAnswer
                ? _value.correctAnswer
                : correctAnswer // ignore: cast_nullable_to_non_nullable
                      as String,
            explanation: null == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String,
            hints: null == hints
                ? _value.hints
                : hints // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as String,
            conceptTags: null == conceptTags
                ? _value.conceptTags
                : conceptTags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            topicIds: null == topicIds
                ? _value.topicIds
                : topicIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            videoTimestamp: freezed == videoTimestamp
                ? _value.videoTimestamp
                : videoTimestamp // ignore: cast_nullable_to_non_nullable
                      as String?,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuestionImplCopyWith<$Res>
    implements $QuestionCopyWith<$Res> {
  factory _$$QuestionImplCopyWith(
    _$QuestionImpl value,
    $Res Function(_$QuestionImpl) then,
  ) = __$$QuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String questionText,
    QuestionType questionType,
    List<String> options,
    String correctAnswer,
    String explanation,
    List<String> hints,
    String difficulty,
    List<String> conceptTags,
    List<String> topicIds,
    String? videoTimestamp,
    int points,
  });
}

/// @nodoc
class __$$QuestionImplCopyWithImpl<$Res>
    extends _$QuestionCopyWithImpl<$Res, _$QuestionImpl>
    implements _$$QuestionImplCopyWith<$Res> {
  __$$QuestionImplCopyWithImpl(
    _$QuestionImpl _value,
    $Res Function(_$QuestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionText = null,
    Object? questionType = null,
    Object? options = null,
    Object? correctAnswer = null,
    Object? explanation = null,
    Object? hints = null,
    Object? difficulty = null,
    Object? conceptTags = null,
    Object? topicIds = null,
    Object? videoTimestamp = freezed,
    Object? points = null,
  }) {
    return _then(
      _$QuestionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        questionText: null == questionText
            ? _value.questionText
            : questionText // ignore: cast_nullable_to_non_nullable
                  as String,
        questionType: null == questionType
            ? _value.questionType
            : questionType // ignore: cast_nullable_to_non_nullable
                  as QuestionType,
        options: null == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        correctAnswer: null == correctAnswer
            ? _value.correctAnswer
            : correctAnswer // ignore: cast_nullable_to_non_nullable
                  as String,
        explanation: null == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String,
        hints: null == hints
            ? _value._hints
            : hints // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as String,
        conceptTags: null == conceptTags
            ? _value._conceptTags
            : conceptTags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        topicIds: null == topicIds
            ? _value._topicIds
            : topicIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        videoTimestamp: freezed == videoTimestamp
            ? _value.videoTimestamp
            : videoTimestamp // ignore: cast_nullable_to_non_nullable
                  as String?,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$QuestionImpl extends _Question {
  const _$QuestionImpl({
    required this.id,
    required this.questionText,
    required this.questionType,
    required final List<String> options,
    required this.correctAnswer,
    required this.explanation,
    required final List<String> hints,
    required this.difficulty,
    required final List<String> conceptTags,
    final List<String> topicIds = const [],
    this.videoTimestamp,
    this.points = 1,
  }) : _options = options,
       _hints = hints,
       _conceptTags = conceptTags,
       _topicIds = topicIds,
       super._();

  @override
  final String id;
  @override
  final String questionText;
  @override
  final QuestionType questionType;
  final List<String> _options;
  @override
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final String correctAnswer;
  @override
  final String explanation;
  final List<String> _hints;
  @override
  List<String> get hints {
    if (_hints is EqualUnmodifiableListView) return _hints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hints);
  }

  @override
  final String difficulty;
  final List<String> _conceptTags;
  @override
  List<String> get conceptTags {
    if (_conceptTags is EqualUnmodifiableListView) return _conceptTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conceptTags);
  }

  final List<String> _topicIds;
  @override
  @JsonKey()
  List<String> get topicIds {
    if (_topicIds is EqualUnmodifiableListView) return _topicIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topicIds);
  }

  // Topics this question belongs to
  @override
  final String? videoTimestamp;
  @override
  @JsonKey()
  final int points;

  @override
  String toString() {
    return 'Question(id: $id, questionText: $questionText, questionType: $questionType, options: $options, correctAnswer: $correctAnswer, explanation: $explanation, hints: $hints, difficulty: $difficulty, conceptTags: $conceptTags, topicIds: $topicIds, videoTimestamp: $videoTimestamp, points: $points)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            const DeepCollectionEquality().equals(other._hints, _hints) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(
              other._conceptTags,
              _conceptTags,
            ) &&
            const DeepCollectionEquality().equals(other._topicIds, _topicIds) &&
            (identical(other.videoTimestamp, videoTimestamp) ||
                other.videoTimestamp == videoTimestamp) &&
            (identical(other.points, points) || other.points == points));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    questionText,
    questionType,
    const DeepCollectionEquality().hash(_options),
    correctAnswer,
    explanation,
    const DeepCollectionEquality().hash(_hints),
    difficulty,
    const DeepCollectionEquality().hash(_conceptTags),
    const DeepCollectionEquality().hash(_topicIds),
    videoTimestamp,
    points,
  );

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      __$$QuestionImplCopyWithImpl<_$QuestionImpl>(this, _$identity);
}

abstract class _Question extends Question {
  const factory _Question({
    required final String id,
    required final String questionText,
    required final QuestionType questionType,
    required final List<String> options,
    required final String correctAnswer,
    required final String explanation,
    required final List<String> hints,
    required final String difficulty,
    required final List<String> conceptTags,
    final List<String> topicIds,
    final String? videoTimestamp,
    final int points,
  }) = _$QuestionImpl;
  const _Question._() : super._();

  @override
  String get id;
  @override
  String get questionText;
  @override
  QuestionType get questionType;
  @override
  List<String> get options;
  @override
  String get correctAnswer;
  @override
  String get explanation;
  @override
  List<String> get hints;
  @override
  String get difficulty;
  @override
  List<String> get conceptTags;
  @override
  List<String> get topicIds; // Topics this question belongs to
  @override
  String? get videoTimestamp;
  @override
  int get points;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
