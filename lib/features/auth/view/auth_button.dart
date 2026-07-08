import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/auth_viewmodel.dart';

class AniListLoginButton extends ConsumerWidget {
  const AniListLoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return ElevatedButton(
      onPressed: authState.isLoading
          ? null
          : () {
              ref.read(authProvider.notifier).login();
            },
      child: Text(authState.isLoggedIn ? 'Logged in' : 'Login with AniList'),
    );
  }
}
