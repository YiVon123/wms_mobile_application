import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wms_mobile_application/providers/service_provider.dart';
import 'screens/home_page.dart';
import 'screens/schedule_page.dart';
import 'screens/profile_page.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/curved_nav_bar.dart';
import 'constants/colors.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // accessible for all pages
        create: (context) => ServiceProvider(),
        child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curved Navigation App',
      theme: ThemeData(
        primarySwatch: AppColors.blue,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomePage(),
    const SchedulePage(),
    const ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  void _onNavTapped(int index) {
    setState(() {
      _pageIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(pageIndex: _pageIndex),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavBar(
        pageIndex: _pageIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}