// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StudentProfile {
  String get studentId => throw _privateConstructorUsedError;
  LearningStyle get learningStyle => throw _privateConstructorUsedError;
  Map<String, double> get subjectProficiency =>
      throw _privateConstructorUsedError;
  Map<String, int> get conceptMastery => throw _privateConstructorUsedError;
  StudyPattern get studyPattern => throw _privateConstructorUsedError;
  PerformanceMetrics get performanceMetrics =>
      throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  List<String> get weakConcepts => throw _privateConstructorUsedError;
  List<String> get strongConcepts => throw _privateConstructorUsedError;
  List<String> get preferredTopics => throw _privateConstructorUsedError;
  Map<String, dynamic>? get preferences => throw _privateConstructorUsedError;

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentProfileCopyWith<StudentProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentProfileCopyWith<$Res> {
  factory $StudentProfileCopyWith(
    StudentProfile value,
    $Res Function(StudentProfile) then,
  ) = _$StudentProfileCopyWithImpl<$Res, StudentProfile>;
  @useResult
  $Res call({
    String studentId,
    LearningStyle learningStyle,
    Map<String, double> subjectProficiency,
    Map<String, int> conceptMastery,
    StudyPattern studyPattern,
    PerformanceMetrics performanceMetrics,
    DateTime lastUpdated,
    List<String> weakConcepts,
    List<String> strongConcepts,
    List<String> preferredTopics,
    Map<String, dynamic>? preferences,
  });

  $StudyPatternCopyWith<$Res> get studyPattern;
  $PerformanceMetricsCopyWith<$Res> get performanceMetrics;
}

/// @nodoc
class _$StudentProfileCopyWithImpl<$Res, $Val extends StudentProfile>
    implements $StudentProfileCopyWith<$Res> {
  _$StudentProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? learningStyle = null,
    Object? subjectProficiency = null,
    Object? conceptMastery = null,
    Object? studyPattern = null,
    Object? performanceMetrics = null,
    Object? lastUpdated = null,
    Object? weakConcepts = null,
    Object? strongConcepts = null,
    Object? preferredTopics = null,
    Object? preferences = freezed,
  }) {
    return _then(
      _value.copyWith(
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            learningStyle: null == learningStyle
                ? _value.learningStyle
                : learningStyle // ignore: cast_nullable_to_non_nullable
                      as LearningStyle,
            subjectProficiency: null == subjectProficiency
                ? _value.subjectProficiency
                : subjectProficiency // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            conceptMastery: null == conceptMastery
                ? _value.conceptMastery
                : conceptMastery // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            studyPattern: null == studyPattern
                ? _value.studyPattern
                : studyPattern // ignore: cast_nullable_to_non_nullable
                      as StudyPattern,
            performanceMetrics: null == performanceMetrics
                ? _value.performanceMetrics
                : performanceMetrics // ignore: cast_nullable_to_non_nullable
                      as PerformanceMetrics,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            weakConcepts: null == weakConcepts
                ? _value.weakConcepts
                : weakConcepts // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            strongConcepts: null == strongConcepts
                ? _value.strongConcepts
                : strongConcepts // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            preferredTopics: null == preferredTopics
                ? _value.preferredTopics
                : preferredTopics // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            preferences: freezed == preferences
                ? _value.preferences
                : preferences // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StudyPatternCopyWith<$Res> get studyPattern {
    return $StudyPatternCopyWith<$Res>(_value.studyPattern, (value) {
      return _then(_value.copyWith(studyPattern: value) as $Val);
    });
  }

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PerformanceMetricsCopyWith<$Res> get performanceMetrics {
    return $PerformanceMetricsCopyWith<$Res>(_value.performanceMetrics, (
      value,
    ) {
      return _then(_value.copyWith(performanceMetrics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StudentProfileImplCopyWith<$Res>
    implements $StudentProfileCopyWith<$Res> {
  factory _$$StudentProfileImplCopyWith(
    _$StudentProfileImpl value,
    $Res Function(_$StudentProfileImpl) then,
  ) = __$$StudentProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String studentId,
    LearningStyle learningStyle,
    Map<String, double> subjectProficiency,
    Map<String, int> conceptMastery,
    StudyPattern studyPattern,
    PerformanceMetrics performanceMetrics,
    DateTime lastUpdated,
    List<String> weakConcepts,
    List<String> strongConcepts,
    List<String> preferredTopics,
    Map<String, dynamic>? preferences,
  });

  @override
  $StudyPatternCopyWith<$Res> get studyPattern;
  @override
  $PerformanceMetricsCopyWith<$Res> get performanceMetrics;
}

/// @nodoc
class __$$StudentProfileImplCopyWithImpl<$Res>
    extends _$StudentProfileCopyWithImpl<$Res, _$StudentProfileImpl>
    implements _$$StudentProfileImplCopyWith<$Res> {
  __$$StudentProfileImplCopyWithImpl(
    _$StudentProfileImpl _value,
    $Res Function(_$StudentProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? learningStyle = null,
    Object? subjectProficiency = null,
    Object? conceptMastery = null,
    Object? studyPattern = null,
    Object? performanceMetrics = null,
    Object? lastUpdated = null,
    Object? weakConcepts = null,
    Object? strongConcepts = null,
    Object? preferredTopics = null,
    Object? preferences = freezed,
  }) {
    return _then(
      _$StudentProfileImpl(
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        learningStyle: null == learningStyle
            ? _value.learningStyle
            : learningStyle // ignore: cast_nullable_to_non_nullable
                  as LearningStyle,
        subjectProficiency: null == subjectProficiency
            ? _value._subjectProficiency
            : subjectProficiency // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        conceptMastery: null == conceptMastery
            ? _value._conceptMastery
            : conceptMastery // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        studyPattern: null == studyPattern
            ? _value.studyPattern
            : studyPattern // ignore: cast_nullable_to_non_nullable
                  as StudyPattern,
        performanceMetrics: null == performanceMetrics
            ? _value.performanceMetrics
            : performanceMetrics // ignore: cast_nullable_to_non_nullable
                  as PerformanceMetrics,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        weakConcepts: null == weakConcepts
            ? _value._weakConcepts
            : weakConcepts // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        strongConcepts: null == strongConcepts
            ? _value._strongConcepts
            : strongConcepts // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        preferredTopics: null == preferredTopics
            ? _value._preferredTopics
            : preferredTopics // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        preferences: freezed == preferences
            ? _value._preferences
            : preferences // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$StudentProfileImpl extends _StudentProfile {
  const _$StudentProfileImpl({
    required this.studentId,
    required this.learningStyle,
    required final Map<String, double> subjectProficiency,
    required final Map<String, int> conceptMastery,
    required this.studyPattern,
    required this.performanceMetrics,
    required this.lastUpdated,
    final List<String> weakConcepts = const [],
    final List<String> strongConcepts = const [],
    final List<String> preferredTopics = const [],
    final Map<String, dynamic>? preferences,
  }) : _subjectProficiency = subjectProficiency,
       _conceptMastery = conceptMastery,
       _weakConcepts = weakConcepts,
       _strongConcepts = strongConcepts,
       _preferredTopics = preferredTopics,
       _preferences = preferences,
       super._();

  @override
  final String studentId;
  @override
  final LearningStyle learningStyle;
  final Map<String, double> _subjectProficiency;
  @override
  Map<String, double> get subjectProficiency {
    if (_subjectProficiency is EqualUnmodifiableMapView)
      return _subjectProficiency;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_subjectProficiency);
  }

  final Map<String, int> _conceptMastery;
  @override
  Map<String, int> get conceptMastery {
    if (_conceptMastery is EqualUnmodifiableMapView) return _conceptMastery;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_conceptMastery);
  }

  @override
  final StudyPattern studyPattern;
  @override
  final PerformanceMetrics performanceMetrics;
  @override
  final DateTime lastUpdated;
  final List<String> _weakConcepts;
  @override
  @JsonKey()
  List<String> get weakConcepts {
    if (_weakConcepts is EqualUnmodifiableListView) return _weakConcepts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weakConcepts);
  }

  final List<String> _strongConcepts;
  @override
  @JsonKey()
  List<String> get strongConcepts {
    if (_strongConcepts is EqualUnmodifiableListView) return _strongConcepts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_strongConcepts);
  }

  final List<String> _preferredTopics;
  @override
  @JsonKey()
  List<String> get preferredTopics {
    if (_preferredTopics is EqualUnmodifiableListView) return _preferredTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferredTopics);
  }

  final Map<String, dynamic>? _preferences;
  @override
  Map<String, dynamic>? get preferences {
    final value = _preferences;
    if (value == null) return null;
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'StudentProfile(studentId: $studentId, learningStyle: $learningStyle, subjectProficiency: $subjectProficiency, conceptMastery: $conceptMastery, studyPattern: $studyPattern, performanceMetrics: $performanceMetrics, lastUpdated: $lastUpdated, weakConcepts: $weakConcepts, strongConcepts: $strongConcepts, preferredTopics: $preferredTopics, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentProfileImpl &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.learningStyle, learningStyle) ||
                other.learningStyle == learningStyle) &&
            const DeepCollectionEquality().equals(
              other._subjectProficiency,
              _subjectProficiency,
            ) &&
            const DeepCollectionEquality().equals(
              other._conceptMastery,
              _conceptMastery,
            ) &&
            (identical(other.studyPattern, studyPattern) ||
                other.studyPattern == studyPattern) &&
            (identical(other.performanceMetrics, performanceMetrics) ||
                other.performanceMetrics == performanceMetrics) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality().equals(
              other._weakConcepts,
              _weakConcepts,
            ) &&
            const DeepCollectionEquality().equals(
              other._strongConcepts,
              _strongConcepts,
            ) &&
            const DeepCollectionEquality().equals(
              other._preferredTopics,
              _preferredTopics,
            ) &&
            const DeepCollectionEquality().equals(
              other._preferences,
              _preferences,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    studentId,
    learningStyle,
    const DeepCollectionEquality().hash(_subjectProficiency),
    const DeepCollectionEquality().hash(_conceptMastery),
    studyPattern,
    performanceMetrics,
    lastUpdated,
    const DeepCollectionEquality().hash(_weakConcepts),
    const DeepCollectionEquality().hash(_strongConcepts),
    const DeepCollectionEquality().hash(_preferredTopics),
    const DeepCollectionEquality().hash(_preferences),
  );

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentProfileImplCopyWith<_$StudentProfileImpl> get copyWith =>
      __$$StudentProfileImplCopyWithImpl<_$StudentProfileImpl>(
        this,
        _$identity,
      );
}

abstract class _StudentProfile extends StudentProfile {
  const factory _StudentProfile({
    required final String studentId,
    required final LearningStyle learningStyle,
    required final Map<String, double> subjectProficiency,
    required final Map<String, int> conceptMastery,
    required final StudyPattern studyPattern,
    required final PerformanceMetrics performanceMetrics,
    required final DateTime lastUpdated,
    final List<String> weakConcepts,
    final List<String> strongConcepts,
    final List<String> preferredTopics,
    final Map<String, dynamic>? preferences,
  }) = _$StudentProfileImpl;
  const _StudentProfile._() : super._();

  @override
  String get studentId;
  @override
  LearningStyle get learningStyle;
  @override
  Map<String, double> get subjectProficiency;
  @override
  Map<String, int> get conceptMastery;
  @override
  StudyPattern get studyPattern;
  @override
  PerformanceMetrics get performanceMetrics;
  @override
  DateTime get lastUpdated;
  @override
  List<String> get weakConcepts;
  @override
  List<String> get strongConcepts;
  @override
  List<String> get preferredTopics;
  @override
  Map<String, dynamic>? get preferences;

  /// Create a copy of StudentProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentProfileImplCopyWith<_$StudentProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StudyPattern {
  int get totalSessions => throw _privateConstructorUsedError;
  int get totalMinutes => throw _privateConstructorUsedError;
  double get averageDailyMinutes => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  double get consistency => throw _privateConstructorUsedError;
  List<int> get preferredHours => throw _privateConstructorUsedError;
  Map<String, int>? get dayOfWeekDistribution =>
      throw _privateConstructorUsedError;

  /// Create a copy of StudyPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudyPatternCopyWith<StudyPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudyPatternCopyWith<$Res> {
  factory $StudyPatternCopyWith(
    StudyPattern value,
    $Res Function(StudyPattern) then,
  ) = _$StudyPatternCopyWithImpl<$Res, StudyPattern>;
  @useResult
  $Res call({
    int totalSessions,
    int totalMinutes,
    double averageDailyMinutes,
    int currentStreak,
    int longestStreak,
    double consistency,
    List<int> preferredHours,
    Map<String, int>? dayOfWeekDistribution,
  });
}

/// @nodoc
class _$StudyPatternCopyWithImpl<$Res, $Val extends StudyPattern>
    implements $StudyPatternCopyWith<$Res> {
  _$StudyPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudyPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSessions = null,
    Object? totalMinutes = null,
    Object? averageDailyMinutes = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? consistency = null,
    Object? preferredHours = null,
    Object? dayOfWeekDistribution = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalSessions: null == totalSessions
                ? _value.totalSessions
                : totalSessions // ignore: cast_nullable_to_non_nullable
                      as int,
            totalMinutes: null == totalMinutes
                ? _value.totalMinutes
                : totalMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            averageDailyMinutes: null == averageDailyMinutes
                ? _value.averageDailyMinutes
                : averageDailyMinutes // ignore: cast_nullable_to_non_nullable
                      as double,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            consistency: null == consistency
                ? _value.consistency
                : consistency // ignore: cast_nullable_to_non_nullable
                      as double,
            preferredHours: null == preferredHours
                ? _value.preferredHours
                : preferredHours // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            dayOfWeekDistribution: freezed == dayOfWeekDistribution
                ? _value.dayOfWeekDistribution
                : dayOfWeekDistribution // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudyPatternImplCopyWith<$Res>
    implements $StudyPatternCopyWith<$Res> {
  factory _$$StudyPatternImplCopyWith(
    _$StudyPatternImpl value,
    $Res Function(_$StudyPatternImpl) then,
  ) = __$$StudyPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalSessions,
    int totalMinutes,
    double averageDailyMinutes,
    int currentStreak,
    int longestStreak,
    double consistency,
    List<int> preferredHours,
    Map<String, int>? dayOfWeekDistribution,
  });
}

/// @nodoc
class __$$StudyPatternImplCopyWithImpl<$Res>
    extends _$StudyPatternCopyWithImpl<$Res, _$StudyPatternImpl>
    implements _$$StudyPatternImplCopyWith<$Res> {
  __$$StudyPatternImplCopyWithImpl(
    _$StudyPatternImpl _value,
    $Res Function(_$StudyPatternImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudyPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSessions = null,
    Object? totalMinutes = null,
    Object? averageDailyMinutes = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? consistency = null,
    Object? preferredHours = null,
    Object? dayOfWeekDistribution = freezed,
  }) {
    return _then(
      _$StudyPatternImpl(
        totalSessions: null == totalSessions
            ? _value.totalSessions
            : totalSessions // ignore: cast_nullable_to_non_nullable
                  as int,
        totalMinutes: null == totalMinutes
            ? _value.totalMinutes
            : totalMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        averageDailyMinutes: null == averageDailyMinutes
            ? _value.averageDailyMinutes
            : averageDailyMinutes // ignore: cast_nullable_to_non_nullable
                  as double,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        consistency: null == consistency
            ? _value.consistency
            : consistency // ignore: cast_nullable_to_non_nullable
                  as double,
        preferredHours: null == preferredHours
            ? _value._preferredHours
            : preferredHours // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        dayOfWeekDistribution: freezed == dayOfWeekDistribution
            ? _value._dayOfWeekDistribution
            : dayOfWeekDistribution // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
      ),
    );
  }
}

/// @nodoc

class _$StudyPatternImpl extends _StudyPattern {
  const _$StudyPatternImpl({
    required this.totalSessions,
    required this.totalMinutes,
    required this.averageDailyMinutes,
    required this.currentStreak,
    required this.longestStreak,
    required this.consistency,
    required final List<int> preferredHours,
    final Map<String, int>? dayOfWeekDistribution,
  }) : _preferredHours = preferredHours,
       _dayOfWeekDistribution = dayOfWeekDistribution,
       super._();

  @override
  final int totalSessions;
  @override
  final int totalMinutes;
  @override
  final double averageDailyMinutes;
  @override
  final int currentStreak;
  @override
  final int longestStreak;
  @override
  final double consistency;
  final List<int> _preferredHours;
  @override
  List<int> get preferredHours {
    if (_preferredHours is EqualUnmodifiableListView) return _preferredHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferredHours);
  }

  final Map<String, int>? _dayOfWeekDistribution;
  @override
  Map<String, int>? get dayOfWeekDistribution {
    final value = _dayOfWeekDistribution;
    if (value == null) return null;
    if (_dayOfWeekDistribution is EqualUnmodifiableMapView)
      return _dayOfWeekDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'StudyPattern(totalSessions: $totalSessions, totalMinutes: $totalMinutes, averageDailyMinutes: $averageDailyMinutes, currentStreak: $currentStreak, longestStreak: $longestStreak, consistency: $consistency, preferredHours: $preferredHours, dayOfWeekDistribution: $dayOfWeekDistribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudyPatternImpl &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            (identical(other.averageDailyMinutes, averageDailyMinutes) ||
                other.averageDailyMinutes == averageDailyMinutes) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.consistency, consistency) ||
                other.consistency == consistency) &&
            const DeepCollectionEquality().equals(
              other._preferredHours,
              _preferredHours,
            ) &&
            const DeepCollectionEquality().equals(
              other._dayOfWeekDistribution,
              _dayOfWeekDistribution,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalSessions,
    totalMinutes,
    averageDailyMinutes,
    currentStreak,
    longestStreak,
    consistency,
    const DeepCollectionEquality().hash(_preferredHours),
    const DeepCollectionEquality().hash(_dayOfWeekDistribution),
  );

  /// Create a copy of StudyPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudyPatternImplCopyWith<_$StudyPatternImpl> get copyWith =>
      __$$StudyPatternImplCopyWithImpl<_$StudyPatternImpl>(this, _$identity);
}

abstract class _StudyPattern extends StudyPattern {
  const factory _StudyPattern({
    required final int totalSessions,
    required final int totalMinutes,
    required final double averageDailyMinutes,
    required final int currentStreak,
    required final int longestStreak,
    required final double consistency,
    required final List<int> preferredHours,
    final Map<String, int>? dayOfWeekDistribution,
  }) = _$StudyPatternImpl;
  const _StudyPattern._() : super._();

  @override
  int get totalSessions;
  @override
  int get totalMinutes;
  @override
  double get averageDailyMinutes;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  double get consistency;
  @override
  List<int> get preferredHours;
  @override
  Map<String, int>? get dayOfWeekDistribution;

  /// Create a copy of StudyPattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudyPatternImplCopyWith<_$StudyPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PerformanceMetrics {
  int get totalQuizzes => throw _privateConstructorUsedError;
  int get passedQuizzes => throw _privateConstructorUsedError;
  double get averageScore => throw _privateConstructorUsedError;
  double get averageTimePerQuiz => throw _privateConstructorUsedError;
  int get perfectScores => throw _privateConstructorUsedError;
  int get improvements => throw _privateConstructorUsedError;
  int get declines => throw _privateConstructorUsedError;
  List<double> get recentScores => throw _privateConstructorUsedError;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerformanceMetricsCopyWith<PerformanceMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerformanceMetricsCopyWith<$Res> {
  factory $PerformanceMetricsCopyWith(
    PerformanceMetrics value,
    $Res Function(PerformanceMetrics) then,
  ) = _$PerformanceMetricsCopyWithImpl<$Res, PerformanceMetrics>;
  @useResult
  $Res call({
    int totalQuizzes,
    int passedQuizzes,
    double averageScore,
    double averageTimePerQuiz,
    int perfectScores,
    int improvements,
    int declines,
    List<double> recentScores,
  });
}

/// @nodoc
class _$PerformanceMetricsCopyWithImpl<$Res, $Val extends PerformanceMetrics>
    implements $PerformanceMetricsCopyWith<$Res> {
  _$PerformanceMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuizzes = null,
    Object? passedQuizzes = null,
    Object? averageScore = null,
    Object? averageTimePerQuiz = null,
    Object? perfectScores = null,
    Object? improvements = null,
    Object? declines = null,
    Object? recentScores = null,
  }) {
    return _then(
      _value.copyWith(
            totalQuizzes: null == totalQuizzes
                ? _value.totalQuizzes
                : totalQuizzes // ignore: cast_nullable_to_non_nullable
                      as int,
            passedQuizzes: null == passedQuizzes
                ? _value.passedQuizzes
                : passedQuizzes // ignore: cast_nullable_to_non_nullable
                      as int,
            averageScore: null == averageScore
                ? _value.averageScore
                : averageScore // ignore: cast_nullable_to_non_nullable
                      as double,
            averageTimePerQuiz: null == averageTimePerQuiz
                ? _value.averageTimePerQuiz
                : averageTimePerQuiz // ignore: cast_nullable_to_non_nullable
                      as double,
            perfectScores: null == perfectScores
                ? _value.perfectScores
                : perfectScores // ignore: cast_nullable_to_non_nullable
                      as int,
            improvements: null == improvements
                ? _value.improvements
                : improvements // ignore: cast_nullable_to_non_nullable
                      as int,
            declines: null == declines
                ? _value.declines
                : declines // ignore: cast_nullable_to_non_nullable
                      as int,
            recentScores: null == recentScores
                ? _value.recentScores
                : recentScores // ignore: cast_nullable_to_non_nullable
                      as List<double>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PerformanceMetricsImplCopyWith<$Res>
    implements $PerformanceMetricsCopyWith<$Res> {
  factory _$$PerformanceMetricsImplCopyWith(
    _$PerformanceMetricsImpl value,
    $Res Function(_$PerformanceMetricsImpl) then,
  ) = __$$PerformanceMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalQuizzes,
    int passedQuizzes,
    double averageScore,
    double averageTimePerQuiz,
    int perfectScores,
    int improvements,
    int declines,
    List<double> recentScores,
  });
}

/// @nodoc
class __$$PerformanceMetricsImplCopyWithImpl<$Res>
    extends _$PerformanceMetricsCopyWithImpl<$Res, _$PerformanceMetricsImpl>
    implements _$$PerformanceMetricsImplCopyWith<$Res> {
  __$$PerformanceMetricsImplCopyWithImpl(
    _$PerformanceMetricsImpl _value,
    $Res Function(_$PerformanceMetricsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuizzes = null,
    Object? passedQuizzes = null,
    Object? averageScore = null,
    Object? averageTimePerQuiz = null,
    Object? perfectScores = null,
    Object? improvements = null,
    Object? declines = null,
    Object? recentScores = null,
  }) {
    return _then(
      _$PerformanceMetricsImpl(
        totalQuizzes: null == totalQuizzes
            ? _value.totalQuizzes
            : totalQuizzes // ignore: cast_nullable_to_non_nullable
                  as int,
        passedQuizzes: null == passedQuizzes
            ? _value.passedQuizzes
            : passedQuizzes // ignore: cast_nullable_to_non_nullable
                  as int,
        averageScore: null == averageScore
            ? _value.averageScore
            : averageScore // ignore: cast_nullable_to_non_nullable
                  as double,
        averageTimePerQuiz: null == averageTimePerQuiz
            ? _value.averageTimePerQuiz
            : averageTimePerQuiz // ignore: cast_nullable_to_non_nullable
                  as double,
        perfectScores: null == perfectScores
            ? _value.perfectScores
            : perfectScores // ignore: cast_nullable_to_non_nullable
                  as int,
        improvements: null == improvements
            ? _value.improvements
            : improvements // ignore: cast_nullable_to_non_nullable
                  as int,
        declines: null == declines
            ? _value.declines
            : declines // ignore: cast_nullable_to_non_nullable
                  as int,
        recentScores: null == recentScores
            ? _value._recentScores
            : recentScores // ignore: cast_nullable_to_non_nullable
                  as List<double>,
      ),
    );
  }
}

/// @nodoc

class _$PerformanceMetricsImpl extends _PerformanceMetrics {
  const _$PerformanceMetricsImpl({
    required this.totalQuizzes,
    required this.passedQuizzes,
    required this.averageScore,
    required this.averageTimePerQuiz,
    required this.perfectScores,
    required this.improvements,
    required this.declines,
    final List<double> recentScores = const [],
  }) : _recentScores = recentScores,
       super._();

  @override
  final int totalQuizzes;
  @override
  final int passedQuizzes;
  @override
  final double averageScore;
  @override
  final double averageTimePerQuiz;
  @override
  final int perfectScores;
  @override
  final int improvements;
  @override
  final int declines;
  final List<double> _recentScores;
  @override
  @JsonKey()
  List<double> get recentScores {
    if (_recentScores is EqualUnmodifiableListView) return _recentScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentScores);
  }

  @override
  String toString() {
    return 'PerformanceMetrics(totalQuizzes: $totalQuizzes, passedQuizzes: $passedQuizzes, averageScore: $averageScore, averageTimePerQuiz: $averageTimePerQuiz, perfectScores: $perfectScores, improvements: $improvements, declines: $declines, recentScores: $recentScores)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerformanceMetricsImpl &&
            (identical(other.totalQuizzes, totalQuizzes) ||
                other.totalQuizzes == totalQuizzes) &&
            (identical(other.passedQuizzes, passedQuizzes) ||
                other.passedQuizzes == passedQuizzes) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.averageTimePerQuiz, averageTimePerQuiz) ||
                other.averageTimePerQuiz == averageTimePerQuiz) &&
            (identical(other.perfectScores, perfectScores) ||
                other.perfectScores == perfectScores) &&
            (identical(other.improvements, improvements) ||
                other.improvements == improvements) &&
            (identical(other.declines, declines) ||
                other.declines == declines) &&
            const DeepCollectionEquality().equals(
              other._recentScores,
              _recentScores,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalQuizzes,
    passedQuizzes,
    averageScore,
    averageTimePerQuiz,
    perfectScores,
    improvements,
    declines,
    const DeepCollectionEquality().hash(_recentScores),
  );

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerformanceMetricsImplCopyWith<_$PerformanceMetricsImpl> get copyWith =>
      __$$PerformanceMetricsImplCopyWithImpl<_$PerformanceMetricsImpl>(
        this,
        _$identity,
      );
}

abstract class _PerformanceMetrics extends PerformanceMetrics {
  const factory _PerformanceMetrics({
    required final int totalQuizzes,
    required final int passedQuizzes,
    required final double averageScore,
    required final double averageTimePerQuiz,
    required final int perfectScores,
    required final int improvements,
    required final int declines,
    final List<double> recentScores,
  }) = _$PerformanceMetricsImpl;
  const _PerformanceMetrics._() : super._();

  @override
  int get totalQuizzes;
  @override
  int get passedQuizzes;
  @override
  double get averageScore;
  @override
  double get averageTimePerQuiz;
  @override
  int get perfectScores;
  @override
  int get improvements;
  @override
  int get declines;
  @override
  List<double> get recentScores;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerformanceMetricsImplCopyWith<_$PerformanceMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
