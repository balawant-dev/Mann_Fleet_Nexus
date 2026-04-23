class GetComplaintsModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  int? currentPage;
  String? message;
  List<MyComplaintData>? data;

  GetComplaintsModel(
      {this.status,
        this.totalResult,
        this.totalPage,
        this.currentPage,
        this.message,
        this.data});

  GetComplaintsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    currentPage = json['currentPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MyComplaintData>[];
      json['data'].forEach((v) {
        data!.add(new MyComplaintData.fromJson(v));
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

class MyComplaintData {
  String? sId;
  String? issueCategory;
  String? ticketId;
  String? description;
  String? ticketStatus;
  List<String>? imageFiles;
  String? videoFiles;
  String? createdAt;

  MyComplaintData(
      {this.sId,
        this.issueCategory,
        this.ticketId,
        this.description,
        this.ticketStatus,
        this.imageFiles,
        this.videoFiles,
        this.createdAt});

  MyComplaintData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    issueCategory = json['issueCategory'];
    ticketId = json['ticketId'];
    description = json['description'];
    ticketStatus = json['ticketStatus'];
    imageFiles = json['imageFiles'].cast<String>();
    videoFiles = json['videoFiles'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['issueCategory'] = this.issueCategory;
    data['ticketId'] = this.ticketId;
    data['description'] = this.description;
    data['ticketStatus'] = this.ticketStatus;
    data['imageFiles'] = this.imageFiles;
    data['videoFiles'] = this.videoFiles;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
