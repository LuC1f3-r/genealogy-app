import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/tree/widgets/person_card.dart';
import '../models/person_model.dart';

part 'family_tree_repository.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Repository
// ─────────────────────────────────────────────────────────────────────────────

/// All Firestore reads and writes for the family tree.
///
/// Relationship integrity is maintained with batch writes — adding a child
/// updates the child doc AND both parent docs atomically.
class FamilyTreeRepository {
  FamilyTreeRepository(this._firestore);

  final FirebaseFirestore _firestore;

  // ── Collection reference ───────────────────────────────────────────────────
  CollectionReference<Map<String, dynamic>> _persons(String treeId) =>
      _firestore.collection('trees').doc(treeId).collection('persons');

  // ── Real-time stream ───────────────────────────────────────────────────────

  /// Emits the full list of [PersonNode]s whenever Firestore changes.
  /// Offline cache is handled automatically by the Firestore SDK.
  Stream<List<PersonNode>> watchPersons(String treeId) {
    return _persons(treeId).snapshots().map((snapshot) => snapshot.docs
        .map((doc) => PersonModel.fromDoc(doc).toDomain())
        .toList());
  }

  // ── Single fetch (for checking existence) ─────────────────────────────────

  Future<PersonNode?> getPerson(String treeId, String personId) async {
    final doc = await _persons(treeId).doc(personId).get();
    if (!doc.exists) return null;
    return PersonModel.fromDoc(
            doc as DocumentSnapshot<Map<String, dynamic>>)
        .toDomain();
  }

  // ── Add person ─────────────────────────────────────────────────────────────

  /// Adds a person and atomically updates all related persons' arrays.
  ///
  /// For a new child: pass [fatherIdToUpdate] and [motherIdToUpdate] so their
  /// `childIds` arrays are updated in the same batch.
  Future<void> addPerson(
    String treeId,
    PersonNode person, {
    String? fatherIdToUpdate,
    String? motherIdToUpdate,
    String? husbandIdToUpdate, // when adding a wife node
  }) async {
    final batch = _firestore.batch();
    final col = _persons(treeId);

    // Write the new person document.
    final model = PersonModel.fromDomain(person);
    batch.set(col.doc(person.id), model.toJson());

    // Update father's childIds.
    if (fatherIdToUpdate != null) {
      batch.update(col.doc(fatherIdToUpdate), {
        'childIds': FieldValue.arrayUnion([person.id]),
      });
    }

    // Update mother's childIds.
    if (motherIdToUpdate != null) {
      batch.update(col.doc(motherIdToUpdate), {
        'childIds': FieldValue.arrayUnion([person.id]),
      });
    }

    // Update husband's spouseIds when adding a wife node.
    if (husbandIdToUpdate != null) {
      batch.update(col.doc(husbandIdToUpdate), {
        'spouseIds': FieldValue.arrayUnion([person.id]),
      });
    }

    await batch.commit();
  }

  // ── Update person ──────────────────────────────────────────────────────────

  /// Updates an existing person's own fields only (name, dates, currentLocation etc).
  /// Does NOT touch relationship arrays — use [addPerson] / [removePerson] for that.
  Future<void> updatePerson(String treeId, PersonNode person) async {
    final model = PersonModel.fromDomain(person);
    await _persons(treeId).doc(person.id).update(model.toJson());
  }

  // ── Remove person ──────────────────────────────────────────────────────────

  /// Removes a person and cleans up all references in related persons' arrays.
  Future<void> removePerson(String treeId, String personId) async {
    final batch = _firestore.batch();
    final col = _persons(treeId);

    // Fetch the person so we know which docs to clean up.
    final doc = await col.doc(personId).get();
    if (!doc.exists) return;

    final person =
        PersonModel.fromDoc(doc as DocumentSnapshot<Map<String, dynamic>>)
            .toDomain();

    // Remove from all parents' childIds.
    for (final parentId in person.parentIds) {
      batch.update(col.doc(parentId), {
        'childIds': FieldValue.arrayRemove([personId]),
      });
    }

    // Remove from husband's spouseIds (if wife).
    if (person.isSpouseOf != null) {
      batch.update(col.doc(person.isSpouseOf!), {
        'spouseIds': FieldValue.arrayRemove([personId]),
      });
    }

    // Remove from all children's parentIds.
    for (final childId in person.childIds) {
      batch.update(col.doc(childId), {
        'parentIds': FieldValue.arrayRemove([personId]),
      });
    }

    // Delete the person document itself.
    batch.delete(col.doc(personId));

    await batch.commit();
  }

  // ── Mark divorce ───────────────────────────────────────────────────────────

  /// Sets the `divorcedFrom` field on a wife node, which causes the ✕ marker
  /// to appear on the marriage connector in the tree renderer.
  Future<void> markDivorce(
      String treeId, String wifeId, String husbandId) async {
    await _persons(treeId)
        .doc(wifeId)
        .update({'divorcedFrom': husbandId});
  }

  Future<void> unmarkDivorce(String treeId, String wifeId) async {
    await _persons(treeId)
        .doc(wifeId)
        .update({'divorcedFrom': FieldValue.delete()});
  }

  // ── One-time seed ──────────────────────────────────────────────────────────

  /// Pushes the initial hardcoded list to Firestore in batches of 500.
  /// Safe to call multiple times — uses `set` with merge so existing docs
  /// are not duplicated.
  Future<void> seedInitialData(
      String treeId, List<PersonNode> nodes) async {
    const batchLimit = 499;
    var batch = _firestore.batch();
    int count = 0;

    for (final node in nodes) {
      final model = PersonModel.fromDomain(node);
      batch.set(
        _persons(treeId).doc(node.id),
        model.toJson(),
        SetOptions(merge: true),
      );
      count++;
      if (count >= batchLimit) {
        await batch.commit();
        batch = _firestore.batch();
        count = 0;
      }
    }

    if (count > 0) await batch.commit();
  }

  // ── Check if tree has data ─────────────────────────────────────────────────

  Future<bool> treeHasData(String treeId) async {
    final snap =
        await _persons(treeId).limit(1).get();
    return snap.docs.isNotEmpty;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Riverpod provider
// ─────────────────────────────────────────────────────────────────────────────

@riverpod
FamilyTreeRepository familyTreeRepository(Ref ref) {
  return FamilyTreeRepository(FirebaseFirestore.instance);
}
