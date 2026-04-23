
class CreateBookingSummeryModel {
  var status;
  var message;
  Data? data;

  CreateBookingSummeryModel({this.status, this.message, this.data});

  CreateBookingSummeryModel.fromJson(Map<String, dynamic> json) {
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
  var bookingId;
  var bookingNumber;
  var paymentStatus;
  var assignmentStatus;
  var tripStatus;
  var overallStatus;
  var scheduledAt;
  var isScheduled;
  Razorpay? razorpay;
  Pickup? pickup;
  Pickup? dropoff;
  var bookingType;
  var estimatedKm;
  var estimatedMins;
  var estimatedFare;
  FareBreakup? fareBreakup;
  var createdAt;
  var tripStartOtp;
  var tripEndOtp;

  Data(
      {this.bookingId,
        this.bookingNumber,
        this.paymentStatus,
        this.assignmentStatus,
        this.tripStatus,
        this.overallStatus,
        this.scheduledAt,
        this.isScheduled,
        this.razorpay,
        this.pickup,
        this.dropoff,
        this.bookingType,
        this.estimatedKm,
        this.estimatedMins,
        this.estimatedFare,
        this.fareBreakup,
        this.createdAt,
        this.tripStartOtp,
        this.tripEndOtp});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    bookingNumber = json['bookingNumber'];
    paymentStatus = json['paymentStatus'];
    assignmentStatus = json['assignmentStatus'];
    tripStatus = json['tripStatus'];
    overallStatus = json['overallStatus'];
    scheduledAt = json['scheduledAt'];
    isScheduled = json['isScheduled'];
    razorpay = json['razorpay'] != null
        ? new Razorpay.fromJson(json['razorpay'])
        : null;
    pickup =
    json['pickup'] != null ? new Pickup.fromJson(json['pickup']) : null;
    dropoff =
    json['dropoff'] != null ? new Pickup.fromJson(json['dropoff']) : null;
    bookingType = json['bookingType'];
    estimatedKm = json['estimatedKm'];
    estimatedMins = json['estimatedMins'];
    estimatedFare = json['estimatedFare'];
    fareBreakup = json['fareBreakup'] != null
        ? new FareBreakup.fromJson(json['fareBreakup'])
        : null;
    createdAt = json['createdAt'];
    tripStartOtp = json['tripStartOtp'];
    tripEndOtp = json['tripEndOtp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    data['bookingNumber'] = this.bookingNumber;
    data['paymentStatus'] = this.paymentStatus;
    data['assignmentStatus'] = this.assignmentStatus;
    data['tripStatus'] = this.tripStatus;
    data['overallStatus'] = this.overallStatus;
    data['scheduledAt'] = this.scheduledAt;
    data['isScheduled'] = this.isScheduled;
    if (this.razorpay != null) {
      data['razorpay'] = this.razorpay!.toJson();
    }
    if (this.pickup != null) {
      data['pickup'] = this.pickup!.toJson();
    }
    if (this.dropoff != null) {
      data['dropoff'] = this.dropoff!.toJson();
    }
    data['bookingType'] = this.bookingType;
    data['estimatedKm'] = this.estimatedKm;
    data['estimatedMins'] = this.estimatedMins;
    data['estimatedFare'] = this.estimatedFare;
    if (this.fareBreakup != null) {
      data['fareBreakup'] = this.fareBreakup!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['tripStartOtp'] = this.tripStartOtp;
    data['tripEndOtp'] = this.tripEndOtp;
    return data;
  }
}

class Razorpay {
  var orderId;
  var amount;
  var currency;
  var key;

  Razorpay({this.orderId, this.amount, this.currency, this.key});

  Razorpay.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    amount = json['amount'];
    currency = json['currency'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['key'] = this.key;
    return data;
  }
}

class Pickup {
  var lat;
  var lng;
  var address;

  Pickup({this.lat, this.lng, this.address});

  Pickup.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    return data;
  }
}

class FareBreakup {
  var baseFare;
  var distanceCharge;
  var timeCharge;
  var surgeCharge;
  var subtotal;
  var gstAmount;
  var tollCharge;
  var totalFare;

  FareBreakup(
      {this.baseFare,
        this.distanceCharge,
        this.timeCharge,
        this.surgeCharge,
        this.subtotal,
        this.gstAmount,
        this.tollCharge,
        this.totalFare});

  FareBreakup.fromJson(Map<String, dynamic> json) {
    baseFare = json['baseFare'];
    distanceCharge = json['distanceCharge'];
    timeCharge = json['timeCharge'];
    surgeCharge = json['surgeCharge'];
    subtotal = json['subtotal'];
    gstAmount = json['gstAmount'];
    tollCharge = json['tollCharge'];
    totalFare = json['totalFare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['baseFare'] = this.baseFare;
    data['distanceCharge'] = this.distanceCharge;
    data['timeCharge'] = this.timeCharge;
    data['surgeCharge'] = this.surgeCharge;
    data['subtotal'] = this.subtotal;
    data['gstAmount'] = this.gstAmount;
    data['tollCharge'] = this.tollCharge;
    data['totalFare'] = this.totalFare;
    return data;
  }
}
