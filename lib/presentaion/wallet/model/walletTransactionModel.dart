class WalletTransactionModel {
 var status;
  var totalResult;
  var totalPage;
  var currentPage;
 var message;
  List<Data>? data;

  WalletTransactionModel(
      {this.status,
        this.totalResult,
        this.totalPage,
        this.currentPage,
        this.message,
        this.data});

  WalletTransactionModel.fromJson(Map<String, dynamic> json) {
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
 var sId;
 var user;
 var type;
  var amount;
  var balanceBefore;
  var balanceAfter;
 var reason;
 var description;
 var referenceId;
 var referenceModel;
 var performedBy;
 var status;
 var isDeleted;
 var createdAt;
 var updatedAt;
  var iV;
 var id;

  Data(
      {this.sId,
        this.user,
        this.type,
        this.amount,
        this.balanceBefore,
        this.balanceAfter,
        this.reason,
        this.description,
        this.referenceId,
        this.referenceModel,
        this.performedBy,
        this.status,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    type = json['type'];
    amount = json['amount'];
    balanceBefore = json['balanceBefore'];
    balanceAfter = json['balanceAfter'];
    reason = json['reason'];
    description = json['description'];
    referenceId = json['referenceId'];
    referenceModel = json['referenceModel'];
    performedBy = json['performedBy'];
    status = json['status'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['balanceBefore'] = this.balanceBefore;
    data['balanceAfter'] = this.balanceAfter;
    data['reason'] = this.reason;
    data['description'] = this.description;
    data['referenceId'] = this.referenceId;
    data['referenceModel'] = this.referenceModel;
    data['performedBy'] = this.performedBy;
    data['status'] = this.status;
    data['isDeleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}
