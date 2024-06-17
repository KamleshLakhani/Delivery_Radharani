class OrderDetail {
  List<OrderDetailData> data;

  OrderDetail({this.data});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<OrderDetailData>();
      json['data'].forEach((v) {
        data.add(new OrderDetailData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetailData {
  int id;
  int customerId;
  String orderKey;
  int assignOrderTo;
  int assignDeliveryTo;
  String orderDate;
  String orderLocation;
  int customerAddressId;
  String expectedDeliveryDate;
  String deliveryTimeSlot;
  String walletAmount;
  String totalOrderPrice;
  int deliveryCharge;
  String totalWithDeliveryCharge;
  int couponId;
  String couponDiscount;
  int gstType;
  String paymentMethod;
  String paymentStatus;
  String orderStatus;
  String createdAt;
  String updatedAt;
  Customer customer;
  List<OrderDetails> orderDetails;
  OrderAddress orderAddress;

  OrderDetailData(
      {this.id,
        this.customerId,
        this.orderKey,
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
        this.paymentStatus,
        this.orderStatus,
        this.createdAt,
        this.updatedAt,
        this.customer,
        this.orderDetails,
        this.orderAddress});

  OrderDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    orderKey = json['order_key'];
    assignOrderTo = json['assign_order_to'];
    assignDeliveryTo = json['assign_delivery_to'];
    orderDate = json['order_date'];
    orderLocation = json['order_location'];
    customerAddressId = json['customer_address_id'];
    expectedDeliveryDate = json['expected_delivery_date'];
    deliveryTimeSlot = json['delivery_time_slot'];
    walletAmount = json['wallet_amount'];
    totalOrderPrice = json['total_order_price'];
    deliveryCharge = json['delivery_charge'];
    totalWithDeliveryCharge = json['total_with_delivery_charge'];
    couponId = json['coupon_id'];
    couponDiscount = json['coupon_discount'];
    gstType = json['gst_type'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    if (json['order_details'] != null) {
      orderDetails = new List<OrderDetails>();
      json['order_details'].forEach((v) {
        orderDetails.add(new OrderDetails.fromJson(v));
      });
    }
    orderAddress = json['order_address'] != null
        ? new OrderAddress.fromJson(json['order_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['order_key'] = this.orderKey;
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
    data['payment_status'] = this.paymentStatus;
    data['order_status'] = this.orderStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
    if (this.orderAddress != null) {
      data['order_address'] = this.orderAddress.toJson();
    }
    return data;
  }
}

class Customer {
  int id;
  String name;
  String email;
  String mobileNumber;
  Null referenceId;
  String referCode;
  String passCode;
  Null loginCode;
  int areaId;
  String address;
  int pinCode;
  String balance;
  String profilePic;
  String deviceId;
  int isGuestMember;
  String notificationToken;
  String createdAt;
  String updatedAt;

  Customer(
      {this.id,
        this.name,
        this.email,
        this.mobileNumber,
        this.referenceId,
        this.referCode,
        this.passCode,
        this.loginCode,
        this.areaId,
        this.address,
        this.pinCode,
        this.balance,
        this.profilePic,
        this.deviceId,
        this.isGuestMember,
        this.notificationToken,
        this.createdAt,
        this.updatedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    referenceId = json['reference_id'];
    referCode = json['refer_code'];
    passCode = json['pass_code'];
    loginCode = json['login_code'];
    areaId = json['area_id'];
    address = json['address'];
    pinCode = json['pin_code'];
    balance = json['balance'];
    profilePic = json['profile_pic'];
    deviceId = json['device_id'];
    isGuestMember = json['is_guest_member'];
    notificationToken = json['notification_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    data['reference_id'] = this.referenceId;
    data['refer_code'] = this.referCode;
    data['pass_code'] = this.passCode;
    data['login_code'] = this.loginCode;
    data['area_id'] = this.areaId;
    data['address'] = this.address;
    data['pin_code'] = this.pinCode;
    data['balance'] = this.balance;
    data['profile_pic'] = this.profilePic;
    data['device_id'] = this.deviceId;
    data['is_guest_member'] = this.isGuestMember;
    data['notification_token'] = this.notificationToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class OrderDetails {
  int id;
  int orderId;
  int productId;
  String productName;
  int quantity;
  Null weight;
  String realPrice;
  String price;
  String discount;
  Null gst;
  int status;
  String createdAt;
  String updatedAt;
  Meals meals;

  OrderDetails(
      {this.id,
        this.orderId,
        this.productId,
        this.productName,
        this.quantity,
        this.weight,
        this.realPrice,
        this.price,
        this.discount,
        this.gst,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.meals});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    quantity = json['quantity'];
    weight = json['weight'];
    realPrice = json['real_price'];
    price = json['price'];
    discount = json['discount'];
    gst = json['gst'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    meals = json['meals'] != null ? new Meals.fromJson(json['meals']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['quantity'] = this.quantity;
    data['weight'] = this.weight;
    data['real_price'] = this.realPrice;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['gst'] = this.gst;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.meals != null) {
      data['meals'] = this.meals.toJson();
    }
    return data;
  }
}

class Meals {
  int id;
  String availability;
  String week;
  String days;
  String taxes;
  int isMaintain;
  MealsData meals;
  String items;
  int amount;
  String ingredients;
  String minimumOrder;
  String discount;
  int activation;
  String createdAt;
  String updatedAt;

  Meals(
      {this.id,
        this.availability,
        this.week,
        this.days,
        this.taxes,
        this.isMaintain,
        this.meals,
        this.items,
        this.amount,
        this.ingredients,
        this.minimumOrder,
        this.discount,
        this.activation,
        this.createdAt,
        this.updatedAt});

  Meals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    availability = json['availability'];
    week = json['week'];
    days = json['days'];
    taxes = json['taxes'];
    isMaintain = json['is_maintain'];
    meals = json['meals'] != null ? new MealsData.fromJson(json['meals']) : null;
    items = json['items'];
    amount = json['amount'];
    ingredients = json['ingredients'];
    minimumOrder = json['minimum_order'];
    discount = json['discount'];
    activation = json['activation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['availability'] = this.availability;
    data['week'] = this.week;
    data['days'] = this.days;
    data['taxes'] = this.taxes;
    data['is_maintain'] = this.isMaintain;
    if (this.meals != null) {
      data['meals'] = this.meals.toJson();
    }
    data['items'] = this.items;
    data['amount'] = this.amount;
    data['ingredients'] = this.ingredients;
    data['minimum_order'] = this.minimumOrder;
    data['discount'] = this.discount;
    data['activation'] = this.activation;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class MealsData {
  int id;
  String name;
  String description;
  String image;
  int activation;
  String createdAt;
  String updatedAt;

  MealsData(
      {this.id,
        this.name,
        this.description,
        this.image,
        this.activation,
        this.createdAt,
        this.updatedAt});

  MealsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    activation = json['activation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['activation'] = this.activation;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class OrderAddress {
  int id;
  int customerId;
  String apartment;
  String addressLine1;
  String addressLine2;
  String landmark;
  int areaId;
  String areaName;
  int cityId;
  int stateId;
  int countryId;
  String pincode;
  String lat;
  String long;
  int isDefault;
  int status;
  String createdAt;
  String updatedAt;

  OrderAddress(
      {this.id,
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
        this.isDefault,
        this.status,
        this.createdAt,
        this.updatedAt});

  OrderAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    apartment = json['apartment'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    landmark = json['landmark'];
    areaId = json['area_id'];
    areaName = json['area_name'];
    cityId = json['city_id'];
    stateId = json['state_id'];
    countryId = json['country_id'];
    pincode = json['pincode'];
    lat = json['lat'];
    long = json['long'];
    isDefault = json['is_default'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    data['is_default'] = this.isDefault;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
