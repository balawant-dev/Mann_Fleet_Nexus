class BookingCancelModel {
  bool? status;
  String? message;
  Data? data;

  BookingCancelModel({this.status, this.message, this.data});

  BookingCancelModel.fromJson(Map<String, dynamic> json) {
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
  String? bookingId;
  String? bookingNumber;
  double? refundAmount;
  double? newWalletBalance;
  String? cancelledAt;

  Data(
      {this.bookingId,
        this.bookingNumber,
        this.refundAmount,
        this.newWalletBalance,
        this.cancelledAt});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    bookingNumber = json['bookingNumber'];
    refundAmount = json['refundAmount'];
    newWalletBalance = json['newWalletBalance'];
    cancelledAt = json['cancelledAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    data['bookingNumber'] = this.bookingNumber;
    data['refundAmount'] = this.refundAmount;
    data['newWalletBalance'] = this.newWalletBalance;
    data['cancelledAt'] = this.cancelledAt;
    return data;
  }
}
