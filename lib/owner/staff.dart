import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leave_management/owner/viewstaffprofile.dart';

class StaffOwner extends StatefulWidget {
  final String email;
  StaffOwner({this.email});

  @override
  _StaffOwnerState createState() => _StaffOwnerState();
}

class _StaffOwnerState extends State<StaffOwner> {
  List data = [];

  @override
  initState() {
    fetchData();
    super.initState();
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
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) => Card(
                color: Colors.amber[300],
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewStaffProfileOwner(
                            name: data[index]['name'],
                            ic: data[index]['ic_card'],
                            phone: data[index]['phone'],
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  data[index]['name'],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.purple),
                                    ),
                                    child: Text(
                                      data[index]['department'],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                                  child: Container(
                                    width: 300,
                                    child: Text(
                                      data[index]['phone'] +
                                          "\n" +
                                          data[index]['email'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 48, 48, 54)),
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
              )),
    );
  }
}
