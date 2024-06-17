import 'CurrentLoginUser.dart';

class Profile {
  ProfileData data;

  Profile({this.data});

  Profile.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class ProfileData {
  CurrentLoginUser deliveryBoy;

  ProfileData({this.deliveryBoy});

  ProfileData.fromJson(Map<String, dynamic> json) {
    deliveryBoy = json['deliveryBoy'] != null
        ? new CurrentLoginUser.fromJson(json['deliveryBoy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deliveryBoy != null) {
      data['deliveryBoy'] = this.deliveryBoy.toJson();
    }
    return data;
  }
}
