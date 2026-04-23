import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';

class BookingHistoryDetailModel {
  bool? status;
  String? message;
  BookingHistoryDetailData? data;

  BookingHistoryDetailModel({
    this.status,
    this.message,
    this.data,
  });

  factory BookingHistoryDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingHistoryDetailModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? BookingHistoryDetailData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BookingHistoryDetailData {
  Pickup? pickup;
  Pickup? dropoff;
  PricingSnapshot? pricingSnapshot;
  Payment? payment;
  ExtraCharge? extraCharge;
  FareBreakup? fareBreakup;
  Actual? actual;
  Intercity? intercity;
  Hourly? hourly;
  RoundTrip? roundTrip;
  DriverResponse? driverResponse;

  String? id;
  String? bookingNumber;
  String? user;
  Segment? segment;
  Region? region;
  String? bookingType;
  String? paymentStatus;
  String? assignmentStatus;
  String? tripStatus;
  String? overallStatus;

  double? estimatedKm;
  int? estimatedMins;
  double? estimatedFare;
  double? prepaidAmount;

  String? scheduledAt;
  bool? isScheduled;
  String? paymentAt;
  String? createdAt;
  String? updatedAt;
  String? assignedAt;

  String? tripStartOtp;
  String? tripEndOtp;
  bool? tripStartOtpVerify;
  bool? tripEndOtpVerify;

  String? invoice;

  Driver? driver;
  Vehicle? vehicle;
  AssignedBy? assignedBy;

  String? createdAtIST;
  String? scheduledAtIST;
  String? paymentAtIST;
  String? assignedAtIST;
  String? tripStartAtIST;
  String? tripEndAtIST;
  String? cancelledAtIST;

  int? v;

  BookingHistoryDetailData({
    this.pickup,
    this.dropoff,
    this.pricingSnapshot,
    this.payment,
    this.extraCharge,
    this.fareBreakup,
    this.actual,
    this.intercity,
    this.hourly,
    this.roundTrip,
    this.driverResponse,
    this.id,
    this.bookingNumber,
    this.user,
    this.segment,
    this.region,
    this.bookingType,
    this.paymentStatus,
    this.assignmentStatus,
    this.tripStatus,
    this.overallStatus,
    this.estimatedKm,
    this.estimatedMins,
    this.estimatedFare,
    this.prepaidAmount,
    this.scheduledAt,
    this.isScheduled,
    this.paymentAt,
    this.createdAt,
    this.updatedAt,
    this.assignedAt,
    this.tripStartOtp,
    this.tripEndOtp,
    this.tripStartOtpVerify,
    this.tripEndOtpVerify,
    this.invoice,
    this.driver,
    this.vehicle,
    this.assignedBy,
    this.createdAtIST,
    this.scheduledAtIST,
    this.paymentAtIST,
    this.assignedAtIST,
    this.tripStartAtIST,
    this.tripEndAtIST,
    this.cancelledAtIST,
    this.v,
  });

  factory BookingHistoryDetailData.fromJson(Map<String, dynamic> json) {
    return BookingHistoryDetailData(
      pickup: json['pickup'] != null ? Pickup.fromJson(json['pickup']) : null,
      dropoff: json['dropoff'] != null ? Pickup.fromJson(json['dropoff']) : null,
      pricingSnapshot: json['pricingSnapshot'] != null ? PricingSnapshot.fromJson(json['pricingSnapshot']) : null,
      payment: json['payment'] != null ? Payment.fromJson(json['payment']) : null,
      extraCharge: json['extraCharge'] != null ? ExtraCharge.fromJson(json['extraCharge']) : null,
      fareBreakup: json['fareBreakup'] != null ? FareBreakup.fromJson(json['fareBreakup']) : null,
      actual: json['actual'] != null ? Actual.fromJson(json['actual']) : null,
      intercity: json['intercity'] != null ? Intercity.fromJson(json['intercity']) : null,
      hourly: json['hourly'] != null ? Hourly.fromJson(json['hourly']) : null,
      roundTrip: json['roundTrip'] != null ? RoundTrip.fromJson(json['roundTrip']) : null,
      driverResponse: json['driverResponse'] != null ? DriverResponse.fromJson(json['driverResponse']) : null,

      id: json['_id'] as String?,
      bookingNumber: json['bookingNumber'] as String?,
      user: json['user'] as String?,
      segment: json['segment'] != null ? Segment.fromJson(json['segment']) : null,
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      bookingType: json['bookingType'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      assignmentStatus: json['assignmentStatus'] as String?,
      tripStatus: json['tripStatus'] as String?,
      overallStatus: json['overallStatus'] as String?,

      estimatedKm: (json['estimatedKm'] as num?)?.toDouble(),
      estimatedMins: json['estimatedMins'] as int?,
      estimatedFare: (json['estimatedFare'] as num?)?.toDouble(),
      prepaidAmount: (json['prepaidAmount'] as num?)?.toDouble(),

      scheduledAt: json['scheduledAt'] as String?,
      isScheduled: json['isScheduled'] as bool?,
      paymentAt: json['paymentAt'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      assignedAt: json['assignedAt'] as String?,

      tripStartOtp: json['tripStartOtp'] as String?,
      tripEndOtp: json['tripEndOtp'] as String?,
      tripStartOtpVerify: json['tripStartOtpVerify'] as bool?,
      tripEndOtpVerify: json['tripEndOtpVerify'] as bool?,

      invoice: json['invoice'] as String?,

      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
      vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      assignedBy: json['assignedBy'] != null ? AssignedBy.fromJson(json['assignedBy']) : null,

      createdAtIST: json['createdAtIST'] as String?,
      scheduledAtIST: json['scheduledAtIST'] as String?,
      paymentAtIST: json['paymentAtIST'] as String?,
      assignedAtIST: json['assignedAtIST'] as String?,
      tripStartAtIST: json['tripStartAtIST'] as String?,
      tripEndAtIST: json['tripEndAtIST'] as String?,
      cancelledAtIST: json['cancelledAtIST'] as String?,

      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pickup != null) data['pickup'] = pickup!.toJson();
    if (dropoff != null) data['dropoff'] = dropoff!.toJson();
    if (pricingSnapshot != null) data['pricingSnapshot'] = pricingSnapshot!.toJson();
    if (payment != null) data['payment'] = payment!.toJson();
    if (extraCharge != null) data['extraCharge'] = extraCharge!.toJson();
    if (fareBreakup != null) data['fareBreakup'] = fareBreakup!.toJson();
    if (actual != null) data['actual'] = actual!.toJson();
    if (intercity != null) data['intercity'] = intercity!.toJson();
    if (hourly != null) data['hourly'] = hourly!.toJson();
    if (roundTrip != null) data['roundTrip'] = roundTrip!.toJson();
    if (driverResponse != null) data['driverResponse'] = driverResponse!.toJson();

    data['_id'] = id;
    data['bookingNumber'] = bookingNumber;
    data['user'] = user;
    if (segment != null) data['segment'] = segment!.toJson();
    if (region != null) data['region'] = region!.toJson();
    data['bookingType'] = bookingType;
    data['paymentStatus'] = paymentStatus;
    data['assignmentStatus'] = assignmentStatus;
    data['tripStatus'] = tripStatus;
    data['overallStatus'] = overallStatus;

    data['estimatedKm'] = estimatedKm;
    data['estimatedMins'] = estimatedMins;
    data['estimatedFare'] = estimatedFare;
    data['prepaidAmount'] = prepaidAmount;

    data['scheduledAt'] = scheduledAt;
    data['isScheduled'] = isScheduled;
    data['paymentAt'] = paymentAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['assignedAt'] = assignedAt;

    data['tripStartOtp'] = tripStartOtp;
    data['tripEndOtp'] = tripEndOtp;
    data['tripStartOtpVerify'] = tripStartOtpVerify;
    data['tripEndOtpVerify'] = tripEndOtpVerify;
    data['invoice'] = invoice;

    if (driver != null) data['driver'] = driver!.toJson();
    if (vehicle != null) data['vehicle'] = vehicle!.toJson();
    if (assignedBy != null) data['assignedBy'] = assignedBy!.toJson();

    data['createdAtIST'] = createdAtIST;
    data['scheduledAtIST'] = scheduledAtIST;
    data['paymentAtIST'] = paymentAtIST;
    data['assignedAtIST'] = assignedAtIST;
    data['tripStartAtIST'] = tripStartAtIST;
    data['tripEndAtIST'] = tripEndAtIST;
    data['cancelledAtIST'] = cancelledAtIST;

    data['__v'] = v;
    return data;
  }
}

// ================== New Classes Added ==================

class Driver {
  String? id;
  String? phone;
  int? rating;
  String? name;
  String? profilePic;

  Driver({this.id, this.phone, this.rating, this.name, this.profilePic});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'] as String?,
      phone: json['phone'] as String?,
      rating: json['rating'] as int?,
      name: json['name'] as String?,
      profilePic: json['profilePic'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['phone'] = phone;
    data['rating'] = rating;
    data['name'] = name;
    data['profilePic'] = profilePic;
    return data;
  }
}

class Vehicle {
  String? id;
  String? brand;
  String? model;
  String? fuelType;
  String? color;
  String? carNumber;

  Vehicle({this.id, this.brand, this.model, this.fuelType, this.color, this.carNumber});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] as String?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      fuelType: json['fuelType'] as String?,
      color: json['color'] as String?,
      carNumber: json['carNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['brand'] = brand;
    data['model'] = model;
    data['fuelType'] = fuelType;
    data['color'] = color;
    data['carNumber'] = carNumber;
    return data;
  }
}

class AssignedBy {
  String? id;
  String? email;
  String? createdAtIST;

  AssignedBy({this.id, this.email, this.createdAtIST});

  factory AssignedBy.fromJson(Map<String, dynamic> json) {
    return AssignedBy(
      id: json['_id'] as String?,
      email: json['email'] as String?,
      createdAtIST: json['createdAtIST'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['email'] = email;
    data['createdAtIST'] = createdAtIST;
    return data;
  }
}

class DriverResponse {
  String? status;
  String? respondedAt;
  String? cancelRequestId;

  DriverResponse({this.status, this.respondedAt, this.cancelRequestId});

  factory DriverResponse.fromJson(Map<String, dynamic> json) {
    return DriverResponse(
      status: json['status'] as String?,
      respondedAt: json['respondedAt'] as String?,
      cancelRequestId: json['cancelRequestId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['respondedAt'] = respondedAt;
    data['cancelRequestId'] = cancelRequestId;
    return data;
  }
}
// class BookingHistoryDetailModel {
//   bool? status;
//   String? message;
//   BookingHistoryDetailData? data;
//
//   BookingHistoryDetailModel({
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   factory BookingHistoryDetailModel.fromJson(Map<String, dynamic> json) {
//     return BookingHistoryDetailModel(
//       status: json['status'] as bool?,
//       message: json['message'] as String?,
//       data: json['data'] != null ? BookingHistoryDetailData.fromJson(json['data']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class BookingHistoryDetailData {
//   Pickup? pickup;
//   Pickup? dropoff;
//   PricingSnapshot? pricingSnapshot;
//   Payment? payment;
//   ExtraCharge? extraCharge;
//   FareBreakup? fareBreakup;
//   Actual? actual;
//   Intercity? intercity;
//   Hourly? hourly;
//   RoundTrip? roundTrip;
//
//   String? id;
//   String? bookingNumber;
//   String? user;
//   Segment? segment;
//   Region? region;
//   String? bookingType;
//   String? paymentStatus;
//   String? assignmentStatus;
//   String? tripStatus;
//   String? overallStatus;
//
//   double? estimatedKm;
//   int? estimatedMins;
//   double? estimatedFare;
//   double? prepaidAmount;
//
//   String? scheduledAt;
//   String? paymentAt;
//   String? createdAt;
//   String? updatedAt;
//
//   int? v;
//
//   BookingHistoryDetailData({
//     this.pickup,
//     this.dropoff,
//     this.pricingSnapshot,
//     this.payment,
//     this.extraCharge,
//     this.fareBreakup,
//     this.actual,
//     this.intercity,
//     this.hourly,
//     this.roundTrip,
//     this.id,
//     this.bookingNumber,
//     this.user,
//     this.segment,
//     this.region,
//     this.bookingType,
//     this.paymentStatus,
//     this.assignmentStatus,
//     this.tripStatus,
//     this.overallStatus,
//     this.estimatedKm,
//     this.estimatedMins,
//     this.estimatedFare,
//     this.prepaidAmount,
//     this.scheduledAt,
//     this.paymentAt,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });
//
//   factory BookingHistoryDetailData.fromJson(Map<String, dynamic> json) {
//     return BookingHistoryDetailData(
//       pickup: json['pickup'] != null ? Pickup.fromJson(json['pickup']) : null,
//       dropoff: json['dropoff'] != null ? Pickup.fromJson(json['dropoff']) : null,
//       pricingSnapshot: json['pricingSnapshot'] != null
//           ? PricingSnapshot.fromJson(json['pricingSnapshot'])
//           : null,
//       payment: json['payment'] != null ? Payment.fromJson(json['payment']) : null,
//       extraCharge: json['extraCharge'] != null
//           ? ExtraCharge.fromJson(json['extraCharge'])
//           : null,
//       fareBreakup: json['fareBreakup'] != null
//           ? FareBreakup.fromJson(json['fareBreakup'])
//           : null,
//       actual: json['actual'] != null ? Actual.fromJson(json['actual']) : null,
//       intercity: json['intercity'] != null
//           ? Intercity.fromJson(json['intercity'])
//           : null,
//       hourly: json['hourly'] != null ? Hourly.fromJson(json['hourly']) : null,
//       roundTrip: json['roundTrip'] != null
//           ? RoundTrip.fromJson(json['roundTrip'])
//           : null,
//       id: json['_id'] as String?,
//       bookingNumber: json['bookingNumber'] as String?,
//       user: json['user'] as String?,
//       segment: json['segment'] != null ? Segment.fromJson(json['segment']) : null,
//       region: json['region'] != null ? Region.fromJson(json['region']) : null,
//       bookingType: json['bookingType'] as String?,
//       paymentStatus: json['paymentStatus'] as String?,
//       assignmentStatus: json['assignmentStatus'] as String?,
//       tripStatus: json['tripStatus'] as String?,
//       overallStatus: json['overallStatus'] as String?,
//       estimatedKm: (json['estimatedKm'] as num?)?.toDouble(),
//       estimatedMins: json['estimatedMins'] as int?,
//       estimatedFare: (json['estimatedFare'] as num?)?.toDouble(),
//       prepaidAmount: (json['prepaidAmount'] as num?)?.toDouble(),
//       scheduledAt: json['scheduledAt'] as String?,
//       paymentAt: json['paymentAt'] as String?,
//       createdAt: json['createdAt'] as String?,
//       updatedAt: json['updatedAt'] as String?,
//       v: json['__v'] as int?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (pickup != null) data['pickup'] = pickup!.toJson();
//     if (dropoff != null) data['dropoff'] = dropoff!.toJson();
//     if (pricingSnapshot != null) data['pricingSnapshot'] = pricingSnapshot!.toJson();
//     if (payment != null) data['payment'] = payment!.toJson();
//     if (extraCharge != null) data['extraCharge'] = extraCharge!.toJson();
//     if (fareBreakup != null) data['fareBreakup'] = fareBreakup!.toJson();
//     if (actual != null) data['actual'] = actual!.toJson();
//     if (intercity != null) data['intercity'] = intercity!.toJson();
//     if (hourly != null) data['hourly'] = hourly!.toJson();
//     if (roundTrip != null) data['roundTrip'] = roundTrip!.toJson();
//     data['_id'] = id;
//     data['bookingNumber'] = bookingNumber;
//     data['user'] = user;
//     if (segment != null) data['segment'] = segment!.toJson();
//     if (region != null) data['region'] = region!.toJson();
//     data['bookingType'] = bookingType;
//     data['paymentStatus'] = paymentStatus;
//     data['assignmentStatus'] = assignmentStatus;
//     data['tripStatus'] = tripStatus;
//     data['overallStatus'] = overallStatus;
//     data['estimatedKm'] = estimatedKm;
//     data['estimatedMins'] = estimatedMins;
//     data['estimatedFare'] = estimatedFare;
//     data['prepaidAmount'] = prepaidAmount;
//     data['scheduledAt'] = scheduledAt;
//     data['paymentAt'] = paymentAt;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['__v'] = v;
//     return data;
//   }
// }

class Pickup {
  double? lat;
  double? lng;
  String? address;

  Pickup({this.lat, this.lng, this.address});

  factory Pickup.fromJson(Map<String, dynamic> json) {
    return Pickup(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    data['address'] = address;
    return data;
  }
}

class PricingSnapshot {
  DriverFare? driverFare;
  double? baseFare;
  double? perKmRate;
  double? perMinRate;
  double? minFare;
  double? surgeMultiplier;
  String? surgeLabel;
  String? timeType;
  double? cancellationFee;
  double? gstPercent;

  PricingSnapshot({
    this.driverFare,
    this.baseFare,
    this.perKmRate,
    this.perMinRate,
    this.minFare,
    this.surgeMultiplier,
    this.surgeLabel,
    this.timeType,
    this.cancellationFee,
    this.gstPercent,
  });

  factory PricingSnapshot.fromJson(Map<String, dynamic> json) {
    return PricingSnapshot(
      driverFare: json['driverFare'] != null
          ? DriverFare.fromJson(json['driverFare'])
          : null,
      baseFare: (json['baseFare'] as num?)?.toDouble(),
      perKmRate: (json['perKmRate'] as num?)?.toDouble(),
      perMinRate: (json['perMinRate'] as num?)?.toDouble(),
      minFare: (json['minFare'] as num?)?.toDouble(),
      surgeMultiplier: (json['surgeMultiplier'] as num?)?.toDouble(),
      surgeLabel: json['surgeLabel'] as String?,
      timeType: json['timeType'] as String?,
      cancellationFee: (json['cancellationFee'] as num?)?.toDouble(),
      gstPercent: (json['gstPercent'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (driverFare != null) data['driverFare'] = driverFare!.toJson();
    data['baseFare'] = baseFare;
    data['perKmRate'] = perKmRate;
    data['perMinRate'] = perMinRate;
    data['minFare'] = minFare;
    data['surgeMultiplier'] = surgeMultiplier;
    data['surgeLabel'] = surgeLabel;
    data['timeType'] = timeType;
    data['cancellationFee'] = cancellationFee;
    data['gstPercent'] = gstPercent;
    return data;
  }
}

class DriverFare {
  dynamic perKmRate;
  dynamic flatPerTrip;
  dynamic minGuarantee;
  dynamic allowancePerDay;
  bool? tollIncluded;

  DriverFare({
    this.perKmRate,
    this.flatPerTrip,
    this.minGuarantee,
    this.allowancePerDay,
    this.tollIncluded,
  });

  factory DriverFare.fromJson(Map<String, dynamic> json) {
    return DriverFare(
      perKmRate: json['perKmRate'],
      flatPerTrip: json['flatPerTrip'],
      minGuarantee: json['minGuarantee'],
      allowancePerDay: json['allowancePerDay'],
      tollIncluded: json['tollIncluded'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['perKmRate'] = perKmRate;
    data['flatPerTrip'] = flatPerTrip;
    data['minGuarantee'] = minGuarantee;
    data['allowancePerDay'] = allowancePerDay;
    data['tollIncluded'] = tollIncluded;
    return data;
  }
}

class Payment {
  ExtraPayment? extraPayment;
  String? method;
  String? gatewayRef;
  double? paidAmount;
  String? paidAt;
  String? status;

  Payment({
    this.extraPayment,
    this.method,
    this.gatewayRef,
    this.paidAmount,
    this.paidAt,
    this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      extraPayment: json['extraPayment'] != null
          ? ExtraPayment.fromJson(json['extraPayment'])
          : null,
      method: json['method'] as String?,
      gatewayRef: json['gatewayRef'] as String?,
      paidAmount: (json['paidAmount'] as num?)?.toDouble(),
      paidAt: json['paidAt'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (extraPayment != null) data['extraPayment'] = extraPayment!.toJson();
    data['method'] = method;
    data['gatewayRef'] = gatewayRef;
    data['paidAmount'] = paidAmount;
    data['paidAt'] = paidAt;
    data['status'] = status;
    return data;
  }
}

class ExtraPayment {
  double? amount;
  String? status;
  String? method;
  String? gatewayRef;
  String? paidAt;

  ExtraPayment({
    this.amount,
    this.status,
    this.method,
    this.gatewayRef,
    this.paidAt,
  });

  factory ExtraPayment.fromJson(Map<String, dynamic> json) {
    return ExtraPayment(
      amount: (json['amount'] as num?)?.toDouble(),
      status: json['status'] as String?,
      method: json['method'] as String?,
      gatewayRef: json['gatewayRef'] as String?,
      paidAt: json['paidAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['status'] = status;
    data['method'] = method;
    data['gatewayRef'] = gatewayRef;
    data['paidAt'] = paidAt;
    return data;
  }
}

class ExtraCharge {
  double? amount;
  String? reason;
  bool? isPaid;
  String? paidAt;

  ExtraCharge({this.amount, this.reason, this.isPaid, this.paidAt});

  factory ExtraCharge.fromJson(Map<String, dynamic> json) {
    return ExtraCharge(
      amount: (json['amount'] as num?)?.toDouble(),
      reason: json['reason'] as String?,
      isPaid: json['isPaid'] as bool?,
      paidAt: json['paidAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['reason'] = reason;
    data['isPaid'] = isPaid;
    data['paidAt'] = paidAt;
    return data;
  }
}

class FareBreakup {
  Estimated? estimated;
  FinalFare? finalFare;

  FareBreakup({this.estimated, this.finalFare});

  factory FareBreakup.fromJson(Map<String, dynamic> json) {
    return FareBreakup(
      estimated: json['estimated'] != null
          ? Estimated.fromJson(json['estimated'])
          : null,
      finalFare: json['final'] != null ? FinalFare.fromJson(json['final']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (estimated != null) data['estimated'] = estimated!.toJson();
    if (finalFare != null) data['final'] = finalFare!.toJson();
    return data;
  }
}

class Estimated {
  double? baseFare;
  double? distanceCharge;
  double? timeCharge;
  double? surgeCharge;
  double? subtotal;
  double? gstAmount;
  double? tollCharge;
  double? totalFare;
  double? airportFare;
  double? nightFare;
  double? surchargeAmount;

  Estimated({
    this.baseFare,
    this.distanceCharge,
    this.timeCharge,
    this.surgeCharge,
    this.subtotal,
    this.gstAmount,
    this.tollCharge,
    this.totalFare,
    this.airportFare,
    this.nightFare,
    this.surchargeAmount,
  });

  factory Estimated.fromJson(Map<String, dynamic> json) {
    return Estimated(
      baseFare: (json['baseFare'] as num?)?.toDouble(),
      distanceCharge: (json['distanceCharge'] as num?)?.toDouble(),
      timeCharge: (json['timeCharge'] as num?)?.toDouble(),
      surgeCharge: (json['surgeCharge'] as num?)?.toDouble(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      gstAmount: (json['gstAmount'] as num?)?.toDouble(),
      tollCharge: (json['tollCharge'] as num?)?.toDouble(),
      totalFare: (json['totalFare'] as num?)?.toDouble(),
      airportFare: (json['airportFare'] as num?)?.toDouble(),
      nightFare: (json['nightFare'] as num?)?.toDouble(),
      surchargeAmount: (json['surchargeAmount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['baseFare'] = baseFare;
    data['distanceCharge'] = distanceCharge;
    data['timeCharge'] = timeCharge;
    data['surgeCharge'] = surgeCharge;
    data['subtotal'] = subtotal;
    data['gstAmount'] = gstAmount;
    data['tollCharge'] = tollCharge;
    data['totalFare'] = totalFare;
    data['airportFare'] = airportFare;
    data['nightFare'] = nightFare;
    data['surchargeAmount'] = surchargeAmount;
    return data;
  }
}

class FinalFare {
  double? baseFare;
  double? distanceCharge;
  double? timeCharge;
  double? surgeCharge;
  double? subtotal;
  double? gstAmount;
  double? tollCharge;
  double? extraKmCharge;
  double? extraTimeCharge;
  double? discountAmount;
  double? walletUsed;
  double? totalFare;

  FinalFare({
    this.baseFare,
    this.distanceCharge,
    this.timeCharge,
    this.surgeCharge,
    this.subtotal,
    this.gstAmount,
    this.tollCharge,
    this.extraKmCharge,
    this.extraTimeCharge,
    this.discountAmount,
    this.walletUsed,
    this.totalFare,
  });

  factory FinalFare.fromJson(Map<String, dynamic> json) {
    return FinalFare(
      baseFare: (json['baseFare'] as num?)?.toDouble(),
      distanceCharge: (json['distanceCharge'] as num?)?.toDouble(),
      timeCharge: (json['timeCharge'] as num?)?.toDouble(),
      surgeCharge: (json['surgeCharge'] as num?)?.toDouble(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      gstAmount: (json['gstAmount'] as num?)?.toDouble(),
      tollCharge: (json['tollCharge'] as num?)?.toDouble(),
      extraKmCharge: (json['extraKmCharge'] as num?)?.toDouble(),
      extraTimeCharge: (json['extraTimeCharge'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      walletUsed: (json['walletUsed'] as num?)?.toDouble(),
      totalFare: (json['totalFare'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['baseFare'] = baseFare;
    data['distanceCharge'] = distanceCharge;
    data['timeCharge'] = timeCharge;
    data['surgeCharge'] = surgeCharge;
    data['subtotal'] = subtotal;
    data['gstAmount'] = gstAmount;
    data['tollCharge'] = tollCharge;
    data['extraKmCharge'] = extraKmCharge;
    data['extraTimeCharge'] = extraTimeCharge;
    data['discountAmount'] = discountAmount;
    data['walletUsed'] = walletUsed;
    data['totalFare'] = totalFare;
    return data;
  }
}

class Actual {
  String? polyline;
  double? distanceKm;
  double? durationMins;
  double? tollAmount;

  Actual({this.polyline, this.distanceKm, this.durationMins, this.tollAmount});

  factory Actual.fromJson(Map<String, dynamic> json) {
    return Actual(
      polyline: json['polyline'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      durationMins: (json['durationMins'] as num?)?.toDouble(),
      tollAmount: (json['tollAmount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['polyline'] = polyline;
    data['distanceKm'] = distanceKm;
    data['durationMins'] = durationMins;
    data['tollAmount'] = tollAmount;
    return data;
  }
}

class Intercity {
  int? tripDays;
  double? tollAmount;
  dynamic driverPayout;
  dynamic driverAllowanceTotal;

  Intercity({
    this.tripDays,
    this.tollAmount,
    this.driverPayout,
    this.driverAllowanceTotal,
  });

  factory Intercity.fromJson(Map<String, dynamic> json) {
    return Intercity(
      tripDays: json['tripDays'] as int?,
      tollAmount: (json['tollAmount'] as num?)?.toDouble(),
      driverPayout: json['driverPayout'],
      driverAllowanceTotal: json['driverAllowanceTotal'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tripDays'] = tripDays;
    data['tollAmount'] = tollAmount;
    data['driverPayout'] = driverPayout;
    data['driverAllowanceTotal'] = driverAllowanceTotal;
    return data;
  }
}

class Hourly {
  int? extraHours;
  int? extraKms;
  double? extraCharges;

  Hourly({this.extraHours, this.extraKms, this.extraCharges});

  factory Hourly.fromJson(Map<String, dynamic> json) {
    return Hourly(
      extraHours: json['extraHours'] as int?,
      extraKms: json['extraKms'] as int?,
      extraCharges: (json['extraCharges'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['extraHours'] = extraHours;
    data['extraKms'] = extraKms;
    data['extraCharges'] = extraCharges;
    return data;
  }
}

class RoundTrip {
  String? returnStatus;
  dynamic returnFare;

  RoundTrip({this.returnStatus, this.returnFare});

  factory RoundTrip.fromJson(Map<String, dynamic> json) {
    return RoundTrip(
      returnStatus: json['returnStatus'] as String?,
      returnFare: json['returnFare'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['returnStatus'] = returnStatus;
    data['returnFare'] = returnFare;
    return data;
  }
}

class Segment {
  String? id;
  String? name;
  int? maxCapacity;

  Segment({this.id, this.name, this.maxCapacity});

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      maxCapacity: json['maxCapacity'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['maxCapacity'] = maxCapacity;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['state'] = state;
    return data;
  }
}