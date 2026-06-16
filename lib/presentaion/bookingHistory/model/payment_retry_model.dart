class PaymentRetryModel {
  bool? status;
  String? message;
  PaymentRetryData? data;

  PaymentRetryModel({this.status, this.message, this.data});

  factory PaymentRetryModel.fromJson(Map<String, dynamic> json) {
    return PaymentRetryModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? PaymentRetryData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data?.toJson()};
  }
}

class PaymentRetryData {
  String? bookingId;
  String? bookingNumber;
  RetryRazorpay? razorpay;
  double? estimatedFare;
  String? paymentStatus;
  String? overallStatus;

  PaymentRetryData({
    this.bookingId,
    this.bookingNumber,
    this.razorpay,
    this.estimatedFare,
    this.paymentStatus,
    this.overallStatus,
  });

  factory PaymentRetryData.fromJson(Map<String, dynamic> json) {
    return PaymentRetryData(
      bookingId: json['bookingId'],
      bookingNumber: json['bookingNumber'],
      razorpay: json['razorpay'] != null
          ? RetryRazorpay.fromJson(json['razorpay'])
          : null,
      estimatedFare: (json['estimatedFare'] as num?)?.toDouble(),
      paymentStatus: json['paymentStatus'],
      overallStatus: json['overallStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'bookingNumber': bookingNumber,
      'razorpay': razorpay?.toJson(),
      'estimatedFare': estimatedFare,
      'paymentStatus': paymentStatus,
      'overallStatus': overallStatus,
    };
  }
}

class RetryRazorpay {
  String? orderId;
  int? amount;
  String? currency;
  String? key;

  RetryRazorpay({this.orderId, this.amount, this.currency, this.key});

  factory RetryRazorpay.fromJson(Map<String, dynamic> json) {
    return RetryRazorpay(
      orderId: json['orderId'],
      amount: json['amount'],
      currency: json['currency'],
      key: json['key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'amount': amount,
      'currency': currency,
      'key': key,
    };
  }
}
