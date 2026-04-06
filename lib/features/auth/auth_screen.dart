// Auth screen is intentionally unused — the app has no user login.
// Data is managed directly in the Firebase console by admins.
// This file is kept to avoid breaking any stale route references.
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('No login required.')),
    );
  }
}
