class SignatureUpload {
  String message;
  String fileName;

  SignatureUpload({this.message, this.fileName});

  SignatureUpload.fromJson(Map<String, dynamic> json) {
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
