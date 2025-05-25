import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/providers/watch_providers.dart';

/// Snackbar-style loading overlay for the watch screen
class LoadingOverlay extends ConsumerWidget {
  final VoidCallback onRetry;

  const LoadingOverlay({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchState = ref.watch(watchProvider);

    if (!watchState.sourceLoading && !watchState.episodesLoading) {
      return const SizedBox.shrink();
    }

    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: watchState.sourceLoading || watchState.episodesLoading
          ? Offset.zero
          : const Offset(1, 0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        child: Container(
          width: 250,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                watchState.loadingMessage ?? 'Loading...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onRetry,
                child: Icon(
                  Iconsax.repeat_circle,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
