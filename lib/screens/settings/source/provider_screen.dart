import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Assuming these are your provider imports
import 'package:shonenx/core/registery/anime_source_registery_provider.dart';
import 'package:shonenx/data/hive/providers/provider_provider.dart';

// Provider to store the status data
final providerStatusProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/Darkx-dev/ShonenX-Providers-Status/refs/heads/main/server_status.json'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
  throw Exception('Failed to load provider status');
});

// Method to show ProviderSettingsScreen as a bottom sheet
void showProviderSettingsBottomSheet(
    BuildContext context, Function(bool) callback) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows dynamic height
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6, // Compact initial height
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => ProviderSettingsScreen(
        callback: callback,
        scrollController: scrollController, // Pass controller for scrolling
      ),
    ),
  );
}

class ProviderSettingsScreen extends ConsumerWidget {
  final Function(bool)? callback;
  final ScrollController?
      scrollController; // Optional controller for bottom sheet

  const ProviderSettingsScreen(
      {super.key, this.scrollController, this.callback});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final providerSettings = ref.watch(providerSettingsProvider);
    final animeSources =
        ref.read(animeSourceRegistryProvider).registry.allProviderKeys;
    final providerStatus = ref.watch(providerStatusProvider);
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 8), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Minimize vertical space
        children: [
          // Drag handle for bottom sheet
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Compact header
          Container(
            padding: const EdgeInsets.all(8), // Reduced padding
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.info_circle,
                  size: 16, // Smaller icon
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Select Anime Source',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12), // Reduced spacing
          // Compact status legend
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _StatusIndicator(
                color: Colors.green,
                label: 'Online',
                isCompact: true,
              ),
              const SizedBox(width: 12),
              _StatusIndicator(
                color: Colors.orange,
                label: 'Degraded',
                isCompact: true,
              ),
              const SizedBox(width: 12),
              _StatusIndicator(
                color: Colors.red,
                label: 'Offline',
                isCompact: true,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Provider list
          Expanded(
            child: providerStatus.when(
              data: (statusData) => _ProviderList(
                animeSources: animeSources,
                statusData: statusData,
                selectedProvider: providerSettings.selectedProviderName,
                onProviderSelected: (provider) {
                  if (callback != null) {
                    callback!(true);
                  }
                  ref.read(providerSettingsProvider.notifier).updateSettings(
                        (prev) => prev.copyWith(
                          selectedProviderName: provider,
                        ),
                      );
                  Navigator.pop(context); // Close bottom sheet on selection
                },
                scrollController: scrollController,
              ),
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 3), // Thinner
                    SizedBox(height: 8),
                    Text(
                      'Loading...',
                      style: TextStyle(fontSize: 12), // Smaller text
                    ),
                  ],
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.wifi_square,
                      size: 48, // Smaller icon
                      color: colorScheme.error.withOpacity(0.6),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to Load',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Check your connection.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => ref.refresh(providerStatusProvider),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderList extends StatelessWidget {
  final List<String> animeSources;
  final Map<String, dynamic> statusData;
  final String selectedProvider;
  final Function(String) onProviderSelected;
  final ScrollController? scrollController;

  const _ProviderList({
    required this.animeSources,
    required this.statusData,
    required this.selectedProvider,
    required this.onProviderSelected,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController, // Use provided controller
      itemCount: animeSources.length,
      itemBuilder: (context, index) {
        final String provider = animeSources[index];
        final status = statusData[provider];
        return _ProviderCard(
          provider: provider,
          status: status,
          isSelected: selectedProvider == provider,
          onTap: () => onProviderSelected(provider),
        );
      },
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final String provider;
  final dynamic status;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProviderCard({
    required this.provider,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toLowerCase()) {
      case 'online':
        return Colors.green;
      case 'degraded':
        return Colors.orange;
      case 'offline':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    if (status == null) return Icons.question_mark_rounded;
    switch (status.toLowerCase()) {
      case 'online':
        return Iconsax.tick_circle;
      case 'degraded':
        return Iconsax.warning_2;
      case 'offline':
        return Iconsax.close_circle;
      default:
        return Icons.question_mark_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    final String statusText = status != null ? status['status'] : 'unknown';
    final statusColor = _getStatusColor(statusText);
    final statusIcon = _getStatusIcon(statusText);

    return Container(
      margin: const EdgeInsets.only(bottom: 8), // Reduced margin
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Smaller radius
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
          width: isSelected ? 1.5 : 1,
        ),
        color: isSelected
            ? colorScheme.primary.withOpacity(0.1)
            : colorScheme.surface,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8), // Reduced padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6), // Smaller padding
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary.withOpacity(0.15)
                              : colorScheme.surfaceVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Iconsax.cloud,
                          size: 16, // Smaller icon
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.toUpperCase(),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                            fontSize: isSmallScreen ? 14 : 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: statusColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 14, // Smaller icon
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusText.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final Color color;
  final String label;
  final bool isCompact;

  const _StatusIndicator({
    required this.color,
    required this.label,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: isCompact ? 10 : 12, // Smaller in compact mode
          height: isCompact ? 10 : 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4), // Reduced spacing
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: isCompact ? 11 : 12,
          ),
        ),
      ],
    );
  }
}
