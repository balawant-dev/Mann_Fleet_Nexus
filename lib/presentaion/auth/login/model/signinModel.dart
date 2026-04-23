class SignInModel {
  bool? status;
  String? message;
  Data? data;
  bool? newUser;

  SignInModel({this.status, this.message, this.data, this.newUser});

  SignInModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    newUser = json['newUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['newUser'] = this.newUser;
    return data;
  }
}

class Data {
  String? mobile;
  String? email;
  String? otpExpiry;
  User? user;
  String? type;

  Data({this.mobile, this.email, this.otpExpiry, this.user, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    email = json['email'];
    otpExpiry = json['otpExpiry'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['otpExpiry'] = this.otpExpiry;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class User {
  String? sId;
  String? id;
  String? mobile;
  int? walletBalance;
  bool? isVerified;
  String? deviceId;
  String? deviceType;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? otpExpiry;

  User(
      {this.sId,
        this.id,
        this.mobile,
        this.walletBalance,
        this.isVerified,
        this.deviceId,
        this.deviceType,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.otpExpiry});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    mobile = json['mobile'];
    walletBalance = json['walletBalance'];
    isVerified = json['isVerified'];
    deviceId = json['deviceId'];
    deviceType = json['deviceType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    otpExpiry = json['otpExpiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['walletBalance'] = this.walletBalance;
    data['isVerified'] = this.isVerified;
    data['deviceId'] = this.deviceId;
    data['deviceType'] = this.deviceType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['otpExpiry'] = this.otpExpiry;
    return data;
  }
}
