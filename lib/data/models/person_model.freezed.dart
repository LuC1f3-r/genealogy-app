// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PersonModel _$PersonModelFromJson(Map<String, dynamic> json) {
  return _PersonModel.fromJson(json);
}

/// @nodoc
mixin _$PersonModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get dob => throw _privateConstructorUsedError;
  String? get dod => throw _privateConstructorUsedError;
  String? get currentLocation => throw _privateConstructorUsedError;
  bool get isLiving => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  @_GenderConverter()
  PersonGender get gender => throw _privateConstructorUsedError;
  @_RelTypeConverter()
  ChildRelType get childRelType => throw _privateConstructorUsedError;
  String? get twinSiblingId => throw _privateConstructorUsedError;
  String? get isSpouseOf => throw _privateConstructorUsedError;
  String? get divorcedFrom => throw _privateConstructorUsedError;
  List<String> get spouseIds => throw _privateConstructorUsedError;
  List<String> get parentIds => throw _privateConstructorUsedError;
  List<String> get childIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PersonModelCopyWith<PersonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonModelCopyWith<$Res> {
  factory $PersonModelCopyWith(
          PersonModel value, $Res Function(PersonModel) then) =
      _$PersonModelCopyWithImpl<$Res, PersonModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? dob,
      String? dod,
      String? currentLocation,
      bool isLiving,
      String? photoUrl,
      @_GenderConverter() PersonGender gender,
      @_RelTypeConverter() ChildRelType childRelType,
      String? twinSiblingId,
      String? isSpouseOf,
      String? divorcedFrom,
      List<String> spouseIds,
      List<String> parentIds,
      List<String> childIds});
}

/// @nodoc
class _$PersonModelCopyWithImpl<$Res, $Val extends PersonModel>
    implements $PersonModelCopyWith<$Res> {
  _$PersonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? dob = freezed,
    Object? dod = freezed,
    Object? currentLocation = freezed,
    Object? isLiving = null,
    Object? photoUrl = freezed,
    Object? gender = null,
    Object? childRelType = null,
    Object? twinSiblingId = freezed,
    Object? isSpouseOf = freezed,
    Object? divorcedFrom = freezed,
    Object? spouseIds = null,
    Object? parentIds = null,
    Object? childIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dob: freezed == dob
          ? _value.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as String?,
      dod: freezed == dod
          ? _value.dod
          : dod // ignore: cast_nullable_to_non_nullable
              as String?,
      currentLocation: freezed == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      isLiving: null == isLiving
          ? _value.isLiving
          : isLiving // ignore: cast_nullable_to_non_nullable
              as bool,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as PersonGender,
      childRelType: null == childRelType
          ? _value.childRelType
          : childRelType // ignore: cast_nullable_to_non_nullable
              as ChildRelType,
      twinSiblingId: freezed == twinSiblingId
          ? _value.twinSiblingId
          : twinSiblingId // ignore: cast_nullable_to_non_nullable
              as String?,
      isSpouseOf: freezed == isSpouseOf
          ? _value.isSpouseOf
          : isSpouseOf // ignore: cast_nullable_to_non_nullable
              as String?,
      divorcedFrom: freezed == divorcedFrom
          ? _value.divorcedFrom
          : divorcedFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      spouseIds: null == spouseIds
          ? _value.spouseIds
          : spouseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parentIds: null == parentIds
          ? _value.parentIds
          : parentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      childIds: null == childIds
          ? _value.childIds
          : childIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonModelImplCopyWith<$Res>
    implements $PersonModelCopyWith<$Res> {
  factory _$$PersonModelImplCopyWith(
          _$PersonModelImpl value, $Res Function(_$PersonModelImpl) then) =
      __$$PersonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? dob,
      String? dod,
      String? currentLocation,
      bool isLiving,
      String? photoUrl,
      @_GenderConverter() PersonGender gender,
      @_RelTypeConverter() ChildRelType childRelType,
      String? twinSiblingId,
      String? isSpouseOf,
      String? divorcedFrom,
      List<String> spouseIds,
      List<String> parentIds,
      List<String> childIds});
}

/// @nodoc
class __$$PersonModelImplCopyWithImpl<$Res>
    extends _$PersonModelCopyWithImpl<$Res, _$PersonModelImpl>
    implements _$$PersonModelImplCopyWith<$Res> {
  __$$PersonModelImplCopyWithImpl(
      _$PersonModelImpl _value, $Res Function(_$PersonModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? dob = freezed,
    Object? dod = freezed,
    Object? currentLocation = freezed,
    Object? isLiving = null,
    Object? photoUrl = freezed,
    Object? gender = null,
    Object? childRelType = null,
    Object? twinSiblingId = freezed,
    Object? isSpouseOf = freezed,
    Object? divorcedFrom = freezed,
    Object? spouseIds = null,
    Object? parentIds = null,
    Object? childIds = null,
  }) {
    return _then(_$PersonModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dob: freezed == dob
          ? _value.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as String?,
      dod: freezed == dod
          ? _value.dod
          : dod // ignore: cast_nullable_to_non_nullable
              as String?,
      currentLocation: freezed == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      isLiving: null == isLiving
          ? _value.isLiving
          : isLiving // ignore: cast_nullable_to_non_nullable
              as bool,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as PersonGender,
      childRelType: null == childRelType
          ? _value.childRelType
          : childRelType // ignore: cast_nullable_to_non_nullable
              as ChildRelType,
      twinSiblingId: freezed == twinSiblingId
          ? _value.twinSiblingId
          : twinSiblingId // ignore: cast_nullable_to_non_nullable
              as String?,
      isSpouseOf: freezed == isSpouseOf
          ? _value.isSpouseOf
          : isSpouseOf // ignore: cast_nullable_to_non_nullable
              as String?,
      divorcedFrom: freezed == divorcedFrom
          ? _value.divorcedFrom
          : divorcedFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      spouseIds: null == spouseIds
          ? _value._spouseIds
          : spouseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parentIds: null == parentIds
          ? _value._parentIds
          : parentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      childIds: null == childIds
          ? _value._childIds
          : childIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonModelImpl extends _PersonModel {
  const _$PersonModelImpl(
      {required this.id,
      required this.name,
      this.dob,
      this.dod,
      this.currentLocation,
      this.isLiving = false,
      this.photoUrl,
      @_GenderConverter() this.gender = PersonGender.unknown,
      @_RelTypeConverter() this.childRelType = ChildRelType.biological,
      this.twinSiblingId,
      this.isSpouseOf,
      this.divorcedFrom,
      final List<String> spouseIds = const [],
      final List<String> parentIds = const [],
      final List<String> childIds = const []})
      : _spouseIds = spouseIds,
        _parentIds = parentIds,
        _childIds = childIds,
        super._();

  factory _$PersonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? dob;
  @override
  final String? dod;
  @override
  final String? currentLocation;
  @override
  @JsonKey()
  final bool isLiving;
  @override
  final String? photoUrl;
  @override
  @JsonKey()
  @_GenderConverter()
  final PersonGender gender;
  @override
  @JsonKey()
  @_RelTypeConverter()
  final ChildRelType childRelType;
  @override
  final String? twinSiblingId;
  @override
  final String? isSpouseOf;
  @override
  final String? divorcedFrom;
  final List<String> _spouseIds;
  @override
  @JsonKey()
  List<String> get spouseIds {
    if (_spouseIds is EqualUnmodifiableListView) return _spouseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_spouseIds);
  }

  final List<String> _parentIds;
  @override
  @JsonKey()
  List<String> get parentIds {
    if (_parentIds is EqualUnmodifiableListView) return _parentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parentIds);
  }

  final List<String> _childIds;
  @override
  @JsonKey()
  List<String> get childIds {
    if (_childIds is EqualUnmodifiableListView) return _childIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childIds);
  }

  @override
  String toString() {
    return 'PersonModel(id: $id, name: $name, dob: $dob, dod: $dod, currentLocation: $currentLocation, isLiving: $isLiving, photoUrl: $photoUrl, gender: $gender, childRelType: $childRelType, twinSiblingId: $twinSiblingId, isSpouseOf: $isSpouseOf, divorcedFrom: $divorcedFrom, spouseIds: $spouseIds, parentIds: $parentIds, childIds: $childIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dob, dob) || other.dob == dob) &&
            (identical(other.dod, dod) || other.dod == dod) &&
            (identical(other.currentLocation, currentLocation) ||
                other.currentLocation == currentLocation) &&
            (identical(other.isLiving, isLiving) ||
                other.isLiving == isLiving) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.childRelType, childRelType) ||
                other.childRelType == childRelType) &&
            (identical(other.twinSiblingId, twinSiblingId) ||
                other.twinSiblingId == twinSiblingId) &&
            (identical(other.isSpouseOf, isSpouseOf) ||
                other.isSpouseOf == isSpouseOf) &&
            (identical(other.divorcedFrom, divorcedFrom) ||
                other.divorcedFrom == divorcedFrom) &&
            const DeepCollectionEquality()
                .equals(other._spouseIds, _spouseIds) &&
            const DeepCollectionEquality()
                .equals(other._parentIds, _parentIds) &&
            const DeepCollectionEquality().equals(other._childIds, _childIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      dob,
      dod,
      currentLocation,
      isLiving,
      photoUrl,
      gender,
      childRelType,
      twinSiblingId,
      isSpouseOf,
      divorcedFrom,
      const DeepCollectionEquality().hash(_spouseIds),
      const DeepCollectionEquality().hash(_parentIds),
      const DeepCollectionEquality().hash(_childIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonModelImplCopyWith<_$PersonModelImpl> get copyWith =>
      __$$PersonModelImplCopyWithImpl<_$PersonModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonModelImplToJson(
      this,
    );
  }
}

abstract class _PersonModel extends PersonModel {
  const factory _PersonModel(
      {required final String id,
      required final String name,
      final String? dob,
      final String? dod,
      final String? currentLocation,
      final bool isLiving,
      final String? photoUrl,
      @_GenderConverter() final PersonGender gender,
      @_RelTypeConverter() final ChildRelType childRelType,
      final String? twinSiblingId,
      final String? isSpouseOf,
      final String? divorcedFrom,
      final List<String> spouseIds,
      final List<String> parentIds,
      final List<String> childIds}) = _$PersonModelImpl;
  const _PersonModel._() : super._();

  factory _PersonModel.fromJson(Map<String, dynamic> json) =
      _$PersonModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get dob;
  @override
  String? get dod;
  @override
  String? get currentLocation;
  @override
  bool get isLiving;
  @override
  String? get photoUrl;
  @override
  @_GenderConverter()
  PersonGender get gender;
  @override
  @_RelTypeConverter()
  ChildRelType get childRelType;
  @override
  String? get twinSiblingId;
  @override
  String? get isSpouseOf;
  @override
  String? get divorcedFrom;
  @override
  List<String> get spouseIds;
  @override
  List<String> get parentIds;
  @override
  List<String> get childIds;
  @override
  @JsonKey(ignore: true)
  _$$PersonModelImplCopyWith<_$PersonModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
