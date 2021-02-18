import 'package:flutter/material.dart';
import 'package:leave_management/manager/viewacceptleave.dart';
import 'package:leave_management/manager/viewrejectleave.dart';
import 'package:leave_management/manager/viewstaffleave.dart';
import 'package:leave_management/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StaffLeaveDashboardManager extends StatefulWidget {
  final User user;

  const StaffLeaveDashboardManager({Key key, this.user}) : super(key: key);
  @override
  _StaffLeaveDashboardManager createState() =>
      new _StaffLeaveDashboardManager();
}

class _StaffLeaveDashboardManager extends State<StaffLeaveDashboardManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[],
            bottom: TabBar(
              tabs: [
                Tab(
                    child: Text(
                  'PENDING',
                  style: TextStyle(fontSize: 14),
                )),
                Tab(
                    child: Text(
                  'ACCEPTED',
                  style: TextStyle(fontSize: 14),
                )),
                Tab(
                    child: Text(
                  'REJECTED',
                  style: TextStyle(fontSize: 14),
                )),
              ],
            ),
            title: Text('Staff Leave Status'),
          ),
          body: TabBarView(
            children: [
              StaffPendingScreenManager(),
              StaffAcceptScreenManager(),
              StaffRejectScreenManager(),
            ],
          ),
        ),
      ),
    );
  }
}

class StaffPendingScreenManager extends StatefulWidget {
  final User user;
  const StaffPendingScreenManager({Key key, this.user});

  @override
  _StaffPendingScreenManagerState createState() =>
      _StaffPendingScreenManagerState();
}

class _StaffPendingScreenManagerState extends State<StaffPendingScreenManager> {
  List data = [];
  GlobalKey<RefreshIndicatorState> refreshKey;
  Future fetchData() async {
    final response = await http.get(
        "https://attendance.inspirazs.com/php/get_pendingleave_manager.php");

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    //init();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      key: refreshKey,
      color: Colors.deepOrange,
      onRefresh: () async {
        await refreshList();
      },
      child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List list = snapshot.data;
                      return Container(
                          width: 410,
                          height: 210,
                          padding: new EdgeInsets.all(10.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.purple,
                            elevation: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      "https://attendance.inspirazs.com/profile/${list[index]['employee_email']}.jpg",
                                    ),
                                  ),
                                  title: Text(list[index]['leave_type'],
                                      style: TextStyle(fontSize: 22.0)),
                                  subtitle: Text(
                                      list[index]['employee_name'] +
                                          '\n' +
                                          'Applied On: ' +
                                          list[index]['convert_create_at'] +
                                          '\n' +
                                          list[index]['convert_start_date'] +
                                          ' - ' +
                                          list[index]['convert_end_date'] +
                                          '\n' +
                                          'Status: Pending',
                                      style: TextStyle(fontSize: 16.0)),
                                  isThreeLine: true,
                                ),
                                ButtonBar(
                                  children: <Widget>[
                                    RaisedButton(
                                      child: const Text('VIEW'),
                                      color: Colors.blue,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewStaffLeaveManager(
                                                    id: list[index]['id'],
                                                    dateApplied:
                                                        list[index][
                                                            'convert_create_at'],
                                                    email: list[index]
                                                        ['employee_email'],
                                                    name: list[index]
                                                        ['employee_name'],
                                                    leave: list[index]
                                                        ['leave_type'],
                                                    desc: list[index]
                                                        ['description'],
                                                    startDate: list[index]
                                                        ['convert_start_date'],
                                                    endDate: list[index]
                                                        ['convert_end_date']),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    ));
  }

  Future makeRequest() async {
    final response = await http.get(
        "https://attendance.inspirazs.com/php/get_pendingleave_manager.php");

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

class StaffAcceptScreenManager extends StatefulWidget {
  final User user;
  const StaffAcceptScreenManager({Key key, this.user});

  @override
  _StaffAcceptScreenManagerState createState() =>
      _StaffAcceptScreenManagerState();
}

class _StaffAcceptScreenManagerState extends State<StaffAcceptScreenManager> {
  List data = [];
  GlobalKey<RefreshIndicatorState> refreshKey;
  Future fetchData() async {
    final response = await http.get(
        "https://attendance.inspirazs.com/php/get_acceptleave_manager.php");

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    //init();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      key: refreshKey,
      color: Colors.deepOrange,
      onRefresh: () async {
        await refreshList();
      },
      child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List list = snapshot.data;
                      return Container(
                          width: 410,
                          height: 210,
                          padding: new EdgeInsets.all(10.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.green,
                            elevation: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      "https://attendance.inspirazs.com/profile/${list[index]['employee_email']}.jpg",
                                    ),
                                  ),
                                  title: Text(list[index]['leave_type'],
                                      style: TextStyle(fontSize: 22.0)),
                                  subtitle: Text(
                                      list[index]['employee_name'] +
                                          '\n' +
                                          'Applied On: ' +
                                          list[index]['convert_create_at'] +
                                          '\n' +
                                          list[index]['convert_start_date'] +
                                          ' - ' +
                                          list[index]['convert_end_date'] +
                                          '\n' +
                                          'Status: Accepted',
                                      style: TextStyle(fontSize: 16.0)),
                                  isThreeLine: true,
                                ),
                                ButtonBar(
                                  children: <Widget>[
                                    RaisedButton(
                                      child: const Text('VIEW'),
                                      color: Colors.blue,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewAcceptLeaveManager(
                                                    id: list[index]['id'],
                                                    dateApplied: list[index]
                                                        ['convert_create_at'],
                                                    email: list[index]
                                                        ['employee_email'],
                                                    name: list[index]
                                                        ['employee_name'],
                                                    leave: list[index]
                                                        ['leave_type'],
                                                    desc: list[index]
                                                        ['description'],
                                                    startDate: list[index]
                                                        ['convert_start_date'],
                                                    endDate: list[index]
                                                        ['convert_end_date']),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    ));
  }

  Future makeRequest() async {
    final response = await http.get(
        "https://attendance.inspirazs.com/php/get_acceptleave_manager.php");

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

class StaffRejectScreenManager extends StatefulWidget {
  final User user;
  const StaffRejectScreenManager({Key key, this.user});

  @override
  _StaffRejectScreenManagerState createState() =>
      _StaffRejectScreenManagerState();
}

class _StaffRejectScreenManagerState extends State<StaffRejectScreenManager> {
  List data = [];
  GlobalKey<RefreshIndicatorState> refreshKey;
  Future fetchData() async {
    final response = await http.get(
        "https://attendance.inspirazs.com/php/get_rejectleave_manager.php");

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    //init();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      key: refreshKey,
      color: Colors.deepOrange,
      onRefresh: () async {
        await refreshList();
      },
      child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List list = snapshot.data;
                      return Container(
                          width: 410,
                          height: 210,
                          padding: new EdgeInsets.all(10.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.red[600],
                            elevation: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      "https://attendance.inspirazs.com/profile/${list[index]['employee_email']}.jpg",
                                    ),
                                  ),
                                  title: Text(list[index]['leave_type'],
                                      style: TextStyle(fontSize: 22.0)),
                                  subtitle: Text(
                                      list[index]['employee_name'] +
                                          '\n' +
                                          'Applied On: ' +
                                          list[index]['convert_create_at'] +
                                          '\n' +
                                          list[index]['convert_start_date'] +
                                          ' - ' +
                                          list[index]['convert_end_date'] +
                                          '\n' +
                                          'Status: Rejected',
                                      style: TextStyle(fontSize: 16.0)),
                                  isThreeLine: true,
                                ),
                                ButtonBar(
                                  children: <Widget>[
                                    RaisedButton(
                                      child: const Text('VIEW'),
                                      color: Colors.blue,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewRejectLeaveManager(
                                                    id: list[index]['id'],
                                                    dateApplied: list[index]
                                                        ['convert_create_at'],
                                                    email: list[index]
                                                        ['employee_email'],
                                                    name: list[index]
                                                        ['employee_name'],
                                                    leave: list[index]
                                                        ['leave_type'],
                                                    desc: list[index]
                                                        ['description'],
                                                    startDate: list[index]
                                                        ['convert_start_date'],
                                                    endDate: list[index]
                                                        ['convert_end_date']),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    ));
  }

  Future makeRequest() async {
    final response = await http.get(
        "https://attendance.inspirazs.com/php/get_rejectleave_manager.php");

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
