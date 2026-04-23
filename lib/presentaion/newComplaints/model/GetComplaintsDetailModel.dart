class GetComplaintsDetailModel {
  bool? status;
  String? message;
  ComplaintDetailData? data;

  GetComplaintsDetailModel({this.status, this.message, this.data});

  GetComplaintsDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ComplaintDetailData.fromJson(json['data']) : null;
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

class ComplaintDetailData {
  String? sId;
  String? issueCategory;
  String? otherLabel;
  String? ticketId;
  String? description;
  String? onModel;
  ReporterComplaintData? reporter;
  String? ticketStatus;
  List<String>? imageFiles;
  String? videoFiles;
  String? createdAt;
  int? iV;

  ComplaintDetailData(
      {this.sId,
        this.issueCategory,
        this.otherLabel,
        this.ticketId,
        this.description,
        this.onModel,
        this.reporter,
        this.ticketStatus,
        this.imageFiles,
        this.videoFiles,
        this.createdAt,
        this.iV});

  ComplaintDetailData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    issueCategory = json['issueCategory'];
    otherLabel = json['otherLabel'];
    ticketId = json['ticketId'];
    description = json['description'];
    onModel = json['onModel'];
    reporter = json['reporter'] != null
        ? new ReporterComplaintData.fromJson(json['reporter'])
        : null;
    ticketStatus = json['ticketStatus'];
    imageFiles = json['imageFiles'].cast<String>();
    videoFiles = json['videoFiles'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['issueCategory'] = this.issueCategory;
    data['otherLabel'] = this.otherLabel;
    data['ticketId'] = this.ticketId;
    data['description'] = this.description;
    data['onModel'] = this.onModel;
    if (this.reporter != null) {
      data['reporter'] = this.reporter!.toJson();
    }
    data['ticketStatus'] = this.ticketStatus;
    data['imageFiles'] = this.imageFiles;
    data['videoFiles'] = this.videoFiles;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class ReporterComplaintData {
  String? sId;
  String? email;
  String? name;
  String? profilePic;
  String? id;

  ReporterComplaintData({this.sId, this.email, this.name, this.profilePic, this.id});

  ReporterComplaintData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
    profilePic = json['profilePic'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['name'] = this.name;
    data['profilePic'] = this.profilePic;
    data['id'] = this.id;
    return data;
  }
}
