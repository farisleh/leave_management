import 'package:flutter/material.dart';
import 'package:leave_management/hod/viewacceptleave.dart';
import 'package:leave_management/hod/viewrejectleave.dart';
import 'package:leave_management/hod/viewstaffleave.dart';
import 'package:leave_management/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StaffLeaveDashboardHod extends StatefulWidget {
  final User user;

  const StaffLeaveDashboardHod({Key key, this.user}) : super(key: key);
  @override
  _StaffLeaveDashboardHod createState() => new _StaffLeaveDashboardHod();
}

class _StaffLeaveDashboardHod extends State<StaffLeaveDashboardHod> {
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
              StaffPendingScreenHod(),
              StaffAcceptScreenHod(),
              StaffRejectScreenHod(),
            ],
          ),
        ),
      ),
    );
  }
}

class StaffPendingScreenHod extends StatefulWidget {
  final User user;
  const StaffPendingScreenHod({Key key, this.user});

  @override
  _StaffPendingScreenHodState createState() => _StaffPendingScreenHodState();
}

class _StaffPendingScreenHodState extends State<StaffPendingScreenHod> {
  List data = [];
  GlobalKey<RefreshIndicatorState> refreshKey;
  Future fetchData() async {
    final response = await http
        .get("https://attendance.inspirazs.com/php/get_pendingleave_hod.php");

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
                                                ViewStaffLeaveHod(
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
    final response = await http
        .get("https://attendance.inspirazs.com/php/get_pendingleave_hod.php");

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

class StaffAcceptScreenHod extends StatefulWidget {
  final User user;
  const StaffAcceptScreenHod({Key key, this.user});

  @override
  _StaffAcceptScreenHodState createState() => _StaffAcceptScreenHodState();
}

class _StaffAcceptScreenHodState extends State<StaffAcceptScreenHod> {
  List data = [];
  GlobalKey<RefreshIndicatorState> refreshKey;
  Future fetchData() async {
    final response = await http
        .get("https://attendance.inspirazs.com/php/get_acceptleave_hod.php");

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
                                                ViewAcceptLeaveHod(
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
    final response = await http
        .get("https://attendance.inspirazs.com/php/get_acceptleave_hod.php");

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

class StaffRejectScreenHod extends StatefulWidget {
  final User user;
  const StaffRejectScreenHod({Key key, this.user});

  @override
  _StaffRejectScreenHodState createState() => _StaffRejectScreenHodState();
}

class _StaffRejectScreenHodState extends State<StaffRejectScreenHod> {
  List data = [];
  GlobalKey<RefreshIndicatorState> refreshKey;
  Future fetchData() async {
    final response = await http
        .get("https://attendance.inspirazs.com/php/get_rejectleave_hod.php");

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
                                                ViewRejectLeaveHod(
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
    final response = await http
        .get("https://attendance.inspirazs.com/php/get_rejectleave_hod.php");

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
