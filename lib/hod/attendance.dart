import 'package:flutter/material.dart';
import 'package:leave_management/hod/history.dart';
import 'package:leave_management/hod/scan.dart';
import 'package:leave_management/user.dart';

class AttendanceHod extends StatefulWidget {
  final User user;

  const AttendanceHod({Key key, this.user}) : super(key: key);

  @override
  _AttendanceHodState createState() => _AttendanceHodState();
}

class _AttendanceHodState extends State<AttendanceHod> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      ScanHod(user: widget.user),
      HistoryHod(user: widget.user),
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
