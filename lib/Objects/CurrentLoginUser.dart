class CurrentLoginUser {
  int id;
  String name;
  String email;
  String emailVerifiedAt;
  String address;
  String gender;
  String mobileNumber;
  String joiningDate;
  String licenceNumber;
  String image;
  String userType;
  String createdAt;
  String updatedAt;

  CurrentLoginUser(
      {this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.address,
        this.gender,
        this.mobileNumber,
        this.joiningDate,
        this.licenceNumber,
        this.image,
        this.userType,
        this.createdAt,
        this.updatedAt});

  CurrentLoginUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    address = json['address'];
    gender = json['gender'];
    mobileNumber = json['mobile_number'];
    joiningDate = json['joining_date'];
    licenceNumber = json['licence_number'];
    image = json['image'];
    userType = json['user_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['mobile_number'] = this.mobileNumber;
    data['joining_date'] = this.joiningDate;
    data['licence_number'] = this.licenceNumber;
    data['image'] = this.image;
    data['user_type'] = this.userType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
