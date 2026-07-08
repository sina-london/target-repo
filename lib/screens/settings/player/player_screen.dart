import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shonenx/data/hive/providers/player_provider.dart';
import 'package:shonenx/widgets/ui/shonenx_settings.dart';
import 'package:shonenx/widgets/ui/subtitle_customization_modal.dart';

class PlayerSettingsScreen extends ConsumerWidget {
  const PlayerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final settingsState = ref.watch(playerSettingsProvider);

    // if (settingsState.isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    return _buildContent(context, ref);
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final playerSettings = ref.watch(playerSettingsProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SettingsSection(context: context, title: 'Playback', items: [
          SettingsItem(
            icon: Iconsax.timer_1,
            title: 'Episode Completion',
            description:
                'Mark as watched at ${(playerSettings.episodeCompletionThreshold * 100).toStringAsFixed(0)}% completion',
            onTap: () => _setEpisodeCompletionThreshold(context, ref),
          ),
          SettingsItem(
            icon: Iconsax.forward,
            title: 'Playback Speed',
            description: 'Default speed: 1.0x', // Placeholder
            onTap: () => _setPlaybackSpeed(context, ref),
          ),
        ]),
        SettingsSection(context: context, title: 'Subtitles', items: [
          SettingsItem(
            icon: Iconsax.text,
            title: 'Subtitle Appearance',
            description:
                'Font size: ${playerSettings.subtitleFontSize.round()}px, Color: ${playerSettings.subtitleTextColor.toRadixString(16).substring(2)}',
            onTap: () => setSubtitleAppearance(context, ref),
          ),
          SettingsItem(
            onTap: () {},
            icon: Iconsax.clock,
            title: 'Subtitle Timing',
            description: 'Adjust subtitle sync and delay',
            disabled: true,
          ),
        ]),
        SettingsSection(context: context, title: 'Quality', items: [
          SettingsItem(
            onTap: () {},
            icon: Iconsax.video_tick,
            title: 'Video Quality',
            description: 'Default streaming quality settings',
            disabled: true,
          ),
        ]),
        const SizedBox(height: 48),
      ],
    );
  }

  void _setEpisodeCompletionThreshold(
      BuildContext context, WidgetRef ref) async {
    final playerSettings = ref.read(playerSettingsProvider);
    double tempValue = playerSettings.episodeCompletionThreshold;
    final colorScheme = Theme.of(context).colorScheme;

    final newThreshold = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Episode Completion Threshold',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: tempValue,
                    min: 0.5,
                    max: 1.0,
                    divisions: 10,
                    label: '${(tempValue * 100).toStringAsFixed(0)}%',
                    activeColor: colorScheme.primary,
                    inactiveColor: colorScheme.surfaceContainerHighest,
                    onChanged: (value) {
                      setDialogState(() {
                        tempValue = value;
                      });
                    },
                  ),
                  Text(
                    'Mark as watched at ${(tempValue * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(color: colorScheme.onSurface)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, tempValue),
              child: Text('Save', style: TextStyle(color: colorScheme.primary)),
            ),
          ],
        );
      },
    );

    if (newThreshold != null &&
        newThreshold != playerSettings.episodeCompletionThreshold) {
      ref.read(playerSettingsProvider.notifier).updateSettings(
            (prev) => prev.copyWith(episodeCompletionThreshold: newThreshold),
          );
    }
  }

  void _setPlaybackSpeed(BuildContext context, WidgetRef ref) async {
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
    double tempSpeed = 1.0; // Placeholder
    final colorScheme = Theme.of(context).colorScheme;

    final newSpeed = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Default Playback Speed',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: speeds
                    .map(
                      (speed) => RadioListTile<double>(
                        title: Text('${speed}x'),
                        value: speed,
                        groupValue: tempSpeed,
                        activeColor: colorScheme.primary,
                        onChanged: (value) {
                          setDialogState(() {
                            tempSpeed = value!;
                          });
                        },
                      ),
                    )
                    .toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(color: colorScheme.onSurface)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, tempSpeed),
              child: Text('Save', style: TextStyle(color: colorScheme.primary)),
            ),
          ],
        );
      },
    );

    if (newSpeed != null) {
      // Placeholder: Add defaultPlaybackSpeed to PlayerSettingsModel later
    }
  }
}
