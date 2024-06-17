import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:delivery_radharani/Utils/Constant.dart';
import 'package:delivery_radharani/Utils/ToastUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery_radharani/Utils/Utils.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackActivity extends StatefulWidget {
  final String latitude;
  final String longitude;
  final String name;

  TrackActivity(
      {Key key,
      @required this.latitude,
      @required this.longitude,
      @required this.name})
      : super(key: key);

  @override
  _TrackActivityState createState() => _TrackActivityState();
}

class _TrackActivityState extends State<TrackActivity> {
  double CAMERA_ZOOM = 16;
  double CAMERA_TILT = 45;

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;
  String _mapStyle;


  @override
  void initState() {
    super.initState();
    // DEST_LOCATION =
    //     LatLng(double.parse(widget.latitude), double.parse(widget.longitude));
    //
    // SOURCE_LOCATION = LatLng(
    //     Constant.currentLocation.latitude, Constant.currentLocation.longitude);

    currentLocation = Constant.currentLocation;
    destinationLocation = LocationData.fromMap({
      "latitude": double.parse(widget.latitude),
      "longitude": double.parse(widget.longitude),
    });

    location = new Location();
    polylinePoints = PolylinePoints();
    location.onLocationChanged.listen((LocationData cLoc) {
      if (currentLocation != null) {
        currentLocation = cLoc;
        updatePinOnMap();
      }
    });

    setSourceAndDestinationIcons();
    setInitialLocation();
    // showPinsOnMap();
    setPolylines();
    rootBundle.loadString('mapStyle/newStyle.txt').then((string) {
      _mapStyle = string;
    });
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'mapStyle/location_green.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'mapStyle/location_red.png');
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }



  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        target: LatLng(currentLocation.latitude, currentLocation.longitude));
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
      );
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            compassEnabled: true,
            tiltGesturesEnabled: false,
            markers: _markers,
            polylines: _polylines,
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller.complete(controller);
                controller.setMapStyle(_mapStyle);
                setPolylines();
              });
            },
            onCameraMove: (CameraPosition cameraPosition) {
              setState(() {
                CAMERA_ZOOM = cameraPosition.zoom;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Utils.header('TRACK ${widget.name.toUpperCase()}', context),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 25.0),
              child: RaisedButton(
                onPressed: () async {
                  if (Platform.isAndroid) {
                    if (Constant.currentLocation != null) {
                      final url =
                          'https://www.google.com/maps/dir/?api=1&origin=${currentLocation.latitude},${currentLocation.longitude}'
                          '&destination=${destinationLocation.latitude},${destinationLocation.longitude}&travelmode=driving&dir_action=navigate';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }
                  } else {
                    var urlAppleMaps =
                        'https://maps.apple.com/?${currentLocation.latitude},${currentLocation.longitude}';
                    var url =
                        "comgooglemaps://?saddr=${currentLocation.latitude},${currentLocation.longitude}"
                        "&daddr=${destinationLocation.latitude},${destinationLocation.latitude}&directionsmode=driving&dir_action=navigate";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else if (await canLaunch(urlAppleMaps)) {
                      await launch(urlAppleMaps);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }
                },
                padding: EdgeInsets.only(left: 35.0,right: 35.0,top: 10.0,bottom: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                color: Color(Utils.primaryColor),
                child: Utils.textWhite('Track on Google Map', 16.0),
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50.0,
                  width: Utils.getWidth(context),
                  margin:
                      EdgeInsets.only(left: 50.0, right: 50.0, bottom: 25.0),
                  decoration: Utils.whiteBoxDecorationNoShadow(
                      50.0, Color(Utils.primaryColor)),
                  child: Center(child: Utils.textWhite('Reached Out', 16.0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void showPinsOnMap() {
  //   // get a LatLng for the source location
  //   // from the LocationData currentLocation object
  //   var pinPosition =
  //       LatLng(currentLocation.latitude, currentLocation.longitude);
  //   // get a LatLng out of the LocationData object
  //   var destPosition =
  //       LatLng(destinationLocation.latitude, destinationLocation.longitude);
  // //  add the initial source location pin
  // //   _markers.add(Marker(
  // //       markerId: MarkerId('sourcePin'),
  // //       position: pinPosition,
  // //       icon: sourceIcon));
  //   // destination pin
  //   // _markers.add(Marker(
  //   //     markerId: MarkerId('destPin'),
  //   //     position: destPosition,
  //   //     icon: destinationIcon));
  //
  //   setPolylines();
  // }

  void setPolylines() async {
    var apiKey = (Platform.isAndroid)
        ? 'AIzaSyD9npt7zydujGQZ4CO7m6eFroyS0LSuobI'
        : 'AIzaSyBTl5Gr7l2rSEj-XpxkNai_Q-8DD3-lcQc';

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
      travelMode: TravelMode.driving,
    );

    polylineCoordinates.clear();
    _polylines.clear();

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
            width: 3, // set the width of the polylines
            polylineId: PolylineId("poly"),
            color: Colors.red[900],
            points: polylineCoordinates));
      });
    }
  }

//1473265903
  void updatePinOnMap() async {
    try {
      CameraPosition cPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
      );
      final GoogleMapController controller = await _controller.future;

      // ToastUtils.showCustomToast(
      //     context, 'controller != null ## ${controller != null}', 'warning');

      if (controller != null) {
        controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
      }

      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      _markers.removeWhere((m) => m.markerId.value == "sourcePin");
      _markers.add(Marker(
          markerId: MarkerId("sourcePin"),
          position: pinPosition, // updated position
          icon: sourceIcon));

      var destPosition =
      LatLng(destinationLocation.latitude, destinationLocation.longitude);
      _markers.add(Marker(
        markerId: MarkerId("destPin"),
        position: destPosition,
        icon: destinationIcon
      ));

      setPolylines();
    } catch (e) {}
  }

  @override
  void dispose() {
    currentLocation = null;
    destinationLocation = null;
    super.dispose();
  }
}
