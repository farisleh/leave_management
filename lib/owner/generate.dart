import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class GeneratePageOwner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GeneratePageOwnerState();
}

class GeneratePageOwnerState extends State<GeneratePageOwner> {
  String qrData = "QR Code Not Generate Yet!";

  final chooseList = [
    "Check In",
    "Check Out",
  ];
  String dropdownValue = "Check In";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: QrImage(
                data: qrData,
                version: QrVersions.auto,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "    QR CODE DETAILS",
              style: TextStyle(fontSize: 20.0),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                decoration: InputDecoration(
                  labelText: "Choose Time Status",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                items: chooseList.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Select Time Status';
                  }
                  return null;
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  dropdownValue + ' at ' + qrData,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: FlatButton(
                padding: EdgeInsets.all(15.0),
                onPressed: () async {
                  var myFormat = DateFormat('yyyy-MM-dd');
                  var date = new DateTime.now().toString();
                  var dateParse = DateTime.parse(date);
                  var formattedDate = "${myFormat.format(dateParse)}";
                  if (dropdownValue.isEmpty) {
                    setState(() {
                      qrData = "";
                    });
                  } else {
                    setState(() {
                      qrData = formattedDate;
                    });
                  }
                },
                child: Text(
                  "GENERATE QR CODE",
                  style: TextStyle(
                      color: Colors.purple, fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.purple, width: 3.0),
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
