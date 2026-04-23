class PlatformDependenciesModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<Data>? data;

  PlatformDependenciesModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  PlatformDependenciesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResult'] = this.totalResult;
    data['totalPage'] = this.totalPage;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  Name? name;
  String? createdAt;
  int? iV;

  Data({this.sId, this.name, this.createdAt, this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.name != null) {
      data['name'] = this.name!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Name {
  String? userAppVersion;
  String? driverAppVersion;
  String? googleMapKey;
  String? rAZORKEY;
  String? rAZORKEYSECRET;

  Name(
      {this.userAppVersion,
        this.driverAppVersion,
        this.googleMapKey,
        this.rAZORKEY,
        this.rAZORKEYSECRET});

  Name.fromJson(Map<String, dynamic> json) {
    userAppVersion = json['userAppVersion'];
    driverAppVersion = json['driverAppVersion'];
    googleMapKey = json['googleMapKey'];
    rAZORKEY = json['RAZOR_KEY'];
    rAZORKEYSECRET = json['RAZOR_KEY_SECRET'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userAppVersion'] = this.userAppVersion;
    data['driverAppVersion'] = this.driverAppVersion;
    data['googleMapKey'] = this.googleMapKey;
    data['RAZOR_KEY'] = this.rAZORKEY;
    data['RAZOR_KEY_SECRET'] = this.rAZORKEYSECRET;
    return data;
  }
}
