class GetProfileModel {
  bool? status;
  String? message;
  Data? data;

  GetProfileModel({this.status, this.message, this.data});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;

  Data({this.user});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? sId;
  String? mobile;
  int? walletBalance;
  bool? isVerified;
  String? deviceId;
  String? deviceType;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? fcmToken;
  String? email;
  String? gender;
  String? dob;
  String? name;
  String? profilePic;
  String? id;

  User(
      {this.sId,
        this.mobile,
        this.walletBalance,
        this.isVerified,
        this.deviceId,
        this.deviceType,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.fcmToken,
        this.email,
        this.gender,
        this.dob,
        this.name,
        this.profilePic,
        this.id});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobile = json['mobile'];
    walletBalance = json['walletBalance'];
    isVerified = json['isVerified'];
    deviceId = json['deviceId'];
    deviceType = json['deviceType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    fcmToken = json['fcmToken'];
    email = json['email'];
    gender = json['gender'];
    dob = json['dob'];
    name = json['name'];
    profilePic = json['profilePic'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mobile'] = this.mobile;
    data['walletBalance'] = this.walletBalance;
    data['isVerified'] = this.isVerified;
    data['deviceId'] = this.deviceId;
    data['deviceType'] = this.deviceType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['fcmToken'] = this.fcmToken;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['name'] = this.name;
    data['profilePic'] = this.profilePic;
    data['id'] = this.id;
    return data;
  }
}
