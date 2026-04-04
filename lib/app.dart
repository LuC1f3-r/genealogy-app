import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'features/tree/tree_screen.dart';
import 'features/about/about_screen.dart';
import 'shared/widgets/bottom_nav_bar.dart';

/// Root of the application — wires theme and navigation.
class GenealogyApp extends StatelessWidget {
  GenealogyApp({super.key});

  final _router = GoRouter(
    initialLocation: '/tree',
    routes: [
      ShellRoute(
        builder: (context, state, child) => _AppShell(child: child),
        routes: [
          GoRoute(
            path: '/tree',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TreeScreen(),
            ),
          ),
          GoRoute(
            path: '/about',
            pageBuilder: (context, state) => const NoTransitionPage(
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

/// Shell: holds the [BottomNavBar] and swaps screen content.
class _AppShell extends StatelessWidget {
  const _AppShell({required this.child});

  final Widget child;

  static const _tabs = ['/tree', '/about'];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _tabs.indexWhere((t) => location.startsWith(t));

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex < 0 ? 0 : currentIndex,
        onTap: (index) => context.go(_tabs[index]),
      ),
    );
  }
}
