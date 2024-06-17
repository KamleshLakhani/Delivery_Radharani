import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

import 'APiDirectory/ApiSheet.dart';
import 'APiDirectory/ResponseClass.dart';
import 'Activities/HomeActivity.dart';
import 'Objects/Login.dart';
import 'Utils/Constant.dart';
import 'Utils/SharedPreference.dart';
import 'Utils/Utils.dart';
import 'activities/LoginActivity.dart';
import 'activities/OrderDetailsActivity.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, //top bar color
    statusBarIconBrightness: Brightness.dark, //top bar icons/bottom bar color
  ));


}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(Utils.primaryColor),
        accentColor: Color(Utils.accentColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashActivity(),
    );
  }
}

class SplashActivity extends StatefulWidget {
  @override
  _SplashActivityState createState() => _SplashActivityState();
}

class _SplashActivityState extends State<SplashActivity> {


  void getLocation() async {
    var data =
    await SharedPreference.getStringValuesSF(SharedPreference.loginData);

    if (data != '') {
      Login res = Login.fromJson(json.decode(data));
      Constant.token = res.accessToken;

      print('token ## ${Constant.token}');
    } else {
      Constant.token = '';
    }


    new Future.delayed(const Duration(seconds: 1), () async {
      print(Constant.token);
      Navigator.pop(context);
      if (Constant.token != '') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeActivity()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginActivity()));
      }
    });


  }



  showDialogToRequestLocation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What do you want to remember?'),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    getLocation();

    return Scaffold(
      backgroundColor: Color(Utils.accentColor),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'mapStyle/logo.png',
              width: 250,
              height: 350,
            ),
          ],
        ),
      ),
    );
  }

  void getUrl(String api) async {
    // print(api);
    // final response = await ResponseClass.callGetApi(api, context);
    // ConfigData res = ConfigData.fromJson(json.decode(response.body));

    // print(response.body);

    // if (res.result != '') {
    new Future.delayed(const Duration(seconds: 1), () async {
      print(Constant.token);
      Navigator.pop(context);
      if (Constant.token != '') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeActivity()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginActivity()));
      }
    });
    // } else {
    //   print('Config error');
    // }
  }
}
