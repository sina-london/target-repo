import 'package:flutter/material.dart';
import 'package:nekoflow/routes/app_router.dart';  // Import your custom AppRouter

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  // List of onboarding steps
  final List<Map<String, String>> onboardingData = [
    {
      "title": "ShonenX!",
      "description": "The ultimate anime streaming experience.",
      "image":
          "https://camo.githubusercontent.com/eb14bb0a22e968d92f9e873e0b9d40f6cb48d1572a875d0e4e5a8465eb379648/68747470733a2f2f692e706f7374696d672e63632f467a6d3439735a632f506963736172742d32342d31302d32392d31302d30332d31352d3133332e706e67",
    },
    {
      "title": "Track Your Progress",
      "description": "Keep tabs on your favorite shows and episodes.",
      "image": "https://wallpapercave.com/wp/wp10388221.jpg",
    },
  ];

  // Method to go to the next page
  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // After the last page, navigate to the AppRouter (Home screen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppRouter()),
      );
    }
  }

  // Method to go to the previous page
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black, // Dark background for an anime look
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: onboardingData.length,
        itemBuilder: (context, index) {
          return OnboardingPage(
            title: onboardingData[index]['title']!,
            description: onboardingData[index]['description']!,
            image: onboardingData[index]['image']!,
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _currentPage > 0
                ? IconButton(
                    icon: Icon(Icons.navigate_before, size: 40),
                    onPressed: _previousPage,
                  )
                : SizedBox(width: 40), // No button if on the first page
            Row(
              children: List.generate(onboardingData.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            _currentPage < onboardingData.length - 1
                ? IconButton(
                    icon: Icon(Icons.navigate_next, size: 40),
                    onPressed: _nextPage,
                  )
                : TextButton(
                    onPressed: _nextPage,
                    child: Text(
                      'Get Started',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Display the image with a nice rounded border
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image,
              width: 300, // Fixed width
              height: 200, // Fixed height
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white60),
          ),
        ],
      ),
    );
  }
}
