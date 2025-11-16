// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/regrow_provider.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/tracker_screen.dart';
import 'screens/volunteer_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const ReGrowApp());
}

class ReGrowApp extends StatelessWidget {
  const ReGrowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegrowProvider()..loadAll(),
      child: MaterialApp(
        title: 'ReGrow Prototype',
        theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        home: MainTabs(),
      ),
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({Key? key}) : super(key: key);
  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _index = 0;

  final List<Widget> tabs = [
    HomeScreen(),
    MapScreen(),
    TrackerScreen(),
    VolunteerScreen(),
    // Profile - replace placeholders with your info
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _index = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Tracker'),
          BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism), label: 'Volunteer'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
