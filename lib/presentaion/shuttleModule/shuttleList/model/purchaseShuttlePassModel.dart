class PurchaseShuttlePassModel {
  var status;
  var message;
  Data? data;
  ErrorData? error;

  PurchaseShuttlePassModel({
    this.status,
    this.message,
    this.data,
    this.error,
  });

  PurchaseShuttlePassModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    data = json['data'] != null
        ? Data.fromJson(json['data'])
        : null;

    error = json['error'] != null
        ? ErrorData.fromJson(json['error'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['status'] = status;
    json['message'] = message;

    if (data != null) {
      json['data'] = data!.toJson();
    }

    if (error != null) {
      json['error'] = error!.toJson();
    }

    return json;
  }
}
class ErrorData {
  var statusCode;
  var status;
  var message;
  var name;

  ErrorData({
    this.statusCode,
    this.status,
    this.message,
    this.name,
  });

  ErrorData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'status': status,
      'message': message,
      'name': name,
    };
  }
}

class Data {
  var transactionId;
  Pass? pass;
  Route? route;
  Shift? shift;
  Journey? journey;
  Pricing? pricing;
  Validity? validity;
  Razorpay? razorpay;

  Data(
      {this.transactionId,
        this.pass,
        this.route,
        this.shift,
        this.journey,
        this.pricing,
        this.validity,
        this.razorpay});

  Data.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    pass = json['pass'] != null ? new Pass.fromJson(json['pass']) : null;
    route = json['route'] != null ? new Route.fromJson(json['route']) : null;
    shift = json['shift'] != null ? new Shift.fromJson(json['shift']) : null;
    journey =
    json['journey'] != null ? new Journey.fromJson(json['journey']) : null;
    pricing =
    json['pricing'] != null ? new Pricing.fromJson(json['pricing']) : null;
    validity = json['validity'] != null
        ? new Validity.fromJson(json['validity'])
        : null;
    razorpay = json['razorpay'] != null
        ? new Razorpay.fromJson(json['razorpay'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    if (this.pass != null) {
      data['pass'] = this.pass!.toJson();
    }
    if (this.route != null) {
      data['route'] = this.route!.toJson();
    }
    if (this.shift != null) {
      data['shift'] = this.shift!.toJson();
    }
    if (this.journey != null) {
      data['journey'] = this.journey!.toJson();
    }
    if (this.pricing != null) {
      data['pricing'] = this.pricing!.toJson();
    }
    if (this.validity != null) {
      data['validity'] = this.validity!.toJson();
    }
    if (this.razorpay != null) {
      data['razorpay'] = this.razorpay!.toJson();
    }
    return data;
  }
}

class Pass {
  var sId;
  var name;
  var shortDescription;
  var rideCount;
  var validityDays;
  var thumbImage;

  Pass(
      {this.sId,
        this.name,
        this.shortDescription,
        this.rideCount,
        this.validityDays,
        this.thumbImage});

  Pass.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    shortDescription = json['shortDescription'];
    rideCount = json['rideCount'];
    validityDays = json['validityDays'];
    thumbImage = json['thumbImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['shortDescription'] = this.shortDescription;
    data['rideCount'] = this.rideCount;
    data['validityDays'] = this.validityDays;
    data['thumbImage'] = this.thumbImage;
    return data;
  }
}

class Route {
  var sId;
  var name;

  Route({this.sId, this.name});

  Route.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Shift {
  var sId;
  var shiftName;

  Shift({this.sId, this.shiftName});

  Shift.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    shiftName = json['shiftName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['shiftName'] = this.shiftName;
    return data;
  }
}

class Journey {
  var source;
  var destination;
  var pricePerRide;

  Journey({this.source, this.destination, this.pricePerRide});

  Journey.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    destination = json['destination'];
    pricePerRide = json['pricePerRide'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source'] = this.source;
    data['destination'] = this.destination;
    data['pricePerRide'] = this.pricePerRide;
    return data;
  }
}

class Pricing {
  var baseAmount;
  var gstPercent;
  var gstAmount;
  var totalAmount;

  Pricing({this.baseAmount, this.gstPercent, this.gstAmount, this.totalAmount});

  Pricing.fromJson(Map<String, dynamic> json) {
    baseAmount = json['baseAmount'];
    gstPercent = json['gstPercent'];
    gstAmount = json['gstAmount'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['baseAmount'] = this.baseAmount;
    data['gstPercent'] = this.gstPercent;
    data['gstAmount'] = this.gstAmount;
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}

class Validity {
  var purchaseDate;
  var expiryDate;

  Validity({this.purchaseDate, this.expiryDate});

  Validity.fromJson(Map<String, dynamic> json) {
    purchaseDate = json['purchaseDate'];
    expiryDate = json['expiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purchaseDate'] = this.purchaseDate;
    data['expiryDate'] = this.expiryDate;
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
