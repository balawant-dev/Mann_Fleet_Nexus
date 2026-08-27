class OneWayBookingModel {
  var status;
  var message;
  Data? data;

  OneWayBookingModel({this.status, this.message, this.data});

  OneWayBookingModel.fromJson(Map<String, dynamic> json) {
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
  var bookingType;
  var nightCount;
  var bookingTime;
  var timeType;
  var pickup;
  var dropoff;
  var distanceKm;
  var distanceText;
  var durationMins;
  var durationText;
  var trafficCondition;
  var trafficDelayMins;
  var durationWithoutTrafficMins;
  var hasToll;
  var tollAmount;
  var polyline;
  var dataSource;
  var regionName;
  var regionId;
  var isPickupAirport;
  var isDropAirport;
  var isAirportTrip;
  var isGrayMatter;
  WalletBonusRestriction? walletBonusRestriction;
  IntercitySuggestion? intercitySuggestion;
  RoundTripEffective? roundTripEffective;
  List<Segments>? segments;

  Data({
    this.bookingType,
    this.nightCount,
    this.bookingTime,
    this.timeType,
    this.pickup,
    this.dropoff,
    this.distanceKm,
    this.distanceText,
    this.durationMins,
    this.durationText,
    this.trafficCondition,
    this.trafficDelayMins,
    this.durationWithoutTrafficMins,
    this.hasToll,
    this.tollAmount,
    this.polyline,
    this.dataSource,
    this.regionName,
    this.regionId,
    this.isPickupAirport,
    this.isDropAirport,
    this.isAirportTrip,
    this.isGrayMatter,
    this.intercitySuggestion,
    this.roundTripEffective,
    this.walletBonusRestriction,
    this.segments,
  });

  Data.fromJson(Map<String, dynamic> json) {
    bookingType = json['bookingType'];
    nightCount = json['nightCount'];
    bookingTime = json['bookingTime'];
    timeType = json['timeType'];
    pickup = json['pickup'];
    dropoff = json['dropoff'];
    distanceKm = json['distanceKm'];
    distanceText = json['distanceText'];
    durationMins = json['durationMins'];
    durationText = json['durationText'];
    trafficCondition = json['trafficCondition'];
    trafficDelayMins = json['trafficDelayMins'];
    durationWithoutTrafficMins = json['durationWithoutTrafficMins'];
    hasToll = json['hasToll'];
    tollAmount = json['tollAmount'];
    polyline = json['polyline'];
    dataSource = json['dataSource'];
    regionName = json['regionName'];
    regionId = json['regionId'];
    isDropAirport = json['isDropAirport'];
    isPickupAirport = json['isPickupAirport'];
    isAirportTrip = json['isAirportTrip'];
    isGrayMatter = json['isGrayMatter'];
    walletBonusRestriction =
        json['walletBonusRestriction'] != null
            ? new WalletBonusRestriction.fromJson(
              json['walletBonusRestriction'],
            )
            : null;
    roundTripEffective =
        json['roundTripEffective'] != null
            ? RoundTripEffective.fromJson(json['roundTripEffective'])
            : null;
    intercitySuggestion =
        json['intercitySuggestion'] != null
            ? IntercitySuggestion.fromJson(json['intercitySuggestion'])
            : null;
    if (json['segments'] != null) {
      segments = <Segments>[];
      json['segments'].forEach((v) {
        segments!.add(new Segments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingType'] = this.bookingType;
    data['nightCount'] = this.nightCount;
    data['bookingTime'] = this.bookingTime;
    data['timeType'] = this.timeType;
    data['pickup'] = this.pickup;
    data['dropoff'] = this.dropoff;
    data['distanceKm'] = this.distanceKm;
    data['distanceText'] = this.distanceText;
    data['durationMins'] = this.durationMins;
    data['durationText'] = this.durationText;
    data['trafficCondition'] = this.trafficCondition;
    data['trafficDelayMins'] = this.trafficDelayMins;
    data['durationWithoutTrafficMins'] = this.durationWithoutTrafficMins;
    data['hasToll'] = this.hasToll;
    data['tollAmount'] = this.tollAmount;
    data['polyline'] = this.polyline;
    data['dataSource'] = this.dataSource;
    data['regionName'] = this.regionName;
    data['regionId'] = this.regionId;
    data['isGrayMatter'] = this.isGrayMatter;
    data['isDropAirport'] = this.isDropAirport;
    data['isPickupAirport'] = this.isPickupAirport;
    if (this.walletBonusRestriction != null) {
      data['walletBonusRestriction'] = this.walletBonusRestriction!.toJson();
    }
    if (roundTripEffective != null) {
      data['roundTripEffective'] = roundTripEffective!.toJson();
    }
    if (intercitySuggestion != null) {
      data['intercitySuggestion'] = intercitySuggestion!.toJson();
    }
    data['isAirportTrip'] = this.isAirportTrip;
    if (this.segments != null) {
      data['segments'] = this.segments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Segments {
  var segmentId;
  var segmentName;
  var segmentImage;
  var maxCapacity;
  var pricingId;
  var estimatedFare;
  var message;
  FareBreakdown? fareBreakdown;
  var surgeActive;
  var surgeMultiplier;
  var surgeLabel;
  var surgeType;
  var timeType;
  var cancellationFee;
  var bestValue;
  var finalPayableAmount;
  var walletDiscount;

  Segments({
    this.segmentId,
    this.segmentName,
    this.segmentImage,
    this.maxCapacity,
    this.pricingId,
    this.estimatedFare,
    this.message,
    this.fareBreakdown,
    this.surgeActive,
    this.surgeMultiplier,
    this.surgeLabel,
    this.surgeType,
    this.timeType,
    this.cancellationFee,
    this.bestValue,
    this.finalPayableAmount,
    this.walletDiscount,
  });

  Segments.fromJson(Map<String, dynamic> json) {
    segmentId = json['segmentId'];
    segmentName = json['segmentName'];
    segmentImage = json['segmentImage'];
    maxCapacity = json['maxCapacity'];
    pricingId = json['pricingId'];
    estimatedFare = json['estimatedFare'];
    message = json['message'];
    fareBreakdown =
        json['fareBreakdown'] != null
            ? new FareBreakdown.fromJson(json['fareBreakdown'])
            : null;
    surgeActive = json['surgeActive'];
    surgeMultiplier = json['surgeMultiplier'];
    surgeLabel = json['surgeLabel'];
    surgeType = json['surgeType'];
    timeType = json['timeType'];
    cancellationFee = json['cancellationFee'];
    bestValue = json['bestValue'];
    finalPayableAmount = json['finalPayableAmount'];
    walletDiscount = json['walletDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['segmentId'] = this.segmentId;
    data['segmentName'] = this.segmentName;
    data['segmentImage'] = this.segmentImage;
    data['maxCapacity'] = this.maxCapacity;
    data['pricingId'] = this.pricingId;
    data['estimatedFare'] = this.estimatedFare;
    data['message'] = this.message;
    if (this.fareBreakdown != null) {
      data['fareBreakdown'] = this.fareBreakdown!.toJson();
    }
    data['surgeActive'] = this.surgeActive;
    data['surgeMultiplier'] = this.surgeMultiplier;
    data['surgeLabel'] = this.surgeLabel;
    data['surgeType'] = this.surgeType;
    data['timeType'] = this.timeType;
    data['cancellationFee'] = this.cancellationFee;
    data['bestValue'] = this.bestValue;
    data['finalPayableAmount'] = this.finalPayableAmount;
    data['walletDiscount'] = this.walletDiscount;
    return data;
  }
}

class FareBreakdown {
  var baseFare;
  var distanceCharge;
  var timeCharge;
  var surgeCharge;
  var subtotal;
  var gstPercent;
  var gstAmount;
  var tollCharge;
  var surchargeAmount;
  var mcdTollCharge;
  var airportFare;
  var nightFare;
  var totalFare;
  var minFareApplied;
  var cancellationFee;
  RoundTripDetail? roundTripDetail;
  FareBreakdown({
    this.baseFare,
    this.distanceCharge,
    this.timeCharge,
    this.surgeCharge,
    this.subtotal,
    this.gstPercent,
    this.gstAmount,
    this.tollCharge,
    this.surchargeAmount,
    this.airportFare,
    this.nightFare,
    this.totalFare,
    this.mcdTollCharge,
    this.minFareApplied,
    this.cancellationFee,
    this.roundTripDetail,

  });

  FareBreakdown.fromJson(Map<String, dynamic> json) {
    baseFare = json['baseFare'];
    distanceCharge = json['distanceCharge'];
    timeCharge = json['timeCharge'];
    surgeCharge = json['surgeCharge'];
    subtotal = json['subtotal'];
    gstPercent = json['gstPercent'];
    gstAmount = json['gstAmount'];
    tollCharge = json['tollCharge'];
    surchargeAmount = json['surchargeAmount'];
    airportFare = json['airportFare'];
    mcdTollCharge = json['mcdTollCharge'];
    nightFare = json['nightFare'];
    totalFare = json['totalFare'];
    minFareApplied = json['minFareApplied'];
    cancellationFee = json['cancellationFee'];
    roundTripDetail = json['roundTripDetail'] != null
        ? RoundTripDetail.fromJson(json['roundTripDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['baseFare'] = this.baseFare;
    data['distanceCharge'] = this.distanceCharge;
    data['timeCharge'] = this.timeCharge;
    data['surgeCharge'] = this.surgeCharge;
    data['subtotal'] = this.subtotal;
    data['gstPercent'] = this.gstPercent;
    data['gstAmount'] = this.gstAmount;
    data['tollCharge'] = this.tollCharge;
    data['surchargeAmount'] = this.surchargeAmount;
    data['airportFare'] = this.airportFare;
    data['mcdTollCharge'] = this.mcdTollCharge;
    data['nightFare'] = this.nightFare;
    data['totalFare'] = this.totalFare;
    data['minFareApplied'] = this.minFareApplied;
    data['cancellationFee'] = this.cancellationFee;
    if (roundTripDetail != null) {
      data['roundTripDetail'] = roundTripDetail!.toJson();
    }
    return data;
  }
}
class RoundTripDetail {
  double? oneWayDistanceKm;
  double? effectiveDistanceKm;
  int? oneWayTravelMins;
  int? idleMinsBetweenLegs;
  int? returnTravelMins;
  int? effectiveTotalMins;

  RoundTripDetail({
    this.oneWayDistanceKm,
    this.effectiveDistanceKm,
    this.oneWayTravelMins,
    this.idleMinsBetweenLegs,
    this.returnTravelMins,
    this.effectiveTotalMins,
  });

  RoundTripDetail.fromJson(Map<String, dynamic> json) {
    oneWayDistanceKm = (json['oneWayDistanceKm'] as num?)?.toDouble();
    effectiveDistanceKm =
        (json['effectiveDistanceKm'] as num?)?.toDouble();
    oneWayTravelMins = json['oneWayTravelMins'];
    idleMinsBetweenLegs = json['idleMinsBetweenLegs'];
    returnTravelMins = json['returnTravelMins'];
    effectiveTotalMins = json['effectiveTotalMins'];
  }

  Map<String, dynamic> toJson() {
    return {
      'oneWayDistanceKm': oneWayDistanceKm,
      'effectiveDistanceKm': effectiveDistanceKm,
      'oneWayTravelMins': oneWayTravelMins,
      'idleMinsBetweenLegs': idleMinsBetweenLegs,
      'returnTravelMins': returnTravelMins,
      'effectiveTotalMins': effectiveTotalMins,
    };
  }
}
class WalletBonusRestriction {
  var active;
  var message;
  var minFareRequired;

  WalletBonusRestriction({this.active, this.message, this.minFareRequired});

  WalletBonusRestriction.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    message = json['message'];
    minFareRequired = json['minFareRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['message'] = this.message;
    data['minFareRequired'] = this.minFareRequired;

    return data;
  }
}



class IntercitySuggestion {
  var message;
  var suggestedBookingType;
  var reason;

  IntercitySuggestion({this.message, this.suggestedBookingType, this.reason});

  IntercitySuggestion.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    suggestedBookingType = json['suggestedBookingType'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    data['suggestedBookingType'] = suggestedBookingType;
    data['reason'] = reason;
    return data;
  }
}

class RoundTripEffective {
  var effectiveDistanceKm;
  var effectiveTotalMins;
  var idleMinsBetweenLegs;
  var returnTravelMins;
  var oneWayDistanceKm;
  var oneWayTravelMins;

  RoundTripEffective({
    this.effectiveDistanceKm,
    this.effectiveTotalMins,
    this.idleMinsBetweenLegs,
    this.returnTravelMins,
    this.oneWayDistanceKm,
    this.oneWayTravelMins,
  });

  RoundTripEffective.fromJson(Map<String, dynamic> json) {
    effectiveDistanceKm = json['effectiveDistanceKm'];
    effectiveTotalMins = json['effectiveTotalMins'];
    idleMinsBetweenLegs = json['idleMinsBetweenLegs'];
    returnTravelMins = json['returnTravelMins'];
    oneWayDistanceKm = json['oneWayDistanceKm'];
    oneWayTravelMins = json['oneWayTravelMins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['effectiveDistanceKm'] = effectiveDistanceKm;
    data['effectiveTotalMins'] = effectiveTotalMins;
    data['idleMinsBetweenLegs'] = idleMinsBetweenLegs;
    data['returnTravelMins'] = returnTravelMins;
    data['oneWayDistanceKm'] = oneWayDistanceKm;
    data['oneWayTravelMins'] = oneWayTravelMins;
    return data;
  }
}
