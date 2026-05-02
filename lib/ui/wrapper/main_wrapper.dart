import 'package:flutter/material.dart';
import '../home/currency_screen.dart';
import '../news/news_screen.dart';
import '../widgets/custom_drawer.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const CurrencyScreen(),
    const NewsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RATESHIFT'),
        centerTitle: true,
        // Removed the actions array so the AppBar is clean
      ),
      drawer: const CustomDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Convert'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'News'),
        ],
      ),
    );
  }
}