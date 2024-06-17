class OrderDelivered {
  List<OrderDeliveredData> data;

  OrderDelivered({this.data});

  OrderDelivered.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<OrderDeliveredData>();
      json['data'].forEach((v) {
        data.add(new OrderDeliveredData.fromJson(v));
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

class OrderDeliveredData {
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

  OrderDeliveredData(
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
        this.updatedAt});

  OrderDeliveredData.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
