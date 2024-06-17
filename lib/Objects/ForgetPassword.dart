class ForgetPassword {
  ForgetPasswordData data;

  ForgetPassword({this.data});

  ForgetPassword.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ForgetPasswordData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class ForgetPasswordData {
  String message;
  int id;

  ForgetPasswordData({this.message, this.id});

  ForgetPasswordData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['id'] = this.id;
    return data;
  }
}
