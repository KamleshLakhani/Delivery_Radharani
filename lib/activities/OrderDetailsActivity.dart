import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:delivery_radharani/APiDirectory/ApiSheet.dart';
import 'package:delivery_radharani/APiDirectory/ResponseClass.dart';
import 'package:delivery_radharani/Objects/OrderDetail.dart';
import 'package:delivery_radharani/Utils/Constant.dart';
import 'package:delivery_radharani/Utils/Utils.dart';
import 'package:delivery_radharani/activities/TrackActivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';

import 'GetSignatureActivity.dart';

class OrderDetailsActivity extends StatefulWidget {
  final int orderId;

  // OrderDetailsActivity({Key key, @required this.orderId}) : super(key: key);
  OrderDetailsActivity({Key key,  this.orderId}) : super(key: key);


  @override
  _OrderDetailsActivityState createState() => _OrderDetailsActivityState();
}

class _OrderDetailsActivityState extends State<OrderDetailsActivity>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  OrderDetailData orderDetail;
  double minDistance = 0.0;
  String address;
  TextEditingController otpController = new TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    fetchData();

    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();
    super.initState();
  }

  Future<OrderDetailData> fetchData() async {
    print(ApiSheet.getUrl + ApiSheet.orderDetails + '/${widget.orderId}');
    final response = await ResponseClass.callGetApi(
        ApiSheet.getUrl + ApiSheet.orderDetails + '/${widget.orderId}',
        context);
    print(response.body);
    OrderDetail res = OrderDetail.fromJson(json.decode(response.body));
    if (res != null) {
      setState(() {
        if(widget.orderId!=null){
          orderDetail = res.data[0];
        }

      });
    }
    return OrderDetailData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (orderDetail != null && address == null) {
      setPolylines();
    }

    return Scaffold(
      body: SafeArea(
        child: (orderDetail != null)
            ?
       RefreshIndicator(
         key: _refreshIndicatorKey,
           onRefresh: ()async{
           print('Refresh');
           },
           child:  SingleChildScrollView(
         child: Column(
           children: [
             Utils.header(
                 orderDetail.customer.name.toUpperCase(), context),
             Container(
               margin: EdgeInsets.only(left: 20.0, right: 20.0),
               padding: EdgeInsets.only(top: 20.0),
               width: Utils.getWidth(context),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       Container(
                         child: (orderDetail.customer.profilePic != null)
                             ? Utils.getImageNetwork(
                             125.0,
                             125.0,
                             ApiSheet.preBaseUrl +
                                 orderDetail.customer.profilePic,
                             150.0)
                             : Center(
                           child: Utils.fontAwesomeIcon(
                               FontAwesomeIcons.solidUserCircle,
                               110.0,
                               Color(Utils.primaryColor)),
                         ),
                         height: 125.0,
                         width: 125.0,
                         decoration: BoxDecoration(
                             color: Color(Utils.white),
                             boxShadow: [Utils.boxShadow()],
                             border: Utils.border(
                                 Color(Utils.primaryColor), 3.0),
                             borderRadius: Utils.borderRadius(
                               150.0,
                             )),
                       ),
                       Utils.sizeBoxesWidth(10.0),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             Utils.sizeBoxesHeight(15.0),
                             Utils.textBoldColor(
                                 orderDetail.customer.mobileNumber,
                                 18.0,
                                 Color(Utils.primaryColor)),
                             Utils.sizeBoxesHeight(5.0),
                             Utils.poundSignWithPrice(
                                 orderDetail.totalWithDeliveryCharge,
                                 Color(Utils.gray)),
                             // Utils.sizeBoxesHeight(5.0),
                             // Utils.textColor('Count it separately kg',
                             //     14.0, Color(Utils.gray)),
                             Utils.sizeBoxesHeight(15.0),
                             Visibility(
                               visible: (orderDetail.orderStatus
                                   .toLowerCase() !=
                                   '5'),
                               child: FadeTransition(
                                 opacity: _animationController,
                                 child: GestureDetector(
                                   onTap: () {
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                           builder: (context) =>
                                               TrackActivity(
                                                 latitude: orderDetail
                                                     .orderAddress.lat,
                                                 longitude: orderDetail
                                                     .orderAddress.long,
                                                 name: orderDetail
                                                     .customer.name,
                                               ),
                                         ));
                                   },
                                   child: Container(
                                     padding: EdgeInsets.only(
                                         left: 15.0,
                                         right: 15.0,
                                         top: 10.0,
                                         bottom: 10.0),
                                     decoration: Utils
                                         .whiteBoxDecorationNoShadow(
                                         25.0,
                                         Color(Utils.primaryColor)),
                                     child: Wrap(
                                       alignment: WrapAlignment.center,
                                       children: <Widget>[
                                         Utils.fontAwesomeIconWhite(
                                             FontAwesomeIcons
                                                 .mapMarkerAlt,
                                             16.0),
                                         Utils.sizeBoxesWidth(10.0),
                                         Utils.textWhite(
                                             'Track' /*orderDetail.orderLocation*/,
                                             16.0),
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                             Utils.sizeBoxesHeight(15.0),
                             Visibility(
                               visible: (orderDetail.orderStatus
                                   .toLowerCase() !=
                                   '5'),
                               child: Utils.textColor(
                                   'Distance ' +
                                       minDistance.toStringAsFixed(3) +
                                       ' Miles',
                                   15.0,
                                   Color(Utils.gray)),
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                   Utils.sizeBoxesHeight(25.0),
                   Utils.textBoldColor(
                       'Address', 18.0, Color(Utils.blackAccent)),
                   Padding(
                     padding:
                     const EdgeInsets.only(top: 15.0, bottom: 15.0),
                     child: Utils.textMultiLine(
                         (address != null) ? address : '' , 15.0, Color(Utils.black), 3),
                   ),
                   Utils.sizeBoxesHeight(25.0),
                   Utils.textBoldColor(
                       'Orders', 18.0, Color(Utils.blackAccent)),
                   Utils.sizeBoxesHeight(10.0),
                   (orderDetail.orderDetails.length == 0)
                       ? Center(
                       child: Utils.textBoldColor(
                           'No Dish available',
                           18.0,
                           Color(Utils.blackAccent)))
                       : Container(
                     height:
                     115.0 * orderDetail.orderDetails.length,
                     child: ListView.builder(
                         padding: EdgeInsets.all(0.0),
                         itemCount:
                         orderDetail.orderDetails.length,
                         physics: NeverScrollableScrollPhysics(),
                         itemBuilder: (context, index) {
                           return Container(
                             width: Utils.getWidth(context),
                             height: 100.0,
                             margin: EdgeInsets.only(
                                 top: 5.0, bottom: 10.0),
                             padding: EdgeInsets.all(10.0),
                             decoration:
                             Utils.whiteBoxDecoration(15.0),
                             child: Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               children: <Widget>[
                                 (orderDetail.orderDetails[index]
                                     .meals !=
                                     null)
                                     ? Utils.getImageNetwork(
                                     80.0,
                                     80.0,
                                     ApiSheet.preBaseUrl +
                                         orderDetail
                                             .orderDetails[
                                         index]
                                             .meals
                                             .meals
                                             .image,
                                     50.0)
                                     : Utils.imageAssets(
                                     'mapStyle/logo.png',
                                     80.0,
                                     80.0),
                                 Utils.sizeBoxesWidth(15.0),
                                 Expanded(
                                   child: Column(
                                     crossAxisAlignment:
                                     CrossAxisAlignment.start,
                                     children: <Widget>[
                                       Utils.textBoldMultiLine(
                                           orderDetail
                                               .orderDetails[index]
                                               .productName,
                                           18.0,
                                           Color(
                                               Utils.primaryColor),
                                           1),
                                       Utils.sizeBoxesHeight(5.0),
                                       Utils.poundSignWithPrice(
                                           orderDetail
                                               .orderDetails[index]
                                               .price,
                                           Color(Utils.gray)),
                                       Utils.sizeBoxesHeight(5.0),
                                       Utils.textColor(
                                           'Qty : ${orderDetail.orderDetails[index].quantity}',
                                           14.0,
                                           Color(Utils.gray)),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           );
                         }),
                   ),
                   Utils.sizeBoxesHeight(25.0),
                   Row(
                     children: <Widget>[
                       Utils.textBoldBlack('Amount', 20.0),
                       Spacer(),
                       Utils.fontAwesomeIcon(FontAwesomeIcons.poundSign,
                           22.0, Color(Utils.primaryColor)),
                       Utils.sizeBoxesWidth(3.0),
                       Utils.textBoldColor(getTotalPrice(), 24.0,
                           Color(Utils.primaryColor)),
                       Utils.sizeBoxesWidth(5.0)
                     ],
                   ),
                   Utils.sizeBoxesHeight(25.0),
                   Visibility(
                     visible:
                     (orderDetail.orderStatus.toLowerCase() != '5'),
                     child: GestureDetector(
                       onTap: () {
                         Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) =>
                                     GetSignatureActivity(
                                         orderDetail: orderDetail,
                                         orderId: widget.orderId)))
                             .then((value) {
                           if (value != null) {
                             if (value == 'true') {
                               Constant.delivered = true;
                               setState(() {
                                 orderDetail.orderStatus = '5';
                               });
                             }
                           }
                         });
                       },
                       child: Container(
                         height: 50.0,
                         width: Utils.getWidth(context),
                         margin:
                         EdgeInsets.only(left: 25.0, right: 25.0),
                         decoration: Utils.whiteBoxDecorationNoShadow(
                             50.0, Color(Utils.primaryColor)),
                         child: Center(
                             child: Utils.textWhite(
                                 'Confirm Delivery', 16.0)),
                       ),
                     ),
                   ),
                   Utils.sizeBoxesHeight(25.0),
                 ],
               ),
             ),
           ],
         ),
       ))
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  String getTotalPrice() {
    double tempValue = 0.0;
    for (int i = 0; i < orderDetail.orderDetails.length; i++) {
      // if (orderDetail.orderDetails[i].selectedToDeliver == 1) {
      tempValue += double.parse(orderDetail.orderDetails[i].price);
      // }
    }
    print(tempValue.toStringAsFixed(2));
    return tempValue.toStringAsFixed(2);
  }

  void setPolylines() async {
    address = (orderDetail.orderAddress != null)
        ? '${orderDetail.orderAddress.apartment}, '
            '${orderDetail.orderAddress.addressLine1}, '
            '${orderDetail.orderAddress.addressLine2}, '
            '${orderDetail.orderAddress.areaName}, '
            '${orderDetail.orderAddress.pincode}'
        : orderDetail.customer.address;

    if (orderDetail.orderAddress.lat == null &&
        orderDetail.orderAddress.long == null) {
      var addresses = await Geocoder.local.findAddressesFromQuery(address);
      var first = addresses.first;

      orderDetail.orderAddress.lat = first.coordinates.latitude.toString();
      orderDetail.orderAddress.long = first.coordinates.longitude.toString();
    }

    // if (Constant.currentLocation.latitude != null &&
    //     Constant.currentLocation.longitude != null) {
      var apiKey = (Platform.isAndroid)
          ? 'AIzaSyD9npt7zydujGQZ4CO7m6eFroyS0LSuobI'
          : 'AIzaSyBTl5Gr7l2rSEj-XpxkNai_Q-8DD3-lcQc';
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        PointLatLng(
            /*51.585088, -0.341001*/
            Constant.currentLocation.latitude,
            Constant.currentLocation.longitude),
        PointLatLng(double.parse(orderDetail.orderAddress.lat),
            double.parse(orderDetail.orderAddress.long) /*_endPoint.latitude, _endPoint.longitude*/),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        var dis = 0.0;
        for (int i = 0; i < result.points.length; i++) {
          dis = _coordinateDistance(
            /* 51.585088,
            -0.341001*/
              Constant.currentLocation.latitude,
              Constant.currentLocation.longitude,
              double.parse(orderDetail.orderAddress.lat),
              double.parse(orderDetail.orderAddress.long));
          if (minDistance > dis || minDistance == 0.0) {
            minDistance = dis;
          }
        }
      }
    // }

    minDistance *= 0.621371;
    setState(() {});
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

}





