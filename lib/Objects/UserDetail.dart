import 'Area.dart';

class UserDetail {
  var id;
  var name;
  var email;
  var mobileNumber;
  Area area;
  var address;
  var pinCode;
  var accountCreatedAt;
  var totalCartProducts;
  var referCode;
  var balance;

  UserDetail(
      {this.id,
        this.name,
        this.email,
        this.mobileNumber,
        this.area,
        this.address,
        this.pinCode,
        this.accountCreatedAt,
        this.totalCartProducts,
        this.referCode,
        this.balance});

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    area = json['area'] != null ? new Area.fromJson(json['area']) : null;
    address = json['address'];
    pinCode = json['pin_code'];
    accountCreatedAt = json['account_created_at'];
    totalCartProducts = json['total_cart_products'];
    referCode = json['refer_code'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    if (this.area != null) {
      data['area'] = this.area.toJson();
    }
    data['address'] = this.address;
    data['pin_code'] = this.pinCode;
    data['account_created_at'] = this.accountCreatedAt;
    data['total_cart_products'] = this.totalCartProducts;
    data['refer_code'] = this.referCode;
    data['balance'] = this.balance;
    return data;
  }
}
