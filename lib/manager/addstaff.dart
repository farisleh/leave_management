import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leave_management/manager/staff.dart';
import 'package:leave_management/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AddStaffManager extends StatefulWidget {
  final User user;

  const AddStaffManager({Key key, this.user}) : super(key: key);
  @override
  _AddStaffManagerState createState() => new _AddStaffManagerState();
}

class _AddStaffManagerState extends State<AddStaffManager> {
  var myFormat = DateFormat('d MMMM yyyy');
  DateTime _dateBirthday = new DateTime.now();
  String _dateTextBirthday = '';
  DateTime _dateJoin = new DateTime.now();
  String _dateTextJoin = '';
  DateTime _dateLast = new DateTime.now();
  String _dateTextLast = '';
  String pathAsset = 'assets/images/profile.png';
  File _image;
  String urlUpload = "https://attendance.inspirazs.com/php/register_user.php";
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _iccontroller = TextEditingController();
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  final TextEditingController _leavecontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _cimbcontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _qualificationcontroller =
      TextEditingController();
  String _name,
      _ic,
      _email,
      _password,
      _phone,
      _cimb,
      _address,
      _qualification,
      _leave;

  Future<Null> _selectBirthdayDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dateBirthday,
        firstDate: DateTime(1900),
        lastDate: DateTime(2080));

    if (picked != null) {
      setState(() {
        _dateBirthday = picked;
        _dateTextBirthday = "${myFormat.format(_dateBirthday)}";
      });
    }
  }

  Future<Null> _selectJoinDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dateJoin,
        firstDate: DateTime(2010),
        lastDate: DateTime(2080));

    if (picked != null) {
      setState(() {
        _dateJoin = picked;
        _dateTextJoin = "${myFormat.format(_dateJoin)}";
      });
    }
  }

  Future<Null> _selectLastDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dateLast,
        firstDate: DateTime(2010),
        lastDate: DateTime(2080));

    if (picked != null) {
      setState(() {
        _dateLast = picked;
        _dateTextLast = "${myFormat.format(_dateLast)}";
      });
    }
  }

  final departmentList = [
    "Graphic Designer",
    "Information System",
    "Social Media",
    "Internship"
  ];

  String dropdownValueDepartment = 'Graphic Designer';

  final positionList = [
    "Staff",
    "Head of Department",
    "Manager",
    "Business Owner"
  ];

  String dropdownValuePosition = 'Staff';

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Add Staff'),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 25,
                    ),
                    Text(
                      'Profile Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(height: 24, width: 24)
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: GestureDetector(
                    onTap: _choose,
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 70,
                          child: ClipOval(
                              child: Container(
                            width: 180,
                            height: 200,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: _image == null
                                      ? AssetImage(pathAsset)
                                      : FileImage(_image),
                                  fit: BoxFit.fill,
                                )),
                          )),
                        ),
                        Positioned(
                            right: 1,
                            bottom: 1,
                            child: Container(
                              height: 40,
                              width: 40,
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _namecontroller,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.people),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Employee Name:'),
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _iccontroller,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.credit_card_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'I/C Number:'),
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _emcontroller,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.email),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Email Address:'),
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _passcontroller,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.lock),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Password:'),
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _phonecontroller,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.phone),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Phone Number:'),
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _cimbcontroller,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.account_balance),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'CIMB Account Number:'),
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _addresscontroller,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.home),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Address:'),
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField(
                  value: dropdownValueDepartment,
                  icon: Icon(Icons.arrow_downward),
                  decoration: InputDecoration(
                    labelText: "Select Department Type",
                    icon: Icon(Icons.business),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: departmentList.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValueDepartment = newValue;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Select Department Type';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField(
                  value: dropdownValuePosition,
                  icon: Icon(Icons.arrow_downward),
                  decoration: InputDecoration(
                    labelText: "Select Position Type",
                    icon: Icon(Icons.hail),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: positionList.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValuePosition = newValue;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Select Position Type';
                    }
                    return null;
                  },
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _qualificationcontroller,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.school),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Qualification:'),
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _leavecontroller,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.shopping_bag),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Annual Leave:'),
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onTap: () => _selectBirthdayDate(context),
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.date_range),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Birthday: ' + _dateTextBirthday,
                      labelStyle: TextStyle(color: Colors.black)),
                  style: new TextStyle(fontSize: 15.0, color: Colors.black),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onTap: () => _selectJoinDate(context),
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.perm_contact_calendar_sharp),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Date Joined: ' + _dateTextJoin,
                      labelStyle: TextStyle(color: Colors.black)),
                  style: new TextStyle(fontSize: 15.0, color: Colors.black),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onTap: () => _selectLastDate(context),
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.perm_contact_calendar_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Last Date: ' + _dateTextLast,
                      labelStyle: TextStyle(color: Colors.black)),
                  style: new TextStyle(fontSize: 15.0, color: Colors.black),
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
                      onPressed: () {},
                      child: new Text("Cancel"),
                      color: Colors.red,
                    ),
                    new RaisedButton(
                      padding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.black),
                      ),
                      onPressed: _onRegister,
                      child: new Text("Submit"),
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _choose() async {
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    uploadData();
  }

  void uploadData() async {
    _name = _namecontroller.text;
    _ic = _iccontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phonecontroller.text;
    _cimb = _cimbcontroller.text;
    _address = _addresscontroller.text;
    _qualification = _qualificationcontroller.text;
    _leave = _leavecontroller.text;
    _dateTextBirthday = _dateTextBirthday;
    _dateTextJoin = _dateTextJoin;
    _dateTextLast = _dateTextLast;

    if (_image == null) {
      Toast.show("Please take picture or gallery", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (_name.isEmpty) {
      Toast.show("Please put an employee name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (_ic.isEmpty) {
      Toast.show("Please put I/C number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (_phone.length <= 10) {
      Toast.show("Phone number should be more than 9 number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (_address.isEmpty) {
      Toast.show("You must fill in address!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (_password.length < 5) {
      Toast.show("Please put more than 5 character", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (_qualification.isEmpty) {
      Toast.show("You must fill in qualification!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (_leave.isEmpty) {
      Toast.show("Give some number for annual leave", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if ((_isEmailValid(_email))) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();
      String base64Image = base64Encode(_image.readAsBytesSync());
      await http.post(urlUpload, body: {
        "name": _name,
        "ic_card": _ic,
        "email": _email,
        "password": _password,
        "phone": _phone,
        "cimb": _cimb,
        "address": _address,
        "department": dropdownValueDepartment,
        "position": dropdownValuePosition,
        "qualification": _qualification,
        "annual_leave": _leave,
        "birthday": _dateTextBirthday,
        "date_join": _dateTextJoin,
        "last_date": _dateTextLast,
        "encoded_string": base64Image
      }).then((res) {
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (res.body.contains(
            "A information successfuly add staff has been sent to user email account")) {
          pr.hide();
          Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => StaffManager()));
          Navigator.pop(context);
        } else {
          pr.hide();
          Toast.show(res.body + "!! Please reload", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show("Check your email format", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}
