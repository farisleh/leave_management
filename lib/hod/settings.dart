import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leave_management/login.dart';
import 'package:leave_management/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class SettingsPageHod extends StatefulWidget {
  final User user;

  SettingsPageHod({this.user});
  @override
  _SettingsPageHodState createState() => _SettingsPageHodState();
}

class _SettingsPageHodState extends State<SettingsPageHod> {
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Settings'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.deepPurple,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
                title: const Text(
                  "Change Password",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => _password()),
            ListTile(
                title: const Text(
                  "Change Phone Number",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => _phone()),
            ListTile(
                title: const Text(
                  "Change Address",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => _address()),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.volume_up_outlined,
                  color: Colors.deepPurple,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            SwitchListTile(
              title: const Text(
                "On Notification",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
              activeColor: Colors.green,
              onChanged: (bool value) {},
              value: true,
            ),
            SizedBox(
              height: 50,
            ),
            Center(
                child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: () {
                _logout(context);
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Text("SIGN OUT",
                  style: TextStyle(
                      fontSize: 16, letterSpacing: 2.2, color: Colors.white)),
            ))
          ],
        ),
      ),
    );
  }

  void _logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', '');
    await prefs.setString('pass', '');
    print("LOGOUT");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  void _password() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.45,
            child: ListView(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: passwordcontroller,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Password',
                        border: InputBorder.none),
                    style: new TextStyle(fontSize: 17.0, color: Colors.black54),
                  ),
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
                          Navigator.pop(context);
                        },
                        child: new Text("Close"),
                        color: Colors.red,
                      ),
                      new RaisedButton(
                        padding: EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0),
                          side: BorderSide(color: Colors.black),
                        ),
                        onPressed: () {
                          updatePassword();
                        },
                        child: new Text("Update"),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void updatePassword() async {
    if (passwordcontroller.text.length < 6) {
      Toast.show("Password must at least 6 character!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Updating...");
    pr.show();
    await http.post("https://attendance.inspirazs.com/php/update_profile.php",
        body: {
          'email': widget.user.email,
          "password": passwordcontroller.text
        }).then((res) {
      var string = res.body;
      List dres = string.split("~");
      if (dres[0] == "success") {
        setState(() {
          widget.user.name = dres[1];
          Toast.show("Success ", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
          return;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _phone() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.45,
            child: ListView(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: phonecontroller,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        icon: Icon(Icons.phone),
                        labelText: 'Phone',
                        hintText: widget.user.phone,
                        border: InputBorder.none),
                    style: new TextStyle(fontSize: 17.0, color: Colors.black54),
                  ),
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
                          Navigator.pop(context);
                        },
                        child: new Text("Close"),
                        color: Colors.red,
                      ),
                      new RaisedButton(
                        padding: EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0),
                          side: BorderSide(color: Colors.black),
                        ),
                        onPressed: () {
                          updatePhone();
                        },
                        child: new Text("Update"),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void updatePhone() async {
    if (phonecontroller.text.isEmpty) {
      Toast.show("Phone Number must be at least 10 number!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Updating...");
    pr.show();
    await http.post("https://attendance.inspirazs.com/php/update_profile.php",
        body: {
          'email': widget.user.email,
          "phone": phonecontroller.text
        }).then((res) {
      var string = res.body;
      List dres = string.split("~");
      if (dres[0] == "success") {
        setState(() {
          widget.user.phone = dres[4];
          Toast.show("Success ", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
          return;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _address() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.50,
            child: ListView(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: addresscontroller,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    decoration: new InputDecoration(
                        icon: Icon(Icons.home),
                        labelText: 'Address',
                        hintText: widget.user.address,
                        border: InputBorder.none),
                    style: new TextStyle(fontSize: 17.0, color: Colors.black54),
                  ),
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
                          Navigator.pop(context);
                        },
                        child: new Text("Close"),
                        color: Colors.red,
                      ),
                      new RaisedButton(
                        padding: EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0),
                          side: BorderSide(color: Colors.black),
                        ),
                        onPressed: () {
                          updateAddress();
                        },
                        child: new Text("Update"),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void updateAddress() async {
    if (addresscontroller.text.isEmpty) {
      Toast.show("The field cannot be empty!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Updating...");
    pr.show();
    await http.post("https://attendance.inspirazs.com/php/update_profile.php",
        body: {
          'email': widget.user.email,
          "address": addresscontroller.text
        }).then((res) {
      var string = res.body;
      List dres = string.split("~");
      if (dres[0] == "success") {
        setState(() {
          widget.user.address = dres[5];
          Toast.show("Success ", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
          return;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
