import 'package:flutter/material.dart';
import 'package:meet_network_image/meet_network_image.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:leave_management/hod/staffleavedashboard.dart';

class ViewRejectLeaveHod extends StatefulWidget {
  final String id;
  final String dateApplied;
  final String email;
  final String name;
  final String leave;
  final String desc;
  final String startDate;
  final String endDate;
  ViewRejectLeaveHod(
      {this.id,
      this.dateApplied,
      this.email,
      this.name,
      this.leave,
      this.desc,
      this.startDate,
      this.endDate});

  @override
  _ViewRejectLeaveHodState createState() => _ViewRejectLeaveHodState();
}

class _ViewRejectLeaveHodState extends State<ViewRejectLeaveHod> {
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
            ListTile(
              leading: Text('Status: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              title: Text(
                'Rejected',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
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
