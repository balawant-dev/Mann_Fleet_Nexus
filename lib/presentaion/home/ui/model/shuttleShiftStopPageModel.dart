class ShuttleShiftStopPageModel {
  bool? status;
  var totalResult;
  var message;
  List<Data>? data;

  ShuttleShiftStopPageModel(
      {this.status, this.totalResult, this.message, this.data});

  ShuttleShiftStopPageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
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
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  var shiftId;
  var date;
  var shiftName;
  Route? route;
  var gst;
  Source? source;
  Destination? destination;
  List<IntermediateStops>? intermediateStops;
  var totalPrice;
  var priceWithGst;

  Data(
      {this.shiftId,
      this.date,
        this.shiftName,
        this.route,
        this.gst,
        this.source,
        this.destination,
        this.intermediateStops,
        this.totalPrice,
        this.priceWithGst});

  Data.fromJson(Map<String, dynamic> json) {
    shiftId = json['shiftId'];
    date = json['date'];
    shiftName = json['shiftName'];
    route = json['route'] != null ? new Route.fromJson(json['route']) : null;
    gst = json['gst'];
    source =
    json['source'] != null ? new Source.fromJson(json['source']) : null;
    destination = json['destination'] != null
        ? new Destination.fromJson(json['destination'])
        : null;
    if (json['intermediateStops'] != null) {
      intermediateStops = <IntermediateStops>[];
      json['intermediateStops'].forEach((v) {
        intermediateStops!.add(new IntermediateStops.fromJson(v));
      });
    }
    totalPrice = json['totalPrice'];
    priceWithGst = json['priceWithGst'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shiftId'] = this.shiftId;
    data['date'] = this.date;
    data['shiftName'] = this.shiftName;
    if (this.route != null) {
      data['route'] = this.route!.toJson();
    }
    data['gst'] = this.gst;
    if (this.source != null) {
      data['source'] = this.source!.toJson();
    }
    if (this.destination != null) {
      data['destination'] = this.destination!.toJson();
    }
    if (this.intermediateStops != null) {
      data['intermediateStops'] =
          this.intermediateStops!.map((v) => v.toJson()).toList();
    }
    data['totalPrice'] = this.totalPrice;
    data['priceWithGst'] = this.priceWithGst;
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

class Source {
  var name;
  var address;
  var departureTime;
  var price;

  Source({this.name, this.address, this.departureTime, this.price});

  Source.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    departureTime = json['departureTime'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['departureTime'] = this.departureTime;
    data['price'] = this.price;
    return data;
  }
}

class Destination {
  var name;
  var address;
  var arrivalTime;

  Destination({this.name, this.address, this.arrivalTime});

  Destination.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    arrivalTime = json['arrivalTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['arrivalTime'] = this.arrivalTime;
    return data;
  }
}

class IntermediateStops {
  var name;
  var address;
  var arrivalTime;
  var departureTime;

  IntermediateStops(
      {this.name, this.address, this.arrivalTime, this.departureTime});

  IntermediateStops.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    arrivalTime = json['arrivalTime'];
    departureTime = json['departureTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['arrivalTime'] = this.arrivalTime;
    data['departureTime'] = this.departureTime;
    return data;
  }
}
