import 'package:flutter/material.dart';
import 'package:leave_management/login.dart';
import 'package:leave_management/owner/settings.dart';
import 'package:leave_management/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileOwner extends StatelessWidget {
  final User user;

  const ProfileOwner({Key key, this.user}) : super(key: key);
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
                    builder: (context) => SettingsPageOwner(user: user),
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
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://attendance.inspirazs.com/profile/${user.email}.jpg",
                          ),
                          radius: 50.0,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          user.name,
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
                                        user.leave + ' days',
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
                                        user.annual,
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
                subtitle: Text(user.ic_card),
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
                subtitle: Text(user.phone),
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
                subtitle: Text(user.email),
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
                subtitle: Text(user.department),
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
                subtitle: Text(user.position),
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
                subtitle: Text(user.address),
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
                subtitle: Text(user.birthday),
                onTap: () => print("ListTile")),
          ],
        ),
      ),
    );
  }
}
