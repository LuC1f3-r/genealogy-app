import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants
// ─────────────────────────────────────────────────────────────────────────────

/// The Firestore tree document ID — shared by all family members.
const String kTreeId = 'janvekar';

// ─────────────────────────────────────────────────────────────────────────────
// Admin check
// ─────────────────────────────────────────────────────────────────────────────

/// The app has no user login — all editing is done directly in the Firebase
/// console by admins. This provider always returns `false` so admin-only
/// UI (FAB, edit controls) is never shown to regular users.
@riverpod
bool isAdmin(IsAdminRef ref) => false;
