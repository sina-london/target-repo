import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shonenx/core/registery/anime_source_registery_provider.dart';
import 'package:shonenx/core/utils/app_logger.dart';
import 'package:shonenx/data/hive/providers/home_page_provider.dart';
import 'package:shonenx/data/hive/providers/ui_provider.dart';

/// Enhanced loading screen with better error handling, debugging capabilities, and anime quotes.
class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final AnimationController _pulseController;
  late final AnimationController _fadeController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _fadeAnimation;

  String _currentStatus = 'Initializing...';
  bool _hasError = false;
  String? _errorMessage;
  // ignore: unused_field
  double _manualProgress = 0.0;

  // Simple quote system
  int _currentQuoteIndex = 0;
  Timer? _quoteTimer;

  // Timeout timer to prevent infinite loading
  Timer? _timeoutTimer;
  static const Duration _initializationTimeout = Duration(seconds: 30);

  // Simple anime quotes
  static const List<String> _quotes = [
    '"Believe in yourself!" - Gurren Lagann',
    '"Hard work beats talent!" - Rock Lee',
    '"Never give up!" - Naruto',
    '"The future is now!" - One Piece',
    '"Dreams come true!" - Fairy Tail',
  ];

  @override
  void initState() {
    super.initState();
    AppLogger.d('Initializing Enhanced LoadingScreen with Anime Quotes');

    _initializeAnimations();
    _startQuoteRotation();
    _startTimeoutTimer();

    // Initialize app after first frame with error handling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAppSafely();
    });
  }

  void _initializeAnimations() {
    // Pulse animation for logo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    // Progress animation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    // Fade animation for status changes
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  void _startQuoteRotation() {
    _quoteTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && !_hasError) {
        setState(() {
          _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
        });
      }
    });
  }

  void _startTimeoutTimer() {
    _timeoutTimer = Timer(_initializationTimeout, () {
      if (mounted && !_hasError) {
        AppLogger.e(
            'Initialization timeout after ${_initializationTimeout.inSeconds} seconds');
        _handleError('Initialization timed out. Please restart the app.');
      }
    });
  }

  @override
  void dispose() {
    AppLogger.d('Disposing Enhanced LoadingScreen');
    _timeoutTimer?.cancel();
    _quoteTimer?.cancel();
    _pulseController.dispose();
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  /// Safely initializes the app with comprehensive error handling.
  Future<void> _initializeAppSafely() async {
    try {
      await _initializeApp();
    } catch (e, stackTrace) {
      AppLogger.e('Critical initialization error: $e', e, stackTrace);
      _handleError('Failed to initialize app: ${e.toString()}');
    }
  }

  /// Main initialization logic with detailed progress tracking.
  Future<void> _initializeApp() async {
    AppLogger.d('Starting comprehensive app initialization');

    try {
      // Step 1: Initialize basic services
      _updateStatus('Setting up core services...', 0.1);
      await Future.delayed(
          const Duration(milliseconds: 500)); // Allow UI to update

      // Step 2: Initialize anime registry
      _updateStatus('Loading anime sources...', 0.3);
      final animeRegistryNotifier =
          ref.read(animeSourceRegistryProvider.notifier);
      await animeRegistryNotifier.initialize(null);

      // Verify registry initialization
      final registryState = ref.read(animeSourceRegistryProvider);
      if (!registryState.registry.isInitialized) {
        throw Exception(
            'Anime source registry failed to initialize: ${registryState.error ?? 'Unknown error'}');
      }
      AppLogger.d('✅ Anime source registry initialized successfully');

      // Step 3: Initialize homepage
      _updateStatus('Preparing homepage...', 0.6);
      final homepageNotifier = ref.read(homepageProvider.notifier);
      await homepageNotifier.initialize();
      AppLogger.d('✅ Homepage initialized successfully');

      // Step 4: Apply UI settings
      _updateStatus('Applying UI settings...', 0.8);
      await _applyUISettings();

      // Step 5: Final preparations
      _updateStatus('Finalizing setup...', 0.95);
      await Future.delayed(
          const Duration(milliseconds: 800)); // Allow animations to complete

      // Step 6: Complete and navigate
      _updateStatus('Ready!', 1.0);
      await Future.delayed(const Duration(milliseconds: 500));

      await _navigateToDefaultRoute();
    } catch (e, stackTrace) {
      AppLogger.e('Initialization step failed: $e', e, stackTrace);
      rethrow; // Re-throw to be caught by the outer try-catch
    }
  }

  /// Applies UI settings with error handling.
  Future<void> _applyUISettings() async {
    try {
      final uiSettings = ref.read(uiSettingsProvider);
      if (uiSettings.immersiveMode) {
        AppLogger.d('Enabling immersive mode');
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
      AppLogger.d('✅ UI settings applied successfully');
    } catch (e) {
      AppLogger.w('Failed to apply UI settings: $e');
      // Don't throw - UI settings failure shouldn't prevent app launch
    }
  }

  /// Navigates to the default route with validation.
  Future<void> _navigateToDefaultRoute() async {
    if (!mounted) {
      AppLogger.w('LoadingScreen unmounted before navigation');
      return;
    }

    try {
      final uiSettings = ref.read(uiSettingsProvider);
      final route = _getValidRoute(uiSettings.defaultTab);

      AppLogger.d('Navigating to default route: $route');
      _timeoutTimer?.cancel(); // Cancel timeout as we're about to navigate

      // Use pushReplacement to ensure we don't keep the loading screen in history
      context.pushReplacement(route);
    } catch (e) {
      AppLogger.e('Navigation failed: $e');
      // Fallback to home route
      context.pushReplacement('/');
    }
  }

  /// Validates and returns a safe route.
  String _getValidRoute(String? defaultTab) {
    const validRoutes = {
      'Home': '/',
      'Watchlist': '/watchlist',
      'Browse': '/browse',
    };

    return validRoutes[defaultTab] ?? '/';
  }

  /// Updates the loading status and progress.
  void _updateStatus(String status, double progress) {
    if (!mounted) return;

    setState(() {
      _currentStatus = status;
      _manualProgress = progress;
    });

    // Animate progress controller to match manual progress
    _progressController.animateTo(
      progress,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );

    AppLogger.d('Loading status: $status (${(progress * 100).toInt()}%)');
  }

  /// Handles errors by updating the UI and providing user feedback.
  void _handleError(String message) {
    if (!mounted) return;

    setState(() {
      _hasError = true;
      _errorMessage = message;
      _currentStatus = 'Error occurred';
    });

    _progressController.stop();
    _quoteTimer?.cancel(); // Stop quote rotation on error
    AppLogger.e('Loading error: $message');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: _buildContent(colorScheme, size, theme),
    );
  }

  /// Builds the main content with enhanced visual design.
  Widget _buildContent(ColorScheme colorScheme, Size size, ThemeData theme) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface,
            colorScheme.surfaceContainerLowest,
          ],
        ),
      ),
      child: Stack(
        children: [
          _buildBackgroundElements(colorScheme, size),
          _buildMainContent(colorScheme, size, theme),
          if (_hasError) _buildErrorOverlay(colorScheme, theme),
        ],
      ),
    );
  }

  /// Creates subtle background design elements.
  Widget _buildBackgroundElements(ColorScheme colorScheme, Size size) {
    return Stack(
      children: [
        _buildAccentCircle(
          top: -size.width * 0.15,
          right: -size.width * 0.15,
          color: colorScheme.primary,
          size: size.width * 0.4,
        ),
        _buildAccentCircle(
          bottom: -size.width * 0.2,
          left: -size.width * 0.1,
          color: colorScheme.secondary,
          size: size.width * 0.35,
        ),
        _buildAccentCircle(
          top: size.height * 0.3,
          right: -size.width * 0.3,
          color: colorScheme.tertiary,
          size: size.width * 0.25,
        ),
      ],
    );
  }

  /// Creates a decorative accent circle with enhanced gradient.
  Widget _buildAccentCircle({
    double? top,
    double? right,
    double? bottom,
    double? left,
    required Color color,
    required double size,
  }) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              color.withOpacity(0.08),
              color.withOpacity(0.03),
              color.withOpacity(0.0),
            ],
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Builds the centered content with enhanced animations.
  Widget _buildMainContent(
      ColorScheme colorScheme, Size size, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEnhancedLogo(colorScheme),
            const SizedBox(height: 48),
            _buildAppInfo(colorScheme),
            const SizedBox(height: 24),
            _buildSimpleQuote(colorScheme),
            const SizedBox(height: 48),
            _buildProgressSection(colorScheme, size),
            const SizedBox(height: 32),
            _buildDebugInfo(colorScheme),
          ],
        ),
      ),
    );
  }

  /// Enhanced logo with better visual effects.
  Widget _buildEnhancedLogo(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/icons/app_icon-modified-2.png',
                  width: 90,
                  height: 90,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.play_circle_filled,
                      size: 90,
                      color: colorScheme.primary,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// App name and tagline with better typography.
  Widget _buildAppInfo(ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          'ShonenX',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Premium Anime Experience',
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  /// Simple anime quote display.
  Widget _buildSimpleQuote(ColorScheme colorScheme) {
    if (_hasError) return const SizedBox.shrink();

    return Text(
      _quotes[_currentQuoteIndex],
      style: TextStyle(
        color: colorScheme.primary.withOpacity(0.8),
        fontSize: 14,
        fontStyle: FontStyle.italic,
        letterSpacing: 0.3,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Enhanced progress section with status updates.
  Widget _buildProgressSection(ColorScheme colorScheme, Size size) {
    return SizedBox(
      width: size.width * 0.7,
      child: Column(
        children: [
          _buildProgressBar(colorScheme, size),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              _currentStatus,
              style: TextStyle(
                color: _hasError
                    ? colorScheme.error
                    : colorScheme.onSurface.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Enhanced progress bar with gradient.
  Widget _buildProgressBar(ColorScheme colorScheme, Size size) {
    return Container(
      height: 6,
      width: size.width * 0.7,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(3),
      ),
      child: AnimatedBuilder(
        animation: _progressController,
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                height: 6,
                width: size.width * 0.7 * _progressController.value,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Debug information for development.
  Widget _buildDebugInfo(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Text(
          '${(_progressController.value * 100).toInt()}%',
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        );
      },
    );
  }

  /// Error overlay with retry option.
  Widget _buildErrorOverlay(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.error.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Initialization Failed',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage ?? 'An unexpected error occurred',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: const Text('Exit App'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _errorMessage = null;
                        _currentStatus = 'Retrying...';
                        _currentQuoteIndex = 0;
                      });
                      _progressController.reset();
                      _startQuoteRotation();
                      _initializeAppSafely();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
