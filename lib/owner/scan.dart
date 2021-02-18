import 'package:flutter/material.dart';
import 'package:leave_management/owner/generate.dart';
import 'package:leave_management/user.dart';

class ScanOwner extends StatefulWidget {
  final User user;

  const ScanOwner({Key key, this.user}) : super(key: key);
  @override
  _ScanOwnerState createState() => new _ScanOwnerState();
}

class _ScanOwnerState extends State<ScanOwner> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('QR Code Generator'),
        ),
        body: SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AspectRatio(
                  aspectRatio: 15.0 / 11.0,
                  child: Image.asset('assets/images/qr-code.png'),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                child: FlatButton(
                  padding: EdgeInsets.all(15.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GeneratePageOwner(),
                      ),
                    );
                  },
                  child: Text(
                    'GENERATE QR CODE',
                    style: TextStyle(
                        color: Colors.purple, fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.purple, width: 3.0),
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
            ],
          ),
        ));
  }
}
