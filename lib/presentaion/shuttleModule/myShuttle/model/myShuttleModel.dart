// class MyShuttleModel {
//   bool? status;
//   var totalResult;
//   var totalPage;
//   var currentPage;
//   var message;
//   List<MyShuttleData>? data;
//
//   MyShuttleModel(
//       {this.status,
//         this.totalResult,
//         this.totalPage,
//         this.currentPage,
//         this.message,
//         this.data});
//
//   MyShuttleModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     totalResult = json['totalResult'];
//     totalPage = json['totalPage'];
//     currentPage = json['currentPage'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <MyShuttleData>[];
//       json['data'].forEach((v) {
//         data!.add(new MyShuttleData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['totalResult'] = this.totalResult;
//     data['totalPage'] = this.totalPage;
//     data['currentPage'] = this.currentPage;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class MyShuttleData {
//   var sId;
//   ShuttlePass? shuttlePass;
//   var user;
//   var source;
//   var destination;
//   ShuttleRoute? shuttleRoute;
//   var pricePerRide;
//   var totalRides;
//   var remainingRides;
//   var baseAmount;
//   var gstAmount;
//   var gstPercent;
//   var purchaseDate;
//   var expiryDate;
//   var bookingDate;
//   var totalAmount;
//   var paymentStatus;
//   var paymentMethod;
//   var orderId;
//   var transactionId;
//   var createdAt;
//   var updatedAt;
//   var iV;
//
//   MyShuttleData(
//       {this.sId,
//         this.shuttlePass,
//         this.user,
//         this.source,
//         this.destination,
//         this.shuttleRoute,
//         this.pricePerRide,
//         this.totalRides,
//         this.remainingRides,
//         this.baseAmount,
//         this.gstAmount,
//         this.gstPercent,
//         this.purchaseDate,
//         this.expiryDate,
//         this.bookingDate,
//         this.totalAmount,
//         this.paymentStatus,
//         this.paymentMethod,
//         this.orderId,
//         this.transactionId,
//         this.createdAt,
//         this.updatedAt,
//         this.iV});
//
//   MyShuttleData.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     shuttlePass = json['shuttlePass'] != null
//         ? new ShuttlePass.fromJson(json['shuttlePass'])
//         : null;
//     user = json['user'];
//     source = json['source'];
//     destination = json['destination'];
//     shuttleRoute = json['shuttleRoute'] != null
//         ? new ShuttleRoute.fromJson(json['shuttleRoute'])
//         : null;
//     pricePerRide = json['pricePerRide'];
//     totalRides = json['totalRides'];
//     remainingRides = json['remainingRides'];
//     baseAmount = json['baseAmount'];
//     gstAmount = json['gstAmount'];
//     gstPercent = json['gstPercent'];
//     purchaseDate = json['purchaseDate'];
//     expiryDate = json['expiryDate'];
//     bookingDate = json['bookingDate'];
//     totalAmount = json['totalAmount'];
//     paymentStatus = json['paymentStatus'];
//     paymentMethod = json['paymentMethod'];
//     orderId = json['orderId'];
//     transactionId = json['transactionId'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     if (this.shuttlePass != null) {
//       data['shuttlePass'] = this.shuttlePass!.toJson();
//     }
//     data['user'] = this.user;
//     data['source'] = this.source;
//     data['destination'] = this.destination;
//     if (this.shuttleRoute != null) {
//       data['shuttleRoute'] = this.shuttleRoute!.toJson();
//     }
//     data['pricePerRide'] = this.pricePerRide;
//     data['totalRides'] = this.totalRides;
//     data['remainingRides'] = this.remainingRides;
//     data['baseAmount'] = this.baseAmount;
//     data['gstAmount'] = this.gstAmount;
//     data['gstPercent'] = this.gstPercent;
//     data['purchaseDate'] = this.purchaseDate;
//     data['expiryDate'] = this.expiryDate;
//     data['bookingDate'] = this.bookingDate;
//     data['totalAmount'] = this.totalAmount;
//     data['paymentStatus'] = this.paymentStatus;
//     data['paymentMethod'] = this.paymentMethod;
//     data['orderId'] = this.orderId;
//     data['transactionId'] = this.transactionId;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
//
// class ShuttlePass {
//   var sId;
//   var name;
//   var shortDescription;
//   var thumbImage;
//   var rideCount;
//   var validityDays;
//
//   ShuttlePass(
//       {this.sId,
//         this.name,
//         this.shortDescription,
//         this.thumbImage,
//         this.rideCount,
//         this.validityDays});
//
//   ShuttlePass.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     shortDescription = json['shortDescription'];
//     thumbImage = json['thumbImage'];
//     rideCount = json['rideCount'];
//     validityDays = json['validityDays'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['shortDescription'] = this.shortDescription;
//     data['thumbImage'] = this.thumbImage;
//     data['rideCount'] = this.rideCount;
//     data['validityDays'] = this.validityDays;
//     return data;
//   }
// }
//
// class ShuttleRoute {
//   var sId;
//   var name;
//
//   ShuttleRoute({this.sId, this.name});
//
//   ShuttleRoute.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     return data;
//   }
// }
class MyShuttleModel {
  bool? status;
  var totalResult;
  var totalPage;
  var currentPage;
  var message;
  List<MyShuttleData>? data;

  MyShuttleModel(
      {this.status,
        this.totalResult,
        this.totalPage,
        this.currentPage,
        this.message,
        this.data});

  MyShuttleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    currentPage = json['currentPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MyShuttleData>[];
      json['data'].forEach((v) {
        data!.add(new MyShuttleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResult'] = this.totalResult;
    data['totalPage'] = this.totalPage;
    data['currentPage'] = this.currentPage;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyShuttleData {
  var sId;
  ShuttlePass? shuttlePass;
  var user;
  var source;
  var destination;
  ShuttleRoute? shuttleRoute;
  ShuttleShift? shuttleShift;
  var bookingDate;
  var pricePerRide;
  var totalRides;
  var remainingRides;
  var baseAmount;
  var gstAmount;
  var gstPercent;
  var purchaseDate;
  var expiryDate;
  var totalAmount;
  var paymentStatus;
  var paymentMethod;
  var orderId;
  var createdAt;
  var updatedAt;
  var iV;
  var transactionId;

  MyShuttleData(
      {this.sId,
        this.shuttlePass,
        this.user,
        this.source,
        this.destination,
        this.shuttleRoute,
        this.shuttleShift,
        this.bookingDate,
        this.pricePerRide,
        this.totalRides,
        this.remainingRides,
        this.baseAmount,
        this.gstAmount,
        this.gstPercent,
        this.purchaseDate,
        this.expiryDate,
        this.totalAmount,
        this.paymentStatus,
        this.paymentMethod,
        this.orderId,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.transactionId});

  MyShuttleData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    shuttlePass = json['shuttlePass'] != null
        ? new ShuttlePass.fromJson(json['shuttlePass'])
        : null;
    user = json['user'];
    source = json['source'];
    destination = json['destination'];
    shuttleRoute = json['shuttleRoute'] != null
        ? new ShuttleRoute.fromJson(json['shuttleRoute'])
        : null;
    shuttleShift = json['shuttleShift'] != null
        ? new ShuttleShift.fromJson(json['shuttleShift'])
        : null;
    bookingDate = json['bookingDate'];
    pricePerRide = json['pricePerRide'];
    totalRides = json['totalRides'];
    remainingRides = json['remainingRides'];
    baseAmount = json['baseAmount'];
    gstAmount = json['gstAmount'];
    gstPercent = json['gstPercent'];
    purchaseDate = json['purchaseDate'];
    expiryDate = json['expiryDate'];
    totalAmount = json['totalAmount'];
    paymentStatus = json['paymentStatus'];
    paymentMethod = json['paymentMethod'];
    orderId = json['orderId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    transactionId = json['transactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.shuttlePass != null) {
      data['shuttlePass'] = this.shuttlePass!.toJson();
    }
    data['user'] = this.user;
    data['source'] = this.source;
    data['destination'] = this.destination;
    if (this.shuttleRoute != null) {
      data['shuttleRoute'] = this.shuttleRoute!.toJson();
    }
    if (this.shuttleShift != null) {
      data['shuttleShift'] = this.shuttleShift!.toJson();
    }
    data['bookingDate'] = this.bookingDate;
    data['pricePerRide'] = this.pricePerRide;
    data['totalRides'] = this.totalRides;
    data['remainingRides'] = this.remainingRides;
    data['baseAmount'] = this.baseAmount;
    data['gstAmount'] = this.gstAmount;
    data['gstPercent'] = this.gstPercent;
    data['purchaseDate'] = this.purchaseDate;
    data['expiryDate'] = this.expiryDate;
    data['totalAmount'] = this.totalAmount;
    data['paymentStatus'] = this.paymentStatus;
    data['paymentMethod'] = this.paymentMethod;
    data['orderId'] = this.orderId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['transactionId'] = this.transactionId;
    return data;
  }
}

class ShuttlePass {
  var sId;
  var name;
  var shortDescription;
  var thumbImage;
  var rideCount;
  var validityDays;

  ShuttlePass(
      {this.sId,
        this.name,
        this.shortDescription,
        this.thumbImage,
        this.rideCount,
        this.validityDays});

  ShuttlePass.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    shortDescription = json['shortDescription'];
    thumbImage = json['thumbImage'];
    rideCount = json['rideCount'];
    validityDays = json['validityDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['shortDescription'] = this.shortDescription;
    data['thumbImage'] = this.thumbImage;
    data['rideCount'] = this.rideCount;
    data['validityDays'] = this.validityDays;
    return data;
  }
}

class ShuttleRoute {
  var sId;
  var name;

  ShuttleRoute({this.sId, this.name});

  ShuttleRoute.fromJson(Map<String, dynamic> json) {
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

class ShuttleShift {
  var sId;
  var shuttleRoute;
  var shiftName;
  List<StoppageTimes>? stoppageTimes;
  var gst;
  bool? isActive;
  var createdAt;
  var updatedAt;
  var iV;

  ShuttleShift(
      {this.sId,
        this.shuttleRoute,
        this.shiftName,
        this.stoppageTimes,
        this.gst,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ShuttleShift.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    shuttleRoute = json['shuttleRoute'];
    shiftName = json['shiftName'];
    if (json['stoppageTimes'] != null) {
      stoppageTimes = <StoppageTimes>[];
      json['stoppageTimes'].forEach((v) {
        stoppageTimes!.add(new StoppageTimes.fromJson(v));
      });
    }
    gst = json['gst'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['shuttleRoute'] = this.shuttleRoute;
    data['shiftName'] = this.shiftName;
    if (this.stoppageTimes != null) {
      data['stoppageTimes'] =
          this.stoppageTimes!.map((v) => v.toJson()).toList();
    }
    data['gst'] = this.gst;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class StoppageTimes {
  var name;
  var lat;
  var lng;
  var address;
  var order;
  var arrivalTime;
  var departureTime;
  var price;
  var sId;

  StoppageTimes(
      {this.name,
        this.lat,
        this.lng,
        this.address,
        this.order,
        this.arrivalTime,
        this.departureTime,
        this.price,
        this.sId});

  StoppageTimes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    order = json['order'];
    arrivalTime = json['arrivalTime'];
    departureTime = json['departureTime'];
    price = json['price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['order'] = this.order;
    data['arrivalTime'] = this.arrivalTime;
    data['departureTime'] = this.departureTime;
    data['price'] = this.price;
    data['_id'] = this.sId;
    return data;
  }
}
