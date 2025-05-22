import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shonenx/core/registery/anime_source_registery.dart';
import 'package:shonenx/core/sources/anime/anime_provider.dart';
import 'package:shonenx/core/sources/anime/animekai.dart';
import 'package:shonenx/core/sources/anime/animepahe.dart';
import 'package:shonenx/core/sources/anime/aniwatch/aniwatch.dart';
import 'package:shonenx/core/sources/anime/aniwatch/hianime.dart';
import 'package:shonenx/core/sources/anime/aniwatch/kaido.dart';
import 'package:shonenx/data/hive/providers/provider_provider.dart';

import 'package:shonenx/core/utils/app_logger.dart'; 

/// State class for the anime source registry
class AnimeSourceRegistryState {
  final AnimeSourceRegistery registry;
  final bool isInitializing;
  final String? selectedProviderKey;
  final String? error;
  final String? customApiUrl;

  const AnimeSourceRegistryState({
    required this.registry,
    this.selectedProviderKey = "hianime",
    this.isInitializing = false,
    this.error,
    this.customApiUrl,
  });

  AnimeSourceRegistryState copyWith({
    AnimeSourceRegistery? registry,
    bool? isInitializing,
    String? error,
    String? customApiUrl,
  }) {
    return AnimeSourceRegistryState(
      registry: registry ?? this.registry,
      isInitializing: isInitializing ?? this.isInitializing,
      error: error, // Allow null to clear error
      customApiUrl: customApiUrl ?? this.customApiUrl,
    );
  }
}

/// Notifier for the anime source registry
class AnimeSourceRegistryNotifier extends StateNotifier<AnimeSourceRegistryState> {
  // Flag to prevent multiple initializations
  bool _isInitializing = false;

  AnimeSourceRegistryNotifier()
      : super(AnimeSourceRegistryState(registry: AnimeSourceRegistery())) {
    AppLogger.d('AnimeSourceRegistryNotifier created');
  }

  /// Initialize the registry with the given API URL
  /// This should be called during app startup
  Future<void> initialize(String? apiUrl) async {
    // Prevent multiple initializations
    if (_isInitializing) {
      AppLogger.d('Registry initialization already in progress');
      return;
    }

    try {
      _isInitializing = true;
      state = state.copyWith(isInitializing: true, error: null);

      // Set registry status to initializing
      state.registry.setStatus(RegistryStatus.initializing);

      // Clear any existing providers
      state.registry.clear();

      // Register all providers
      final providers = [
        {"key": "hianime", "provider": HiAnimeProvider(customApiUrl: apiUrl)},
        {"key": "aniwatch", "provider": AniwatchProvider(customApiUrl: apiUrl)},
        {"key": "kaido", "provider": KaidoProvider(customApiUrl: apiUrl)},
        {"key": "animekai", "provider": AnimekaiProvider(customApiUrl: apiUrl)},
        {
          "key": "animepahe",
          "provider": AnimePaheProvider(customApiUrl: apiUrl)
        },
      ];

      // Register each provider and track failures
      final failedProviders = <String>[];
      for (final providerData in providers) {
        final key = providerData["key"] as String;
        final provider = providerData["provider"] as AnimeProvider;

        final success = state.registry.registerProvider(key, provider);
        if (!success) {
          failedProviders.add(key);
        }
      }

      // Check if any providers failed to register
      if (failedProviders.isNotEmpty) {
        final errorMsg =
            'Failed to register providers: ${failedProviders.join(', ')}';
        state.registry.setStatus(RegistryStatus.error, errorMsg);
        state = state.copyWith(
          isInitializing: false,
          error: errorMsg,
          customApiUrl: apiUrl,
        );
        AppLogger.e(errorMsg);
        return;
      }

      // Set registry status to initialized
      state.registry.setStatus(RegistryStatus.initialized);
      state = state.copyWith(
        isInitializing: false,
        error: null,
        customApiUrl: apiUrl,
      );

      AppLogger.i(
          'Registry initialized with ${state.registry.providerCount} providers');
    } catch (e, stackTrace) {
      final errorMsg = 'Error initializing registry: $e';
      state.registry.setStatus(RegistryStatus.error, errorMsg);
      state = state.copyWith(
        isInitializing: false,
        error: errorMsg,
      );
      AppLogger.e(errorMsg, e, stackTrace);
    } finally {
      _isInitializing = false;
    }
  }

  /// Update the API URL for all providers
  Future<void> updateApiUrl(String newApiUrl) async {
    AppLogger.d('Updating API URL to: $newApiUrl');
    await initialize(newApiUrl);
  }

  /// Reset the API URL to the default
  Future<void> resetApiUrl() async {
    AppLogger.d('Resetting API URL to default');
    await initialize(null);
  }

  /// Get a provider by key
  AnimeProvider? getProvider(String key) {
    return state.registry.getProvider(key);
  }

  /// Get all provider keys
  List<String> get allProviderKeys => state.registry.allProviderKeys;

  /// Get all providers
  List<AnimeProvider> get allProviders => state.registry.allProviders;
}

/// Provider for the anime source registry
final animeSourceRegistryProvider = StateNotifierProvider<
    AnimeSourceRegistryNotifier,
    AnimeSourceRegistryState>((ref) => AnimeSourceRegistryNotifier());

/// Provider for the current anime provider based on the selected provider key
final currentAnimeProviderProvider = Provider<AnimeProvider?>((ref) {
  final registryState = ref.watch(animeSourceRegistryProvider);
  String? selectedKey = registryState.selectedProviderKey;

  if (selectedKey == null) {
    final key = ref.read(providerSettingsProvider).selectedProviderName;
    selectedKey = key;
  }

  // If the registry is not initialized or the selected provider is loading, return null
  if (!registryState.registry.isInitialized) {
    return null;
  }

  return registryState.registry.getProvider(selectedKey);
});

/// Provider that indicates whether the anime source registry is ready to use
final isAnimeSourceRegistryReadyProvider = Provider<bool>((ref) {
  final registryState = ref.watch(animeSourceRegistryProvider);
  return registryState.registry.isInitialized && !registryState.isInitializing;
});
