class CreateComplaintsModel {
  bool? status;
  String? message;
  Data? data;

  CreateComplaintsModel({this.status, this.message, this.data});

  CreateComplaintsModel.fromJson(Map<String, dynamic> json) {
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
  String? ticketId;
  String? issueCategory;
  String? description;
  String? status;
  String? createdAt;

  Data(
      {this.ticketId,
        this.issueCategory,
        this.description,
        this.status,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticketId'];
    issueCategory = json['issueCategory'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticketId'] = this.ticketId;
    data['issueCategory'] = this.issueCategory;
    data['description'] = this.description;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
