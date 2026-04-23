class GetNotificationModel {
  bool? status;
  int? unreadCount;
  int? totalResult;
  int? totalPage;
  int? currentPage;
  String? message;
  List<Data>? data;

  GetNotificationModel(
      {this.status,
        this.unreadCount,
        this.totalResult,
        this.totalPage,
        this.currentPage,
        this.message,
        this.data});

  GetNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    unreadCount = json['unreadCount'];
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
    data['unreadCount'] = this.unreadCount;
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
  String? sId;
  Booking? booking;
  String? type;
  String? title;
  String? body;
  bool? isRead;
  String? createdAt;

  Data(
      {this.sId,
        this.booking,
        this.type,
        this.title,
        this.body,
        this.isRead,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    booking =
    json['booking'] != null ? new Booking.fromJson(json['booking']) : null;
    type = json['type'];
    title = json['title'];
    body = json['body'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.booking != null) {
      data['booking'] = this.booking!.toJson();
    }
    data['type'] = this.type;
    data['title'] = this.title;
    data['body'] = this.body;
    data['isRead'] = this.isRead;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Booking {
  String? sId;
  String? bookingNumber;
  String? overallStatus;
  String? createdAtIST;
  String? scheduledAtIST;
  String? paymentAtIST;
  String? assignedAtIST;
  String? tripStartAtIST;
  String? tripEndAtIST;
  String? cancelledAtIST;
  String? id;

  Booking(
      {this.sId,
        this.bookingNumber,
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
