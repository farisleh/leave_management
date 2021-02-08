import 'package:flutter/material.dart';
import 'package:leave_management/staff/viewacceptleave.dart';
import 'package:leave_management/staff/viewpendingleave.dart';
import 'package:leave_management/staff/viewrejectleave.dart';
import 'package:leave_management/user.dart';
import 'package:leave_management/staff/myleave.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class MyLeaveDashboardStaff extends StatefulWidget {
  final User user;

  const MyLeaveDashboardStaff({Key key, this.user}) : super(key: key);
  @override
  _MyLeaveDashboardStaff createState() => new _MyLeaveDashboardStaff();
}

class _MyLeaveDashboardStaff extends State<MyLeaveDashboardStaff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyLeaveStaff(user: widget.user),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.add,
                      size: 26.0,
                    ),
                  )),
            ],
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
            title: Text('Leave Status'),
          ),
          body: TabBarView(
            children: [
              MyPendingScreenStaff(user: widget.user),
              MyAcceptScreenStaff(user: widget.user),
              MyRejectScreenStaff(user: widget.user),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPendingScreenStaff extends StatefulWidget {
  final User user;
  const MyPendingScreenStaff({Key key, this.user}) : super(key: key);

  @override
  _MyPendingScreenStaffState createState() => _MyPendingScreenStaffState();
}

class _MyPendingScreenStaffState extends State<MyPendingScreenStaff> {
  List data = [];
  GlobalKey<RefreshIndicatorState> refreshKey;

  Future fetchData() async {
    final response = await http.post(
        "https://attendance.inspirazs.com/php/get_myleave.php",
        body: {'employee_name': widget.user.name});

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
                                          'Date Applied: ' +
                                          list[index]['create_at'] +
                                          '\n' +
                                          list[index]['start_date'] +
                                          ' - ' +
                                          list[index]['end_date'] +
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
                                                ViewPendingLeaveStaff(
                                                    id: list[index]['id'],
                                                    dateApplied: list[index]
                                                        ['create_at'],
                                                    email: list[index]
                                                        ['employee_email'],
                                                    name: list[index]
                                                        ['employee_name'],
                                                    leave:
                                                        list[index]
                                                            ['leave_type'],
                                                    desc:
                                                        list[index]
                                                            ['description'],
                                                    startDate: list[index]
                                                        ['start_date'],
                                                    endDate: list[index]
                                                        ['end_date']),
                                          ),
                                        );
                                      },
                                    ),
                                    RaisedButton(
                                      child: const Text('DELETE'),
                                      color: Colors.red,
                                      onPressed: () {
                                        deleteLeave(id: list[index]['id']);
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
    final response = await http.post(
        "https://attendance.inspirazs.com/php/get_myleave.php",
        body: {'employee_name': widget.user.name});

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

  void deleteLeave({String id}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Ready to delete?"),
          content: new Text("This leave's application will delete."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                updateDelete(id: id);
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateDelete({String id}) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Deleting...");
    pr.show();
    await http.post("https://attendance.inspirazs.com/php/delete_myleave.php",
        body: {'id': id}).then((res) async {
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        pr.hide();
        Navigator.pop(context);
      } else {
        pr.hide();
        Toast.show(res.body + ". Please reload", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
  }
}

class MyAcceptScreenStaff extends StatefulWidget {
  final User user;
  const MyAcceptScreenStaff({Key key, this.user}) : super(key: key);

  @override
  _MyAcceptScreenStaffState createState() => _MyAcceptScreenStaffState();
}

class _MyAcceptScreenStaffState extends State<MyAcceptScreenStaff> {
  List data = [];
  GlobalKey<RefreshIndicatorState> refreshKey;
  Future fetchData() async {
    final response = await http.post(
        "https://attendance.inspirazs.com/php/get_myleave_accept.php",
        body: {'employee_name': widget.user.name});

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
                                          'Date Applied: ' +
                                          list[index]['create_at'] +
                                          '\n' +
                                          list[index]['start_date'] +
                                          ' - ' +
                                          list[index]['end_date'] +
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
                                                ViewAcceptLeaveStaff(
                                                    id: list[index]['id'],
                                                    dateApplied: list[index]
                                                        ['create_at'],
                                                    email: list[index]
                                                        ['employee_email'],
                                                    name: list[index]
                                                        ['employee_name'],
                                                    leave: list[index]
                                                        ['leave_type'],
                                                    desc: list[index]
                                                        ['description'],
                                                    startDate: list[index]
                                                        ['start_date'],
                                                    endDate: list[index]
                                                        ['end_date']),
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
    final response = await http.post(
        "https://attendance.inspirazs.com/php/get_myleave_accept.php",
        body: {'employee_name': widget.user.name});

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

class MyRejectScreenStaff extends StatefulWidget {
  final User user;
  const MyRejectScreenStaff({Key key, this.user}) : super(key: key);

  @override
  _MyRejectScreenStaffState createState() => _MyRejectScreenStaffState();
}

class _MyRejectScreenStaffState extends State<MyRejectScreenStaff> {
  List data = [];
  GlobalKey<RefreshIndicatorState> refreshKey;
  Future fetchData() async {
    final response = await http.post(
        "https://attendance.inspirazs.com/php/get_myleave_reject.php",
        body: {'employee_name': widget.user.name});

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
                                          'Date Applied: ' +
                                          list[index]['create_at'] +
                                          '\n' +
                                          list[index]['start_date'] +
                                          ' - ' +
                                          list[index]['end_date'] +
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
                                                ViewRejectLeaveStaff(
                                                    id: list[index]['id'],
                                                    dateApplied: list[index]
                                                        ['create_at'],
                                                    email: list[index]
                                                        ['employee_email'],
                                                    name: list[index]
                                                        ['employee_name'],
                                                    leave: list[index]
                                                        ['leave_type'],
                                                    desc: list[index]
                                                        ['description'],
                                                    startDate: list[index]
                                                        ['start_date'],
                                                    endDate: list[index]
                                                        ['end_date']),
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
    final response = await http.post(
        "https://attendance.inspirazs.com/php/get_myleave_reject.php",
        body: {'employee_name': widget.user.name});

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
