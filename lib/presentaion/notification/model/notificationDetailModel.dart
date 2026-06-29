class NotificationDetailModel {
  var status;
  var message;
  NotificationDetailData? data;

  NotificationDetailModel({this.status, this.message, this.data});

  NotificationDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new NotificationDetailData.fromJson(json['data']) : null;
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

class NotificationDetailData {
  var sId;
  var driver;
  Booking? booking;
  var type;
  var title;
  var body;
  var isRead;
  var createdAt;
  var iV;

  NotificationDetailData(
      {this.sId,
        this.driver,
        this.booking,
        this.type,
        this.title,
        this.body,
        this.isRead,
        this.createdAt,
        this.iV});

  NotificationDetailData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    driver = json['driver'];
    booking =
    json['booking'] != null ? new Booking.fromJson(json['booking']) : null;
    type = json['type'];
    title = json['title'];
    body = json['body'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['driver'] = this.driver;
    if (this.booking != null) {
      data['booking'] = this.booking!.toJson();
    }
    data['type'] = this.type;
    data['title'] = this.title;
    data['body'] = this.body;
    data['isRead'] = this.isRead;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Booking {
  var sId;
  var bookingNumber;
  var tripStatus;
  var overallStatus;
  var createdAtIST;
  var scheduledAtIST;
  var paymentAtIST;
  var assignedAtIST;
  var tripStartAtIST;
  var tripEndAtIST;
  var cancelledAtIST;
  var id;

  Booking(
      {this.sId,
        this.bookingNumber,
        this.tripStatus,
        this.overallStatus,
        this.createdAtIST,
        this.scheduledAtIST,
        this.paymentAtIST,
        this.assignedAtIST,
        this.tripStartAtIST,
        this.tripEndAtIST,
        this.cancelledAtIST,
        this.id});

  Booking.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bookingNumber = json['bookingNumber'];
    tripStatus = json['tripStatus'];
    overallStatus = json['overallStatus'];
    createdAtIST = json['createdAtIST'];
    scheduledAtIST = json['scheduledAtIST'];
    paymentAtIST = json['paymentAtIST'];
    assignedAtIST = json['assignedAtIST'];
    tripStartAtIST = json['tripStartAtIST'];
    tripEndAtIST = json['tripEndAtIST'];
    cancelledAtIST = json['cancelledAtIST'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['bookingNumber'] = this.bookingNumber;
    data['tripStatus'] = this.tripStatus;
    data['overallStatus'] = this.overallStatus;
    data['createdAtIST'] = this.createdAtIST;
    data['scheduledAtIST'] = this.scheduledAtIST;
    data['paymentAtIST'] = this.paymentAtIST;
    data['assignedAtIST'] = this.assignedAtIST;
    data['tripStartAtIST'] = this.tripStartAtIST;
    data['tripEndAtIST'] = this.tripEndAtIST;
    data['cancelledAtIST'] = this.cancelledAtIST;
    data['id'] = this.id;
    return data;
  }
}
