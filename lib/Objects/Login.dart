import 'CurrentLoginUser.dart';

class Login {
  String accessToken;
  String message;
  CurrentLoginUser currentLoginUser;

  Login({this.accessToken, this.message, this.currentLoginUser});

  Login.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    message = json['message'];
    currentLoginUser = json['currentLoginUser'] != null
        ? new CurrentLoginUser.fromJson(json['currentLoginUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['message'] = this.message;
    if (this.currentLoginUser != null) {
      data['currentLoginUser'] = this.currentLoginUser.toJson();
    }
    return data;
  }
}