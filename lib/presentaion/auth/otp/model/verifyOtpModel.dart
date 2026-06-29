class VerifyOtpModel {
  var status;
  var message;
  var token;
  Data? data;

  VerifyOtpModel({this.status, this.message, this.token, this.data});

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
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
  var sId;
  var name;
  var id;
  var mobile;
  var walletBalance;
  var isVerified;
  var isProfileComplete;
  var deviceId;
  var deviceType;
  var createdAt;
  var updatedAt;
  var iV;
  var fcmToken;

  User({
    this.sId,
    this.name,
    this.id,
    this.mobile,
    this.walletBalance,
    this.isVerified,
    this.isProfileComplete,
    this.deviceId,
    this.deviceType,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.fcmToken,
  });

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    id = json['id'];
    mobile = json['mobile'];
    walletBalance = json['walletBalance'];
    isVerified = json['isVerified'];
    isProfileComplete = json['isProfileComplete'];
    deviceId = json['deviceId'];
    deviceType = json['deviceType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['walletBalance'] = this.walletBalance;
    data['isVerified'] = this.isVerified;
    data['isProfileComplete'] = this.isProfileComplete;
    data['deviceId'] = this.deviceId;
    data['deviceType'] = this.deviceType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}
