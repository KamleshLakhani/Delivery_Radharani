class Area {
  var id;
  var name;
  var deliveryCharge;

  Area({this.id, this.name, this.deliveryCharge});

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    deliveryCharge = json['delivery_charge'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['delivery_charge'] = this.deliveryCharge;
    return data;
  }
}