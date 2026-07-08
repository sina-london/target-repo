import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shonenx/core/anilist/services/auth_service.dart';
import 'package:shonenx/shared/providers/auth_provider.dart';

final authProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final service = ref.read(anilistAuthServiceProvider);
  return AuthViewModel(service);
});

class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? anilistAccessToken;

  const AuthState({this.isLoggedIn = false, this.isLoading = false, this.anilistAccessToken});

  AuthState copyWith({bool? isLoggedIn, bool? isLoading, String? anilistAccessToken}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      anilistAccessToken: anilistAccessToken ?? this.anilistAccessToken,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AniListAuthService _authService;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    lOptions: LinuxOptions(),
  );

  AuthViewModel(this._authService) : super(const AuthState());

  Future<void> login() async {
    state = state.copyWith(isLoading: true);

    final code = await _authService.authenticate();
    if (code == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final token = await _authService.getAccessToken(code);
    if (token == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    await secureStorage.write(key: 'anilist-token', value: token);

    state = AuthState(isLoggedIn: true, isLoading: false, anilistAccessToken: token);
  }

  void logout() {
    state = const AuthState();
    secureStorage.delete(key: 'anilist-token');
  }
}
