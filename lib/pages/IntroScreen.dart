import 'package:flutter/material.dart';
import '../component/intro_page.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  final List<IntroPage> _pages = [
    IntroPage(
      title: "MYTODO",
      description: "Welcome to the app!",
    ),
    IntroPage(
      title: "Manage Your Tasks",
      description: "Easily keep track of your daily tasks.",
    ),
    IntroPage(
      title: "Stay Organized",
      description: "Organize your tasks with categories.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
      ),
    );
  }
}
