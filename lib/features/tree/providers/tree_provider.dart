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

/// Forces a complete reseed of the family tree data.
/// Wipes all existing persons and writes the full [kSeedNodes] dataset.
/// Called from [TreeScreen.initState] so the latest data is always pushed.
@riverpod
Future<void> seedIfEmpty(SeedIfEmptyRef ref) async {
  final repo = ref.read(familyTreeRepositoryProvider);
  await repo.forceSeedData(kTreeId, kSeedNodes);
}
