class RatingModel {
  bool? status;
  String? message;

  RatingModel({this.status, this.message});

  RatingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
