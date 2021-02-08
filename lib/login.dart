import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leave_management/hod/dashboard.dart';
import 'package:leave_management/forgot.dart';
import 'package:leave_management/manager/dashboard.dart';
import 'package:leave_management/owner/dashboard.dart';
import 'package:leave_management/staff/dashboard.dart';
import 'package:leave_management/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String urlLogin = "https://attendance.inspirazs.com/php/login.php";
  final TextEditingController emcontroller = TextEditingController();
  final TextEditingController passcontroller = TextEditingController();
  String email = '';
  String password = "";
  bool _isChecked = false;
  String msg = '';

  @override
  void initState() {
    print('Init: $email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.purple));
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                scale: 2.5,
              ),
              TextField(
                  controller: emcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email', icon: Icon(Icons.email))),
              TextField(
                controller: passcontroller,
                decoration: InputDecoration(
                    labelText: 'Password', icon: Icon(Icons.lock)),
                obscureText: true,
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minWidth: 300,
                height: 50,
                child: Text('Login'),
                color: Colors.purple,
                textColor: Colors.white,
                elevation: 15,
                onPressed: () {
                  _login();
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool value) {
                      _onChange(value);
                    },
                  ),
                  Text('Remember Me', style: TextStyle(fontSize: 16))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: _onForgot,
                  child: Text('Forgot Password ?',
                      style: TextStyle(fontSize: 16))),
            ],
          ),
        ),
      ),
    );
  }

  void _login() {
    email = emcontroller.text;
    password = passcontroller.text;
    if (_isEmailValid(email) && (password.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login in");
      pr.show();
      http.post(urlLogin, body: {
        "email": email,
        "password": password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split("~");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.hide();
          print(dres);
          User user = new User(
              name: dres[1],
              ic_card: dres[2],
              email: dres[3],
              phone: dres[4],
              address: dres[5],
              department: dres[6],
              position: dres[7],
              birthday: dres[8],
              leave: dres[9],
              annual: dres[10],
              join: dres[11],
              last: dres[12]);

          if (dres[7] == "Business Owner") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardOwner(user: user)));
          }
          if (dres[7] == "Manager") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardManager(user: user)));
          }
          if (dres[7] == "Head of Department") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardHod(user: user)));
          }
          if (dres[7] == "Staff" || dres[7] == "Internship") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardStaff(user: user)));
          }
        } else {
          pr.hide();
        }
      }).catchError((err) {
        pr.hide();
        print(err);
      });
    } else {}
  }

  void _onForgot() {
    print('Forgot');
    Navigator.push(context, MaterialPageRoute(builder: (context) => Forgot()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      savepref(value);
    });
  }

  void savepref(bool value) async {
    print('Inside savepref');
    email = emcontroller.text;
    password = passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //true save pref
      if (_isEmailValid(email) && (password.length > 5)) {
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        print('Save pref $email');
        print('Save pref $password');
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No email');
        setState(() {
          _isChecked = false;
        });
        Toast.show("Check your credentials", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      setState(() {
        emcontroller.text = '';
        passcontroller.text = '';
        _isChecked = false;
      });
      print('Remove pref');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}
