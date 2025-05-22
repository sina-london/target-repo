import 'package:shonenx/core/sources/anime/anime_provider.dart';
import 'package:shonenx/core/utils/app_logger.dart';

/// Enum representing the initialization status of the registry
enum RegistryStatus { uninitialized, initializing, initialized, error }

/// A registry for anime source providers with improved error handling and management
class AnimeSourceRegistery {
  /// Map of provider keys to provider instances
  final Map<String, AnimeProvider> _providers = {};

  /// Current status of the registry
  RegistryStatus _status = RegistryStatus.uninitialized;

  /// Error message if initialization failed
  String? _errorMessage;

  /// Get the current status of the registry
  RegistryStatus get status => _status;

  /// Get the error message if initialization failed
  String? get errorMessage => _errorMessage;

  /// Check if the registry is initialized
  bool get isInitialized => _status == RegistryStatus.initialized;

  /// Register a provider by a key
  /// Returns true if registration was successful, false otherwise
  bool registerProvider(String key, AnimeProvider provider) {
    try {
      if (key.isEmpty) {
        AppLogger.w('Cannot register provider with empty key');
        return false;
      }

      if (_providers.containsKey(key)) {
        AppLogger.w('Provider with key $key already exists, replacing');
      }

      _providers[key] = provider;
      AppLogger.i('Registered provider: $key');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Error registering provider $key: $e', e, stackTrace);
      return false;
    }
  }

  /// Retrieve a provider by key
  /// Returns null if the provider doesn't exist
  AnimeProvider? getProvider(String key) {
    if (!isInitialized) {
      AppLogger.w('Registry not initialized, cannot get provider: $key');
      return null;
    }

    final provider = _providers[key];
    if (provider == null) {
      AppLogger.w('Provider not found for key: $key');
    }
    return provider;
  }

  /// List all registered providers
  List<AnimeProvider> get allProviders => _providers.values.toList();

  /// Get all provider keys
  List<String> get allProviderKeys => _providers.keys.toList();

  /// Check if a provider exists
  bool hasProvider(String key) => _providers.containsKey(key);

  /// Get the number of registered providers
  int get providerCount => _providers.length;

  /// Clear all providers
  void clear() {
    _providers.clear();
    AppLogger.i('Cleared all providers');
  }

  /// Set the registry status
  void setStatus(RegistryStatus status, [String? errorMessage]) {
    _status = status;
    _errorMessage = errorMessage;
    AppLogger.i('Registry status changed to: $_status');
    if (errorMessage != null) {
      AppLogger.e('Registry error: $errorMessage');
    }
  }
}
