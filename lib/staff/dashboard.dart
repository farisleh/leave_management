import 'package:flutter/material.dart';
import 'package:leave_management/staff/myleavedashboard.dart';
import 'package:leave_management/staff/profile.dart';
import 'package:leave_management/staff/scan.dart';
import 'package:leave_management/staff/staff.dart';
import 'package:leave_management/user.dart';

class DashboardStaff extends StatefulWidget {
  final User user;

  const DashboardStaff({Key key, this.user}) : super(key: key);

  @override
  _DashboardStaffState createState() => _DashboardStaffState();
}

class _DashboardStaffState extends State<DashboardStaff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspirazs Staff Management'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              currentAccountPicture: new CircleAvatar(
                radius: 50.0,
                backgroundColor: const Color(0xFF778899),
                backgroundImage: NetworkImage(
                    "https://attendance.inspirazs.com/profile/${widget.user.email}.jpg"),
              ),
              accountEmail: Text(widget.user.email),
              accountName: Text(widget.user.name),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: <Widget>[
          Card(
            elevation: 10,
            color: Colors.blue,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(9.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StaffView(),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 13.0 / 11.0,
                    child: Image.asset('assets/images/office-staff.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Staff",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 10,
            color: Colors.yellow,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(9.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScanStaff(user: widget.user),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 13.0 / 11.0,
                    child: Image.asset('assets/images/barcode.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Attendance",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 10,
            color: Colors.red,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(9.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyLeaveDashboardStaff(user: widget.user),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 14.0 / 12.0,
                    child: Image.asset('assets/images/medical.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "My Leave",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 10,
            color: Colors.green,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(9.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileStaff(user: widget.user),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 14.0 / 12.0,
                    child: Image.asset('assets/images/profile.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Profile",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
