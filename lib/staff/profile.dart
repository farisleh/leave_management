import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leave_management/staff/settings.dart';
import 'package:leave_management/user.dart';
import 'package:http/http.dart' as http;

String urluploadImage =
    "https://attendance.inspirazs.com/php/update_imageprofile.php";
File _image;
int number = 0;

class ProfileStaff extends StatefulWidget {
  final User user;
  const ProfileStaff({Key key, this.user}) : super(key: key);

  @override
  _ProfileStaffState createState() => _ProfileStaffState();
}

class _ProfileStaffState extends State<ProfileStaff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Profile'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPageStaff(user: widget.user),
                  ),
                );
              }),
        ],
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
                        new Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                _takePicture();
                              },
                              child: Stack(
                                children: <Widget>[
                                  CircleAvatar(
                                      radius: 55.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: _image == null
                                                  ? NetworkImage(
                                                      "https://attendance.inspirazs.com/profile/${widget.user.email}.jpg")
                                                  : FileImage(_image),
                                              fit: BoxFit.fill,
                                            )),
                                      )),
                                  Positioned(
                                      right: 3,
                                      bottom: 3,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.deepOrange,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          widget.user.name,
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
                              horizontal: 20.0, vertical: 5.0),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 20.0),
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
                                        widget.user.leave + ' days',
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
                                        widget.user.annual + ' days left',
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
                subtitle: Text(widget.user.ic_card),
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
                subtitle: Text(widget.user.phone),
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
                subtitle: Text(widget.user.email),
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
                subtitle: Text(widget.user.cimb),
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
                subtitle: Text(widget.user.department),
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
                subtitle: Text(widget.user.position),
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
                subtitle: Text(widget.user.address),
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
                subtitle: Text(widget.user.birthday),
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
                subtitle: Text(widget.user.join),
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
                subtitle:
                    Text(widget.user.last == "" ? 'N/A' : widget.user.last),
                onTap: () => print("ListTile")),
          ],
        ),
      ),
    );
  }

  void _takePicture() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Take new profile picture?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                final picker = ImagePicker();

                final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);

                setState(() {
                  if (pickedFile != null) {
                    _image = File(pickedFile.path);
                  } else {
                    print('No image selected.');
                  }
                });
                String base64Image = base64Encode(_image.readAsBytesSync());
                http.post(urluploadImage, body: {
                  "encoded_string": base64Image,
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
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
}
