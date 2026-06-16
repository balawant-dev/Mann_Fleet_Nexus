class GetShuttlePassesModel {
  final bool? status;
  final int? totalResult;
  final String? message;
  final ShuttleData? data;

  GetShuttlePassesModel({
    this.status,
    this.totalResult,
    this.message,
    this.data,
  });

  factory GetShuttlePassesModel.fromJson(Map<String, dynamic> json) {
    return GetShuttlePassesModel(
      status: json['status'],
      totalResult: json['totalResult'],
      message: json['message'],
      data: json['data'] != null
          ? ShuttleData.fromJson(json['data'])
          : null,
    );
  }
}

class ShuttleData {
  final RouteInfo? routeInfo;
  final List<PassModelShuttle>? passes;

  ShuttleData({
    this.routeInfo,
    this.passes,
  });

  factory ShuttleData.fromJson(Map<String, dynamic> json) {
    return ShuttleData(
      routeInfo: json['routeInfo'] != null
          ? RouteInfo.fromJson(json['routeInfo'])
          : null,
      passes: json['passes'] != null
          ? List<PassModelShuttle>.from(
          json['passes'].map((x) => PassModelShuttle.fromJson(x)))
          : [],
    );
  }
}

class RouteInfo {
  final String? source;
  final String? destination;

  RouteInfo({
    this.source,
    this.destination,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    return RouteInfo(
      source: json['source'],
      destination: json['destination'],
    );
  }
}

class PassModelShuttle {
  final String? passId;
  final String? name;
  final String? shortDescription;
  final String? description;
  final List<String>? benefits;
  final String? thumbImage;
  final int? rideCount;
  final bool? isPurchased;
  final int? remainingRides;
  final String? transactionId;
  final Pricing? pricing;
  final Expiry? expiry;

  PassModelShuttle({
    this.passId,
    this.name,
    this.shortDescription,
    this.description,
    this.benefits,
    this.thumbImage,
    this.rideCount,
    this.pricing,
    this.isPurchased,////////////
    this.remainingRides,/////////////
    this.transactionId,/////////////
    this.expiry,
  });

  factory PassModelShuttle.fromJson(Map<String, dynamic> json) {
    return PassModelShuttle(
      passId: json['passId'],
      name: json['name'],
      shortDescription: json['shortDescription'],
      description: json['description'],
      benefits: json['benefits'] != null
          ? List<String>.from(json['benefits'])
          : [],
      thumbImage: json['thumbImage'],
      rideCount: json['rideCount'],
      isPurchased: json['isPurchased'],
      remainingRides: json['remainingRides'],
      transactionId: json['transactionId'],
      pricing: json['pricing'] != null
          ? Pricing.fromJson(json['pricing'])
          : null,
      expiry: json['expiry'] != null
          ? Expiry.fromJson(json['expiry'])
          : null,
    );
  }
}

class Pricing {
  final double? basePricePerRide;
  final double? totalPrice;
  final double? gstPercent;
  final double? gstAmount;
  final double? finalPrice;
  final double? perRidePrice;

  Pricing({
    this.basePricePerRide,
    this.totalPrice,
    this.gstPercent,
    this.gstAmount,
    this.finalPrice,
    this.perRidePrice,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      basePricePerRide: (json['basePricePerRide'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      gstPercent: (json['gstPercent'] as num?)?.toDouble(),
      gstAmount: (json['gstAmount'] as num?)?.toDouble(),
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
      perRidePrice: (json['perRidePrice'] as num?)?.toDouble(),
    );
  }
}

class Expiry {
  final DateTime? expiryDate;
  final String? expiryText;
  final int? validityDays;
  final bool? expiresAtEndOfMonth;

  Expiry({
    this.expiryDate,
    this.expiryText,
    this.validityDays,
    this.expiresAtEndOfMonth,
  });

  factory Expiry.fromJson(Map<String, dynamic> json) {
    return Expiry(
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
      expiryText: json['expiryText'],
      validityDays: json['validityDays'],
      expiresAtEndOfMonth: json['expiresAtEndOfMonth'],
    );
  }
}