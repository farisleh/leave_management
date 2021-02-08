import 'package:flutter/material.dart';
import 'package:leave_management/login.dart';
import 'package:leave_management/staff/dashboard.dart';
import 'package:leave_management/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'hod/dashboard.dart';
import 'manager/dashboard.dart';
import 'owner/dashboard.dart';

String _email, _password;
String urlLogin = "https://attendance.inspirazs.com/php/login.php";

void main() => runApp(SplashScreen());

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                scale: 2,
              ),
              SizedBox(
                height: 20,
              ),
              new ProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            //print('Sucess Login');
            loadpref(this.context);
          }
        });
      });
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      width: 200,
      color: Colors.deepPurple,
      child: LinearProgressIndicator(
        value: animation.value,
        backgroundColor: Colors.black,
        valueColor:
            new AlwaysStoppedAnimation<Color>(Color.fromRGBO(255, 0, 0, 1)),
      ),
    ));
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(255, 0, 0, .1),
  100: Color.fromRGBO(255, 0, 0, .2),
  200: Color.fromRGBO(255, 0, 0, .3),
  300: Color.fromRGBO(255, 0, 0, .4),
  400: Color.fromRGBO(255, 0, 0, .5),
  500: Color.fromRGBO(255, 0, 0, .6),
  600: Color.fromRGBO(255, 0, 0, .7),
  700: Color.fromRGBO(255, 0, 0, .8),
  800: Color.fromRGBO(255, 0, 0, .9),
  900: Color.fromRGBO(255, 0, 0, 1),
};

void loadpref(BuildContext ctx) async {
  print('Inside loadpref()');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _email = (prefs.getString('email') ?? '');
  _password = (prefs.getString('password') ?? '');
  print("Splash:Preference");
  print(_email);
  print(_password);
  if (_isEmailValid(_email ?? "no email")) {
    //try to login if got email;
    _onLogin(_email, _password, ctx);
  } else {
    Navigator.push(ctx, MaterialPageRoute(builder: (context) => Login()));
  }
}

bool _isEmailValid(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

void _onLogin(String email, String password, BuildContext ctx) {
  http.post(urlLogin, body: {
    "email": _email,
    "password": _password,
  }).then((res) {
    print(res.statusCode);
    var string = res.body;
    List dres = string.split("~");
    print("SPLASH:loading");
    print(dres);
    if (dres[0] == "success") {
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
            ctx,
            MaterialPageRoute(
                builder: (context) => DashboardOwner(user: user)));
      }
      if (dres[7] == "Manager") {
        Navigator.push(
            ctx,
            MaterialPageRoute(
                builder: (context) => DashboardManager(user: user)));
      }
      if (dres[7] == "Head of Department") {
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => DashboardHod(user: user)));
      }
      if (dres[7] == "Staff" || dres[7] == "Internship") {
        Navigator.push(
            ctx,
            MaterialPageRoute(
                builder: (context) => DashboardStaff(user: user)));
      }
    } else {
      Navigator.push(ctx, MaterialPageRoute(builder: (context) => Login()));
    }
  }).catchError((err) {
    print(err);
  });
}
