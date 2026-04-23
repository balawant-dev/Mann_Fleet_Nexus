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
  List<Segments>? segments;

  Data(
      {this.bookingType,
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
        this.segments});

  Data.fromJson(Map<String, dynamic> json) {
    bookingType = json['bookingType'];
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
  FareBreakdown? fareBreakdown;
  var surgeActive;
  var surgeMultiplier;
  var surgeLabel;
  var surgeType;
  var timeType;
  var cancellationFee;
  var bestValue;

  Segments(
      {this.segmentId,
        this.segmentName,
        this.segmentImage,
        this.maxCapacity,
        this.pricingId,
        this.estimatedFare,
        this.fareBreakdown,
        this.surgeActive,
        this.surgeMultiplier,
        this.surgeLabel,
        this.surgeType,
        this.timeType,
        this.cancellationFee,
        this.bestValue});

  Segments.fromJson(Map<String, dynamic> json) {
    segmentId = json['segmentId'];
    segmentName = json['segmentName'];
    segmentImage = json['segmentImage'];
    maxCapacity = json['maxCapacity'];
    pricingId = json['pricingId'];
    estimatedFare = json['estimatedFare'];
    fareBreakdown = json['fareBreakdown'] != null
        ? new FareBreakdown.fromJson(json['fareBreakdown'])
        : null;
    surgeActive = json['surgeActive'];
    surgeMultiplier = json['surgeMultiplier'];
    surgeLabel = json['surgeLabel'];
    surgeType = json['surgeType'];
    timeType = json['timeType'];
    cancellationFee = json['cancellationFee'];
    bestValue = json['bestValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['segmentId'] = this.segmentId;
    data['segmentName'] = this.segmentName;
    data['segmentImage'] = this.segmentImage;
    data['maxCapacity'] = this.maxCapacity;
    data['pricingId'] = this.pricingId;
    data['estimatedFare'] = this.estimatedFare;
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
  var airportFare;
  var nightFare;
  var totalFare;
  var minFareApplied;
  var cancellationFee;

  FareBreakdown(
      {this.baseFare,
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
        this.minFareApplied,
        this.cancellationFee});

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
    nightFare = json['nightFare'];
    totalFare = json['totalFare'];
    minFareApplied = json['minFareApplied'];
    cancellationFee = json['cancellationFee'];
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
    data['nightFare'] = this.nightFare;
    data['totalFare'] = this.totalFare;
    data['minFareApplied'] = this.minFareApplied;
    data['cancellationFee'] = this.cancellationFee;
    return data;
  }
}
