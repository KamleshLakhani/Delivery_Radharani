class CustomTimeSlot {
  Data data;

  CustomTimeSlot({this.data});

  CustomTimeSlot.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Date> date;
  List<TimeSlot> timeSlot;

  Data({this.date, this.timeSlot});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['date'] != null) {
      date = new List<Date>();
      json['date'].forEach((v) {
        date.add(new Date.fromJson(v));
      });
    }
    if (json['time_slot'] != null) {
      timeSlot = new List<TimeSlot>();
      json['time_slot'].forEach((v) {
        timeSlot.add(new TimeSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.date != null) {
      data['date'] = this.date.map((v) => v.toJson()).toList();
    }
    if (this.timeSlot != null) {
      data['time_slot'] = this.timeSlot.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Date {
  String orderDate;

  Date({this.orderDate});

  Date.fromJson(Map<String, dynamic> json) {
    orderDate = json['order_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_date'] = this.orderDate;
    return data;
  }
}

class TimeSlot {
  String deliveryTimeSlot;

  TimeSlot({this.deliveryTimeSlot});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    deliveryTimeSlot = json['time'];
    // deliveryTimeSlot = json['delivery_time_slot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.deliveryTimeSlot;
    // data['delivery_time_slot'] = this.deliveryTimeSlot;
    return data;
  }
}
