import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FirePage extends StatefulWidget {
  @override
  _FirePageWidgetState createState() => _FirePageWidgetState();
}

class _FirePageWidgetState extends State<FirePage> {
  Position _userLocation;
  @override
  initState() {
    super.initState();
  }

  int _reportID;
  String _service; //service selected in the drop down
  String _report; //what type of report is selected
  @override
  Widget build(BuildContext context) {
    //These take in our text input to be used
    final myControllerName = TextEditingController();
    final myControllerNumber = TextEditingController();
    final myControllerAdditionalInformation = TextEditingController();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF2d3447),
        appBar: AppBar(
          title: Text('Fire Page'),
          backgroundColor: Color(0xFF2D3439),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
            child: Column(
              children: [
                //TODO Clean up all of the text and add all of the proper report types
                Text(
                  "Please Select What Services are Required as well(Defaults to Just Fire)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
                DropdownButton<String>(
                    //Service drop down
                    hint: Text(
                      'Please Choose One',
                      style: TextStyle(color: Colors.white),
                    ),
                    items: <String>[
                      'None',
                      'Medical',
                      'Police',
                      'Medical and Police'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (String changed) {
                      _service = changed;
                      setState(() {});
                    },
                    value: _service,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white)),
                Text(
                  "Please Select Type of Report",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
                DropdownButton<String>(
                  //report drop down
                  hint: Text(
                    'No report type is selected',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),

                  items: <String>['Fire', 'Gas Leak', 'Figure out more']
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (String changed) {
                    _report = changed;
                    setState(() {});
                  },
                  value: _report,
                ), //DropdownButton
                Text(
                  "Please enter your name otherwise this will be submitted Anonymously",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
                TextFormField(
                  controller: myControllerName,
                  textAlign: TextAlign.center,
                  autocorrect: false,
                  showCursor: true,
                  toolbarOptions: ToolbarOptions(
                    cut: false,
                    copy: false,
                    selectAll: true,
                    paste: false,
                  ),
                  decoration: new InputDecoration.collapsed(
                      hintText: "Please enter your name",
                      hintStyle: TextStyle(
                          fontSize: 15.0, color: Colors.blueGrey[100])),
                  style: TextStyle(color: Colors.white),
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(45),
                    WhitelistingTextInputFormatter(new RegExp(
                        '[A-Za-z\\s]')), //This will allow for letters and periods
                  ],
                ),
                Text(
                  "Please submit your phone number(Not required)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
                TextFormField(
                  controller: myControllerNumber,
                  textAlign: TextAlign.center,
                  autocorrect: false,
                  showCursor: true,
                  keyboardType: TextInputType.number,
                  toolbarOptions: ToolbarOptions(
                    cut: false,
                    copy: false,
                    selectAll: true,
                    paste: false,
                  ),
                  decoration: new InputDecoration.collapsed(
                      hintText: "Please enter phone number",
                      hintStyle: TextStyle(
                          fontSize: 15.0, color: Colors.blueGrey[100])),
                  style: TextStyle(color: Colors.white),
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(14),
                    WhitelistingTextInputFormatter.digitsOnly,
                    //WhitelistingTextInputFormatter(new RegExp('[\\-,1,2,3,4,5,6,7,8,9,0]')) //This will allow for numbers and -
                  ],
                ),
                Text(
                  "Enter any additional information below",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
                TextFormField(
                  controller: myControllerAdditionalInformation,
                  textAlign: TextAlign.center,
                  autocorrect: true,
                  showCursor: true,
                  toolbarOptions: ToolbarOptions(
                    cut: false,
                    copy: false,
                    selectAll: true,
                    paste: false,
                  ),
                  decoration: new InputDecoration.collapsed(
                      hintText: "Enter any other information (256 max)",
                      hintStyle: TextStyle(
                          fontSize: 15.0, color: Colors.blueGrey[100])),
                  style: TextStyle(color: Colors.white),
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(256),
                    WhitelistingTextInputFormatter(new RegExp(
                        '[A-Za-z\\.\\s]')), //This will allow for letters and periods
                  ],
                ),
                Center(
                  child: RaisedButton(
                    padding: new EdgeInsets.all(20.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.white)),
                    child: Text('Submit'),
                    onPressed: () async {
                      _userLocation = await _getLocation();
                      String encodeName;
                      String encodeNumber;
                      String encodedAdditional;
                      String encodedService;
                      String encodedReport;
                      String encodedLocation;
                      String encodedDateTime;
                      DateTime now = DateTime.now();
                      encodedDateTime =
                          DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
                      if (_service != null) {
                        if (_service == 'None') {
                          encodedService = "F";
                        } else if (_service == 'Medical') {
                          encodedService = "FH";
                        } else if (_service == 'Police') {
                          encodedService = "FP";
                        } else if (_service == 'Medical and Police') {
                          encodedService = "FPH";
                        }
                      } else {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              // Retrieve the text the user has entered by using the
                              // TextEditingController.
                              content: Text('Please select a service required'),
                            );
                          },
                        );
                      }
                      if (_report == null) {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              // Retrieve the text the user has entered by using the
                              // TextEditingController.
                              content: Text('Please select a report type'),
                            );
                          },
                        );
                      }
                      if (myControllerName.text.toString() != "" ||
                          myControllerName.text.toString() != "\\+") {
                        encodeName = myControllerName.text;
                      } else {
                        encodeName = 'Annonymous';
                      }
                      if (myControllerNumber.text.toString() != "") {
                        encodeNumber = myControllerNumber.text;
                      } else {
                        encodeNumber = 'N/A';
                      }
                      if (myControllerAdditionalInformation.text.toString() !=
                          "") {
                        encodedAdditional =
                            myControllerAdditionalInformation.text;
                      } else {
                        encodedAdditional = 'N/A';
                      }
                      encodedReport = _report;
                      encodedLocation = _userLocation.toString();
                      var values = {
                        "timestamp": encodedDateTime,
                        "required_responders": encodedService,
                        "status": "New",
                        "urgency": "High",
                        "GPS": encodedLocation,
                        "name": encodeName,
                        "phone": encodeNumber,
                        "photo": null,
                        "message": encodedAdditional,
                        "report_level": "Emergency",
                        "report_type": encodedReport
                      };
                      final jsonData = json.encode(values);
                      _postReport(jsonData).then((reportIDValue) {
                        _reportID = reportIDValue;
                        Navigator.pop(context, _reportID);
                      });
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            // Retrieve the text the user has entered by using the
                            content: Text("Your report was submitted"),
                          );
                        },
                      );
                      // Add Submission results later
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<Position> _getLocation() async {
  var currentLocation;
  try {
    currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  } catch (e) {
    currentLocation = null;
  }
  return currentLocation;
}

class ReportID {
  final int reportID;
  ReportID({this.reportID});
  factory ReportID.fromJson(Map<String, dynamic> json) {
    return ReportID(
      reportID: json['report_id'],
    );
  }
  int get getReportID {
    return reportID;
  }
}

Future<int> _postReport(Object jsonData) async {
  final response = await http.put('http://18.222.188.253:80/add_report',
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
      body: jsonData);
  if (response.statusCode == 200) {
    return ReportID.fromJson(json.decode(response.body)).getReportID;
  } else {
    throw Exception('Report was not submitted');
  }
}
