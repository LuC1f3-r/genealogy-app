import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/tree/widgets/person_card.dart';

part 'person_model.freezed.dart';
part 'person_model.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enum serialization helpers
// ─────────────────────────────────────────────────────────────────────────────

class _GenderConverter implements JsonConverter<PersonGender, String> {
  const _GenderConverter();
  @override
  PersonGender fromJson(String v) =>
      PersonGender.values.firstWhere((e) => e.name == v,
          orElse: () => PersonGender.unknown);
  @override
  String toJson(PersonGender v) => v.name;
}

class _RelTypeConverter implements JsonConverter<ChildRelType, String> {
  const _RelTypeConverter();
  @override
  ChildRelType fromJson(String v) =>
      ChildRelType.values.firstWhere((e) => e.name == v,
          orElse: () => ChildRelType.biological);
  @override
  String toJson(ChildRelType v) => v.name;
}

// ─────────────────────────────────────────────────────────────────────────────
// PersonModel — Firestore DTO
// ─────────────────────────────────────────────────────────────────────────────

/// Serialisable Firestore document that mirrors [PersonNode].
///
/// The tree-rendering layer always works with [PersonNode] (the domain model).
/// Conversion happens only at the repository boundary:
///   Firestore → [PersonModel.fromJson] → [toDomain] → [PersonNode]
///   [PersonNode] → [PersonModel.fromDomain] → [toJson] → Firestore
@freezed
class PersonModel with _$PersonModel {
  const factory PersonModel({
    required String id,
    required String name,
    String? dob,
    String? dod,
    String? currentLocation,
    @Default(false) bool isLiving,
    String? photoUrl,
    @_GenderConverter() @Default(PersonGender.unknown) PersonGender gender,
    @_RelTypeConverter()
    @Default(ChildRelType.biological)
    ChildRelType childRelType,
    String? twinSiblingId,
    String? isSpouseOf,
    String? divorcedFrom,
    @Default([]) List<String> spouseIds,
    @Default([]) List<String> parentIds,
    @Default([]) List<String> childIds,
  }) = _PersonModel;

  // ── JSON / Firestore ───────────────────────────────────────────────────────
  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);

  // ── Domain conversion ──────────────────────────────────────────────────────
  const PersonModel._();

  /// Converts this DTO to the domain [PersonNode] used by the tree renderer.
  PersonNode toDomain() => PersonNode(
        id: id,
        name: name,
        dob: dob,
        dod: dod,
        currentLocation: currentLocation,
        isLiving: isLiving,
        photoUrl: photoUrl,
        gender: gender,
        childRelType: childRelType,
        twinSiblingId: twinSiblingId,
        isSpouseOf: isSpouseOf,
        divorcedFrom: divorcedFrom,
        spouseIds: List<String>.from(spouseIds),
        parentIds: List<String>.from(parentIds),
        childIds: List<String>.from(childIds),
      );

  /// Creates a [PersonModel] from the domain [PersonNode].
  factory PersonModel.fromDomain(PersonNode node) => PersonModel(
        id: node.id,
        name: node.name,
        dob: node.dob,
        dod: node.dod,
        currentLocation: node.currentLocation,
        isLiving: node.isLiving,
        photoUrl: node.photoUrl,
        gender: node.gender,
        childRelType: node.childRelType,
        twinSiblingId: node.twinSiblingId,
        isSpouseOf: node.isSpouseOf,
        divorcedFrom: node.divorcedFrom,
        spouseIds: node.allSpouseIds,
        parentIds: node.parentIds,
        childIds: node.childIds,
      );

  /// Reads from a Firestore [DocumentSnapshot].
  factory PersonModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    data['id'] = doc.id; // ensure id comes from doc ID, not stored field
    return PersonModel.fromJson(data);
  }
}
