// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QuizSession {
  String get id => throw _privateConstructorUsedError;
  String get quizId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  List<Question> get questions => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  QuizSessionState get state => throw _privateConstructorUsedError;
  int get currentQuestionIndex => throw _privateConstructorUsedError;
  Map<String, String> get answers => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;

  /// PHASE 4: Backup of answers for undo/restore functionality
  /// This stores the previous state of answers before clearAllAnswers() is called
  Map<String, String>? get answersBackup => throw _privateConstructorUsedError;

  /// Assessment type for this quiz session (readiness, knowledge, or practice)
  /// Defaults to practice for backward compatibility
  AssessmentType get assessmentType => throw _privateConstructorUsedError;

  /// Create a copy of QuizSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizSessionCopyWith<QuizSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizSessionCopyWith<$Res> {
  factory $QuizSessionCopyWith(
    QuizSession value,
    $Res Function(QuizSession) then,
  ) = _$QuizSessionCopyWithImpl<$Res, QuizSession>;
  @useResult
  $Res call({
    String id,
    String quizId,
    String studentId,
    List<Question> questions,
    DateTime startTime,
    QuizSessionState state,
    int currentQuestionIndex,
    Map<String, String> answers,
    DateTime? endTime,
    Map<String, String>? answersBackup,
    AssessmentType assessmentType,
  });
}

/// @nodoc
class _$QuizSessionCopyWithImpl<$Res, $Val extends QuizSession>
    implements $QuizSessionCopyWith<$Res> {
  _$QuizSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizId = null,
    Object? studentId = null,
    Object? questions = null,
    Object? startTime = null,
    Object? state = null,
    Object? currentQuestionIndex = null,
    Object? answers = null,
    Object? endTime = freezed,
    Object? answersBackup = freezed,
    Object? assessmentType = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            quizId: null == quizId
                ? _value.quizId
                : quizId // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            questions: null == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<Question>,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as QuizSessionState,
            currentQuestionIndex: null == currentQuestionIndex
                ? _value.currentQuestionIndex
                : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            answers: null == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            answersBackup: freezed == answersBackup
                ? _value.answersBackup
                : answersBackup // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
            assessmentType: null == assessmentType
                ? _value.assessmentType
                : assessmentType // ignore: cast_nullable_to_non_nullable
                      as AssessmentType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizSessionImplCopyWith<$Res>
    implements $QuizSessionCopyWith<$Res> {
  factory _$$QuizSessionImplCopyWith(
    _$QuizSessionImpl value,
    $Res Function(_$QuizSessionImpl) then,
  ) = __$$QuizSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String quizId,
    String studentId,
    List<Question> questions,
    DateTime startTime,
    QuizSessionState state,
    int currentQuestionIndex,
    Map<String, String> answers,
    DateTime? endTime,
    Map<String, String>? answersBackup,
    AssessmentType assessmentType,
  });
}

/// @nodoc
class __$$QuizSessionImplCopyWithImpl<$Res>
    extends _$QuizSessionCopyWithImpl<$Res, _$QuizSessionImpl>
    implements _$$QuizSessionImplCopyWith<$Res> {
  __$$QuizSessionImplCopyWithImpl(
    _$QuizSessionImpl _value,
    $Res Function(_$QuizSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizId = null,
    Object? studentId = null,
    Object? questions = null,
    Object? startTime = null,
    Object? state = null,
    Object? currentQuestionIndex = null,
    Object? answers = null,
    Object? endTime = freezed,
    Object? answersBackup = freezed,
    Object? assessmentType = null,
  }) {
    return _then(
      _$QuizSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        quizId: null == quizId
            ? _value.quizId
            : quizId // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        questions: null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<Question>,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as QuizSessionState,
        currentQuestionIndex: null == currentQuestionIndex
            ? _value.currentQuestionIndex
            : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        answers: null == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        answersBackup: freezed == answersBackup
            ? _value._answersBackup
            : answersBackup // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        assessmentType: null == assessmentType
            ? _value.assessmentType
            : assessmentType // ignore: cast_nullable_to_non_nullable
                  as AssessmentType,
      ),
    );
  }
}

/// @nodoc

class _$QuizSessionImpl extends _QuizSession {
  const _$QuizSessionImpl({
    required this.id,
    required this.quizId,
    required this.studentId,
    required final List<Question> questions,
    required this.startTime,
    required this.state,
    this.currentQuestionIndex = 0,
    final Map<String, String> answers = const {},
    this.endTime,
    final Map<String, String>? answersBackup,
    this.assessmentType = AssessmentType.practice,
  }) : _questions = questions,
       _answers = answers,
       _answersBackup = answersBackup,
       super._();

  @override
  final String id;
  @override
  final String quizId;
  @override
  final String studentId;
  final List<Question> _questions;
  @override
  List<Question> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  final DateTime startTime;
  @override
  final QuizSessionState state;
  @override
  @JsonKey()
  final int currentQuestionIndex;
  final Map<String, String> _answers;
  @override
  @JsonKey()
  Map<String, String> get answers {
    if (_answers is EqualUnmodifiableMapView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_answers);
  }

  @override
  final DateTime? endTime;

  /// PHASE 4: Backup of answers for undo/restore functionality
  /// This stores the previous state of answers before clearAllAnswers() is called
  final Map<String, String>? _answersBackup;

  /// PHASE 4: Backup of answers for undo/restore functionality
  /// This stores the previous state of answers before clearAllAnswers() is called
  @override
  Map<String, String>? get answersBackup {
    final value = _answersBackup;
    if (value == null) return null;
    if (_answersBackup is EqualUnmodifiableMapView) return _answersBackup;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Assessment type for this quiz session (readiness, knowledge, or practice)
  /// Defaults to practice for backward compatibility
  @override
  @JsonKey()
  final AssessmentType assessmentType;

  @override
  String toString() {
    return 'QuizSession(id: $id, quizId: $quizId, studentId: $studentId, questions: $questions, startTime: $startTime, state: $state, currentQuestionIndex: $currentQuestionIndex, answers: $answers, endTime: $endTime, answersBackup: $answersBackup, assessmentType: $assessmentType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quizId, quizId) || other.quizId == quizId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.currentQuestionIndex, currentQuestionIndex) ||
                other.currentQuestionIndex == currentQuestionIndex) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            const DeepCollectionEquality().equals(
              other._answersBackup,
              _answersBackup,
            ) &&
            (identical(other.assessmentType, assessmentType) ||
                other.assessmentType == assessmentType));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    quizId,
    studentId,
    const DeepCollectionEquality().hash(_questions),
    startTime,
    state,
    currentQuestionIndex,
    const DeepCollectionEquality().hash(_answers),
    endTime,
    const DeepCollectionEquality().hash(_answersBackup),
    assessmentType,
  );

  /// Create a copy of QuizSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizSessionImplCopyWith<_$QuizSessionImpl> get copyWith =>
      __$$QuizSessionImplCopyWithImpl<_$QuizSessionImpl>(this, _$identity);
}

abstract class _QuizSession extends QuizSession {
  const factory _QuizSession({
    required final String id,
    required final String quizId,
    required final String studentId,
    required final List<Question> questions,
    required final DateTime startTime,
    required final QuizSessionState state,
    final int currentQuestionIndex,
    final Map<String, String> answers,
    final DateTime? endTime,
    final Map<String, String>? answersBackup,
    final AssessmentType assessmentType,
  }) = _$QuizSessionImpl;
  const _QuizSession._() : super._();

  @override
  String get id;
  @override
  String get quizId;
  @override
  String get studentId;
  @override
  List<Question> get questions;
  @override
  DateTime get startTime;
  @override
  QuizSessionState get state;
  @override
  int get currentQuestionIndex;
  @override
  Map<String, String> get answers;
  @override
  DateTime? get endTime;

  /// PHASE 4: Backup of answers for undo/restore functionality
  /// This stores the previous state of answers before clearAllAnswers() is called
  @override
  Map<String, String>? get answersBackup;

  /// Assessment type for this quiz session (readiness, knowledge, or practice)
  /// Defaults to practice for backward compatibility
  @override
  AssessmentType get assessmentType;

  /// Create a copy of QuizSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizSessionImplCopyWith<_$QuizSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
