import 'package:capstone/utils/profile_type.dart';
import 'package:capstone/views/collector_home_page.dart';
import 'package:capstone/views/profile_page.dart';
import 'package:capstone/views/sustainable_practices.dart';
import 'package:capstone/views/user_history.dart';
import 'package:capstone/views/waste_collectors.dart';
import 'package:flutter/material.dart';

class CollectorMainPage extends StatefulWidget {
  const CollectorMainPage({super.key});

  @override
  State<CollectorMainPage> createState() => _CollectorMainPageState();
}

class _CollectorMainPageState extends State<CollectorMainPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
      _tabController!.index = _currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const [
          CollectorHomePage(),
          WasteCollectors(),
          WastePractices(),
          ProfilePage(profileType: ProfileType.user),
          UserHistory()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Earnings',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Profile',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _currentIndex,
        onTap: changePage,
        showUnselectedLabels: true,
      ),
    );
  }
}
