// class RecentLocationModel {
//   final bool status;
//   final String message;
//   final int results;
//   final List<RecentLocationData> data;
//
//   RecentLocationModel({
//     required this.status,
//     required this.message,
//     required this.results,
//     required this.data,
//   });
//
//   factory RecentLocationModel.fromJson(Map<String, dynamic> json) {
//     return RecentLocationModel(
//       status: json['status'] ?? false,
//       message: json['message'] ?? '',
//       results: json['results'] ?? 0,
//       data:
//           (json['data'] as List<dynamic>?)
//               ?.map((e) => RecentLocationData.fromJson(e))
//               .toList() ??
//           [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'message': message,
//       'results': results,
//       'data': data.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class RecentLocationData {
//   final String id;
//   final String createdAt;
//   final double latitude;
//   final String location;
//   final double longitude;
//
//   RecentLocationData({
//     required this.id,
//     required this.createdAt,
//     required this.latitude,
//     required this.location,
//     required this.longitude,
//   });
//
//   factory RecentLocationData.fromJson(Map<String, dynamic> json) {
//     return RecentLocationData(
//       id: json['_id'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
//       location: json['location'] ?? '',
//       longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'createdAt': createdAt,
//       'latitude': latitude,
//       'location': location,
//       'longitude': longitude,
//     };
//   }
// }

class RecentLocationModel {
  bool? status;
  int? count;
  List<RecentLocationData>? data;

  RecentLocationModel({this.status, this.count, this.data});

  RecentLocationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    if (json['data'] != null) {
      data = <RecentLocationData>[];
      json['data'].forEach((v) {
        data!.add(new RecentLocationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecentLocationData {
  String? type;
  double? lat;
  double? lng;
  String? address;
  String? lastUsedAt;
  String? bookingNumber;
  String? source;
  String? model;
  String? id;

  RecentLocationData(
      {this.type,
        this.lat,
        this.lng,
        this.address,
        this.lastUsedAt,
        this.source,
        this.model,
        this.id,
        this.bookingNumber});

  RecentLocationData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    lastUsedAt = json['lastUsedAt'];
    bookingNumber = json['bookingNumber'];
    source = json['source'];
    model = json['model'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['lastUsedAt'] = this.lastUsedAt;
    data['bookingNumber'] = this.bookingNumber;
    data['source'] = this.source;
    data['model'] = this.model;
    data['id'] = this.id;
    return data;
  }
}
