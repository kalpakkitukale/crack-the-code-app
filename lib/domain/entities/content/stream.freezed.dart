// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stream.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Stream {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<String> get subjects => throw _privateConstructorUsedError;

  /// Create a copy of Stream
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StreamCopyWith<Stream> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreamCopyWith<$Res> {
  factory $StreamCopyWith(Stream value, $Res Function(Stream) then) =
      _$StreamCopyWithImpl<$Res, Stream>;
  @useResult
  $Res call({String id, String name, List<String> subjects});
}

/// @nodoc
class _$StreamCopyWithImpl<$Res, $Val extends Stream>
    implements $StreamCopyWith<$Res> {
  _$StreamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Stream
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? subjects = null}) {
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
            subjects: null == subjects
                ? _value.subjects
                : subjects // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StreamImplCopyWith<$Res> implements $StreamCopyWith<$Res> {
  factory _$$StreamImplCopyWith(
    _$StreamImpl value,
    $Res Function(_$StreamImpl) then,
  ) = __$$StreamImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, List<String> subjects});
}

/// @nodoc
class __$$StreamImplCopyWithImpl<$Res>
    extends _$StreamCopyWithImpl<$Res, _$StreamImpl>
    implements _$$StreamImplCopyWith<$Res> {
  __$$StreamImplCopyWithImpl(
    _$StreamImpl _value,
    $Res Function(_$StreamImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Stream
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? subjects = null}) {
    return _then(
      _$StreamImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        subjects: null == subjects
            ? _value._subjects
            : subjects // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$StreamImpl extends _Stream {
  const _$StreamImpl({
    required this.id,
    required this.name,
    required final List<String> subjects,
  }) : _subjects = subjects,
       super._();

  @override
  final String id;
  @override
  final String name;
  final List<String> _subjects;
  @override
  List<String> get subjects {
    if (_subjects is EqualUnmodifiableListView) return _subjects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subjects);
  }

  @override
  String toString() {
    return 'Stream(id: $id, name: $name, subjects: $subjects)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._subjects, _subjects));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_subjects),
  );

  /// Create a copy of Stream
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StreamImplCopyWith<_$StreamImpl> get copyWith =>
      __$$StreamImplCopyWithImpl<_$StreamImpl>(this, _$identity);
}

abstract class _Stream extends Stream {
  const factory _Stream({
    required final String id,
    required final String name,
    required final List<String> subjects,
  }) = _$StreamImpl;
  const _Stream._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  List<String> get subjects;

  /// Create a copy of Stream
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StreamImplCopyWith<_$StreamImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
