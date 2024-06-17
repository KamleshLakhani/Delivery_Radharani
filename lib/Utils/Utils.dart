import 'dart:convert';
import 'dart:io';

import 'package:delivery_radharani/APiDirectory/ApiSheet.dart';
import 'package:delivery_radharani/Objects/ErrorCode.dart';
import 'package:delivery_radharani/Objects/Login.dart';
import 'package:delivery_radharani/Objects/ResponseData.dart';
import 'package:delivery_radharani/Utils/ToastUtils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'Constant.dart';
import 'SharedPreference.dart';

class Utils {
  static var primaryColor = 0xff4C311E;
  static var lightPrimaryColor = 0xff51AD56;
  static var accentColor = 0xffEECD98;
  static var blackAccent = 0xff2e3033;
  static var white = 0xffffffff;
  static var white_opacity = 0x80ffffff;
  static var whiteAccent = 0xfff1f4f8;
  static var black = 0xff000000;
  static var black_opacity = 0x26d3d3d3;
  static var gray = 0xffA18C74;
  static var lightGreen = 0xffF6E6CB;
  static var warning = 0xffE43E3E;
  static var background = 0xfff5f5f5;

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static boxShadow() {
    return BoxShadow(
      color: Colors.black.withOpacity(0.16),
      spreadRadius: 0,
      blurRadius: 6,
      offset: Offset(0, 3), // changes position of shadow
    );
  }

  static Widget getImageNetwork(
      double width, double height, String image, double corner) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(corner),
      child: Image.network(
        image,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return imageAssets('mapStyle/logo.png', width, height);
        },
      ),
    );
  }

  static textAlignment(
      String text, TextAlign align, double textSize, Color textColor) {
    return Text(text,
        textAlign: align,
        style: new TextStyle(fontSize: textSize, color: textColor));
  }

  static poundSignWithPrice(String price, Color color) {
    return Row(
      children: [
        fontAwesomeIcon(FontAwesomeIcons.poundSign, 13.0, color),
        sizeBoxesWidth(3.0),
        textColor(price, 14.0, color),
        sizeBoxesWidth(5.0),
      ],
    );
  }

  static Text textBoldMultiLineClip(
      String title, double size, Color color, int lines) {
    return Text(title,
        maxLines: lines,
        overflow: TextOverflow.clip,
        style: new TextStyle(
            fontWeight: FontWeight.bold, fontSize: size, color: color));
  }

  static poundSignWithPriceBold(String price, Color color) {
    return Row(
      children: [
        fontAwesomeIcon(FontAwesomeIcons.poundSign, 16.0, color),
        sizeBoxesWidth(3.0),
        textBoldColor(price, 14.0, color),
        sizeBoxesWidth(5.0),
      ],
    );
  }

  static Widget getProfilePic(
      double width, double height, String image, double corner) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(corner),
      child: Image.network(
        image,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
              child: fontAwesomeIconBlack(
                  FontAwesomeIcons.solidUserCircle, height - 13));
        },
      ),
    );
  }

  static Widget getImageFile(
      double width, double height, File image, double corner) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(corner),
      child: Image.file(
        image,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return getImageNetwork(width, height,
              ApiSheet.preBaseUrl + 'public_html/images/no-image.png', corner);
        },
      ),
    );
  }

  static Future<Login> getUserData() async {
    var getData =
        await SharedPreference.getStringValuesSF(SharedPreference.loginData);
    Login user = Login.fromJson(json.decode(getData));
    return user;
  }

  static border(Color color, double width) {
    return Border.all(color: color, width: width);
  }

  static borderRadius(double corner) {
    return BorderRadius.all(
      Radius.circular(corner),
    );
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }

  static void removeData() async {
    Constant.token = '';
    if (await SharedPreference.containsKey(SharedPreference.token)) {
      SharedPreference.removeValues(SharedPreference.token);
    }
    if (await SharedPreference.containsKey(SharedPreference.loginData)) {
      SharedPreference.removeValues(SharedPreference.loginData);
    }

    await SharedPreference.prefs.clear();
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static changeDateFormat(String toPattern, DateTime date) {
    final DateFormat formatter = DateFormat(toPattern);
    final String formatted = formatter.format(date);
    return formatted;
  }

  static changeDateFormatString(
      String fromPattern, String toPattern, String date) {
    DateFormat outputFormat = DateFormat(fromPattern);
    DateTime date2 = outputFormat.parse(date);
    final DateFormat formatter1 = DateFormat(toPattern);
    final String formatted1 = formatter1.format(date2);

    return formatted1;
  }

  static Widget textFieldBlack(
      String hintText, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextField(
        autofocus: false,
        cursorColor: Color(black),
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black54),
            hintText: hintText),
      ),
    );
  }

  static Widget textFieldBlackWithBackgroundAndPrefixIcon(
      String hintText,
      TextEditingController controller,
      double corner,
      IconData icon,
      Color iconColor,
      double size,
      TextInputType type) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffF6E6CB),
          borderRadius: BorderRadius.all(Radius.circular(corner))),
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
      child: TextField(
        autofocus: false,
        obscureText: false,
        maxLines: 1,
        maxLength: null,
        keyboardType: type,
        cursorColor: Color(primaryColor),
        controller: controller,
        style: TextStyle(color: Color(primaryColor), fontSize: 16.0),
        decoration: InputDecoration(
            icon: FaIcon(
              icon,
              color: iconColor,
              size: size,
            ),
            border: InputBorder.none,
            counterText: '',
            hintStyle: TextStyle(color: Color(gray)),
            hintText: hintText),
      ),
    );
  }

  static Widget textFieldBlackWithBackgroundPrefixIconAndPostfixIcon(
      String hintText,
      TextEditingController controller,
      double corner,
      IconData icon,
      Color iconColor,
      double size,
      TextInputType type) {
    bool secureText = true;
    return StatefulBuilder(
      builder: (context, setState) => Container(
        decoration: BoxDecoration(
            color: Color(0xffF6E6CB),
            borderRadius: BorderRadius.all(Radius.circular(corner))),
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: TextField(
          autofocus: false,
          obscureText: secureText,
          maxLines: 1,
          keyboardType: type,
          cursorColor: Color(primaryColor),
          controller: controller,
          style: TextStyle(
            color: Color(primaryColor),
          ),
          decoration: InputDecoration(
              icon: fontAwesomeIconBlack(icon, size),
              border: InputBorder.none,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    secureText = !secureText;
                  });
                },
                icon: (secureText)
                    ? Icon(
                        Icons.visibility,
                        size: 24.0,
                      )
                    : Icon(
                        Icons.visibility_off,
                        size: 24.0,
                      ),
              ),
              hintStyle: TextStyle(color: Color(gray)),
              hintText: hintText),
        ),
      ),
    );
  }

  static Widget textFieldBlackWithBackgroundAndPrefixIconNonEditable(
      String hintText,
      TextEditingController controller,
      double corner,
      IconData icon,
      Color iconColor,
      double size) {
    return Container(
      decoration: BoxDecoration(
          color: Color(lightGreen),
          borderRadius: BorderRadius.all(Radius.circular(corner))),
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
      child: TextField(
        maxLines: null,
        enabled: false,
        autofocus: false,
        cursorColor: Color(black),
        controller: controller,
        style: TextStyle(color: Color(primaryColor).withOpacity(0.5)),
        decoration: InputDecoration(
            icon: FaIcon(
              icon,
              size: size,
              color: iconColor,
            ),
            border: InputBorder.none,
            hintStyle: TextStyle(color: Color(gray)),
            hintText: hintText),
      ),
    );
  }

  static Widget fontAwesomeIcon(IconData icon, var size, Color color) {
    return FaIcon(
      icon,
      size: size,
      color: color,
    );
  }

  static Widget fontAwesomeIconGreen(IconData icon, var size) {
    return FaIcon(
      icon,
      size: size,
      color: Color(primaryColor),
    );
  }

  static Widget fontAwesomeIconWhite(IconData icon, var size) {
    return FaIcon(
      icon,
      size: size,
      color: Color(accentColor),
    );
  }

  static Widget fontAwesomeIconBlack(IconData icon, var size) {
    return FaIcon(
      icon,
      size: size,
      color: Color(primaryColor),
    );
  }

  static Widget textBoldColor(String title, double textSize, Color color) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: textSize, color: color),
    );
  }

  static Widget textBoldBlack(String title, double textSize) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: textSize,
          color: Color(primaryColor)),
    );
  }

  static Widget textBoldWhite(String title, double textSize) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: textSize,
          color: Color(accentColor)),
    );
  }

  static Text textBoldMultiLine(
      String title, double size, Color color, int lines) {
    return Text(title,
        maxLines: lines,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(
            fontWeight: FontWeight.bold, fontSize: size, color: color));
  }

  static SizedBox sizeBoxesHeight(double size) {
    return SizedBox(
      height: size,
    );
  }

  static SizedBox sizeBoxesWidth(double size) {
    return SizedBox(
      width: size,
    );
  }

  static Text textBlack(String title, double size) {
    return Text(title,
        style: new TextStyle(fontSize: size, color: Color(primaryColor)));
  }

  static Text textWhite(String title, double size) {
    return Text(title,
        style: new TextStyle(fontSize: size, color: Color(accentColor)));
  }

  static Text textColor(String title, double size, Color color) {
    return Text(title, style: new TextStyle(fontSize: size, color: color));
  }

  static Text textMultiLine(String title, double size, Color color, int lines) {
    return (lines == 1)
        ? Text(title,
            overflow: TextOverflow.ellipsis,
            maxLines: lines,
            style: new TextStyle(fontSize: size, color: color))
        : Text(title,
            maxLines: lines,
            style: new TextStyle(fontSize: size, color: color));
  }

  static whiteBoxDecoration(double corner) {
    return BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(corner),
        ),
        color: Color(lightGreen));
  }

  static whiteBoxDecorationNoShadow(double corner, Color color) {
    return BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(corner),
        ),
        color: color);
  }

  static header(String header, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              customBorder: new CircleBorder(),
              splashColor: Color(Utils.gray),
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Utils.fontAwesomeIcon(
                    FontAwesomeIcons.arrowLeft, 24.0, Color(primaryColor)),
              )),
          Utils.sizeBoxesWidth(5.0),
          Utils.textColor(header, 20.0, Color(primaryColor)),
        ],
      ),
    );
  }

  static void errorCode(String body, BuildContext context) {
    try {
      ErrorCode res = ErrorCode.fromJson(json.decode(body));
      ToastUtils.showCustomToast(context, res.error.message, 'warning');
      print(res.error.message);
    } catch (e) {
      ResponseData res = ResponseData.fromJson(json.decode(body));
      ToastUtils.showCustomToast(context, res.data.message, 'warning');
      print(res.data.message);
    }
  }

  static imageAssets(String image, double width, double height) {
    return Image.asset(
      image,
      width: width,
      height: height,
    );
  }
}
