import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'package:leave_management/user.dart';

class HistoryManager extends StatefulWidget {
  final User user;

  const HistoryManager({Key key, this.user}) : super(key: key);
  @override
  _HistoryManagerState createState() => new _HistoryManagerState();
}

class _HistoryManagerState extends State<HistoryManager> {
  List data = [];
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  initState() {
    fetchData();
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  void fetchData() async {
    final response = await http
        .get("https://attendance.inspirazs.com/php/get_attendance.php");

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
        groupComparator: (value1, value2) => value2.compareTo(value1),
        itemComparator: (item1, item2) =>
            item1['name'].compareTo(item2['name']),
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
                    element['time_out']),
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
