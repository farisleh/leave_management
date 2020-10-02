import 'package:flutter/material.dart';

class Staff extends StatefulWidget {
  @override
  _StaffState createState() => _StaffState();
}

class _StaffState extends State<Staff> {
  @override
  initState() {
    super.initState();
  }

  @override
  // TODO: implement widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Staff Inspirazs'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            title: Text(
              'John Judah',
            ),
            subtitle: Text('2348031980943'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Text('Another data');
            },
          ),
          new Divider(
            height: 1.0,
            indent: 1.0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            title: Text('Bisola Akanbi'),
            subtitle: Text('2348031980943'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Text('Another data');
            },
            onLongPress: () {
              Text('Data');
            },
          ),
          new Divider(
            height: 1.0,
            indent: 1.0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            title: Text('Eghosa Iku'),
            subtitle: Text('2348031980943'),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          new Divider(
            height: 1.0,
            indent: 1.0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            title: Text(
              'Andrew Ndebuisi',
            ),
            subtitle: Text('2348034280943'),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          new Divider(
            height: 1.0,
            indent: 1.0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            title: Text('Arinze Dayo'),
            subtitle: Text('2348031980943'),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          new Divider(
            height: 1.0,
            indent: 1.0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            title: Text('Wakara Zimbu'),
            subtitle: Text('2348031980943'),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          new Divider(
            height: 1.0,
            indent: 1.0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            title: Text('Emaechi Chinedu'),
            subtitle: Text('2348031980943'),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          new Divider(
            height: 1.0,
            indent: 10.0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            title: Text('Osaretin Igbinomwanhia'),
            subtitle: Text('2348031980943'),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          new Divider(
            height: 1.0,
            indent: 10.0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            title: Text('Osagumwenro Nosa'),
            subtitle: Text('2348031980943'),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }
}
