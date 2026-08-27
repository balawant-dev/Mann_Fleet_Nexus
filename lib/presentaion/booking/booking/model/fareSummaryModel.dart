class FareSummaryModel {
  var status;
  var message;
  Data? data;

  FareSummaryModel({this.status, this.message, this.data});

  FareSummaryModel.fromJson(Map<String, dynamic> json) {
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
  var segmentId;
  var segmentName;
  var segmentImage;
  var maxCapacity;
  var bookingType;
  var timeType;
  var regionId;
  var distanceKm;
  var durationMins;
  RoundTripEffective? roundTripEffective;
  var estimatedFare;
  FareBreakdown? fareBreakdown;
  var walletBalance;
  var walletDiscount;
  var couponDiscount;
  var finalPayableAmount;
  var bonusRestricted;
  var signupBonusMinFare;
  var couponApplied;
  var couponCode;
  var couponStatus;
  var tollAmount;
  var mcdTollCharge;
  var nightCount;
  var nightFare;
  var bookingTime;
  var returnDateTime;
  var isPickupAirport;
  var isDropAirport;
  var isAirportTrip;

  Data(
      {this.segmentId,
        this.segmentName,
        this.segmentImage,
        this.maxCapacity,
        this.bookingType,
        this.timeType,
        this.regionId,
        this.distanceKm,
        this.durationMins,
        this.roundTripEffective,
        this.estimatedFare,
        this.fareBreakdown,
        this.walletBalance,
        this.walletDiscount,
        this.couponDiscount,
        this.finalPayableAmount,
        this.bonusRestricted,
        this.signupBonusMinFare,
        this.couponApplied,
        this.couponCode,
        this.couponStatus,
        this.tollAmount,
        this.mcdTollCharge,
        this.nightCount,
        this.nightFare,
        this.bookingTime,
        this.returnDateTime,
        this.isPickupAirport,
        this.isDropAirport,
        this.isAirportTrip});

  Data.fromJson(Map<String, dynamic> json) {
    segmentId = json['segmentId'];
    segmentName = json['segmentName'];
    segmentImage = json['segmentImage'];
    maxCapacity = json['maxCapacity'];
    bookingType = json['bookingType'];
    timeType = json['timeType'];
    regionId = json['regionId'];
    distanceKm = json['distanceKm'];
    durationMins = json['durationMins'];
    roundTripEffective = json['roundTripEffective'] != null
        ? new RoundTripEffective.fromJson(json['roundTripEffective'])
        : null;
    estimatedFare = json['estimatedFare'];
    fareBreakdown = json['fareBreakdown'] != null
        ? new FareBreakdown.fromJson(json['fareBreakdown'])
        : null;
    walletBalance = json['walletBalance'];
    walletDiscount = json['walletDiscount'];
    couponDiscount = json['couponDiscount'];
    finalPayableAmount = json['finalPayableAmount'];
    bonusRestricted = json['bonusRestricted'];
    signupBonusMinFare = json['signupBonusMinFare'];
    couponApplied = json['couponApplied'];
    couponCode = json['couponCode'];
    couponStatus = json['couponStatus'];
    tollAmount = json['tollAmount'];
    mcdTollCharge = json['mcdTollCharge'];
    nightCount = json['nightCount'];
    nightFare = json['nightFare'];
    bookingTime = json['bookingTime'];
    returnDateTime = json['returnDateTime'];
    isPickupAirport = json['isPickupAirport'];
    isDropAirport = json['isDropAirport'];
    isAirportTrip = json['isAirportTrip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['segmentId'] = this.segmentId;
    data['segmentName'] = this.segmentName;
    data['segmentImage'] = this.segmentImage;
    data['maxCapacity'] = this.maxCapacity;
    data['bookingType'] = this.bookingType;
    data['timeType'] = this.timeType;
    data['regionId'] = this.regionId;
    data['distanceKm'] = this.distanceKm;
    data['durationMins'] = this.durationMins;
    if (this.roundTripEffective != null) {
      data['roundTripEffective'] = this.roundTripEffective!.toJson();
    }
    data['estimatedFare'] = this.estimatedFare;
    if (this.fareBreakdown != null) {
      data['fareBreakdown'] = this.fareBreakdown!.toJson();
    }
    data['walletBalance'] = this.walletBalance;
    data['walletDiscount'] = this.walletDiscount;
    data['couponDiscount'] = this.couponDiscount;
    data['finalPayableAmount'] = this.finalPayableAmount;
    data['bonusRestricted'] = this.bonusRestricted;
    data['signupBonusMinFare'] = this.signupBonusMinFare;
    data['couponApplied'] = this.couponApplied;
    data['couponCode'] = this.couponCode;
    data['couponStatus'] = this.couponStatus;
    data['tollAmount'] = this.tollAmount;
    data['mcdTollCharge'] = this.mcdTollCharge;
    data['nightCount'] = this.nightCount;
    data['nightFare'] = this.nightFare;
    data['bookingTime'] = this.bookingTime;
    data['returnDateTime'] = this.returnDateTime;
    data['isPickupAirport'] = this.isPickupAirport;
    data['isDropAirport'] = this.isDropAirport;
    data['isAirportTrip'] = this.isAirportTrip;
    return data;
  }
}

class RoundTripEffective {
  var effectiveDistanceKm;
  var effectiveTotalMins;
  var idleMinsBetweenLegs;
  var returnTravelMins;

  RoundTripEffective(
      {this.effectiveDistanceKm,
        this.effectiveTotalMins,
        this.idleMinsBetweenLegs,
        this.returnTravelMins});

  RoundTripEffective.fromJson(Map<String, dynamic> json) {
    effectiveDistanceKm = json['effectiveDistanceKm'];
    effectiveTotalMins = json['effectiveTotalMins'];
    idleMinsBetweenLegs = json['idleMinsBetweenLegs'];
    returnTravelMins = json['returnTravelMins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['effectiveDistanceKm'] = this.effectiveDistanceKm;
    data['effectiveTotalMins'] = this.effectiveTotalMins;
    data['idleMinsBetweenLegs'] = this.idleMinsBetweenLegs;
    data['returnTravelMins'] = this.returnTravelMins;
    return data;
  }
}

class FareBreakdown {
  var baseFare;
  var distanceCharge;
  var timeCharge;
  var rideCharge;
  var baseFallbackActive;
  var walletUsed;
  var couponDiscount;
  var netTaxableBase;
  var surgeCharge;
  var gstPercent;
  var gstAmount;
  var subtotal;
  var tollCharge;
  var mcdTollCharge;
  var surchargeAmount;
  var airportFare;
  var nightFare;
  var totalFare;
  var finalPayableAmount;
  var minFareApplied;
  var cancellationFee;
  RoundTripDetail? roundTripDetail;

  FareBreakdown(
      {this.baseFare,
        this.distanceCharge,
        this.timeCharge,
        this.rideCharge,
        this.baseFallbackActive,
        this.walletUsed,
        this.couponDiscount,
        this.netTaxableBase,
        this.surgeCharge,
        this.gstPercent,
        this.gstAmount,
        this.subtotal,
        this.tollCharge,
        this.mcdTollCharge,
        this.surchargeAmount,
        this.airportFare,
        this.nightFare,
        this.totalFare,
        this.finalPayableAmount,
        this.minFareApplied,
        this.cancellationFee,
        this.roundTripDetail});

  FareBreakdown.fromJson(Map<String, dynamic> json) {
    baseFare = json['baseFare'];
    distanceCharge = json['distanceCharge'];
    timeCharge = json['timeCharge'];
    rideCharge = json['rideCharge'];
    baseFallbackActive = json['baseFallbackActive'];
    walletUsed = json['walletUsed'];
    couponDiscount = json['couponDiscount'];
    netTaxableBase = json['netTaxableBase'];
    surgeCharge = json['surgeCharge'];
    gstPercent = json['gstPercent'];
    gstAmount = json['gstAmount'];
    subtotal = json['subtotal'];
    tollCharge = json['tollCharge'];
    mcdTollCharge = json['mcdTollCharge'];
    surchargeAmount = json['surchargeAmount'];
    airportFare = json['airportFare'];
    nightFare = json['nightFare'];
    totalFare = json['totalFare'];
    finalPayableAmount = json['finalPayableAmount'];
    minFareApplied = json['minFareApplied'];
    cancellationFee = json['cancellationFee'];
    roundTripDetail = json['roundTripDetail'] != null
        ? new RoundTripDetail.fromJson(json['roundTripDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['baseFare'] = this.baseFare;
    data['distanceCharge'] = this.distanceCharge;
    data['timeCharge'] = this.timeCharge;
    data['rideCharge'] = this.rideCharge;
    data['baseFallbackActive'] = this.baseFallbackActive;
    data['walletUsed'] = this.walletUsed;
    data['couponDiscount'] = this.couponDiscount;
    data['netTaxableBase'] = this.netTaxableBase;
    data['surgeCharge'] = this.surgeCharge;
    data['gstPercent'] = this.gstPercent;
    data['gstAmount'] = this.gstAmount;
    data['subtotal'] = this.subtotal;
    data['tollCharge'] = this.tollCharge;
    data['mcdTollCharge'] = this.mcdTollCharge;
    data['surchargeAmount'] = this.surchargeAmount;
    data['airportFare'] = this.airportFare;
    data['nightFare'] = this.nightFare;
    data['totalFare'] = this.totalFare;
    data['finalPayableAmount'] = this.finalPayableAmount;
    data['minFareApplied'] = this.minFareApplied;
    data['cancellationFee'] = this.cancellationFee;
    if (this.roundTripDetail != null) {
      data['roundTripDetail'] = this.roundTripDetail!.toJson();
    }
    return data;
  }
}

class RoundTripDetail {
  var oneWayDistanceKm;
  var effectiveDistanceKm;
  var oneWayTravelMins;
  var idleMinsBetweenLegs;
  var returnTravelMins;
  var effectiveTotalMins;

  RoundTripDetail(
      {this.oneWayDistanceKm,
        this.effectiveDistanceKm,
        this.oneWayTravelMins,
        this.idleMinsBetweenLegs,
        this.returnTravelMins,
        this.effectiveTotalMins});

  RoundTripDetail.fromJson(Map<String, dynamic> json) {
    oneWayDistanceKm = json['oneWayDistanceKm'];
    effectiveDistanceKm = json['effectiveDistanceKm'];
    oneWayTravelMins = json['oneWayTravelMins'];
    idleMinsBetweenLegs = json['idleMinsBetweenLegs'];
    returnTravelMins = json['returnTravelMins'];
    effectiveTotalMins = json['effectiveTotalMins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oneWayDistanceKm'] = this.oneWayDistanceKm;
    data['effectiveDistanceKm'] = this.effectiveDistanceKm;
    data['oneWayTravelMins'] = this.oneWayTravelMins;
    data['idleMinsBetweenLegs'] = this.idleMinsBetweenLegs;
    data['returnTravelMins'] = this.returnTravelMins;
    data['effectiveTotalMins'] = this.effectiveTotalMins;
    return data;
  }
}
