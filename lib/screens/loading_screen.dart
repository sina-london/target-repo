import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shonenx/core/registery/anime_source_registery_provider.dart';
import 'package:shonenx/core/utils/app_logger.dart';
import 'package:shonenx/data/hive/providers/home_page_provider.dart';
import 'package:shonenx/data/hive/providers/ui_provider.dart';

/// Displays a loading screen with a pulsing logo and progress bar during app initialization.
class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    AppLogger.d('Initializing LoadingScreen');

    // Pulse animation for logo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    // Progress animation for bar
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();
    _progressController.addListener(() {
      if (_progressController.value >= 0.95) {
        _progressController.stop();
      }
    });

    // Initialize app after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeApp());
  }

  @override
  void dispose() {
    AppLogger.d('Disposing LoadingScreen');
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  /// Initializes the app by setting up providers and navigating to the default route.
  Future<void> _initializeApp() async {
    AppLogger.d('Starting app initialization');
    try {
      // Initialize providers
      final animeRegistryNotifier = ref.read(animeSourceRegistryProvider.notifier);
      final homepageNotifier = ref.read(homepageProvider.notifier);

      await Future.wait([
        animeRegistryNotifier.initialize(null),
        homepageNotifier.initialize(),
      ]);

      final registryState = ref.read(animeSourceRegistryProvider);
      if (!registryState.registry.isInitialized) {
        throw Exception('Anime source registry failed: ${registryState.error}');
      }
      AppLogger.d('Anime source registry and homepage initialized');

      // Complete progress animation
      await _progressController.animateTo(1.0, duration: const Duration(milliseconds: 300));

      // Apply UI settings
      final uiSettings = ref.read(uiSettingsProvider);
      if (uiSettings.immersiveMode) {
        AppLogger.d('Enabling immersive mode');
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }

      // Navigate to default route
      final route = {
        'Home': '/',
        'Watchlist': '/watchlist',
        'Browse': '/browse',
      }[uiSettings.defaultTab] ?? '/';
      AppLogger.d('Navigating to default route: $route');
      if (mounted) {
        context.go(route);
      } else {
        AppLogger.w('LoadingScreen unmounted before navigation');
      }
    } catch (e, stackTrace) {
      AppLogger.e('Initialization failed: $e', e, stackTrace);
      if (mounted) {
        context.go('/error', extra: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: _buildContent(colorScheme, size),
    );
  }

  /// Builds the main content with gradient background, accent circles, and loading UI.
  Widget _buildContent(ColorScheme colorScheme, Size size) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.surface, colorScheme.surface],
        ),
      ),
      child: Stack(
        children: [
          _buildAccentCircle(
            top: -size.width * 0.2,
            right: -size.width * 0.2,
            color: colorScheme.primary,
          ),
          _buildAccentCircle(
            bottom: -size.width * 0.25,
            left: -size.width * 0.1,
            color: colorScheme.secondary,
          ),
          _buildMainContent(colorScheme, size),
        ],
      ),
    );
  }

  /// Creates a decorative accent circle with a radial gradient.
  Widget _buildAccentCircle({
    double? top,
    double? right,
    double? bottom,
    double? left,
    required Color color,
  }) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [color.withOpacity(0.05), color.withOpacity(0.0)],
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Builds the centered content with logo, app name, tagline, and progress bar.
  Widget _buildMainContent(ColorScheme colorScheme, Size size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPulsingLogo(colorScheme),
          const SizedBox(height: 40),
          _buildAppName(colorScheme),
          const SizedBox(height: 8),
          _buildTagline(colorScheme),
          const SizedBox(height: 48),
          _buildProgressBar(colorScheme, size),
        ],
      ),
    );
  }

  /// Creates the pulsing logo with shadow.
  Widget _buildPulsingLogo(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.12),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/app_icon-modified-2.png',
                width: 80,
                height: 80,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Displays the app name.
  Widget _buildAppName(ColorScheme colorScheme) {
    return Text(
      'ShonenX',
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
    );
  }

  /// Displays the tagline.
  Widget _buildTagline(ColorScheme colorScheme) {
    return Text(
      'Premium Anime Experience',
      style: TextStyle(
        color: colorScheme.onSurface.withOpacity(0.7),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// Builds the animated progress bar and loading text.
  Widget _buildProgressBar(ColorScheme colorScheme, Size size) {
    return SizedBox(
      width: size.width * 0.6,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 4,
                width: size.width * 0.6,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return Container(
                    height: 4,
                    width: size.width * 0.6 * _progressController.value,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return Text(
                _progressController.value < 1.0 ? 'Loading...' : 'Ready',
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}