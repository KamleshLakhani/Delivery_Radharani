class ResponseData {
  ResponseData_Data data;

  ResponseData({this.data});

  ResponseData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ResponseData_Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class ResponseData_Data {
  String status;
  String message;

  ResponseData_Data({this.status,this.message});

  ResponseData_Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
