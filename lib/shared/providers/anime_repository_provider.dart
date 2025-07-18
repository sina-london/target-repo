import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shonenx/core/repositories/anime_repository.dart';
import 'package:shonenx/core/anilist/services/anilist_service.dart';
import 'package:shonenx/features/auth/view_model/auth_notifier.dart';
import 'package:shonenx/core/services/auth_provider_enum.dart';

final animeRepositoryProvider = Provider<AnimeRepository>((ref) {
  final auth = ref.watch(authProvider);

  switch (auth.authPlatform) {
    case AuthPlatform.anilist:
      return ref.watch(anilistServiceProvider);
    case AuthPlatform.mal:
      // Todo: return ref.watch(malServiceProvider);
      throw UnimplementedError("MAL Service not implemented");
    default:
      return ref.watch(anilistServiceProvider);
  }
});
