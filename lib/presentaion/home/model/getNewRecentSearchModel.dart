// class GetNewRecentSearchModel {
//   bool? status;
//   String? message;
//   int? results;
//   List<Data>? data;
//
//   GetNewRecentSearchModel({this.status, this.message, this.results, this.data});
//
//   GetNewRecentSearchModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     results = json['results'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     data['results'] = this.results;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String? sId;
//   String? createdAt;
//   double? latitude;
//   String? location;
//   double? longitude;
//
//   Data(
//       {this.sId, this.createdAt, this.latitude, this.location, this.longitude});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     createdAt = json['createdAt'];
//     latitude = json['latitude'];
//     location = json['location'];
//     longitude = json['longitude'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['createdAt'] = this.createdAt;
//     data['latitude'] = this.latitude;
//     data['location'] = this.location;
//     data['longitude'] = this.longitude;
//     return data;
//   }
// }
