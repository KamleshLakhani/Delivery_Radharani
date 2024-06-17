class OrderByArea {
  List<OrderByAreaData> data;

  OrderByArea({this.data});

  OrderByArea.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<OrderByAreaData>();
      json['data'].forEach((v) {
        data.add(new OrderByAreaData.fromJson(v));
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

class OrderByAreaData {
  int id;
  int customerId;
  String name;
  String image;
  String number;
  String total;
  String paymentType;
  String location;
  String orderKey;
  var totalWeight;

  OrderByAreaData(
      {this.id,
        this.customerId,
        this.name,
        this.image,
        this.number,
        this.total,
        this.paymentType,
        this.location,
        this.orderKey,
        this.totalWeight});

  OrderByAreaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    name = json['name'];
    image = json['image'];
    number = json['number'];
    total = json['total'];
    paymentType = json['payment_type'];
    location = json['location'];
    orderKey = json['order_key'];
    totalWeight = json['total_weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['number'] = this.number;
    data['total'] = this.total;
    data['payment_type'] = this.paymentType;
    data['location'] = this.location;
    data['order_key'] = this.orderKey;
    data['totalWeight'] = this.totalWeight;
    return data;
  }
}
