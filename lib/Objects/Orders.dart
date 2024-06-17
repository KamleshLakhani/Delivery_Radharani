class Orders {
  OrdersData data;

  Orders({this.data});

  Orders.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new OrdersData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class OrdersData {
  List<OrderData> orderData;

  OrdersData({this.orderData});

  OrdersData.fromJson(Map<String, dynamic> json) {
    if (json['orderData'] != null) {
      orderData = new List<OrderData>();
      json['orderData'].forEach((v) {
        orderData.add(new OrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderData != null) {
      data['orderData'] = this.orderData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderData {
  int id;
  int customerId;
  String orderKey;
  String barcodeUrl;
  String qrUrl;
  int assignOrderTo;
  int assignDeliveryTo;
  String orderDate;
  String orderLocation;
  int customerAddressId;
  String expectedDeliveryDate;
  String deliveryTimeSlot;
  String walletAmount;
  String totalOrderPrice;
  String deliveryCharge;
  String totalWithDeliveryCharge;
  int couponId;
  String couponDiscount;
  int gstType;
  String paymentMethod;
  String razorpayPaymentId;
  String razorpayPaymentLinkId;
  String razorpayPaymentLink;
  String paymentStatus;
  String orderStatus;
  String createdAt;
  String updatedAt;
  OrderAddress orderAddress;

  OrderData(
      {this.id,
        this.customerId,
        this.orderKey,
        this.barcodeUrl,
        this.qrUrl,
        this.assignOrderTo,
        this.assignDeliveryTo,
        this.orderDate,
        this.orderLocation,
        this.customerAddressId,
        this.expectedDeliveryDate,
        this.deliveryTimeSlot,
        this.walletAmount,
        this.totalOrderPrice,
        this.deliveryCharge,
        this.totalWithDeliveryCharge,
        this.couponId,
        this.couponDiscount,
        this.gstType,
        this.paymentMethod,
        this.razorpayPaymentId,
        this.razorpayPaymentLinkId,
        this.razorpayPaymentLink,
        this.paymentStatus,
        this.orderStatus,
        this.createdAt,
        this.updatedAt,
        this.orderAddress});

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    orderKey = json['order_key'];
    barcodeUrl = json['barcode_url'];
    qrUrl = json['qr_url'];
    assignOrderTo = json['assign_order_to'];
    assignDeliveryTo = json['assign_delivery_to'];
    orderDate = json['order_date'];
    orderLocation = json['order_location'];
    customerAddressId = json['customer_address_id'];
    expectedDeliveryDate = json['expected_delivery_date'];
    deliveryTimeSlot = json['delivery_time_slot'];
    walletAmount = json['wallet_amount'];
    totalOrderPrice = json['total_order_price'];
    deliveryCharge = json['delivery_charge'].toString();
    totalWithDeliveryCharge = json['total_with_delivery_charge'];
    couponId = json['coupon_id'];
    couponDiscount = json['coupon_discount'];
    gstType = json['gst_type'];
    paymentMethod = json['payment_method'];
    razorpayPaymentId = json['razorpay_payment_id'];
    razorpayPaymentLinkId = json['razorpay_payment_link_id'];
    razorpayPaymentLink = json['razorpay_payment_link'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderAddress = json['order_address'] != null
        ? new OrderAddress.fromJson(json['order_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['order_key'] = this.orderKey;
    data['barcode_url'] = this.barcodeUrl;
    data['qr_url'] = this.qrUrl;
    data['assign_order_to'] = this.assignOrderTo;
    data['assign_delivery_to'] = this.assignDeliveryTo;
    data['order_date'] = this.orderDate;
    data['order_location'] = this.orderLocation;
    data['customer_address_id'] = this.customerAddressId;
    data['expected_delivery_date'] = this.expectedDeliveryDate;
    data['delivery_time_slot'] = this.deliveryTimeSlot;
    data['wallet_amount'] = this.walletAmount;
    data['total_order_price'] = this.totalOrderPrice;
    data['delivery_charge'] = this.deliveryCharge;
    data['total_with_delivery_charge'] = this.totalWithDeliveryCharge;
    data['coupon_id'] = this.couponId;
    data['coupon_discount'] = this.couponDiscount;
    data['gst_type'] = this.gstType;
    data['payment_method'] = this.paymentMethod;
    data['razorpay_payment_id'] = this.razorpayPaymentId;
    data['razorpay_payment_link_id'] = this.razorpayPaymentLinkId;
    data['razorpay_payment_link'] = this.razorpayPaymentLink;
    data['payment_status'] = this.paymentStatus;
    data['order_status'] = this.orderStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.orderAddress != null) {
      data['order_address'] = this.orderAddress.toJson();
    }
    return data;
  }
}

class OrderAddress {
  String id;
  String orderId;
  String customerId;
  String apartment;
  String addressLine1;
  String addressLine2;
  String landmark;
  String areaId;
  String areaName;
  String cityId;
  String stateId;
  String countryId;
  String pincode;
  String lat;
  String long;
  String status;
  String createdAt;
  String updatedAt;

  OrderAddress(
      {this.id,
        this.orderId,
        this.customerId,
        this.apartment,
        this.addressLine1,
        this.addressLine2,
        this.landmark,
        this.areaId,
        this.areaName,
        this.cityId,
        this.stateId,
        this.countryId,
        this.pincode,
        this.lat,
        this.long,
        this.status,
        this.createdAt,
        this.updatedAt});

  OrderAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    orderId = json['order_id'].toString();
    customerId = json['customer_id'].toString();
    apartment = json['apartment'].toString();
    addressLine1 = json['address_line_1'].toString();
    addressLine2 = json['address_line_2'].toString();
    landmark = json['landmark'].toString();
    areaId = json['area_id'].toString();
    areaName = json['area_name'].toString();
    cityId = json['city_id'].toString();
    stateId = json['state_id'].toString();
    countryId = json['country_id'].toString();
    pincode = json['pincode'].toString();
    lat = json['lat'].toString();
    long = json['long'].toString();
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['customer_id'] = this.customerId;
    data['apartment'] = this.apartment;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['landmark'] = this.landmark;
    data['area_id'] = this.areaId;
    data['area_name'] = this.areaName;
    data['city_id'] = this.cityId;
    data['state_id'] = this.stateId;
    data['country_id'] = this.countryId;
    data['pincode'] = this.pincode;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
