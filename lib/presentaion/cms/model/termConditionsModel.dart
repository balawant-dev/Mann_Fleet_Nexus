class TermConditionsModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<Data>? data;

  TermConditionsModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  TermConditionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
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
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? termCondition;
  String? type;
  String? createdAt;
  int? iV;

  Data({this.sId, this.termCondition, this.type, this.createdAt, this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    termCondition = json['termCondition'];
    type = json['type'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['termCondition'] = this.termCondition;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
