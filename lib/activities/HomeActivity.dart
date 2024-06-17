import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' show cos, sqrt, asin;

// import 'package:barcode_scan/barcode_scan.dart';
import 'package:app_settings/app_settings.dart';
import 'package:delivery_radharani/APiDirectory/ApiSheet.dart';
import 'package:delivery_radharani/APiDirectory/ResponseClass.dart';
import 'package:delivery_radharani/Objects/CustomTimeSlot.dart';
import 'package:delivery_radharani/Objects/Login.dart';
import 'package:delivery_radharani/Objects/Logout.dart';
import 'package:delivery_radharani/Objects/Orders.dart';
import 'package:delivery_radharani/Utils/Constant.dart';
import 'package:delivery_radharani/Utils/ToastUtils.dart';
import 'package:delivery_radharani/Utils/Utils.dart';
import 'package:delivery_radharani/activities/MyProfileActivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'ChangePasswordActivity.dart';
import 'LoginActivity.dart';
import 'OrderDetailsActivity.dart';
import 'OrderListActivity.dart';

class HomeActivity extends StatefulWidget {


  @override
  _HomeActivityState createState() => _HomeActivityState();
}

TextEditingController locationController = new TextEditingController();

class _HomeActivityState extends State<HomeActivity>
    with WidgetsBindingObserver {
  List<TimeSlot> times = new List();
  List<Date> dates = new List();
  Login res = new Login();
  List<OrderData> order;

  var selectedDate = Utils.changeDateFormat('yyyy-MM-dd', DateTime.now());

  var selectTimeSlot = 0, minDistance = 0.0, minDisIndex = 0;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _mapController = controller;
    controller.setMapStyle(_mapStyle);
  }

  String _mapStyle;
  bool showProgressBar = false;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  BitmapDescriptor iconGreen, iconRed;
  LocationData _locationData;
  Future<LocationData> locationdata;

  Future<void> getLocation(List<OrderData> orderData) async {
    _markers.clear();
    _polylines.clear();
    _markers.add(Marker(
        markerId: MarkerId(res.currentLoginUser.id.toString()),
        position: LatLng(
          /*51.585088, -0.341001*/
            Constant.currentLocation.latitude,
            Constant.currentLocation.longitude),
        infoWindow: InfoWindow(
            title: 'Your location',
            onTap: () {
              _mapController.hideMarkerInfoWindow(
                  MarkerId(res.currentLoginUser.id.toString()));
            }),
        icon: iconGreen));
    print('Deep${orderData.length}');

    for (int i = 0; i < orderData.length; i++) {
      if (orderData[i].orderAddress != null) {
        if (orderData[i].orderAddress.lat == null &&
            orderData[i].orderAddress.long == null) {
          var address = '${orderData[i].orderAddress.apartment}, ' +
              '${orderData[i].orderAddress.addressLine1}, ' +
              '${orderData[i].orderAddress.addressLine2}, ' +
              '${orderData[i].orderAddress.landmark}, ' +
              '${orderData[i].orderAddress.areaName}';

          var addresses = await Geocoder.local.findAddressesFromQuery(address);
          var first = addresses.first;

          orderData[i].orderAddress.lat = first.coordinates.latitude.toString();
          orderData[i].orderAddress.long = first.coordinates.longitude.toString();
        }
        // print('Yes Live lat track${orderData[i].orderAddress.lat}');
        if (orderData[i].orderAddress.lat != null &&
            orderData[i].orderAddress.long != null) {
          setPolylines(orderData[i].orderAddress.lat, orderData[i].orderAddress.long);
          _markers.add(Marker(
              markerId: MarkerId(orderData[i].id.toString()),
              position: LatLng(
                  double.parse(orderData[i].orderAddress.lat),
                  double.parse(orderData[i].orderAddress.long)),
              infoWindow: InfoWindow(
                  onTap: () {
                    if (_mapController != null)
                      _mapController.hideMarkerInfoWindow(
                          MarkerId(orderData[i].id.toString()));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderDetailsActivity(
                              orderId: orderData[i].id,
                            ))).then((value) {
                      fetchOrders(ApiSheet.getUrl +
                          ApiSheet.getOrderData +
                          '/$selectedDate/${times[selectTimeSlot].deliveryTimeSlot}');
                    });
                  },
                  title:
                  '${orderData[i].orderLocation} (${orderData[i].orderKey})',
                  snippet:
                  '${orderData[i].orderAddress.apartment}, ${orderData[i].orderAddress.addressLine1}, '
                      '${(orderData[i].orderAddress.addressLine2 != null) ? orderData[i].orderAddress.addressLine2 + ', ' : ''}'
                      '${orderData[i].orderLocation}'),
              icon: iconRed));
        }
      }
    }

    if (orderData.length != 0) {
      drawRoute(orderData[minDisIndex].orderAddress.lat,
          orderData[minDisIndex].orderAddress.long);
    } else {
      setState(() {
        showProgressBar = false;
      });
    }
  }

  @override
  void initState() {
    rootBundle.loadString('mapStyle/newStyle.txt').then((string) {
      _mapStyle = string;
    });
    WidgetsBinding.instance.addObserver(this);
    getCurrentUserLocation();
    locationdata=getCurrentUserLocation();

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (redirectToSetting) {
        getCurrentUserLocation();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<LocationData> getCurrentUserLocation() async {
    setState(() {
      showProgressBar = true;
    });
    Location location = new Location();
    LocationData _locationData;

    PermissionStatus _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();

      if (_permissionGranted == PermissionStatus.granted) {
        var _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
        }

        if (_serviceEnabled) {
          _locationData = await location.getLocation();
          Constant.currentLocation = _locationData;
          callOtherMethod();
        }
      } else {
        alertToAllowLocation(
            (_permissionGranted == PermissionStatus.deniedForever) ? 2 : 1);
      }
      return _locationData;
    } else if (_permissionGranted == PermissionStatus.granted) {
      var _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
      }

      if (_serviceEnabled) {
        _locationData = await location.getLocation();
        Constant.currentLocation = _locationData;
        callOtherMethod();
      }
      return _locationData;
    }
  }

  void callOtherMethod() {
    setState(() {
      showProgressBar = false;
    });

    getUserData();
    getTimeSlot(1);

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(132, 172)),
        'mapStyle/location_green.png')
        .then((d) {
      iconGreen = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(132, 172)),
        'mapStyle/location_red.png')
        .then((d) {
      iconRed = d;
    });

    _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
      Constant.currentLocation.latitude,
      Constant.currentLocation.longitude,
    )));
  }

  void getTimeSlot(int add) async {
    setState(() {
      showProgressBar = true;
    });

    final response = await ResponseClass.callGetApi(
        ApiSheet.getTimeSlot + selectedDate, context);
    print(ApiSheet.getTimeSlot + selectedDate);
    print('getTimeSlot ## ${response.body}');

    setState(() {
      showProgressBar = false;
    });

    CustomTimeSlot res = CustomTimeSlot.fromJson(json.decode(response.body));
    // if (res.data.timeSlot.length != 0) {
    times = new List();
    times = res.data.timeSlot;

    if (add == 1) {
      dates.clear();
      dates = new List();
      dates = res.data.date;
    }

    _markers.add(Marker(
        markerId: MarkerId(this.res.currentLoginUser.id.toString()),
        position: LatLng(
          /*51.585088, -0.341001*/
            Constant.currentLocation.latitude,
            Constant.currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your location'),
        icon: iconGreen));
    if (times.length != 0) {
      fetchOrders(ApiSheet.getUrl +
          ApiSheet.getOrderData +
          '/$selectedDate/${times[selectTimeSlot].deliveryTimeSlot}');
    }
  }

  getUserData() async {
    res = await Utils.getUserData();
    setState(() {
      print('User data' + json.encode(res));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigationDrawer(context),
      body:(Constant.currentLocation != null) ?
      Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            height: Utils.getHeight(context),
            width: Utils.getWidth(context),
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                  polylines: _polylines,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      /*51.585088,
                          -0.341001*/
                        Constant.currentLocation.latitude,
                        Constant.currentLocation.longitude
                      // 21.170240,
                      // 72.831062
                    ),
                    zoom: 15.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 60.0),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          decoration: Utils.whiteBoxDecoration(50.0),
                          width: 50.0,
                          height: 50.0,
                          child: Center(
                            child: Utils.fontAwesomeIcon(FontAwesomeIcons.bars,
                                20.0, Color(Utils.primaryColor)),
                          ),
                        ),
                      ),
                      Utils.sizeBoxesWidth(15.0),
                      Expanded(
                        child: Container(
                          // padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: Utils.whiteBoxDecoration(10.0),
                          height: 50.0,
                          child: Row(
                            children: <Widget>[
                              /*Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (locationController.text
                                              .toString()
                                              .trim() !=
                                          '') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderListActivity(
                                                        title: locationController
                                                            .text)));
                                      } else {
                                        ToastUtils.showCustomToast(context,
                                            "Search any location", 'warning');
                                      }
                                    },
                                    child: Utils.fontAwesomeIconGreen(
                                        FontAwesomeIcons.locationArrow, 20.0),
                                  ),
                                ),*/
                              Expanded(
                                child: Utils.textFieldBlack(
                                    'Search location', locationController),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Utils.sizeBoxesWidth(15.0),
                      GestureDetector(
                        onTap: () async {
                          if (locationController.text.toString().trim() != '') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderListActivity(
                                        title: locationController.text)));
                          } else {
                            ToastUtils.showCustomToast(
                                context, "Search any location", 'warning');
                          }
                        },
                        child: Container(
                          decoration: Utils.whiteBoxDecoration(10.0),
                          width: 50.0,
                          height: 50.0,
                          child: Center(
                            child: Utils.fontAwesomeIcon(
                                FontAwesomeIcons.search,
                                20.0,
                                Color(Utils.primaryColor)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _polylines.clear();
                        polylineCoordinates.clear();
                        _markers.clear();

                        getTimeSlot(1);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(Utils.lightGreen),
                          boxShadow: [Utils.boxShadow()],
                        ),
                        padding: EdgeInsets.all(7.0),
                        margin: EdgeInsets.only(right: 20.0, bottom: 5.0),
                        child: Icon(
                          Icons.autorenew_rounded,
                          size: 30.0,
                          color: Color(Utils.primaryColor),
                        ),
                      ),
                    ),
                    Utils.sizeBoxesHeight(10.0),
                    Container(
                      padding:
                      EdgeInsets.only(left: 20.0, top: 25.0, right: 20.0),
                      width: Utils.getWidth(context),
                      height: 210.0,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset:
                              Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                          color: Color(Utils.lightGreen)),
                      child: (dates.length > 0)
                          ? Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Utils.textColor('Delivery Date',
                                      16.0, Colors.black54)),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Utils.textColor(
                                      Utils.changeDateFormat(
                                          'MMMM', DateTime.now()),
                                      16.0,
                                      Color(Utils.primaryColor))),
                            ],
                          ),
                          Utils.sizeBoxesHeight(15.0),
                          Container(
                            height: Utils.getWidth(context) * 0.12,
                            child: ListView.builder(
                                padding: EdgeInsets.all(0.0),
                                scrollDirection: Axis.horizontal,
                                itemCount: dates.length,
                                itemBuilder: (context, index) {
                                  print('D# Dates Length ${dates.length}');
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _markers.clear();
                                        _polylines.clear();
                                        polylineCoordinates.clear();
                                        _markers.add(Marker(
                                            markerId: MarkerId(this
                                                .res
                                                .currentLoginUser
                                                .id
                                                .toString()),
                                            position: LatLng(
                                              /*51.585088, -0.341001*/
                                                Constant.currentLocation
                                                    .latitude,
                                                Constant.currentLocation
                                                    .longitude),
                                            infoWindow: InfoWindow(
                                                title: 'Your location'),
                                            icon: iconGreen));
                                        selectedDate =
                                            dates[index].orderDate;
                                        selectTimeSlot = 0;
                                        getTimeSlot(0);
                                      });
                                    },
                                    child: dateSelector(
                                        dates[index].orderDate, index),
                                  );
                                }),
                          ),
                          Utils.sizeBoxesHeight(15.0),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Utils.textColor(
                                  'Delivery Time', 16.0, Colors.black54)),
                          Utils.sizeBoxesHeight(10.0),
                          Container(
                            height: 40.0,
                            child: ListView.builder(
                                padding: EdgeInsets.all(0.0),
                                scrollDirection: Axis.horizontal,
                                itemCount: times.length,
                                itemBuilder: (context, index) {
                                  var date = times[index]
                                      .deliveryTimeSlot; //.substring(
                                  // times[index]
                                  // .deliveryTimeSlot
                                  // .indexOf('(') +
                                  // 1,
                                  // times[index]
                                  // .deliveryTimeSlot
                                  // .indexOf(')'))
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectTimeSlot = index;
                                        if (times.length != 0) {
                                          fetchOrders(ApiSheet.getUrl +
                                              ApiSheet.getOrderData +
                                              '/$selectedDate/${times[selectTimeSlot].deliveryTimeSlot}');
                                        }
                                      });
                                      // print('${times[selectTimeSlot].deliveryTimeSlot}');
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: (index == 0) ? 0.0 : 5.0,
                                          right: 5.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25.0),
                                        ),
                                        border: Utils.border(
                                            Color(Utils.white), 3.0),
                                        color: (selectTimeSlot == index)
                                            ? Color(Utils.primaryColor)
                                            : Color(Utils.accentColor),
                                      ),
                                      child: Center(
                                        child: Utils.textColor(
                                            date,
                                            14.0,
                                            (selectTimeSlot == index)
                                                ? Color(Utils.accentColor)
                                                : Color(
                                                Utils.primaryColor)),
                                      ),
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                    ),
                                  );
                                }),
                          ),
                          Visibility(
                            visible: false,
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 15.0, left: 15.0, right: 15.0),
                              height: 45.0,
                              width: Utils.getWidth(context),
                              decoration:
                              Utils.whiteBoxDecorationNoShadow(25.0,
                                  Color(Utils.lightPrimaryColor)),
                              child: Center(
                                  child: Utils.textWhite(
                                      'START DELIVERY', 14.0)),
                            ),
                          ),
                        ],
                      )
                          : Container(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            Utils.imageAssets(
                                'mapStyle/logo.png', 150.0, 125.0),
                            Utils.sizeBoxesHeight(5.0),
                            Utils.textBoldBlack(
                                'Delivery not assigned yet!', 16.0),
                            Utils.sizeBoxesHeight(13.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: showProgressBar,
                  child: Container(
                    color: Colors.black38,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ) : Center(child: CircularProgressIndicator(),),
    );
  }

  Widget dateSelector(String data, int index) {
    var dateWidgetSize = Utils.getWidth(context) * 0.12;
    return Container(
      height: dateWidgetSize,
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.only(left: (index == 0) ? 0.0 : 5.0, right: 5.0),
      width: 85.0,
      decoration: BoxDecoration(
        boxShadow: [Utils.boxShadow()],
        borderRadius: Utils.borderRadius(25.0),
        color: Color(
            (selectedDate == data) ? Utils.primaryColor : Utils.accentColor),
        border: Utils.border(Color(Utils.white), 3.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: dateWidgetSize / 1.4,
            width: dateWidgetSize / 1.4,
            decoration: BoxDecoration(
              borderRadius: Utils.borderRadius(25.0),
              color: Color(
                  (selectedDate == data) ? Utils.accentColor : Utils.white),
            ),
            child: Center(
                child: Utils.textBoldMultiLineClip(
                    Utils.changeDateFormatString('yyyy-MM-dd', 'EEE', data),
                    12.0,
                    Color(Utils.primaryColor),
                    1)),
          ),
          Utils.sizeBoxesHeight(2.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Utils.textBoldMultiLineClip(
                    Utils.changeDateFormatString('yyyy-MM-dd', 'dd', data),
                    10.0,
                    Color((selectedDate == data)
                        ? Utils.accentColor
                        : Utils.primaryColor),
                    1),
                Utils.textBoldMultiLineClip(
                    Utils.changeDateFormatString('yyyy-MM-dd', 'MMM', data),
                    10.0,
                    Color((selectedDate == data)
                        ? Utils.accentColor
                        : Utils.primaryColor),
                    1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Drawer navigationDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        color: Color(Utils.accentColor),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50.0),
              height: 100.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: (res != null &&
                        res.currentLoginUser != null &&
                        res.currentLoginUser.image != null)
                        ? Utils.getProfilePic(
                        100.0,
                        100.0,
                        ApiSheet.preBaseUrl + res.currentLoginUser.image,
                        50.0)
                        : Center(
                      child: Utils.fontAwesomeIconBlack(
                          FontAwesomeIcons.solidUserCircle, 86.0),
                    ),
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                        border: Utils.border(Color(Utils.primaryColor), 3.0),
                        borderRadius: Utils.borderRadius(150.0)),
                  ),
                  Utils.sizeBoxesWidth(15.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Utils.textBoldBlack(
                          (res.currentLoginUser != null)
                              ? res.currentLoginUser.name
                              : '',
                          18.0),
                      Utils.sizeBoxesHeight(15.0),
                      Utils.textColor(
                          (res.currentLoginUser != null)
                              ? '+91 ' + res.currentLoginUser.mobileNumber
                              : '',
                          14.0,
                          Color(Utils.primaryColor)),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderListActivity(title: 'DELIVERIES')));
                    },
                    leading: Utils.fontAwesomeIconBlack(
                        FontAwesomeIcons.solidListAlt, 24.0),
                    title: Utils.textBlack('Deliveries', 18.0),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyProfileActivity()))
                          .then((value) {
                        getUserData();
                      });
                    },
                    leading: Utils.fontAwesomeIconBlack(
                        FontAwesomeIcons.solidUser, 24.0),
                    title: Utils.textBlack('My profile', 18.0),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePasswordActivity()));
                    },
                    leading:
                    Utils.fontAwesomeIconBlack(FontAwesomeIcons.key, 24.0),
                    title: Utils.textBlack('Change Password', 18.0),
                  ),
                  ListTile(
                    onTap: () {
                      showLogoutDialog();
                    },
                    leading: Utils.fontAwesomeIconBlack(
                        FontAwesomeIcons.signOutAlt, 24.0),
                    title: Utils.textBlack('Log out', 18.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLogoutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              decoration: BoxDecoration(borderRadius: Utils.borderRadius(20.0)),
              height: 225.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Utils.fontAwesomeIconBlack(FontAwesomeIcons.frownOpen, 50.0),
                  Utils.textBoldBlack('Logout', 20.0),
                  Utils.textBlack('Are you sure you want to logout?', 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: Utils.borderRadius(20.0),
                              color: Color(Utils.accentColor),
                            ),
                            padding: EdgeInsets.only(
                                left: 30.0,
                                right: 30.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Utils.textBoldBlack('Cancel', 14.0)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          logOut();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: Utils.borderRadius(20.0),
                              color: Color(Utils.primaryColor),
                            ),
                            padding: EdgeInsets.only(
                                left: 30.0,
                                right: 30.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Utils.textBoldWhite('Logout', 14.0)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void logOut() async {
    var jsonData = {
      '': '',
    };
    print(ApiSheet.getUrl + ApiSheet.logout);
    final response = await ResponseClass.callPostApi(
        jsonData, ApiSheet.getUrl + ApiSheet.logout, context);
    print(response.body);

    Logout res = Logout.fromJson(json.decode(response.body));
    if (res.message.toLowerCase().contains('successfully')) {
      Utils.removeData();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginActivity(),
          ));
    } else {
      Utils.errorCode(response.body, context);
    }
  }

  void fetchOrders(String api) async {
    setState(() {
      showProgressBar = true;
    });
    print('Baseurl ${api}');
    final response = await ResponseClass.callGetApi(api, context);
    print('Order Data ## ${response.body}');
    if (response.statusCode == 200) {
      Orders res = Orders.fromJson(json.decode(response.body));
      minDisIndex = 0;
      getLocation(res.data.orderData);
    } else {
      Utils.errorCode(response.body, context);
    }
  }

  setPolylines(String lat, String long) async {
    var apiKey = (Platform.isAndroid)
        ? 'AIzaSyD9npt7zydujGQZ4CO7m6eFroyS0LSuobI'
        : 'AIzaSyBTl5Gr7l2rSEj-XpxkNai_Q-8DD3-lcQc';

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(
        /*51.585088, -0.341001*/
          Constant.currentLocation.latitude,
          Constant.currentLocation.longitude),
      PointLatLng(double.parse(lat),
          double.parse(long) /*_endPoint.latitude, _endPoint.longitude*/),
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
            double.parse(lat),
            double.parse(long));
        if (minDistance > dis || minDistance == 0.0) {
          minDistance = dis;
          minDisIndex = i;
        }
      }
    }
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> drawRoute(String lat, String long) async {
    _polylines.clear();
    polylineCoordinates.clear();
    var apiKey = (Platform.isAndroid)
        ? 'AIzaSyD9npt7zydujGQZ4CO7m6eFroyS0LSuobI'
        : 'AIzaSyBTl5Gr7l2rSEj-XpxkNai_Q-8DD3-lcQc';

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(
        /*51.585088, -0.341001*/
          Constant.currentLocation.latitude,
          Constant.currentLocation.longitude),
      PointLatLng(double.parse(lat), double.parse(long)),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (int i = 0; i < result.points.length; i++) {
        polylineCoordinates
            .add(LatLng(result.points[i].latitude, result.points[i].longitude));
      }
    }
    setState(() {
      showProgressBar = false;
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          width: 3,
          color: Colors.red[900],
          points: polylineCoordinates);
      _polylines.add(polyline);
    });
  }

  //459776
  var redirectToSetting = false;

  void alertToAllowLocation(int from) {
    redirectToSetting = false;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Color(Utils.white),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 275,
              padding: EdgeInsets.all(15.0),
              width: Utils.getWidth(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Utils.fontAwesomeIconGreen(
                      FontAwesomeIcons.mapMarkedAlt, 50.0),
                  Utils.textBoldColor(
                      'Access your device location', 20.0, Color(Utils.black)),
                  Utils.textAlignment(
                      (from == 2)
                          ? 'You have to allow location permission. Click ALLOW to give permission from settings.'
                          : 'Please turn on your device to enter your delivery address.',
                      TextAlign.center,
                      16.0,
                      Color(Utils.black)),
                  Utils.sizeBoxesHeight(15.0),
                  RaisedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      if (from == 2) {
                        redirectToSetting = true;
                        AppSettings.openAppSettings();
                      } else
                        getCurrentUserLocation();
                    },
                    padding: EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 35.0, right: 35.0),
                    color: Color(Utils.primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Utils.textWhite('Allow', 16.0),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
