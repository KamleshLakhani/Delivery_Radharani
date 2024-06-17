class AreaList {
  List<AreaListData> data;

  AreaList({this.data});

  AreaList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<AreaListData>();
      json['data'].forEach((v) {
        data.add(new AreaListData.fromJson(v));
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

class AreaListData {
  int id;
  String name;
  int pincode;
  String minimumOrder;
  String deliveryCharge;
  String expectedDeliveryDate;
  List<TimeSlot> timeSlot;

  AreaListData(
      {this.id,
      this.name,
      this.pincode,
      this.minimumOrder,
      this.deliveryCharge,
      this.expectedDeliveryDate,
      this.timeSlot});

  AreaListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pincode = json['pincode'];
    minimumOrder = json['minimum_order'];
    deliveryCharge = json['delivery_charge'];
    expectedDeliveryDate = json['expected_delivery_date'];
    if (json['time_slot'] != null) {
      timeSlot = new List<TimeSlot>();
      json['time_slot'].forEach((v) {
        timeSlot.add(new TimeSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pincode'] = this.pincode;
    data['minimum_order'] = this.minimumOrder;
    data['delivery_charge'] = this.deliveryCharge;
    data['expected_delivery_date'] = this.expectedDeliveryDate;
    if (this.timeSlot != null) {
      data['time_slot'] = this.timeSlot.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeSlot {
  String date;
  String time;

  TimeSlot({this.date, this.time});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}
