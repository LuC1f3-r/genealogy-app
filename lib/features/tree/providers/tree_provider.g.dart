// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$familyTreeHash() => r'26ceb1e8bb3ea0a61dbc5493057ed6ddb0e01cb7';

/// Watches the live Firestore stream for [kTreeId].
///
/// Returns an [AsyncValue<List<PersonNode>>]:
///   - [AsyncLoading]  → first frame, show skeleton
///   - [AsyncData]     → tree is ready, render canvas
///   - [AsyncError]    → Firestore error, show retry UI
///
/// Copied from [familyTree].
@ProviderFor(familyTree)
final familyTreeProvider = AutoDisposeStreamProvider<List<PersonNode>>.internal(
  familyTree,
  name: r'familyTreeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$familyTreeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FamilyTreeRef = AutoDisposeStreamProviderRef<List<PersonNode>>;
String _$seedIfEmptyHash() => r'fd96b2b123bd391c9aec7e9b0351144a7a1fb1b2';

/// Pushes the hardcoded sample data to Firestore if the tree is empty.
/// Called once from [TreeScreen] on first admin sign-in.
///
/// Copied from [seedIfEmpty].
@ProviderFor(seedIfEmpty)
final seedIfEmptyProvider = AutoDisposeFutureProvider<void>.internal(
  seedIfEmpty,
  name: r'seedIfEmptyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$seedIfEmptyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SeedIfEmptyRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
