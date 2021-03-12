import 'package:flutter/material.dart';
import 'package:meet_network_image/meet_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class ViewStaffProfileManager extends StatefulWidget {
  final String name;
  final String ic;
  final String phone;
  final String cimb;
  final String email;
  final String department;
  final String position;
  final String address;
  final String birthday;
  final String totalLeave;
  String annualLeave;
  final String dateJoin;

  final String last;

  ViewStaffProfileManager(
      {this.name,
      this.ic,
      this.phone,
      this.cimb,
      this.email,
      this.department,
      this.position,
      this.address,
      this.birthday,
      this.totalLeave,
      this.annualLeave,
      this.dateJoin,
      this.last});
  @override
  _ViewStaffProfileManagerState createState() =>
      _ViewStaffProfileManagerState();
}

class _ViewStaffProfileManagerState extends State<ViewStaffProfileManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.purple, Colors.purpleAccent])),
                child: Container(
                  width: double.infinity,
                  height: 300.0,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              "https://attendance.inspirazs.com/profile/${widget.email}.jpg",
                            ),
                            radius: 50.0,
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return DetailScreen(email: widget.email);
                            }));
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 1.0),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 7.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Total Leaves",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        widget.totalLeave + ' days',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.pinkAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Annual Leave",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        widget.annualLeave + ' days left',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.pinkAccent,
                                        ),
                                      ),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text('     Add',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              )),
                                          IconButton(
                                              icon:
                                                  Icon(Icons.edit, size: 20.0),
                                              color: Colors.green,
                                              iconSize: 20,
                                              onPressed: () {
                                                _changeLeave();
                                              }),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Attendance",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "-",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.pinkAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.credit_card_outlined,
                    size: 40.0,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {},
                ),
                title: const Text("I/C Number"),
                subtitle: Text(widget.ic),
                onTap: () => print("ListTile")),
            ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.phone,
                    size: 40.0,
                    color: Colors.green,
                  ),
                  onPressed: () {},
                ),
                title: const Text("Phone Number"),
                subtitle: Text(widget.phone),
                onTap: () => print("ListTile")),
            ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.email_outlined,
                    size: 40.0,
                    color: Colors.red,
                  ),
                  onPressed: () {},
                ),
                title: const Text("Email"),
                subtitle: Text(widget.email),
                onTap: () => print("ListTile")),
            ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.account_balance,
                    size: 40.0,
                    color: Colors.red[900],
                  ),
                  onPressed: () {},
                ),
                title: const Text("CIMB Account Number"),
                subtitle: Text(widget.cimb),
                onTap: () => print("ListTile")),
            ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.business,
                    size: 40.0,
                    color: Colors.orange,
                  ),
                  onPressed: () {},
                ),
                title: const Text("Department"),
                subtitle: Text(widget.department),
                onTap: () => print("ListTile")),
            ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.hail,
                    size: 40.0,
                    color: Colors.yellow,
                  ),
                  onPressed: () {},
                ),
                title: const Text("Position"),
                subtitle: Text(widget.position),
                onTap: () => print("ListTile")),
            ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.home,
                    size: 40.0,
                    color: Colors.brown,
                  ),
                  onPressed: () {},
                ),
                title: const Text("Address"),
                subtitle: Text(widget.address),
                onTap: () => print("ListTile")),
            ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.date_range,
                    size: 40.0,
                    color: Colors.cyan,
                  ),
                  onPressed: () {},
                ),
                title: const Text("Birthday"),
                subtitle: Text(widget.birthday),
                onTap: () => print("ListTile")),
            ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.perm_contact_calendar_sharp,
                    size: 40.0,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () {},
                ),
                title: const Text("Date Joined"),
                subtitle: Text(widget.dateJoin),
                onTap: () => print("ListTile")),
            ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.perm_contact_calendar_outlined,
                    size: 40.0,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () {},
                ),
                title: const Text("Last Date"),
                subtitle: Text(widget.last == "" ? 'N/A' : widget.last),
                onTap: () => print("ListTile")),
          ],
        ),
      ),
    );
  }

  void _changeLeave() {
    TextEditingController leavecontroller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Add annual leave for " + widget.name),
          content: new TextField(
              keyboardType: TextInputType.phone,
              controller: leavecontroller,
              decoration: InputDecoration(
                labelText: 'Annual Leave',
                icon: Icon(Icons.shopping_bag),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text("Yes"),
                onPressed: () async {
                  if (leavecontroller.text.isEmpty) {
                    Toast.show("The field cannot be empty!", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    return;
                  }
                  ProgressDialog pr = new ProgressDialog(context,
                      type: ProgressDialogType.Normal, isDismissible: true);
                  pr.style(message: "Updating...");
                  pr.show();
                  await http.post(
                      "https://attendance.inspirazs.com/php/update_annualleave.php",
                      body: {
                        'email': widget.email,
                        "leave": leavecontroller.text
                      }).then((res) {
                    var string = res.body;
                    List dres = string.split("~");
                    if (dres[0] == "success") {
                      setState(() {
                        widget.annualLeave = dres[10];
                        Toast.show("Success ", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        Navigator.of(context).pop();
                      });
                    }
                  }).catchError((err) {
                    print(err);
                  });
                }),
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
}

class DetailScreen extends StatelessWidget {
  final String email;

  DetailScreen({this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: MeetNetworkImage(
              imageUrl:
                  "https://attendance.inspirazs.com/profile/${this.email}.jpg",
              loadingBuilder: (context) => Center(
                child: CircularProgressIndicator(),
              ),
              errorBuilder: (context, e) => Center(
                child: Text('Error appear!'),
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
