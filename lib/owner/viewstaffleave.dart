import 'package:flutter/material.dart';
import 'package:leave_management/owner/staffleavedashboard.dart';
import 'package:meet_network_image/meet_network_image.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class ViewStaffLeaveOwner extends StatefulWidget {
  final String id;
  final String dateApplied;
  final String email;
  final String name;
  final String leave;
  final String desc;
  final String startDate;
  final String endDate;
  ViewStaffLeaveOwner(
      {this.id,
      this.dateApplied,
      this.email,
      this.name,
      this.leave,
      this.desc,
      this.startDate,
      this.endDate});

  @override
  _ViewStaffLeaveOwnerState createState() => _ViewStaffLeaveOwnerState();
}

class _ViewStaffLeaveOwnerState extends State<ViewStaffLeaveOwner> {
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
            Divider(
              color: Colors.black,
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
                      child: MeetNetworkImage(
                        imageUrl:
                            "https://attendance.inspirazs.com/leave/${widget.id}.jpg",
                        loadingBuilder: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorBuilder: (context, e) => Center(
                          child: Text('Error appear!'),
                        ),
                      ),
                      height: 80,
                      width: 80,
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return DetailScreen(id: widget.id);
                      }));
                    },
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
                      rejectLeave();
                    },
                    child: new Text("Reject"),
                    color: Colors.red,
                  ),
                  new RaisedButton(
                    padding: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.black),
                    ),
                    onPressed: () {
                      acceptLeave();
                    },
                    child: new Text("Accept"),
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

  void acceptLeave() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Ready to accept?"),
          content: new Text(
              "This leave's application will be held to manager after the confirmation."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                updateAccept();
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

  void updateAccept() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Approving...");
    pr.show();
    await http.post(
        "https://attendance.inspirazs.com/php/owner_leave_accept.php",
        body: {
          'id': widget.id,
          'email': widget.email,
          'start_date': widget.startDate,
          'end_date': widget.endDate
        }).then((res) async {
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        pr.hide();
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => StaffLeaveDashboardOwner()));
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

  void rejectLeave() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Ready to reject?"),
          content: new Text(
              "This leave's application will not allowed employee to take this leave."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                updateReject();
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

  void updateReject() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Rejecting...");
    pr.show();
    await http.post("https://attendance.inspirazs.com/php/leave_reject.php",
        body: {'id': widget.id, 'email': widget.email}).then((res) async {
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        pr.hide();
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => StaffLeaveDashboardOwner()));
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

class DetailScreen extends StatelessWidget {
  final String id;

  DetailScreen({this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: MeetNetworkImage(
              imageUrl: "https://attendance.inspirazs.com/leave/${this.id}.jpg",
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
