import 'package:flutter/material.dart';
import 'package:nekoflow/routes/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String name = '';

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to ShonenX",
      "description": "Your gateway to endless anime adventures",
      "image": "lib/assets/images/onboarding/logo.png",
    },
    {
      "title": "Discover New Worlds",
      "description": "Explore thousands of anime series and movies",
      "image": "lib/assets/images/onboarding/home.png",
    },
    {
      "title": "Track Your Journey",
      "description": "Keep track of your watchlist and continue where you left off",
      "image": "lib/assets/images/onboarding/watchlist.png",
    },
    // {
    //   "title": "Join the Community",
    //   "description": "Connect with fellow anime fans and share your thoughts",
    //   "image": "lib/assets/images/onboarding/community.png",
    // },
  ];

  void _nextPage() {
    if (_currentPage < onboardingData.length) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AppRouter(name: name.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemCount: onboardingData.length + 1,
          itemBuilder: (context, index) {
            if (index < onboardingData.length) {
              return _buildOnboardingPage(index);
            }
            return _buildNameInputPage();
          },
        ),
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildOnboardingPage(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(
              onboardingData[index]['image']!,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            onboardingData[index]['title']!,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            onboardingData[index]['description']!,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildNameInputPage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What should we call you?",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Enter your name to personalize your experience",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              height: 1.4,
            ),
            // textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            onChanged: (value) => setState(() => name = value),
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: 'Name',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Progress indicators
          Row(
            children: List.generate(
              onboardingData.length + 1,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Next/Get Started button
          TextButton(
            onPressed: name.trim().isNotEmpty || _currentPage < onboardingData.length
                ? _nextPage
                : null,
            child: Text(
              _currentPage < onboardingData.length ? 'Next' : 'Get Started',
              style: TextStyle(
                fontSize: 18,
                color: (name.trim().isNotEmpty || _currentPage < onboardingData.length)
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}