class LoginViaOtp {
  Data data;

  LoginViaOtp({this.data});

  LoginViaOtp.fromJson(Map<String, dynamic> json) {
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
  var message;
  var passCode;

  Data({this.message, this.passCode});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    passCode = json['pass_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['pass_code'] = this.passCode;
    return data;
  }
}