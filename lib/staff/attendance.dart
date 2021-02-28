import 'package:flutter/material.dart';
import 'package:leave_management/staff/history.dart';
import 'package:leave_management/staff/scan.dart';
import 'package:leave_management/user.dart';

class AttendanceStaff extends StatefulWidget {
  final User user;

  const AttendanceStaff({Key key, this.user}) : super(key: key);

  @override
  _AttendanceStaffState createState() => _AttendanceStaffState();
}

class _AttendanceStaffState extends State<AttendanceStaff> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      ScanStaff(user: widget.user),
      HistoryStaff(user: widget.user),
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
