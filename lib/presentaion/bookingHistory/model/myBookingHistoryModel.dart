import 'bookingHistoryDetailModel.dart';

class MyBookingHistoryModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  int? currentPage;
  String? message;
  List<BookingHistoryData>? data;

  MyBookingHistoryModel({
    this.status,
    this.totalResult,
    this.totalPage,
    this.currentPage,
    this.message,
    this.data,
  });

  factory MyBookingHistoryModel.fromJson(Map<String, dynamic> json) {
    return MyBookingHistoryModel(
      status: json['status'] as bool?,
      totalResult: json['totalResult'] as int?,
      totalPage: json['totalPage'] as int?,
      currentPage: json['currentPage'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
                .map(
                  (e) => BookingHistoryData.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['status'] = status;
    map['totalResult'] = totalResult;
    map['totalPage'] = totalPage;
    map['currentPage'] = currentPage;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

class BookingHistoryData {
  Pickup? pickup;
  Pickup? dropoff;
  String? id; // renamed from sId & _id
  String? bookingNumber;
  Segment? segment;
  Region? region;
  String? bookingType;
  String? paymentStatus;
  String? tripStatus;
  String? overallStatus;
  double? estimatedFare;
  double? prepaidAmount;
  String? tripStartOtp;
  String? tripEndOtp;
  String? scheduledAt;
  String? createdAt;
  String? createdAtIST;
  String? scheduledAtIST;
  String? paymentAtIST;
  String? assignedAtIST;
  String? tripStartAtIST;
  String? tripEndAtIST;
  String? cancelledAtIST;

  Driver? driver;
  Vehicle? vehicle;
  double? finalFare;
  String? dropoffAtIST;

  List<BookingRating>? ratings;

  BookingHistoryData({
    this.pickup,
    this.dropoff,
    this.id,
    this.bookingNumber,
    this.segment,
    this.region,
    this.bookingType,
    this.paymentStatus,
    this.tripStatus,
    this.overallStatus,
    this.estimatedFare,
    this.prepaidAmount,
    this.tripStartOtp,
    this.tripEndOtp,
    this.scheduledAt,
    this.createdAt,
    this.createdAtIST,
    this.scheduledAtIST,
    this.paymentAtIST,
    this.assignedAtIST,
    this.tripStartAtIST,
    this.tripEndAtIST,
    this.cancelledAtIST,
    this.driver,
    this.vehicle,
    this.finalFare,
    this.dropoffAtIST,
    this.ratings,
  });

  factory BookingHistoryData.fromJson(Map<String, dynamic> json) {
    return BookingHistoryData(
      pickup: json['pickup'] != null ? Pickup.fromJson(json['pickup']) : null,
      dropoff: json['dropoff'] != null
          ? Pickup.fromJson(json['dropoff'])
          : null,
      id: json['_id'] as String? ?? json['id'] as String?,
      bookingNumber: json['bookingNumber'] as String?,
      segment: json['segment'] != null
          ? Segment.fromJson(json['segment'])
          : null,
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      bookingType: json['bookingType'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      tripStatus: json['tripStatus'] as String?,
      overallStatus: json['overallStatus'] as String?,
      estimatedFare: (json['estimatedFare'] as num?)?.toDouble(),
      prepaidAmount: (json['prepaidAmount'] as num?)?.toDouble(),
      scheduledAt: json['scheduledAt'] as String?,
      tripStartOtp: json['tripStartOtp'] as String?,
      tripEndOtp: json['tripEndOtp'] as String?,
      createdAt: json['createdAt'] as String?,
      createdAtIST: json['createdAtIST'] as String?,
      scheduledAtIST: json['scheduledAtIST'] as String?,
      paymentAtIST: json['paymentAtIST'] as String?,
      assignedAtIST: json['assignedAtIST'] as String?,
      tripStartAtIST: json['tripStartAtIST'] as String?,
      tripEndAtIST: json['tripEndAtIST'] as String?,
      cancelledAtIST: json['cancelledAtIST'] as String?,
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,

      vehicle: json['vehicle'] != null
          ? Vehicle.fromJson(json['vehicle'])
          : null,

      finalFare: (json['finalFare'] as num?)?.toDouble(),

      // finalFare: JsonHelper.numValue(json['finalFare']),

      dropoffAtIST: json['dropoffAtIST'] as String?,

      ratings: json['rating'] != null
          ? (json['rating'] as List)
                .map((e) => BookingRating.fromJson(e))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (pickup != null) map['pickup'] = pickup!.toJson();
    if (dropoff != null) map['dropoff'] = dropoff!.toJson();
    map['_id'] = id;
    map['bookingNumber'] = bookingNumber;
    if (segment != null) map['segment'] = segment!.toJson();
    if (region != null) map['region'] = region!.toJson();
    map['bookingType'] = bookingType;
    map['paymentStatus'] = paymentStatus;
    map['tripStatus'] = tripStatus;
    map['overallStatus'] = overallStatus;
    map['estimatedFare'] = estimatedFare;
    map['prepaidAmount'] = prepaidAmount;
    map['tripStartOtp'] = tripStartOtp;
    map['tripEndOtp'] = tripEndOtp;
    map['scheduledAt'] = scheduledAt;
    map['createdAt'] = createdAt;
    map['createdAtIST'] = createdAtIST;
    map['scheduledAtIST'] = scheduledAtIST;
    map['paymentAtIST'] = paymentAtIST;
    map['assignedAtIST'] = assignedAtIST;
    map['tripStartAtIST'] = tripStartAtIST;
    map['tripEndAtIST'] = tripEndAtIST;
    map['cancelledAtIST'] = cancelledAtIST;
    map['id'] = id;
    if (driver != null) map['driver'] = driver!.toJson();

    if (vehicle != null) map['vehicle'] = vehicle!.toJson();

    map['finalFare'] = finalFare;

    map['dropoffAtIST'] = dropoffAtIST;

    if (ratings != null) {
      map['rating'] = ratings!.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

class Vehicle {
  String? id;
  String? brand;
  String? model;
  String? color;
  String? carNumber;

  Vehicle({this.id, this.brand, this.model, this.color, this.carNumber});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'],
      brand: json['brand'],
      model: json['model'],
      color: json['color'],
      carNumber: json['carNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'brand': brand,
      'model': model,
      'color': color,
      'carNumber': carNumber,
    };
  }
}

class BookingRating {
  String? id;
  num? userRating;
  String? userComment;
  String? createdAt;

  BookingRating({this.id, this.userRating, this.userComment, this.createdAt});

  factory BookingRating.fromJson(Map<String, dynamic> json) {
    return BookingRating(
      id: json['_id'],
      userRating: JsonHelper.numValue(json['userRating']),
      userComment: json['userComment'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userRating': userRating,
      'userComment': userComment,
      'createdAt': createdAt,
    };
  }
}

class Driver {
  String? id;
  String? phone;
  num? rating;
  String? name;
  String? profilePic;

  Driver({this.id, this.phone, this.rating, this.name, this.profilePic});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'],
      phone: json['phone'],
      rating: JsonHelper.numValue(json['rating']),
      name: json['name'],
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'phone': phone,
      'rating': rating,
      'name': name,
      'profilePic': profilePic,
    };
  }
}

class Pickup {
  String? address;

  Pickup({this.address});

  factory Pickup.fromJson(Map<String, dynamic> json) {
    return Pickup(address: json['address'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'address': address};
  }
}

class Segment {
  String? id;
  String? name;

  Segment({this.id, this.name});

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(id: json['_id'] as String?, name: json['name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}

class Region {
  String? id;
  String? name;
  String? state;

  Region({this.id, this.name, this.state});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      state: json['state'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'state': state};
  }
}
