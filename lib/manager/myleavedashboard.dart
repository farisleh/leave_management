import 'package:flutter/material.dart';
import 'package:leave_management/manager/myleave.dart';
import 'package:leave_management/manager/myviewacceptleave.dart';
import 'package:leave_management/manager/myviewpendingleave.dart';
import 'package:leave_management/manager/myviewrejectleave.dart';
import 'package:leave_management/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class MyLeaveDashboardManager extends StatefulWidget {
  final User user;

  const MyLeaveDashboardManager({Key key, this.user}) : super(key: key);
  @override
  _MyLeaveDashboardManager createState() => new _MyLeaveDashboardManager();
}

class _MyLeaveDashboardManager extends State<MyLeaveDashboardManager> {
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
                          builder: (context) =>
                              MyLeaveManager(user: widget.user),
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
              MyPendingScreenManager(user: widget.user),
              MyAcceptScreenManager(user: widget.user),
              MyRejectScreenManager(user: widget.user),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPendingScreenManager extends StatefulWidget {
  final User user;
  const MyPendingScreenManager({Key key, this.user}) : super(key: key);

  @override
  _MyPendingScreenManagerState createState() => _MyPendingScreenManagerState();
}

class _MyPendingScreenManagerState extends State<MyPendingScreenManager> {
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
                                            builder:
                                                (context) =>
                                                    MyViewPendingLeaveManager(
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

class MyAcceptScreenManager extends StatefulWidget {
  final User user;
  const MyAcceptScreenManager({Key key, this.user}) : super(key: key);

  @override
  _MyAcceptScreenManagerState createState() => _MyAcceptScreenManagerState();
}

class _MyAcceptScreenManagerState extends State<MyAcceptScreenManager> {
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
                                                MyViewAcceptLeaveManager(
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

class MyRejectScreenManager extends StatefulWidget {
  final User user;
  const MyRejectScreenManager({Key key, this.user}) : super(key: key);

  @override
  _MyRejectScreenManagerState createState() => _MyRejectScreenManagerState();
}

class _MyRejectScreenManagerState extends State<MyRejectScreenManager> {
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
                                                MyViewRejectLeaveManager(
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
