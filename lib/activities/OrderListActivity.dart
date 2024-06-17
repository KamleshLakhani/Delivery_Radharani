import 'dart:convert';

import 'package:delivery_radharani/APiDirectory/ApiSheet.dart';
import 'package:delivery_radharani/APiDirectory/ResponseClass.dart';
import 'package:delivery_radharani/Objects/AreaList.dart';
import 'package:delivery_radharani/Objects/Login.dart';
import 'package:delivery_radharani/Objects/OrderByArea.dart';
import 'package:delivery_radharani/Objects/OrderDelivered.dart';
import 'package:delivery_radharani/Utils/Constant.dart';
import 'package:delivery_radharani/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'OrderDetailsActivity.dart';

class OrderListActivity extends StatefulWidget {
  final String title;

  OrderListActivity({Key key, @required this.title}) : super(key: key);

  @override
  _OrderListActivityState createState() => _OrderListActivityState();
}

//status: pending, delivered
//date: date picker
//product: write name
//area: pick

class _OrderListActivityState extends State<OrderListActivity> {
  var filterType = 1, selectionDay = 0;
  var searchController = new TextEditingController();
  String areaName = 'KATARGAM';
  Future<OrderByArea> orderList;
  Future<OrderDelivered> orderListDelivered;
  List<OrderDeliveredData> productData = new List();
  List<OrderDeliveredData> productDataCopy = new List();
  Future<AreaList> areaList;
  List<AreaListData> area = new List();
  Login user = new Login();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    user = await Utils.getUserData();

    print(user);
    if (widget.title != 'DELIVERIES') {
      orderList = fetchData();
    } else {
      orderListDelivered = fetchDataDelivered();
      // getAreaFromCityName();
    }
  }

  void getAreaFromCityName() async {
    final response = await ResponseClass.callGetApi(
        ApiSheet.preBaseUrl + 'api/' + ApiSheet.getAreaFromCityName + '/surat',
        context);
    print(
        ApiSheet.preBaseUrl + 'api/' + ApiSheet.getAreaFromCityName + '/surat');
    print(response.body);

    if (response.statusCode == 200) {
      AreaList areaListFromCity = AreaList.fromJson(json.decode(response.body));
      if (areaListFromCity.data.length != 0) {
        area = areaListFromCity.data;
      }
    } else {
      Utils.errorCode(response.body, context);
    }
  }

  Future<OrderByArea> fetchData() async {
    print(ApiSheet.getUrl + ApiSheet.searchLocation + widget.title);
    final response = await ResponseClass.callGetApi(
        ApiSheet.getUrl + ApiSheet.searchLocation + widget.title, context);
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {});
      return OrderByArea.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<OrderDelivered> fetchDataDelivered() async {
    print(user.currentLoginUser.id);
    print(ApiSheet.getUrl +
        ApiSheet.getDeliveries +
        user.currentLoginUser.id.toString());
    final response = await ResponseClass.callGetApi(
        ApiSheet.getUrl +
            ApiSheet.getDeliveries +
            user.currentLoginUser.id.toString(),
        context);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {});
      return OrderDelivered.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Utils.header(widget.title, context),
                Visibility(
                  visible: false /*(widget.title == 'DELIVERIES')*/,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => showFilterBottom(),
                      child: Container(
                          margin: EdgeInsets.only(right: 15.0),
                          padding: EdgeInsets.all(25.0),
                          child: Utils.fontAwesomeIconGreen(
                              FontAwesomeIcons.slidersH, 26.0)),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: (widget.title != 'DELIVERIES')
                  ? RefreshIndicator(
                      onRefresh: _refreshList,
                      key: _refreshIndicatorKey,
                      child: FutureBuilder<OrderByArea>(
                        future: orderList,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<OrderByAreaData> productData =
                                snapshot.data.data;
                            if (productData.length == 0) {
                              return Center(
                                  child: Utils.getImageNetwork(
                                      150,
                                      150,
                                      ApiSheet.preBaseUrl +
                                          'public_html/front_view/img/no-result.png',
                                      0.0));
                            } else {
                              return ListView.builder(
                                itemCount: productData.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderDetailsActivity(
                                                          orderId:
                                                              productData[index]
                                                                  .id)))
                                          .then((value) {
                                        if (widget.title != 'DELIVERIES') {
                                          if (Constant.delivered) {
                                            orderList = fetchData();
                                          }
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 10.0,
                                          bottom: 10.0,
                                          left: 10.0,
                                          right: 10.0),
                                      margin: EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          top: 7.0,
                                          bottom: 7.0),
                                      decoration:
                                          Utils.whiteBoxDecoration(15.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          (productData[index].image != null)
                                              ? Utils.getImageNetwork(
                                                  125.0,
                                                  125.0,
                                                  ApiSheet.preBaseUrl +
                                                      productData[index].image,
                                                  150.0)
                                              : Utils.fontAwesomeIcon(
                                                  FontAwesomeIcons
                                                      .solidUserCircle,
                                                  100.0,
                                                  Color(Utils.primaryColor)),
                                          Utils.sizeBoxesWidth(15.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Utils.textBoldMultiLine(
                                                    productData[index].name,
                                                    18.0,
                                                    Color(Utils.primaryColor),
                                                    1),
                                                Utils.sizeBoxesHeight(5.0),
                                                Utils.textColor(
                                                    '+91 ${productData[index].number}',
                                                    16.0,
                                                    Color(Utils.blackAccent)),
                                                Utils.sizeBoxesHeight(5.0),
                                                Utils.textColor(
                                                    'Rs ${productData[index].total}',
                                                    14.0,
                                                    Color(Utils.gray)),
                                                Utils.sizeBoxesHeight(5.0),
                                                Utils.textColor(
                                                    '${productData[index].totalWeight} kg',
                                                    14.0,
                                                    Color(Utils.gray)),
                                              ],
                                            ),
                                          ),
                                          Utils.sizeBoxesWidth(5.0),
                                          Utils.textColor(
                                              productData[index].location,
                                              16.0,
                                              Color(Utils.lightPrimaryColor)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: Utils.borderRadius(35.0),
                            boxShadow: [Utils.boxShadow()],
                            color: Color(Utils.primaryColor),
                            border:
                                Utils.border(Color(Utils.primaryColor), 3.0),
                          ),
                          height: 50.0,
                          width: Utils.getWidth(context),
                          margin: EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectionDay = 0;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: Utils.borderRadius(35.0),
                                      color: (selectionDay == 0)
                                          ? Color(Utils.lightGreen)
                                          : Color(Utils.primaryColor),
                                    ),
                                    child: Center(
                                      child: Utils.textColor(
                                          'Pending',
                                          16.0,
                                          (selectionDay == 0)
                                              ? Color(Utils.black)
                                              : Color(Utils.white)),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectionDay = 1;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: Utils.borderRadius(35.0),
                                      color: (selectionDay == 1)
                                          ? Color(Utils.lightGreen)
                                          : Color(Utils.primaryColor),
                                    ),
                                    child: Center(
                                      child: Utils.textColor(
                                          'Delivered',
                                          16.0,
                                          (selectionDay == 1)
                                              ? Color(Utils.black)
                                              : Color(Utils.white)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _refresh,
                            key: _refreshIndicatorKey,
                            child: FutureBuilder<OrderDelivered>(
                              future: orderListDelivered,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (productDataCopy.length == 0) {
                                    productDataCopy = snapshot.data.data;
                                  }
                                  productData.clear();
                                  if (selectionDay == 0) {
                                    for (int i = 0;
                                        i < snapshot.data.data.length;
                                        i++) {
                                      if (snapshot.data.data[i].orderStatus
                                              .toLowerCase() !=
                                          '5') {
                                        productData.add(snapshot.data.data[i]);
                                      }
                                    }
                                  } else if (selectionDay == 1) {
                                    for (int i = 0;
                                        i < snapshot.data.data.length;
                                        i++) {
                                      if (snapshot.data.data[i].orderStatus
                                              .toLowerCase() ==
                                          '5') {
                                        productData.add(snapshot.data.data[i]);
                                      }
                                    }
                                  }

                                  if (productData.length == 0) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Utils.getImageNetwork(
                                            150,
                                            150,
                                            ApiSheet.preBaseUrl +
                                                'public_html/front_view/img/no-result.png',
                                            0.0),
                                        Utils.sizeBoxesHeight(10.0),
                                        Utils.textColor('Order not available',
                                            16.0, Color(Utils.gray)),
                                      ],
                                    );
                                  } else {
                                    return ListView.builder(
                                      itemCount: productData.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            print('#%%%#%%%#%%product id${productData[index].id}');
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetailsActivity(
                                                            orderId:
                                                                productData[
                                                                        index]
                                                                      .id))).then(
                                                  (value) {
                                                if (Constant.delivered == true) {
                                                  selectionDay = 1;
                                                  Constant.delivered = false;
                                                  orderListDelivered =
                                                      fetchDataDelivered();
                                                }
                                              });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                                left: 10.0,
                                                right: 10.0),
                                            margin: EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 7.0,
                                                bottom: 7.0),
                                            decoration:
                                                Utils.whiteBoxDecoration(15.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Utils.sizeBoxesWidth(10.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Utils.textBoldMultiLine(
                                                          productData[index]
                                                              .orderKey,
                                                          18.0,
                                                          Color(Utils
                                                              .primaryColor),
                                                          1),
                                                      Utils.sizeBoxesHeight(
                                                          5.0),
                                                      Utils.poundSignWithPrice(
                                                          productData[index]
                                                              .totalOrderPrice,
                                                          Color(Utils
                                                              .primaryColor)),
                                                      Utils.sizeBoxesHeight(
                                                          5.0),
                                                      Utils.textColor(
                                                          'Payment type: ${(productData[index].paymentMethod == 'Ofline') ? 'cod' : productData[index].paymentMethod} (${productData[index].paymentStatus})',
                                                          14.0,
                                                          Color(Utils.gray)),
                                                      Utils.sizeBoxesHeight(
                                                          5.0),
                                                      // Utils.textColor(
                                                      //     Utils.changeDateFormatString(
                                                      //         'yyyy-MM-dd',
                                                      //         'dd MMM yyyy',
                                                      //         productData[index]
                                                      //             .expectedDeliveryDate),
                                                      //     14.0,
                                                      //     Color(Utils.gray)),
                                                    ],
                                                  ),
                                                ),
                                                Utils.sizeBoxesWidth(5.0),
                                                Utils.textColor(
                                                    (productData[index]
                                                                .orderLocation !=
                                                            null)
                                                        ? productData[index]
                                                            .orderLocation
                                                        : '',
                                                    16.0,
                                                    Color(Utils
                                                        .primaryColor)),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  showFilterBottom() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              padding: EdgeInsets.only(
                  top: 24.0,
                  left: 24.0,
                  right: 24.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Utils.textBoldBlack('Advance filter', 18.0),
                  Container(
                    margin: EdgeInsets.only(top: 25.0, bottom: 25.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Utils.sizeBoxesWidth(10.0),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              filterType = 1;
                            });
                          },
                          child: Container(
                            decoration: Utils.whiteBoxDecorationNoShadow(
                                10.0,
                                (filterType == 1)
                                    ? Color(Utils.lightPrimaryColor)
                                    : Colors.black26),
                            child: Utils.textWhite('Date', 16.0),
                            padding: EdgeInsets.only(
                                left: 25.0,
                                top: 10.0,
                                bottom: 10.0,
                                right: 25.0),
                          ),
                        ),
                        Utils.sizeBoxesWidth(10.0),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              filterType = 2;
                            });
                          },
                          child: Container(
                            decoration: Utils.whiteBoxDecorationNoShadow(
                                10.0,
                                (filterType == 2)
                                    ? Color(Utils.lightPrimaryColor)
                                    : Colors.black26),
                            child: Utils.textWhite('Area', 16.0),
                            padding: EdgeInsets.only(
                                left: 25.0,
                                top: 10.0,
                                bottom: 10.0,
                                right: 25.0),
                          ),
                        ),
                        Utils.sizeBoxesWidth(10.0),
                      ],
                    ),
                  ),
                  getFilteredWidget(context),
                ],
              ),
            );
          },
        );
      },
    );
  }

  getFilteredWidget(BuildContext context) {
    if (filterType == 1) {
      return Container(
        margin: EdgeInsets.only(bottom: 25.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child:
                    Utils.textFieldBlackWithBackgroundAndPrefixIconNonEditable(
                        'Select date',
                        searchController,
                        50.0,
                        FontAwesomeIcons.calendarAlt,
                        Color(Utils.primaryColor),
                        24.0),
              ),
            ),
            Utils.sizeBoxesWidth(10.0),
            GestureDetector(
              onTap: () {
                List<OrderDeliveredData> tempList = new List();
                productData = productDataCopy;
                for (int i = 0; i < productData.length; i++) {
                  if (searchController.text.toString().trim() ==
                      Utils.changeDateFormatString('yyyy-MM-dd hh:MM:ss',
                          'dd MMM yyyy', productData[i].createdAt)) {
                    tempList.add(productData[i]);
                  }
                }

                productData = tempList;
                searchController.text = '';

                setState(() {});
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(Utils.primaryColor),
                  boxShadow: [Utils.boxShadow()],
                  borderRadius: Utils.borderRadius(35.0),
                ),
                padding: EdgeInsets.all(15.0),
                child: Utils.fontAwesomeIcon(
                    FontAwesomeIcons.search, 20.0, Color(Utils.white)),
              ),
            )
          ],
        ),
      );
    } else if (filterType == 2) {
      return Container(
        margin: EdgeInsets.only(bottom: 25.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: Utils.whiteBoxDecorationNoShadow(
                    50.0, Color(Utils.lightGreen)),
                padding: EdgeInsets.only(
                    left: 25.0, right: 15.0, top: 3.0, bottom: 3.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      hint: Utils.textColor('Select', 16.0, Colors.grey),
                      isExpanded: true,
                      value: getSelectedArea(areaName),
                      items: area.map((AreaListData areaItem) {
                        return DropdownMenuItem<String>(
                          child: Utils.textBlack(
                              areaItem.name.toUpperCase(), 15.0),
                          value: areaItem.name.toUpperCase(),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          getSelectedArea(value);
                          print(value);

                          List<OrderDeliveredData> tempList = new List();
                          productData = productDataCopy;
                          for (int i = 0; i < productData.length; i++) {
                            if (productData[i].orderLocation != null) {
                              if (areaName ==
                                  productData[i].orderLocation.toUpperCase()) {
                                tempList.add(productData[i]);
                              }
                            }
                          }

                          productData = tempList;
                          setState(() {
                            print('List ${productData.length}');
                          });
                          Navigator.pop(context);
                        });
                      }),
                ),
              ),
            ),
            Utils.sizeBoxesWidth(10.0),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  String getSelectedArea(String subLocality) {
    for (int i = 0; i < area.length; i++) {
      try {
        if (area[i].name.toUpperCase() == subLocality.toUpperCase()) {
          areaName = area[i].name.toUpperCase();
          print('AREA GET ID  ##  ' + area[i].name.toUpperCase());
          return area[i].name.toUpperCase();
        }
      } catch (e) {
        print(e.toString());
      }
    }

    return 'KATARGAM';
  }

  _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        searchController.text = Utils.changeDateFormat('dd MMM yyyy', picked);
        print(searchController.text);
      });
  }

  Future<OrderDelivered> _refresh() {
    orderListDelivered = fetchDataDelivered();
    return orderListDelivered;
  }

  Future<OrderByArea> _refreshList() {
    orderList = fetchData();
    return orderList;
  }
}
