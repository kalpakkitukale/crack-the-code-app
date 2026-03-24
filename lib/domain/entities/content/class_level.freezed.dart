// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'class_level.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ClassLevel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<Stream> get streams => throw _privateConstructorUsedError;

  /// Create a copy of ClassLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClassLevelCopyWith<ClassLevel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClassLevelCopyWith<$Res> {
  factory $ClassLevelCopyWith(
    ClassLevel value,
    $Res Function(ClassLevel) then,
  ) = _$ClassLevelCopyWithImpl<$Res, ClassLevel>;
  @useResult
  $Res call({String id, String name, List<Stream> streams});
}

/// @nodoc
class _$ClassLevelCopyWithImpl<$Res, $Val extends ClassLevel>
    implements $ClassLevelCopyWith<$Res> {
  _$ClassLevelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClassLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? streams = null}) {
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
            streams: null == streams
                ? _value.streams
                : streams // ignore: cast_nullable_to_non_nullable
                      as List<Stream>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClassLevelImplCopyWith<$Res>
    implements $ClassLevelCopyWith<$Res> {
  factory _$$ClassLevelImplCopyWith(
    _$ClassLevelImpl value,
    $Res Function(_$ClassLevelImpl) then,
  ) = __$$ClassLevelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, List<Stream> streams});
}

/// @nodoc
class __$$ClassLevelImplCopyWithImpl<$Res>
    extends _$ClassLevelCopyWithImpl<$Res, _$ClassLevelImpl>
    implements _$$ClassLevelImplCopyWith<$Res> {
  __$$ClassLevelImplCopyWithImpl(
    _$ClassLevelImpl _value,
    $Res Function(_$ClassLevelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClassLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? streams = null}) {
    return _then(
      _$ClassLevelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        streams: null == streams
            ? _value._streams
            : streams // ignore: cast_nullable_to_non_nullable
                  as List<Stream>,
      ),
    );
  }
}

/// @nodoc

class _$ClassLevelImpl extends _ClassLevel {
  const _$ClassLevelImpl({
    required this.id,
    required this.name,
    required final List<Stream> streams,
  }) : _streams = streams,
       super._();

  @override
  final String id;
  @override
  final String name;
  final List<Stream> _streams;
  @override
  List<Stream> get streams {
    if (_streams is EqualUnmodifiableListView) return _streams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_streams);
  }

  @override
  String toString() {
    return 'ClassLevel(id: $id, name: $name, streams: $streams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassLevelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._streams, _streams));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_streams),
  );

  /// Create a copy of ClassLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassLevelImplCopyWith<_$ClassLevelImpl> get copyWith =>
      __$$ClassLevelImplCopyWithImpl<_$ClassLevelImpl>(this, _$identity);
}

abstract class _ClassLevel extends ClassLevel {
  const factory _ClassLevel({
    required final String id,
    required final String name,
    required final List<Stream> streams,
  }) = _$ClassLevelImpl;
  const _ClassLevel._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  List<Stream> get streams;

  /// Create a copy of ClassLevel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClassLevelImplCopyWith<_$ClassLevelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
