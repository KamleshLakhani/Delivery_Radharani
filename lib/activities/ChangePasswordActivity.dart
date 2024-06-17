import 'dart:convert';

import 'package:delivery_radharani/APiDirectory/ApiSheet.dart';
import 'package:delivery_radharani/APiDirectory/ResponseClass.dart';
import 'package:delivery_radharani/Objects/ForgetPassword.dart';
import 'package:delivery_radharani/Objects/Login.dart';
import 'package:delivery_radharani/Objects/ResponseData.dart';
import 'package:delivery_radharani/Utils/ToastUtils.dart';
import 'package:delivery_radharani/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChangePasswordActivity extends StatefulWidget {
  @override
  _ChangePasswordActivityState createState() => _ChangePasswordActivityState();
}

class _ChangePasswordActivityState extends State<ChangePasswordActivity> {
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newConfirmPasswordController =
      new TextEditingController();
  Login user = new Login();

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Utils.accentColor),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: Utils.getWidth(context),
              height: Utils.getHeight(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Utils.sizeBoxesHeight(25.0),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Utils.header('Change Password', context),
                  ),
                  Spacer(),
                  Utils.imageAssets('mapStyle/logo.png', 175.0, 175.0),
                  Utils.sizeBoxesHeight(50.0),
                  Container(
                    margin: EdgeInsets.only(left: 40.0, right: 40.0),
                    child: Utils
                        .textFieldBlackWithBackgroundPrefixIconAndPostfixIcon(
                            'Old password',
                            oldPasswordController,
                            50.0,
                            FontAwesomeIcons.key,
                            Color(Utils.primaryColor),
                            20.0,
                            TextInputType.text),
                  ),
                  Utils.sizeBoxesHeight(25.0),
                  Container(
                    margin: EdgeInsets.only(left: 40.0, right: 40.0),
                    child: Utils
                        .textFieldBlackWithBackgroundPrefixIconAndPostfixIcon(
                            'New password',
                            newPasswordController,
                            50.0,
                            FontAwesomeIcons.key,
                            Color(Utils.primaryColor),
                            20.0,
                            TextInputType.text),
                  ),
                  Utils.sizeBoxesHeight(25.0),
                  Container(
                    margin: EdgeInsets.only(left: 40.0, right: 40.0),
                    child: Utils
                        .textFieldBlackWithBackgroundPrefixIconAndPostfixIcon(
                            'Confirm password',
                            newConfirmPasswordController,
                            50.0,
                            FontAwesomeIcons.key,
                            Color(Utils.primaryColor),
                            20.0,
                            TextInputType.text),
                  ),
                  Spacer(),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 75.0),
                      width: Utils.getWidth(context) - 100,
                      child: RaisedButton(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        onPressed: () {
                          if (validation()) {
                            var jsonPass = {
                              'old_password': oldPasswordController.text,
                              'password': newPasswordController.text,
                              'confirm_password': newConfirmPasswordController.text,
                            };
                            submitNewPassword(
                                ApiSheet.getUrl +
                                    ApiSheet.setNewPassword +
                                    '/${user.currentLoginUser.id}',
                                jsonPass);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        color: Color(Utils.primaryColor),
                        child: Utils.textWhite('Change Password', 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  validation() {
    if (newPasswordController.text == '') {
      ToastUtils.showCustomToast(context, "Enter new password", 'warning');
      return false;
    }

    if (oldPasswordController.text == '') {
      ToastUtils.showCustomToast(context, "Enter old password", 'warning');
      return false;
    }

    if (newConfirmPasswordController.text == '') {
      ToastUtils.showCustomToast(context, "Enter confirm password", 'warning');
      return false;
    }

    if (newPasswordController.text.toString().trim() !=
        newConfirmPasswordController.text.toString().trim()) {
      ToastUtils.showCustomToast(context, "Password are not same", 'warning');
      return false;
    }

    if (newPasswordController.text.toString().trim().length < 8 ||
        newConfirmPasswordController.text.toString().trim().length < 8) {
      ToastUtils.showCustomToast(context,
          "Password\'s character should be 8 character long.", 'warning');
      return false;
    }

    return true;
  }

  void getUserData() async {
    user = await Utils.getUserData();
  }
}
