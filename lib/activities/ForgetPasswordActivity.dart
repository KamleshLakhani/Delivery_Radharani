import 'dart:convert';

import 'package:delivery_radharani/APiDirectory/ApiSheet.dart';
import 'package:delivery_radharani/APiDirectory/ResponseClass.dart';
import 'package:delivery_radharani/Objects/ForgetPassword.dart';
import 'package:delivery_radharani/Objects/ResponseData.dart';
import 'package:delivery_radharani/Utils/ToastUtils.dart';
import 'package:delivery_radharani/Utils/Utils.dart';
import 'package:delivery_radharani/activities/HomeActivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ForgetPasswordActivity extends StatefulWidget {
  @override
  _ForgetPasswordActivityState createState() => _ForgetPasswordActivityState();
}

class _ForgetPasswordActivityState extends State<ForgetPasswordActivity> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();

  var OTP = false;
  var OTPSuccess = false;
  var id = 0;

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Center(
                child: Utils.textBoldColor(
                    'FORGET PASSWORD', 26.0, Color(Utils.primaryColor)),
              ),
              Utils.sizeBoxesHeight(75.0),
              Utils.textFieldBlackWithBackgroundAndPrefixIcon(
                  'Mobile number',
                  emailController,
                  50.0,
                  FontAwesomeIcons.mobile,
                  Color(Utils.primaryColor),
                  20.0,
                  TextInputType.number),
              Visibility(
                visible: OTP,
                  child: Utils.sizeBoxesHeight(20.0)),
              Visibility(
                visible: OTP,
                child: Utils.textFieldBlackWithBackgroundAndPrefixIcon(
                    'OTP',
                    passwordController,
                    50.0,
                    FontAwesomeIcons.key,
                    Color(Utils.primaryColor),
                    20.0,
                    TextInputType.number),
              ),
              PinFieldAutoFill(
                codeLength: 4,
                decoration: UnderlineDecoration(
                  textStyle: TextStyle(fontSize: 0, color: Colors.black),
                  colorBuilder: FixedColorBuilder(Colors.transparent),
                ),
                currentCode: '',
                onCodeSubmitted: (code) {},
                onCodeChanged: (code) {
                  if (code.length == 4) {
                    setState(() {
                      passwordController.text = code;
                    });
                  }
                },
              ),
              Visibility(
                visible: OTPSuccess,
                child: Utils.textFieldBlackWithBackgroundPrefixIconAndPostfixIcon(
                    'New password',
                    newPasswordController,
                    50.0,
                    FontAwesomeIcons.key,
                    Color(Utils.primaryColor),
                    20.0,
                    TextInputType.text),
              ),
              GestureDetector(
                onTap: () async {
                  if (validation()) {
                    var signature = await SmsAutoFill().getAppSignature;
                    var jsonPass = {
                      'mobile_number': emailController.text,
                      'signCode': signature.toString(),
                    };
                    sendOTP(
                        ApiSheet.getUrl+ApiSheet.sendOtpForForget,
                        jsonPass);
                  }
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Utils.textColor(
                          'Resend OTP', 16.0, Color(Utils.primaryColor))),
                ),
              ),
              Utils.sizeBoxesHeight(50.0),
              Container(
                margin: EdgeInsets.only(bottom: 25.0),
                width: Utils.getWidth(context) - 100,
                child: RaisedButton(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  onPressed: () async {
                    if (validation()) {
                      if (!OTP) {
                        var signature = await SmsAutoFill().getAppSignature;
                        var jsonPass = {
                          'mobile_number': emailController.text,
                          'signCode': signature.toString(),
                        };
                        sendOTP(ApiSheet.getUrl + ApiSheet.sendOtpForForget,
                            jsonPass);
                      } else {
                        if (!OTPSuccess) {
                          var jsonPass = {
                            'mobile_number': emailController.text,
                            'code': passwordController.text,
                          };
                          submitForgetOtp(
                              ApiSheet.getUrl + ApiSheet.submitForgetOtp,
                              jsonPass);
                        } else {
                          var jsonPass = {
                            'password': newPasswordController.text,
                          };
                          submitNewPassword(
                              ApiSheet.getUrl +
                                  ApiSheet.setNewPassword +
                                  '/$id',
                              jsonPass);
                        }
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: Color(Utils.primaryColor),
                  child: Utils.textWhite(
                      (!OTP)
                          ? 'Send OTP'
                          : (!OTPSuccess) ? 'Submit' : 'Sign In',
                      18.0),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void submitNewPassword(String api, Map<String, dynamic> jsonPass) async {
    print(api);
    final response = await ResponseClass.callPostApi(jsonPass, api, context);
    print(response.body);
    if (response.statusCode == 200) {
      ResponseData res = ResponseData.fromJson(json.decode(response.body));
      if (res.data.message.contains('Success')) {
        ToastUtils.showCustomToast(context, res.data.message, 'success');
        Navigator.pop(context);
      }
    } else {
      Utils.errorCode(response.body, context);
    }
  }

  void submitForgetOtp(String api, Map<String, dynamic> jsonPass) async {
    final response = await ResponseClass.callPostApi(jsonPass, api, context);
    print(response.body);
    if (response.statusCode == 200) {
      ResponseData res = ResponseData.fromJson(json.decode(response.body));
      if (res.data.message.contains('Success')) {
        ToastUtils.showCustomToast(context, res.data.message, 'success');
        setState(() {
          OTPSuccess = true;
        });
      }
    } else {
      Utils.errorCode(response.body, context);
    }
  }

  void sendOTP(String api, Map<String, dynamic> jsonPass) async {
    print(api);
    final response = await ResponseClass.callPostApi(jsonPass, api, context);
    print(response.body);
    if (response.statusCode == 200) {
      ForgetPassword res = ForgetPassword.fromJson(json.decode(response.body));
      if (res.data.message.contains('successfully')) {
        await SmsAutoFill().listenForCode;

        ToastUtils.showCustomToast(context, res.data.message, 'success');
        setState(() {
          OTP = true;
          id = res.data.id;
        });
      }
    } else {
      Utils.errorCode(response.body, context);
    }
  }

  validation() {
    if (emailController.text == '') {
      ToastUtils.showCustomToast(context, "Enter mobile number", 'warning');
      return false;
    }

    if (OTP) {
      if (passwordController.text == '') {
        ToastUtils.showCustomToast(context, "Enter OTP", 'warning');
        return false;
      }
    }

    if (OTPSuccess) {
      if (newPasswordController.text == '') {
        ToastUtils.showCustomToast(context, "Enter new password", 'warning');
        return false;
      }
    }

    return true;
  }
}
