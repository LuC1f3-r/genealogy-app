import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/tree/tree_screen.dart';
import 'features/about/about_screen.dart';
import 'shared/widgets/bottom_nav_bar.dart';
import 'theme/app_theme.dart';

/// Root of the application — wires [ThemeData] and [GoRouter].
/// No authentication required — the tree is publicly readable.
class GenealogyApp extends StatelessWidget {
  const GenealogyApp({super.key});

  static final _router = GoRouter(
    initialLocation: '/tree',
    routes: [
      // ── Main shell (tree + about with bottom nav) ──────────────────────
      ShellRoute(
        builder: (context, state, child) => _AppShell(child: child),
        routes: [
          GoRoute(
            path: '/tree',
            pageBuilder: (_, __) => const NoTransitionPage(
              child: TreeScreen(),
            ),
          ),
          GoRoute(
            path: '/about',
            pageBuilder: (_, __) => const NoTransitionPage(
              child: AboutScreen(),
            ),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'The Janvekar Family Tree',
      theme: AppTheme.light,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shell — bottom nav bar
// ─────────────────────────────────────────────────────────────────────────────

class _AppShell extends StatelessWidget {
  const _AppShell({required this.child});
  final Widget child;

  static const _tabs = ['/tree', '/about'];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final idx = _tabs.indexWhere((t) => location.startsWith(t));

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: idx < 0 ? 0 : idx,
        onTap: (i) => context.go(_tabs[i]),
      ),
    );
  }
}


