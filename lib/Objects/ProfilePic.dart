class ProfilePic {
  String message;
  String fileName;

  ProfilePic({this.message, this.fileName});

  ProfilePic.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    fileName = json['fileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['fileName'] = this.fileName;
    return data;
  }
}
