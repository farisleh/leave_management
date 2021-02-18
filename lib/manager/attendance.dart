import 'package:flutter/material.dart';
import 'package:leave_management/manager/history.dart';
import 'package:leave_management/manager/scan.dart';
import 'package:leave_management/user.dart';

class AttendanceManager extends StatefulWidget {
  final User user;

  const AttendanceManager({Key key, this.user}) : super(key: key);

  @override
  _AttendanceManagerState createState() => _AttendanceManagerState();
}

class _AttendanceManagerState extends State<AttendanceManager> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      ScanManager(user: widget.user),
      HistoryManager(user: widget.user),
    ];
  }

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        //backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            title: Text("QR Scan"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text("History"),
          ),
        ],
      ),
    );
  }
}
