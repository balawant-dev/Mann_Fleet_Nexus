class SentOTPModel {
  bool? status;
  String? message;
  Data? data;

  SentOTPModel({this.status, this.message, this.data});

  SentOTPModel.fromJson(Map<String, dynamic> json) {
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
  String? mobile;
  String? otpExpiry;

  Data({this.mobile, this.otpExpiry});

  Data.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    otpExpiry = json['otpExpiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['otpExpiry'] = this.otpExpiry;
    return data;
  }
}
