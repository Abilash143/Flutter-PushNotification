import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  final _titleController = TextEditingController();
  final _subTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('noti_icon');
    var initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: null);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
  }

  void _scheduleNotification(String title, String subtitle, int randomNumber) {
    Future.delayed(Duration(seconds: 5)).then((result) async {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          //For displaying all notifications which you have sent (below by below),
          //You should specify non repeatable Channel Id for each time you send notification
          'your channel id',
          'your channel name',
          'your channel description',
          importance: Importance.Max,
          priority: Priority.High,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          randomNumber, title, subtitle, platformChannelSpecifics,
          payload: 'item x');
    });
  }

  int _randomNumber() {
  var rng = new Random();
  int ranNum = rng.nextInt(100);
  return ranNum;
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Push Notify', style: GoogleFonts.roboto()),
          backgroundColor: Colors.blue,
        ),
        body: Container(
          color: Colors.blueGrey[50],
          alignment: Alignment.center,
          child: Card(
            margin: EdgeInsets.all(15),
            child: Container(
              height: 300,
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                    style: GoogleFonts.roboto(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Sub Title'),
                    controller: _subTitleController,
                    style: GoogleFonts.roboto(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                      color: Colors.blue,
                      child: Text('Get Notification',
                          style: GoogleFonts.roboto(color: Colors.white)),
                      onPressed: () {
                        if (((_titleController.text) != '') &&
                            ((_subTitleController.text) != '')) {
                          _scheduleNotification(
                              _titleController.text, _subTitleController.text, _randomNumber());
                        } else {
                          _toastInfo('Please Enter all Fields!');
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
