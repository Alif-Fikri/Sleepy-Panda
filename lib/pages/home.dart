import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sleepys/app/modules/journal/daily/journal_daily_binding.dart';
import 'package:sleepys/app/modules/journal/daily/journal_daily_controller.dart';
import 'package:sleepys/app/modules/journal/daily/journal_daily_view.dart';
import 'package:sleepys/app/modules/journal/monthly/journal_monthly_binding.dart';
import 'package:sleepys/app/modules/journal/monthly/journal_monthly_controller.dart';
import 'package:sleepys/app/modules/journal/monthly/journal_monthly_view.dart';
import 'package:sleepys/app/modules/journal/weekly/journal_weekly_binding.dart';
import 'package:sleepys/app/modules/journal/weekly/journal_weekly_controller.dart';
import 'package:sleepys/app/modules/journal/weekly/journal_weekly_view.dart';
import 'package:sleepys/app/modules/metrics/blood_pressure/blood_pressure_binding.dart';
import 'package:sleepys/app/modules/metrics/blood_pressure/blood_pressure_controller.dart';
import 'package:sleepys/app/modules/metrics/blood_pressure/blood_pressure_view.dart';
import 'package:sleepys/app/modules/profile/profile_binding.dart';
import 'package:sleepys/app/modules/profile/profile_controller.dart';
import 'package:sleepys/app/modules/profile/profile_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _registerDependencies();
    _widgetOptions = <Widget>[
      const JurnalTidurPage(),
      const BloodPressureView(),
      const ProfileView(),
    ];
  }

  void _registerDependencies() {
    if (!Get.isRegistered<BloodPressureController>()) {
      BloodPressureBinding().dependencies();
    }
    if (!Get.isRegistered<ProfileController>()) {
      ProfileBinding().dependencies();
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF20223F),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/book.png')),
              label: 'Jurnal Tidur',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/sleep.png')),
              label: 'Sleep',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/profile.png')),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: const Color(0xFF272E49),
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFF627EAE),
          selectedLabelStyle: const TextStyle(
            color: Color(0xFF627EAE),
            fontFamily: 'Urbanist',
          ),
          unselectedLabelStyle: const TextStyle(
            color: Color(0xFF627EAE),
            fontFamily: 'Urbanist',
          ),
          selectedIconTheme: const IconThemeData(color: Color(0xFFFFC754)),
          unselectedIconTheme: const IconThemeData(color: Color(0xFF627EAE)),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class JurnalTidurPage extends StatefulWidget {
  const JurnalTidurPage({super.key});

  @override
  State<JurnalTidurPage> createState() => _JurnalTidurPageState();
}

class _JurnalTidurPageState extends State<JurnalTidurPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _registerJournalControllers();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _registerJournalControllers() {
    if (!Get.isRegistered<JournalDailyController>()) {
      JournalDailyBinding().dependencies();
    }
    if (!Get.isRegistered<JournalWeeklyController>()) {
      JournalWeeklyBinding().dependencies();
    }
    if (!Get.isRegistered<JournalMonthlyController>()) {
      JournalMonthlyBinding().dependencies();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF20223F),
        title: const Text(
          'Jurnal Tidur',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Urbanist',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF20223F),
                    width: 0,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                labelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 15,
                ),
                unselectedLabelColor: const Color(0xFFFBFBFB),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 15,
                ),
                tabs: const [
                  Tab(text: 'Daily'),
                  Tab(text: 'Week'),
                  Tab(text: 'Month'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          JournalDailyView(),
          JournalWeeklyView(),
          JournalMonthlyView(),
        ],
      ),
    );
  }
}
