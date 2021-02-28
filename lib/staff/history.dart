import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'package:leave_management/user.dart';

class HistoryStaff extends StatefulWidget {
  final User user;

  const HistoryStaff({Key key, this.user}) : super(key: key);
  @override
  _HistoryStaffState createState() => new _HistoryStaffState();
}

class _HistoryStaffState extends State<HistoryStaff> {
  List data = [];
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  initState() {
    fetchData();
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  void fetchData() async {
    final response = await http.post(
        "https://attendance.inspirazs.com/php/get_myattendance.php",
        body: {'name': widget.user.name});

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text('Attendance History'),
      ),
      body: GroupedListView<dynamic, String>(
        elements: data,
        groupBy: (data) => data['convert_date'],
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: true,
        groupSeparatorBuilder: (String value) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        itemBuilder: (c, element) {
          return Card(
            color: Colors.purple,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
            child: Container(
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://attendance.inspirazs.com/profile/${element['email']}.jpg",
                  ),
                ),
                title: Text(element['name']),
                trailing: Text('Check In: ' +
                    element['time_in'] +
                    '\n' +
                    'Check Out: ' +
                    element['time_out'].toString()),
              ),
            ),
          );
        },
      ),
    );
  }

  Future makeRequest() async {
    final response = await http
        .get("https://attendance.inspirazs.com/php/get_attendance.php");

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }
}
