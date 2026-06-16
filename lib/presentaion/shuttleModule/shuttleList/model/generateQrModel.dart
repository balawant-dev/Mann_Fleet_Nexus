class GenerateQrModel {
  bool? status;
  String? message;
  Data? data;

  GenerateQrModel({this.status, this.message, this.data});

  GenerateQrModel.fromJson(Map<String, dynamic> json) {
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
  String? qrToken;
  String? qrImage;
  String? expiresAt;
  int? timeLeft;
  PassInfo? passInfo;

  Data(
      {this.qrToken,
        this.qrImage,
        this.expiresAt,
        this.timeLeft,
        this.passInfo});

  Data.fromJson(Map<String, dynamic> json) {
    qrToken = json['qrToken'];
    qrImage = json['qrImage'];
    expiresAt = json['expiresAt'];
    timeLeft = json['timeLeft'];
    passInfo = json['passInfo'] != null
        ? new PassInfo.fromJson(json['passInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qrToken'] = this.qrToken;
    data['qrImage'] = this.qrImage;
    data['expiresAt'] = this.expiresAt;
    data['timeLeft'] = this.timeLeft;
    if (this.passInfo != null) {
      data['passInfo'] = this.passInfo!.toJson();
    }
    return data;
  }
}

class PassInfo {
  String? name;
  String? source;
  String? destination;
  int? remainingRides;

  PassInfo({this.name, this.source, this.destination, this.remainingRides});

  PassInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    source = json['source'];
    destination = json['destination'];
    remainingRides = json['remainingRides'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['source'] = this.source;
    data['destination'] = this.destination;
    data['remainingRides'] = this.remainingRides;
    return data;
  }
}
