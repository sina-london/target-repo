import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'dart:convert';

import 'package:shonenx/core/registery/anime_source_registery_provider.dart';
import 'package:shonenx/providers/selected_provider.dart';

// State class for server status
class ServerStatus {
  final String status;
  final String message;
  final DateTime lastChecked;

  const ServerStatus({
    this.status = 'unknown',
    this.message = 'Status unknown',
    required this.lastChecked,
  });

  factory ServerStatus.fromJson(Map<String, dynamic> json) {
    return ServerStatus(
      status: json['status'] ?? 'unknown',
      message: json['message'] ?? 'Status unknown',
      lastChecked: DateTime.parse(
          json['lastChecked'] ?? DateTime.now().toIso8601String()),
    );
  }

  static ServerStatus unknown() => ServerStatus(lastChecked: DateTime.now());
}

// Providers
final temporarySelectionProvider = StateProvider<String?>((ref) => null);

final serverStatusProvider =
    FutureProvider<Map<String, ServerStatus>>((ref) async {
  try {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/Darkx-dev/ShonenX-Providers-Status/refs/heads/main/server_status.json'));
    if (response.statusCode == 200) {
      final data = Map<String, dynamic>.from(json.decode(response.body));
      return data.map((key, value) => MapEntry(
          key, ServerStatus.fromJson(Map<String, dynamic>.from(value))));
    }
    throw Exception('Failed to load server status');
  } catch (e) {
    return {};
  }
});

class ProviderSettingsScreen extends ConsumerStatefulWidget {
  const ProviderSettingsScreen({super.key});

  @override
  ConsumerState<ProviderSettingsScreen> createState() =>
      _ProviderSettingsScreenState();
}

class _ProviderSettingsScreenState
    extends ConsumerState<ProviderSettingsScreen> {
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    // Initialize temporary selection
    final selectedKey = ref.read(selectedProviderKeyProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(temporarySelectionProvider.notifier).state =
          selectedKey.selectedProviderKey;
    });
  }

  void _checkForChanges() {
    final currentSelection = ref.read(temporarySelectionProvider);
    final originalSelection =
        ref.read(selectedProviderKeyProvider).selectedProviderKey;
    setState(() {
      _hasChanges = currentSelection != originalSelection;
    });
  }

  void _saveChanges() {
    final tempSelect = ref.read(temporarySelectionProvider);
    if (tempSelect != null) {
      ref
          .read(selectedProviderKeyProvider.notifier)
          .updateSelectedProvider(tempSelect, null);
      setState(() {
        _hasChanges = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Provider settings saved'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final registryState = ref.watch(animeSourceRegistryProvider);
    final serverStatusAsync = ref.watch(serverStatusProvider);

    ref.listen(temporarySelectionProvider, (_, __) => _checkForChanges());

    if (!registryState.registry.isInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Initializing providers...',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            if (registryState.error != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${registryState.error}',
                  style: TextStyle(color: colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        serverStatusAsync.when(
          loading: () => _buildLoadingState(colorScheme),
          error: (error, _) => _buildErrorState(colorScheme),
          data: (serverStatus) => _buildMainContent(
            context,
            registryState.registry.allProviders,
            serverStatus,
            colorScheme,
          ),
        ),
        if (_hasChanges)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _saveChanges,
              child: const Icon(Iconsax.tick_square),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              tooltip: 'Save Changes',
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Checking provider status...',
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.cloud_cross, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Failed to fetch provider status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Check your connection and try again',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(serverStatusProvider),
              icon: const Icon(Iconsax.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    List<dynamic> providers,
    Map<String, ServerStatus> serverStatus,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                'Anime Providers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const Spacer(),
              _buildStatusLegend(colorScheme),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: providers.length,
            itemBuilder: (context, index) => _buildProviderCard(
              context,
              providers[index],
              serverStatus[providers[index].providerName.toLowerCase()] ??
                  ServerStatus.unknown(),
              colorScheme,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusLegend(ColorScheme colorScheme) {
    return Row(
      children: [
        _buildLegendItem(Colors.green, 'Online', colorScheme),
        const SizedBox(width: 8),
        _buildLegendItem(Colors.orange, 'Issues', colorScheme),
        const SizedBox(width: 8),
        _buildLegendItem(Colors.red, 'Offline', colorScheme),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label, ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildProviderCard(
    BuildContext context,
    dynamic provider,
    ServerStatus status,
    ColorScheme colorScheme,
  ) {
    final tempSelection = ref.watch(temporarySelectionProvider);
    final isSelected = provider.providerName == tempSelection;
    final statusColor = _getStatusColor(status.status, colorScheme);

    return Card(
      elevation: isSelected ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          ref.read(temporarySelectionProvider.notifier).state =
              provider.providerName;
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Provider avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerLow,
                child: Text(
                  provider.providerName[0].toUpperCase(),
                  style: TextStyle(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Provider details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.providerName.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            status.message,
                            style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status and selection indicator
              CircleAvatar(
                radius: 16,
                backgroundColor: statusColor.withOpacity(0.1),
                child: Icon(
                  _getStatusIcon(status.status),
                  size: 18,
                  color: statusColor,
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Iconsax.tick_circle,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) => switch (status) {
        'online' => Iconsax.tick_circle,
        'issues' => Iconsax.warning_2,
        'offline' => Icons.error,
        _ => Iconsax.info_circle,
      };

  Color _getStatusColor(String status, ColorScheme colors) => switch (status) {
        'online' => Colors.green,
        'issues' => Colors.orange,
        'offline' => Colors.red,
        _ => colors.onSurface.withOpacity(0.5),
      };
}
