import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leave_management/staff/myleavedashboard.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class ViewPendingLeaveStaff extends StatefulWidget {
  final String id;
  final String dateApplied;
  final String email;
  final String name;
  final String leave;
  final String desc;
  final String startDate;
  final String endDate;
  ViewPendingLeaveStaff(
      {this.id,
      this.dateApplied,
      this.email,
      this.name,
      this.leave,
      this.desc,
      this.startDate,
      this.endDate});

  @override
  _ViewPendingLeaveStaffState createState() => _ViewPendingLeaveStaffState();
}

class _ViewPendingLeaveStaffState extends State<ViewPendingLeaveStaff> {
  File _image;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Leave Details'),
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
                  height: 160.0,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://attendance.inspirazs.com/profile/${widget.email}.jpg",
                          ),
                          radius: 50.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                )),
            ListTile(
              leading: Text('Leave Type: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              title: Text(widget.leave,
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: Text('Description: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              title: Text(
                widget.desc,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            ListTile(
              leading: Text('Leave Image: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              title: Stack(
                children: <Widget>[
                  GestureDetector(
                    child: SizedBox(
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Container(
                            width: 180,
                            height: 200,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: _image == null
                                      ? NetworkImage(
                                          "https://attendance.inspirazs.com/leave/${widget.id}.jpg")
                                      : FileImage(_image),
                                  fit: BoxFit.fill,
                                )),
                          )),
                      height: 80,
                      width: 80,
                    ),
                  ),
                  Positioned(
                      left: 45,
                      bottom: 45,
                      child: Container(
                        height: 50,
                        width: 50,
                        child: IconButton(
                          color: Colors.red,
                          onPressed: _clearimage,
                          icon: Icon(Icons.cancel),
                        ),
                      )),
                ],
              ),
            ),
            ListTile(
              leading: Text('               ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              title: ButtonBar(
                alignment: MainAxisAlignment.start,
                children: <Widget>[
                  new RaisedButton.icon(
                    onPressed: _choose,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.grey)),
                    icon: IconTheme(
                        data: new IconThemeData(color: Colors.white),
                        child: Icon(Icons.add_photo_alternate)),
                    label: Text(
                      "Select Image",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.lightBlue,
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: Text('Date Applied: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              title: Text(
                widget.dateApplied,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: Text('Start Date: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              title: Text(
                widget.startDate,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: Text('End Date: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              title: Text(
                widget.endDate,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: Text('Status: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              title: Text(
                'Pending',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: new ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    padding: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.black),
                    ),
                    onPressed: () {
                      deleteLeave();
                    },
                    child: new Text("Delete"),
                    color: Colors.red,
                  ),
                  new RaisedButton(
                    padding: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.black),
                    ),
                    onPressed: () {
                      _save();
                    },
                    child: new Text("Save"),
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _choose() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      Navigator.of(context);
    });
  }

  void _clearimage() {
    setState(() {
      _image = null;
    });
  }

  void deleteLeave() {
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
                updateDelete();
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

  void updateDelete() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Deleting...");
    pr.show();
    await http.post("https://attendance.inspirazs.com/php/delete_myleave.php",
        body: {'id': widget.id}).then((res) async {
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        pr.hide();
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyLeaveDashboardStaff()));
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

  void _save() async {
    if (_image == null) {
      Toast.show("Please upload an image", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Saving image...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    await http.post(
        "https://attendance.inspirazs.com/php/upload_imageleave.php",
        body: {
          'id': widget.id,
          "encoded_string": base64Image
        }).then((res) async {
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        pr.hide();
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
