import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/family_tree_repository.dart';
import '../../../features/auth/auth_provider.dart';
import '../widgets/person_card.dart';
import '../tree_screen.dart' show kSeedNodes;

part 'tree_provider.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Tree data stream
// ─────────────────────────────────────────────────────────────────────────────

/// Watches the live Firestore stream for [kTreeId].
///
/// Returns an [AsyncValue<List<PersonNode>>]:
///   - [AsyncLoading]  → first frame, show skeleton
///   - [AsyncData]     → tree is ready, render canvas
///   - [AsyncError]    → Firestore error, show retry UI
@riverpod
Stream<List<PersonNode>> familyTree(FamilyTreeRef ref) {
  final repo = ref.watch(familyTreeRepositoryProvider);
  return repo.watchPersons(kTreeId);
}

// ─────────────────────────────────────────────────────────────────────────────
// Seed (one-time, admin only)
// ─────────────────────────────────────────────────────────────────────────────

/// Pushes the hardcoded sample data to Firestore if the tree is empty.
/// Called once from [TreeScreen] on first admin sign-in.
@riverpod
Future<void> seedIfEmpty(SeedIfEmptyRef ref) async {
  final repo    = ref.read(familyTreeRepositoryProvider);
  final isEmpty = !(await repo.treeHasData(kTreeId));
  if (isEmpty) {
    await repo.seedInitialData(kTreeId, kSeedNodes);
  }
}
