class CheckedVerificationStatusModel {
  bool? status;
  String? message;
  Data? data;

  CheckedVerificationStatusModel({this.status, this.message, this.data});

  CheckedVerificationStatusModel.fromJson(Map<String, dynamic> json) {
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
  bool? isVerified;

  Data({this.mobile, this.isVerified});

  Data.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    isVerified = json['isVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['isVerified'] = this.isVerified;
    return data;
  }
}
