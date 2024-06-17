import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:delivery_radharani/APiDirectory/ApiSheet.dart';
import 'package:delivery_radharani/APiDirectory/ResponseClass.dart';
import 'package:delivery_radharani/Objects/Login.dart';
import 'package:delivery_radharani/Utils/Constant.dart';
import 'package:delivery_radharani/Utils/SharedPreference.dart';
import 'package:delivery_radharani/Utils/Strings.dart';
import 'package:delivery_radharani/Utils/ToastUtils.dart';
import 'package:delivery_radharani/Utils/Utils.dart';

import 'ForgetPasswordActivity.dart';
import 'HomeActivity.dart';

class LoginActivity extends StatefulWidget {


  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool showProgressbar = false;


  @override
  void initState() {
    emailController.clear();
    passwordController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Utils.accentColor),
      body: SingleChildScrollView(
        child: Container(
          width: Utils.getWidth(context),
          height: Utils.getHeight(context),
          margin: EdgeInsets.only(left: 40.0, right: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Center(
                child: Utils.textBoldColor(
                    'SIGN IN', 26.0, Color(Utils.primaryColor)),
              ),
              Utils.sizeBoxesHeight(75.0),
              Utils.textFieldBlackWithBackgroundAndPrefixIcon(
                  'Mobile number',
                  emailController,
                  50.0,
                  FontAwesomeIcons.mobile,
                  Color(Utils.primaryColor),
                  24.0,
                  TextInputType.number),
              Utils.sizeBoxesHeight(15.0),
              Utils.textFieldBlackWithBackgroundPrefixIconAndPostfixIcon(
                  'Password',
                  passwordController,
                  50.0,
                  FontAwesomeIcons.key,
                  Color(Utils.primaryColor),
                  24.0,
                  TextInputType.text),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgetPasswordActivity()));
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Utils.textColor(
                          'Forgot password?', 16.0, Color(Utils.primaryColor))),
                ),
              ),
              Utils.sizeBoxesHeight(75.0),
              Container(
                margin: EdgeInsets.only(bottom: 25.0),
                width: Utils.getWidth(context) ,
                child: RaisedButton(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  onPressed: () {
                    if (emailController.text.toString().trim() != '') {
                      if (passwordController.text.toString().trim() != '') {
                        if (emailController.text.toString().length >= 10) {
                          if (passwordController.text.toString().length >= 8) {
                            var jsonPass = {
                              'mobile_number': emailController.text,
                              'password': passwordController.text,
                            };
                            loginDriver(
                                ApiSheet.getUrl + ApiSheet.login, jsonPass);
                          } else {
                            ToastUtils.showCustomToast(
                                context,
                                'Password should be at least 8 character long!',
                                'warning');
                          }
                        } else {
                          ToastUtils.showCustomToast(
                              context, 'Enter valid mobile number!', 'warning');
                        }
                      } else {
                        ToastUtils.showCustomToast(
                            context, 'Enter your password', 'warning');
                      }
                    } else {
                      ToastUtils.showCustomToast(
                          context, 'Enter your mobile number', 'warning');
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: Color(Utils.primaryColor),
                  //loader.gif
                  child: (showProgressbar)
                      ? Utils.imageAssets('mapStyle/loader.gif', 35.0, 35.0)
                      : Utils.textWhite(Strings.sign_in, 18.0),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void loginDriver(String api, Map<String, dynamic> jsonPass) async {
    setState(() {
      showProgressbar = true;
    });
    print(api);
    final response = await ResponseClass.callPostApi(jsonPass, api, context);
    print(response.body);
    setState(() {
      showProgressbar = false;
    });
    Login res = Login.fromJson(json.decode(response.body));
    if (res.currentLoginUser != null) {
      SharedPreference.addStringToSF(SharedPreference.loginData, response.body);

      Constant.token = res.accessToken;

      ToastUtils.showCustomToast(context, res.message, 'success');
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeActivity()));
    } else {
      Utils.errorCode(response.body, context);
    }
  }
}
