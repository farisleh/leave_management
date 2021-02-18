import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:leave_management/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

class ScanHod extends StatefulWidget {
  final User user;

  const ScanHod({Key key, this.user}) : super(key: key);
  @override
  _ScanHodState createState() => new _ScanHodState();
}

class _ScanHodState extends State<ScanHod> {
  String barcode = "Please scan the attendance";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('QR Code Scanner'),
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
                  onPressed: scanQR,
                  child: Text(
                    'START SCAN',
                    style: TextStyle(
                        color: Colors.purple, fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.purple, width: 3.0),
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  barcode,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ));
  }

  Future scanQR() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.barcode = barcode;
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Scanning...");
        pr.show();
        http.post("https://attendance.inspirazs.com/php/upload_scan.php",
            body: {
              "email": widget.user.email,
              "name": widget.user.name,
              "date": barcode
            }).then((res) async {
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          if (res.body.contains("Your has scan successfully submit")) {
            pr.hide();
            Navigator.pop(context);
          } else {
            pr.hide();
            Toast.show(res.body + ". Please scan the attendance", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }).catchError((err) {
          print(err);
          pr.hide();
        });
      });
    } on PlatformException {
      barcode = 'Failed to get platform version.';
    }
  }
}
