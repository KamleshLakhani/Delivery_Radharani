import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:delivery_radharani/APiDirectory/ApiSheet.dart';
import 'package:delivery_radharani/APiDirectory/ResponseClass.dart';
import 'package:delivery_radharani/Objects/OrderDetail.dart';
import 'package:delivery_radharani/Objects/ResponseData.dart';
import 'package:delivery_radharani/Objects/SignatureUpload.dart';
import 'package:delivery_radharani/Utils/ToastUtils.dart';
import 'package:delivery_radharani/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:delivery_radharani/main.dart';
import 'package:signature/signature.dart';

import 'OrderDetailsActivity.dart';

class GetSignatureActivity extends StatefulWidget {
  final OrderDetailData orderDetail;
  final int orderId;

  GetSignatureActivity(
      {Key key, @required this.orderDetail, @required this.orderId})
      : super(key: key);

  @override
  _GetSignatureActivityState createState() => _GetSignatureActivityState();
}

class _GetSignatureActivityState extends State<GetSignatureActivity> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Color(Utils.primaryColor),
    exportBackgroundColor: Colors.transparent,
  );
  File _image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Utils.white),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Utils.header('Confirm Order', context),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Utils.border(Color(Utils.primaryColor), 2.0),
                ),
                child: Signature(
                  height: Utils.getHeight(context) - 225.0,
                  width: Utils.getWidth(context) - 24.0,
                  controller: _controller,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            Utils.sizeBoxesHeight(20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() => _controller.clear());
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                    decoration: Utils.whiteBoxDecorationNoShadow(
                        24.0, Color(Utils.lightGreen)),
                    child: Utils.textBlack('Clear Signature', 14.0),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var data = await _controller.toPngBytes();
                    if (data != null) {
                      startImageUpload(context, data);
                    } else {
                      ToastUtils.showCustomToast(context,
                          'Please take the signature of customer', 'warning');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                    decoration: Utils.whiteBoxDecorationNoShadow(
                        24.0, Color(Utils.primaryColor)),
                    child: Utils.textWhite('Confirm Delivery', 14.0),
                  ),
                ),
              ],
            ),
            Utils.sizeBoxesHeight(25.0),
          ],
        ),
      ),
    );
  }

  startImageUpload(BuildContext context, Uint8List data) async {
    print(ApiSheet.getUrl +
        ApiSheet.saveImagePayment +
        '${widget.orderDetail.id}');
    print('${Base64Encoder().convert(data).toString()}...');
    var jsonPass = {
      'signature': Base64Encoder().convert(data),
    };
    final response = await ResponseClass.callPostApi(
        jsonPass,
        ApiSheet.getUrl +
            ApiSheet.saveImagePayment +
            '${widget.orderDetail.id}',
        context);
    print(response.body);
    if (response.statusCode == 200) {
      SignatureUpload res =
          SignatureUpload.fromJson(json.decode(response.body));
      if (res.fileName != 'null') {
        // ToastUtils.showCustomToast(context, res.message, 'success');
        var jsonData = {'': ''};
        deliverOrder(jsonData);
      }
    } else {
      Utils.errorCode(response.body, context);
    }
  }

  void deliverOrder(Map<String, dynamic> jsonData) async {
    print(ApiSheet.getUrl +
        ApiSheet.updateOrderDetails +
        widget.orderId.toString());
    final response = await ResponseClass.callPostApi(
        jsonData,
        ApiSheet.getUrl +
            ApiSheet.updateOrderDetails +
            widget.orderId.toString(),
        context);
    print(response.body);

    ResponseData res = ResponseData.fromJson(json.decode(response.body));
    if (res.data.message.toLowerCase().contains('successfully')) {
      print('DSA ${res}');
      print('datasd ${res.data.message}');
      ToastUtils.showCustomToast(context, res.data.message, 'success');
      widget.orderDetail.orderStatus = '5';
      Navigator.pop(context, 'true');
      Navigator.pop(context, 'true');


    } else {
      Utils.errorCode(response.body, context);
    }
  }
}
