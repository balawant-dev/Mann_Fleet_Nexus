class AppliedCouponsModel {
  var status;
  var message;
  Data? data;

  AppliedCouponsModel({this.status, this.message, this.data});

  AppliedCouponsModel.fromJson(Map<String, dynamic> json) {
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
  var couponCode;
  var discountType;
  var discountValue;
  var discountAmount;
  var originalAmount;
  var finalAmount;
  CouponDetails? couponDetails;

  Data(
      {this.couponCode,
        this.discountType,
        this.discountValue,
        this.discountAmount,
        this.originalAmount,
        this.finalAmount,
        this.couponDetails});

  Data.fromJson(Map<String, dynamic> json) {
    couponCode = json['couponCode'];
    discountType = json['discountType'];
    discountValue = json['discountValue'];
    discountAmount = json['discountAmount'];
    originalAmount = json['originalAmount'];
    finalAmount = json['finalAmount'];
    couponDetails = json['couponDetails'] != null
        ? new CouponDetails.fromJson(json['couponDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couponCode'] = this.couponCode;
    data['discountType'] = this.discountType;
    data['discountValue'] = this.discountValue;
    data['discountAmount'] = this.discountAmount;
    data['originalAmount'] = this.originalAmount;
    data['finalAmount'] = this.finalAmount;
    if (this.couponDetails != null) {
      data['couponDetails'] = this.couponDetails!.toJson();
    }
    return data;
  }
}

class CouponDetails {
  var minimumFare;
  var maxDiscountAmount;
  var expiryDate;

  CouponDetails({this.minimumFare, this.maxDiscountAmount, this.expiryDate});

  CouponDetails.fromJson(Map<String, dynamic> json) {
    minimumFare = json['minimumFare'];
    maxDiscountAmount = json['maxDiscountAmount'];
    expiryDate = json['expiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minimumFare'] = this.minimumFare;
    data['maxDiscountAmount'] = this.maxDiscountAmount;
    data['expiryDate'] = this.expiryDate;
    return data;
  }
}
