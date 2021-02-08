import 'package:flutter/material.dart';
import 'package:meet_network_image/meet_network_image.dart';

class ViewStaffProfileHod extends StatelessWidget {
  final String name;
  final String ic;
  final String phone;
  final String email;
  final String department;
  final String position;
  final String address;
  final String birthday;
  final String dateJoin;
  final String totalLeave;
  final String annualLeave;
  final String last;
  ViewStaffProfileHod(
      {this.name,
      this.ic,
      this.phone,
      this.email,
      this.department,
      this.position,
      this.address,
      this.birthday,
      this.dateJoin,
      this.totalLeave,
      this.annualLeave,
      this.last});

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
                              "https://attendance.inspirazs.com/profile/${this.email}.jpg",
                            ),
                            radius: 50.0,
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return DetailScreen(email: this.email);
                            }));
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          this.name,
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
                                        this.totalLeave + ' days',
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
                                        this.annualLeave + ' days left',
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
                subtitle: Text(this.ic),
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
                subtitle: Text(this.phone),
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
                subtitle: Text(this.email),
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
                subtitle: Text(this.department),
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
                subtitle: Text(this.position),
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
                subtitle: Text(this.address),
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
                subtitle: Text(this.birthday),
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
                subtitle: Text(this.dateJoin),
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
                subtitle: Text(this.last == "" ? 'N/A' : this.last),
                onTap: () => print("ListTile")),
          ],
        ),
      ),
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
