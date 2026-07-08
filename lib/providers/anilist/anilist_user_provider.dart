import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shonenx/core/anilist/services/anilist_service.dart';
import 'package:shonenx/core/models/anilist/anilist_user.dart';
import 'package:shonenx/core/utils/app_logger.dart';

/// Manages the authenticated user state and handles login/logout operations.
class UserNotifier extends StateNotifier<User?> {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    lOptions: LinuxOptions(),
  );

  UserNotifier() : super(null) {
    AppLogger.d('UserNotifier instantiated');
    _loadUser();
  }

  // --- User Data Management ---

  /// Loads user data from secure storage.
  Future<void> _loadUser() async {
    AppLogger.d('Loading user data from secure storage');
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      final userData = await _storage.read(key: 'userData');
      if (accessToken == null || userData == null) {
        AppLogger.d('No user data found in storage');
        return;
      }

      final userParts = userData.split('#');
      if (userParts.length != 3) {
        AppLogger.w('Invalid user data format: $userData');
        return;
      }

      final userId = int.tryParse(userParts[0]);
      if (userId == null) {
        AppLogger.w('Invalid user ID format: ${userParts[0]}');
        return;
      }

      state = User(
        accessToken: accessToken,
        id: userId,
        name: userParts[1],
        avatar: userParts[2],
      );
      AppLogger.d('User loaded: ${state!.name} (ID: ${state!.id})');
    } catch (e, stackTrace) {
      AppLogger.e('Failed to load user data', e, stackTrace);
      state = null;
    }
  }

  /// Saves user data to secure storage.
  Future<void> _saveUserData({
    required String accessToken,
    required int id,
    required String name,
    required String avatar,
  }) async {
    AppLogger.d('Saving user data for ID: $id');
    try {
      await Future.wait([
        _storage.write(key: 'accessToken', value: accessToken),
        _storage.write(key: 'userData', value: '$id#$name#$avatar'),
      ]);
      state = User(
        accessToken: accessToken,
        id: id,
        name: name,
        avatar: avatar,
      );
      AppLogger.d('User data saved: $name (ID: $id)');
    } catch (e, stackTrace) {
      AppLogger.e('Failed to save user data', e, stackTrace);
    }
  }

  // --- Authentication ---

  /// Logs in the user with the provided access token and fetches their profile.
  Future<void> login(String accessToken) async {
    AppLogger.d('Initiating login with access token');
    try {
      await _storage.write(key: 'accessToken', value: accessToken);
      state = User(accessToken: accessToken);
      final anilistService = AnilistService();
      final user = await anilistService.getUserProfile(accessToken);
      AppLogger.d('User profile fetched: ${user['name']} (ID: ${user['id']})');

      await _saveUserData(
        accessToken: accessToken,
        id: user['id'],
        name: user['name'],
        avatar: user['avatar']['large'],
      );
    } catch (e, stackTrace) {
      AppLogger.e('Login failed', e, stackTrace);
      state = null;
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'userData');
    }
  }

  /// Shows a confirmation dialog for logging out and clears user data.
  Future<void> logout({required BuildContext context}) async {
    AppLogger.d('Showing logout confirmation dialog');
    await showAdaptiveDialog(
      context: context,
      builder: (context) => _buildLogoutDialog(context),
    );
  }

  // --- UI Components ---

  /// Builds the logout confirmation dialog.
  Widget _buildLogoutDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog.adaptive(
      title: const Text('Anilist Logout'),
      content: const Text('You are about to logout. Are you sure?'),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
        TextButton(
          onPressed: () async {
            AppLogger.d('Logging out user');
            try {
              await Future.wait([
                _storage.delete(key: 'accessToken'),
                _storage.delete(key: 'userData'),
              ]);
              state = null;
              if (context.mounted) {
                context.pop();
              }
            } catch (e, stackTrace) {
              AppLogger.e(
                  'Failed to clear user data during logout', e, stackTrace);
            }
          },
          child: Text(
            'Logout',
            style: TextStyle(color: colorScheme.error),
          ),
        ),
      ],
    );
  }
}

/// Riverpod provider for the user state.
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
