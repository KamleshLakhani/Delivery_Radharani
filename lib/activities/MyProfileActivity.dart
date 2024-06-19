import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:delivery_radharani/Objects/Login.dart';
import 'package:delivery_radharani/Objects/ProfilePic.dart';
import 'package:http/http.dart' as http;

import 'package:delivery_radharani/APiDirectory/ApiSheet.dart';
import 'package:delivery_radharani/APiDirectory/ResponseClass.dart';
import 'package:delivery_radharani/Objects/ResponseData.dart';
import 'package:delivery_radharani/Objects/Profile.dart';
import 'package:delivery_radharani/Utils/SharedPreference.dart';
import 'package:delivery_radharani/Utils/ToastUtils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:delivery_radharani/Utils/Utils.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileActivity extends StatefulWidget {
  @override
  _MyProfileActivityState createState() => _MyProfileActivityState();
}

class _MyProfileActivityState extends State<MyProfileActivity> {
  TextEditingController fullNameController,
      phoneNumberController,
      emailController;

  Future<Profile> getProfile;
  Login user = new Login();

  File _image;
  ProfileData data;

  Future getImage(BuildContext context) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile.path != null) {
      setState(() {
        _image = File(pickedFile.path);
        startImageUpload(context);
      });
    }
  }

  Future<Profile> getDeliverProfile(BuildContext context) async {
    print(ApiSheet.getUrl + ApiSheet.getProfile);
    final response = await ResponseClass.callGetApi(
        ApiSheet.getUrl + ApiSheet.getProfile, context);
    print(response.body);

    if (response.statusCode == 200) {
      var data = Profile.fromJson(json.decode(response.body));
      user.currentLoginUser = data.data.deliveryBoy;

      SharedPreference.addStringToSF(
          SharedPreference.loginData, json.encode(user));
      return data;
    } else {
      throw Exception('Failed to load album');
    }
  }

  startImageUpload(BuildContext context) async {
    print(
        ApiSheet.getUrl + ApiSheet.saveImage + '/${user.currentLoginUser.id}');

    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    var length = await _image.length();
    var uri = Uri.parse(
        ApiSheet.getUrl + ApiSheet.saveImage + '/${user.currentLoginUser.id}');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(_image.path));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print('AVTAR UPDATE ## $value');

      ProfilePic res = ProfilePic.fromJson(json.decode(value));
      if (res.message.toLowerCase().contains('successfully')) {
        user.currentLoginUser.image = res.fileName;

        SharedPreference.addStringToSF(
            SharedPreference.loginData, json.encode(user));

        // ToastUtils.showCustomToast(context, res.message, 'success');
      } else {
        ToastUtils.showCustomToast(context, res.message, 'warning');
      }
    });
  }

  @override
  void initState() {
    fullNameController = new TextEditingController();
    phoneNumberController = new TextEditingController();
    emailController = new TextEditingController();

    getDriverData();
    super.initState();
  }

  getDriverData() async {
    user = await Utils.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      getProfile = getDeliverProfile(context);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Utils.header('MY PROFILE', context),
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
                child: FutureBuilder<Profile>(
                  future: getProfile,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      data = snapshot.data.data;

                      fullNameController.text = data.deliveryBoy.name;
                      emailController.text = data.deliveryBoy.email;
                      phoneNumberController.text =
                          data.deliveryBoy.mobileNumber;

                      print('FILE PATH ## ' +
                          ApiSheet.preBaseUrl +
                          data.deliveryBoy.image);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 120.0,
                            height: 120.0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    getImage(context);
                                  },
                                  child: Container(
                                    child: (_image != null)
                                        ? Utils.getImageFile(
                                            100.0, 100.0, _image, 150.0)
                                        : Container(
                                            child: (data != null &&
                                                    data.deliveryBoy.image !=
                                                        null)
                                                ? Utils.getProfilePic(
                                                    120.0,
                                                    120.0,
                                                    ApiSheet.preBaseUrl +
                                                        data.deliveryBoy.image,
                                                    50.0)
                                                : Utils.fontAwesomeIcon(
                                                    FontAwesomeIcons
                                                        .solidUserCircle,
                                                    100.0,
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
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      getImage(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      margin: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        color: Color(Utils.white),
                                        borderRadius: Utils.borderRadius(25.0),
                                      ),
                                      child: Utils.fontAwesomeIconGreen(
                                          FontAwesomeIcons.camera, 14.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Utils.sizeBoxesHeight(50.0),
                          Utils.textFieldBlackWithBackgroundAndPrefixIcon(
                              'Full name',
                              fullNameController,
                              50.0,
                              FontAwesomeIcons.solidUser,
                              Color(Utils.primaryColor),
                              22.0,
                              TextInputType.text),
                          Utils.sizeBoxesHeight(25.0),
                          Utils
                              .textFieldBlackWithBackgroundAndPrefixIconNonEditable(
                                  'Mobile number',
                                  phoneNumberController,
                                  50.0,
                                  FontAwesomeIcons.mobile,
                                  Color(Utils.primaryColor).withOpacity(0.5),
                                  22.0),
                          Utils.sizeBoxesHeight(25.0),
                          Utils
                              .textFieldBlackWithBackgroundAndPrefixIconNonEditable(
                                  'Email',
                                  emailController,
                                  50.0,
                                  FontAwesomeIcons.solidEnvelope,
                                  Color(Utils.primaryColor).withOpacity(0.5),
                                  20.0),
                          Utils.sizeBoxesHeight(50.0),
                          Container(
                            margin: EdgeInsets.only(left: 25.0, right: 25.0),
                            width: Utils.getWidth(context),
                            child: RaisedButton(
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              onPressed: () {
                                var jsonPass = {
                                  'name':
                                      fullNameController.text.toString().trim(),
                                  // 'mobile_number': phoneNumberController.text,
                                  // 'gender': 'male',
                                  // 'address': 'male',
                                };
                                updateProfile(
                                    ApiSheet.getUrl + ApiSheet.updateProfile,
                                    jsonPass,
                                    context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              color: Color(Utils.primaryColor),
                              child: Utils.textWhite('Save', 16.0),
                            ),
                          ),
                          Utils.sizeBoxesHeight(25.0),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateProfile(
      String api, Map<String, dynamic> jsonPass, BuildContext context) async {
    final response = await ResponseClass.callPostApi(jsonPass, api, context);
    print(response.body);
    ResponseData res = ResponseData.fromJson(json.decode(response.body));

    if (response.statusCode == 200) {
      if (res.data.status.toLowerCase().contains('successfully')) {
        user.currentLoginUser.name = fullNameController.text.toString().trim();

        SharedPreference.addStringToSF(
            SharedPreference.loginData, json.encode(user));

        ToastUtils.showCustomToast(context, res.data.status, 'success');
        Navigator.pop(context);
      } else {
        ToastUtils.showCustomToast(context, res.data.status, 'warning');
      }
    } else {
      Utils.errorCode(response.body, context);
    }
  }
}
