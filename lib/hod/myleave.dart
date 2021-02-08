import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leave_management/hod/myleavedashboard.dart';
import 'package:leave_management/user.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MyLeaveHod extends StatefulWidget {
  final User user;
  const MyLeaveHod({Key key, this.user}) : super(key: key);
  @override
  _MyLeaveHodState createState() => new _MyLeaveHodState();
}

class _MyLeaveHodState extends State<MyLeaveHod> {
  var myFormat = DateFormat('yyyy-MM-dd');
  DateTime _startdate = new DateTime.now();
  String _startdateText = '';
  DateTime _enddate = new DateTime.now();
  String _enddateText = '';
  bool visible = false;
  final TextEditingController _descriptioncontroller = TextEditingController();

  Future<Null> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _startdate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2080));

    if (picked != null) {
      setState(() {
        _startdate = picked;
        _startdateText = "${myFormat.format(_startdate)}";
      });
    }
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _enddate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2080));

    if (picked != null) {
      setState(() {
        _enddate = picked;
        _enddateText = "${myFormat.format(_enddate)}";
      });
    }
  }

  final leaveList = [
    "Annual Leave",
    "Medical Leave",
    "Unpaid Leave",
    "Maternity Leave",
    "Others"
  ];
  String dropdownValue = 'Annual Leave';

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Apply Leave'),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Reason For Requested Leave:',
                    style: TextStyle(fontSize: 17))),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                decoration: InputDecoration(
                  labelText: "Select Leave Type",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                items: leaveList.map((String value) {
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
                    return 'Please Select Leave Type';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _descriptioncontroller,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Description(Optional)'),
                maxLines: 4,
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Date Requested:', style: TextStyle(fontSize: 17))),
            Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onTap: () => _selectStartDate(context),
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'From: ' + _startdateText,
                        labelStyle: TextStyle(color: Colors.black)),
                    style: new TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                child: Icon(Icons.date_range),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onTap: () => _selectEndDate(context),
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'To: ' + _enddateText,
                        labelStyle: TextStyle(color: Colors.black)),
                    style: new TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                  height: 50,
                  width: 200, // specific value
                  child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        _sendData();
                      },
                      color: Colors.purple,
                      textColor: Colors.white,
                      icon: Icon(Icons.send_sharp),
                      label: Text("Submit Request"))),
            ),
          ]),
        ));
  }

  void _sendData() async {
    var annual = widget.user.annual;
    var annualint = int.parse(annual);
    var startDate = DateTime.parse(_startdateText);
    var endDate = DateTime.parse(_enddateText);
    var diff = endDate.difference(startDate).inDays + 1;

    if ((diff > annualint) && (dropdownValue == "Annual Leave")) {
      Toast.show(
          "Your annual leave cannot be more than $annualint days", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if ((annualint == 0) && (dropdownValue == "Annual Leave")) {
      Toast.show("Your annual leave have reached the limits", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (_startdateText.isEmpty) {
      Toast.show("Please enter starting date for leave", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (_enddateText.isEmpty) {
      Toast.show("Please enter ending date for leave", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    ByteData bytes = await rootBundle.load('assets/images/no-image.png');
    var buffer = bytes.buffer;
    var m = base64.encode(Uint8List.view(buffer));

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Applying...");
    pr.show();
    await http.post("https://attendance.inspirazs.com/php/upload_hodleave.php",
        body: {
          "employee_email": widget.user.email,
          "employee_name": widget.user.name,
          "leave_type": dropdownValue,
          "description": _descriptioncontroller.text,
          "start_date": _startdateText,
          "end_date": _enddateText,
          "encoded_string": m
        }).then((res) async {
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        pr.hide();
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyLeaveDashboardHod()));
      } else {
        pr.hide();
        Toast.show(res.body + ". Please reload", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
  }
}
