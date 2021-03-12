import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leave_management/manager/addstaff.dart';
import 'package:leave_management/manager/viewstaffprofile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class StaffManager extends StatefulWidget {
  final String email;
  StaffManager({this.email});

  @override
  _StaffManagerState createState() => _StaffManagerState();
}

class _StaffManagerState extends State<StaffManager> {
  List data = [];
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  initState() {
    fetchData();
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  void fetchData() async {
    final response =
        await http.get("https://attendance.inspirazs.com/php/get_user.php");

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Staff Inspirazs'),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        color: Colors.deepOrange,
        onRefresh: () async {
          await refreshList();
        },
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) => Slidable(
                  actionPane: SlidableBehindActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: Card(
                      color: Colors.amber[300],
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewStaffProfileManager(
                                  name: data[index]['name'],
                                  ic: data[index]['ic_card'],
                                  phone: data[index]['phone'],
                                  cimb: data[index]['cimb'],
                                  email: data[index]['email'],
                                  department: data[index]['department'],
                                  position: data[index]['position'],
                                  address: data[index]['address'],
                                  birthday: data[index]['birthday'],
                                  dateJoin: data[index]['date_join'],
                                  totalLeave: data[index]['total_leave'],
                                  annualLeave: data[index]['annual_leave'],
                                  last: data[index]['last_date']),
                            ),
                          );
                        },
                        child: Container(
                          height: 100.0,
                          child: Row(
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl:
                                    "https://attendance.inspirazs.com/profile/${data[index]['email']}.jpg",
                                height: 100.0,
                                width: 70.0,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              Container(
                                height: 100,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        data[index]['name'],
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 3, 0, 3),
                                        child: Container(
                                          width: 150,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.purple),
                                          ),
                                          child: Text(
                                            data[index]['department'],
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 2),
                                        child: Container(
                                          width: 300,
                                          child: Text(
                                            data[index]['phone'] +
                                                "\n" +
                                                data[index]['email'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 48, 48, 54)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () =>
                            {deleteLeave(email: data[index]['email'])}),
                  ],
                )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStaffManager(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future makeRequest() async {
    final response =
        await http.get("https://attendance.inspirazs.com/php/get_user.php");

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

  void deleteLeave({String email}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Ready to delete?"),
          content: new Text("This staff's account will delete."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                updateDelete(email: email);
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

  void updateDelete({String email}) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Deleting...");
    pr.show();
    print(email);
    await http.post("https://attendance.inspirazs.com/php/delete_staff.php",
        body: {'email': email}).then((res) async {
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        pr.hide();
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => StaffManager()));
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
