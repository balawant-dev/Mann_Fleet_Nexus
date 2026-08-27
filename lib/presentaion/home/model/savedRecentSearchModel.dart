class SavedRecentSearchModel {
  bool? status;
  String? message;
  Data? data;

  SavedRecentSearchModel({this.status, this.message, this.data});

  SavedRecentSearchModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? user;
  int? iV;
  String? createdAt;
  double? latitude;
  String? location;
  double? longitude;

  Data(
      {this.sId,
        this.user,
        this.iV,
        this.createdAt,
        this.latitude,
        this.location,
        this.longitude});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    latitude = json['latitude'];
    location = json['location'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['latitude'] = this.latitude;
    data['location'] = this.location;
    data['longitude'] = this.longitude;
    return data;
  }
}
