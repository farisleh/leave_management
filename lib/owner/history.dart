import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'package:leave_management/user.dart';

class HistoryOwner extends StatefulWidget {
  final User user;

  const HistoryOwner({Key key, this.user}) : super(key: key);
  @override
  _HistoryOwnerState createState() => new _HistoryOwnerState();
}

class _HistoryOwnerState extends State<HistoryOwner> {
  List data = [];
  List searchList = [];
  List searchName = [];
  List searchEmail = [];
  List searchCheckout = [];
  List searchCheckin = [];
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
      for (var i = 0; i < data.length; i++) {
        searchList.add(data[i]['date']);
        searchName.add(data[i]['name']);
        searchEmail.add(data[i]['email']);
        searchCheckin.add(data[i]['time_in']);
        searchCheckout.add(data[i]['time_out']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text('Attendance History'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search_rounded,
              ),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: HistorySearch(
                        list: searchList,
                        name: searchName,
                        email: searchEmail,
                        checkin: searchCheckin,
                        checkout: searchCheckout));
              }),
        ],
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

class HistorySearch extends SearchDelegate<String> {
  List<dynamic> list;
  List<dynamic> name;
  List<dynamic> email;
  List<dynamic> checkin;
  List<dynamic> checkout;

  HistorySearch(
      {String hintText = "(e.g. 2021-02-16)",
      this.list,
      this.name,
      this.email,
      this.checkin,
      this.checkout})
      : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.search,
        );

  showData() async {
    final response = await http.post(
        "https://attendance.inspirazs.com/php/search_attendance.php",
        body: {'search': query});

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return jsonData;
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
            showSuggestions(context);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: showData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                List list = snapshot.data;
                return Card(
                  color: Colors.purple,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                  child: Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          "https://attendance.inspirazs.com/profile/${list[index]['email']}.jpg",
                        ),
                      ),
                      title: Text(list[index]['name']),
                      trailing: Text('Check In: ' +
                          list[index]['time_in'] +
                          '\n' +
                          'Check Out: ' +
                          list[index]['time_out'].toString()),
                    ),
                  ),
                );
              });
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var listData = query.isEmpty
        ? list
        : list.where((element) => element.startsWith(query)).toList();
    return listData.isEmpty
        ? Center(child: Text("No Data Found"))
        : ListView.builder(
            itemCount: listData.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.purple,
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Container(
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        "https://attendance.inspirazs.com/profile/${email[index]}.jpg",
                      ),
                    ),
                    title: Text(listData[index] + "\n" + name[index]),
                    trailing: Text('Check In: ' +
                        checkin[index] +
                        '\n' +
                        'Check Out: ' +
                        checkout[index].toString()),
                  ),
                ),
              );
            });
  }
}
