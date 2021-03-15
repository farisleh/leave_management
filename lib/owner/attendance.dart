import 'package:flutter/material.dart';
import 'package:leave_management/owner/history.dart';
import 'package:leave_management/owner/scan.dart';
import 'package:leave_management/user.dart';

class AttendanceOwner extends StatefulWidget {
  final User user;

  const AttendanceOwner({Key key, this.user}) : super(key: key);

  @override
  _AttendanceOwnerState createState() => _AttendanceOwnerState();
}

class _AttendanceOwnerState extends State<AttendanceOwner> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      ScanOwner(user: widget.user),
      HistoryOwner(user: widget.user),
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
