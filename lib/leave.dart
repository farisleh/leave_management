import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_range_form_field/date_range_form_field.dart';

class Leave extends StatefulWidget {
  @override
  _LeaveState createState() => new _LeaveState();
}

class _LeaveState extends State<Leave> {
  String radioButtonItem = 'Annual Leave';
  int id = 1;
  DateTime _date = new DateTime.now();
  String _dateText = '';
  Future<Null> _selectMileageDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2020),
        lastDate: DateTime(2080));

    if (picked != null) {
      setState(() {
        _date = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Leave Form'),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  onTap: () => _selectMileageDate(context),
                  decoration: new InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: 'Date: ' + _dateText,
                      labelStyle: TextStyle(color: Colors.black)),
                  style: new TextStyle(fontSize: 17.0, color: Colors.black54),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.people), labelText: 'Employee Name:'),
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    icon: Icon(Icons.business),
                    labelText: 'Department:',
                  ),
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Reason For Requested Leave:',
                      style: TextStyle(fontSize: 17))),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        radioButtonItem = 'Annual Leave';
                        id = 1;
                      });
                    },
                  ),
                  Text(
                    'Annual Leave',
                    style: new TextStyle(fontSize: 15.0),
                  ),
                  Radio(
                    value: 2,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        radioButtonItem = 'Emergency Leave';
                        id = 2;
                      });
                    },
                  ),
                  Text(
                    'Emergency Leave',
                    style: new TextStyle(fontSize: 15.0),
                  ),
                  Radio(
                    value: 3,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        radioButtonItem = 'Sick Leave';
                        id = 3;
                      });
                    },
                  ),
                  Text(
                    'Sick Leave',
                    style: new TextStyle(fontSize: 15.0),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: 4,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        radioButtonItem = 'Maternity Leave';
                        id = 4;
                      });
                    },
                  ),
                  Text(
                    'Maternity Leave',
                    style: new TextStyle(fontSize: 15.0),
                  ),
                  Radio(
                    value: 5,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        radioButtonItem = 'Death Leave';
                        id = 5;
                      });
                    },
                  ),
                  Text(
                    'Death Leave',
                    style: new TextStyle(fontSize: 15.0),
                  ),
                  Radio(
                    value: 6,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        radioButtonItem = 'Unpaid Leave';
                        id = 6;
                      });
                    },
                  ),
                  Text(
                    'Unpaid Leave',
                    style: new TextStyle(fontSize: 15.0),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: 7,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        radioButtonItem = 'Others';
                        id = 7;
                      });
                    },
                  ),
                  Text(
                    'Others',
                    style: new TextStyle(fontSize: 15.0),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      Text('Date Requested:', style: TextStyle(fontSize: 17))),
              Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onTap: () => _selectMileageDate(context),
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                          icon: Icon(Icons.date_range),
                          labelText: 'from ' + _dateText,
                          labelStyle: TextStyle(color: Colors.black)),
                      style: new TextStyle(fontSize: 15.0, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onTap: () => _selectMileageDate(context),
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                          icon: Icon(Icons.date_range),
                          labelText: 'to ' + _dateText,
                          labelStyle: TextStyle(color: Colors.black)),
                      style: new TextStyle(fontSize: 15.0, color: Colors.black),
                    ),
                  ),
                ),
              ]),
              new ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: () {},
                    child: new Text("Cancel"),
                    color: Colors.red,
                  ),
                  new RaisedButton(
                    onPressed: () {},
                    child: new Text("Submit"),
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
