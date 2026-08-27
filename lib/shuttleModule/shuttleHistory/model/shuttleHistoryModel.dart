class ShuttleHistoryModel {
  var status;
  var totalResult;
  var totalPage;
  var currentPage;
  var message;
  List<Data>? data;

  ShuttleHistoryModel(
      {this.status,
        this.totalResult,
        this.totalPage,
        this.currentPage,
        this.message,
        this.data});

  ShuttleHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    currentPage = json['currentPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  Source? source;
  Source? destination;
  CheckIn? checkIn;
  var sId;
  var user;
  ShuttlePassTransaction? shuttlePassTransaction;
  ShuttleRoute? shuttleRoute;
  ShuttleRouteShift? shuttleRouteShift;
  var status;
  var scannedByDriver;
  var scannedAtStop;
  var scheduledDepartureTime;
  var scheduledDate;
  var travelDirection;
  var rideNumber;
  var remainingRidesAfter;
  var createdAt;
  var updatedAt;
  var iV;

  Data(
      {this.source,
        this.destination,
        this.checkIn,
        this.sId,
        this.user,
        this.shuttlePassTransaction,
        this.shuttleRoute,
        this.shuttleRouteShift,
        this.status,
        this.scannedByDriver,
        this.scannedAtStop,
        this.scheduledDepartureTime,
        this.scheduledDate,
        this.travelDirection,
        this.rideNumber,
        this.remainingRidesAfter,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    source =
    json['source'] != null ? new Source.fromJson(json['source']) : null;
    destination = json['destination'] != null
        ? new Source.fromJson(json['destination'])
        : null;
    checkIn =
    json['checkIn'] != null ? new CheckIn.fromJson(json['checkIn']) : null;
    sId = json['_id'];
    user = json['user'];
    shuttlePassTransaction = json['shuttlePassTransaction'] != null
        ? new ShuttlePassTransaction.fromJson(json['shuttlePassTransaction'])
        : null;
    shuttleRoute = json['shuttleRoute'] != null
        ? new ShuttleRoute.fromJson(json['shuttleRoute'])
        : null;
    shuttleRouteShift = json['shuttleRouteShift'] != null
        ? new ShuttleRouteShift.fromJson(json['shuttleRouteShift'])
        : null;
    status = json['status'];
    scannedByDriver = json['scannedByDriver'];
    scannedAtStop = json['scannedAtStop'];
    scheduledDepartureTime = json['scheduledDepartureTime'];
    scheduledDate = json['scheduledDate'];
    travelDirection = json['travelDirection'];
    rideNumber = json['rideNumber'];
    remainingRidesAfter = json['remainingRidesAfter'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.source != null) {
      data['source'] = this.source!.toJson();
    }
    if (this.destination != null) {
      data['destination'] = this.destination!.toJson();
    }
    if (this.checkIn != null) {
      data['checkIn'] = this.checkIn!.toJson();
    }
    data['_id'] = this.sId;
    data['user'] = this.user;
    if (this.shuttlePassTransaction != null) {
      data['shuttlePassTransaction'] = this.shuttlePassTransaction!.toJson();
    }
    if (this.shuttleRoute != null) {
      data['shuttleRoute'] = this.shuttleRoute!.toJson();
    }
    if (this.shuttleRouteShift != null) {
      data['shuttleRouteShift'] = this.shuttleRouteShift!.toJson();
    }
    data['status'] = this.status;
    data['scannedByDriver'] = this.scannedByDriver;
    data['scannedAtStop'] = this.scannedAtStop;
    data['scheduledDepartureTime'] = this.scheduledDepartureTime;
    data['scheduledDate'] = this.scheduledDate;
    data['travelDirection'] = this.travelDirection;
    data['rideNumber'] = this.rideNumber;
    data['remainingRidesAfter'] = this.remainingRidesAfter;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Source {
  var name;
  var lat;
  var lng;
  var address;

  Source({this.name, this.lat, this.lng, this.address});

  Source.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    return data;
  }
}

class CheckIn {
  var time;
  Null? lat;
  Null? lng;

  CheckIn({this.time, this.lat, this.lng});

  CheckIn.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class ShuttlePassTransaction {
  var sId;
  var shuttlePass;
  var remainingRides;

  ShuttlePassTransaction({this.sId, this.shuttlePass, this.remainingRides});

  ShuttlePassTransaction.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    shuttlePass = json['shuttlePass'];
    remainingRides = json['remainingRides'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['shuttlePass'] = this.shuttlePass;
    data['remainingRides'] = this.remainingRides;
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

class ShuttleRouteShift {
  var sId;
  var shiftName;

  ShuttleRouteShift({this.sId, this.shiftName});

  ShuttleRouteShift.fromJson(Map<String, dynamic> json) {
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
