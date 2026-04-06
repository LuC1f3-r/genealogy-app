// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonModelImpl _$$PersonModelImplFromJson(Map<String, dynamic> json) =>
    _$PersonModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      dob: json['dob'] as String?,
      dod: json['dod'] as String?,
      currentLocation: json['currentLocation'] as String?,
      isLiving: json['isLiving'] as bool? ?? false,
      photoUrl: json['photoUrl'] as String?,
      gender: json['gender'] == null
          ? PersonGender.unknown
          : const _GenderConverter().fromJson(json['gender'] as String),
      childRelType: json['childRelType'] == null
          ? ChildRelType.biological
          : const _RelTypeConverter().fromJson(json['childRelType'] as String),
      twinSiblingId: json['twinSiblingId'] as String?,
      isSpouseOf: json['isSpouseOf'] as String?,
      divorcedFrom: json['divorcedFrom'] as String?,
      spouseIds: (json['spouseIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      parentIds: (json['parentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      childIds: (json['childIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PersonModelImplToJson(_$PersonModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dob': instance.dob,
      'dod': instance.dod,
      'currentLocation': instance.currentLocation,
      'isLiving': instance.isLiving,
      'photoUrl': instance.photoUrl,
      'gender': const _GenderConverter().toJson(instance.gender),
      'childRelType': const _RelTypeConverter().toJson(instance.childRelType),
      'twinSiblingId': instance.twinSiblingId,
      'isSpouseOf': instance.isSpouseOf,
      'divorcedFrom': instance.divorcedFrom,
      'spouseIds': instance.spouseIds,
      'parentIds': instance.parentIds,
      'childIds': instance.childIds,
    };
