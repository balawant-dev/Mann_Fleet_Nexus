class GetCouponsModel {
  bool? status;
  var message;
  var total;
  List<Data>? data;

  GetCouponsModel({this.status, this.message, this.total, this.data});

  GetCouponsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
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
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  var sId;
  var code;
  var discountType;
  var discountValue;
  var minimumFare;
  var maxDiscountAmount;
  var potentialDiscount;
  var finalAmount;
  var expiryDate;
  var numberOfUses;

  Data(
      {this.sId,
        this.code,
        this.discountType,
        this.discountValue,
        this.minimumFare,
        this.maxDiscountAmount,
        this.potentialDiscount,
        this.finalAmount,
        this.expiryDate,
        this.numberOfUses});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    code = json['code'];
    discountType = json['discountType'];
    discountValue = json['discountValue'];
    minimumFare = json['minimumFare'];
    maxDiscountAmount = json['maxDiscountAmount'];
    potentialDiscount = json['potentialDiscount'];
    finalAmount = json['finalAmount'];
    expiryDate = json['expiryDate'];
    numberOfUses = json['numberOfUses'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['code'] = this.code;
    data['discountType'] = this.discountType;
    data['discountValue'] = this.discountValue;
    data['minimumFare'] = this.minimumFare;
    data['maxDiscountAmount'] = this.maxDiscountAmount;
    data['potentialDiscount'] = this.potentialDiscount;
    data['finalAmount'] = this.finalAmount;
    data['expiryDate'] = this.expiryDate;
    data['numberOfUses'] = this.numberOfUses;
    return data;
  }
}
