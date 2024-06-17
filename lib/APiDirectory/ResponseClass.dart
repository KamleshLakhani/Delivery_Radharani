import 'package:delivery_radharani/Utils/Constant.dart';
import 'package:delivery_radharani/Utils/Utils.dart';
import 'package:delivery_radharani/activities/LoginActivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResponseClass {
  static Future<http.Response> callPostApi(
      Map<String, dynamic> jsonData, String api, BuildContext context) async {
    final http.Response response = await http.post(
      Uri.parse(api),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + Constant.token,
      },
      body: jsonData,
    );

    print('$api ## ${response.body}');
    if (response.statusCode == 401) {
      print('ERROR CODE 401 ##');
      Utils.removeData();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginActivity(),
          ));
      return null;
    }

    return response;
  }

  static Future<http.Response> callGetApi(
      String api, BuildContext context) async {
    final http.Response response = await http.get(
      Uri.parse(api),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + Constant.token,
      },
    );

    if (response.statusCode == 401) {
      print('ERROR CODE 401 ##');
      Utils.removeData();
      Navigator.popUntil(context, (route) => route.isFirst);

      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginActivity(),
          ));
      return null;
    }

    return response;
  }

  /*
  void createAlbum(String api, Map<String, dynamic> jsonPass) async {
    final response = await ResponseClass.callPostApi(jsonPass, api);
    Login res = Login.fromJson(json.decode(response.body));

    print(response.body);
    if (res.code.toString() == '1') {
      SharedPreference.addStringToSF(SharedPreference.loginData, response.body);
      SharedPreference.addStringToSF(SharedPreference.userId, res.admin_user_id);
      Constant.userId = res.admin_user_id;
      ToastUtils.showCustomToast(context, res.message, 'success');
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeActivity(la:widget.la,lo:widget.lo)));
    } else {
      ToastUtils.showCustomToast(context, res.message, 'warning');
      print(res.dev_message);
    }
  }


  void getSalesInvoiceData(String api) async {
    final response = await ResponseClass.callGetApi(api);
    Bills res = Bills.fromJson(json.decode(response.body));
    print(response.body);

    if (res.code.toString() == '1') {
      status = res.code.toString();
      setState(() {
        if (page != -1) {
          if (page == 1) {
            listOfData.clear();
          }
          listOfData.addAll(res.results);

          if (res.totalRecord <= listOfData.length) {
            page = -1;
          }
        }
      });
    } else {
      setState(() {
        status = '0';
        ToastUtils.showCustomToast(context, res.message, 'warning');
        print(res.devMessage);
      });
    }
  }*/
}
