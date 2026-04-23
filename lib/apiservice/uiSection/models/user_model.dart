// Step 11: Dummy Models (Example JSON parsing)
// features/auth/domain/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

// Similarly for others:
// ProfileModel, DashboardModel, SettingsModel, UploadResponseModel
// Assume similar structure: factory fromJson
class ProfileModel {
  final String? id;
  final String? name;
  final String? email;
  final String? mobile;
  final String? profileImage;
  final String? gender;
  final String? dob;
  final String? address;

  ProfileModel({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.profileImage,
    this.gender,
    this.dob,
    this.address,
  });

  /// JSON → Model
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString(),
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      profileImage: json['profile_image'],
      gender: json['gender'],
      dob: json['dob'],
      address: json['address'],
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'profile_image': profileImage,
      'gender': gender,
      'dob': dob,
      'address': address,
    };
  }
}


class DashboardModel {
  final int? totalOrders;
  final int? pendingOrders;
  final int? completedOrders;
  final double? totalRevenue;
  final double? todayRevenue;
  final double? monthlyRevenue;


  DashboardModel({
    this.totalOrders,
    this.pendingOrders,
    this.completedOrders,
    this.totalRevenue,
    this.todayRevenue,
    this.monthlyRevenue,

  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalOrders: json['total_orders'],
      pendingOrders: json['pending_orders'],
      completedOrders: json['completed_orders'],
      totalRevenue: _toDouble(json['total_revenue']),
      todayRevenue: _toDouble(json['today_revenue']),
      monthlyRevenue: _toDouble(json['monthly_revenue']),

    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }
}


class SettingsModel {
  final bool? notificationEnabled;
  final bool? darkMode;
  final bool? locationEnabled;
  final String? language;
  final String? currency;
  final String? supportEmail;
  final String? supportPhone;

  SettingsModel({
    this.notificationEnabled,
    this.darkMode,
    this.locationEnabled,
    this.language,
    this.currency,
    this.supportEmail,
    this.supportPhone,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      notificationEnabled: _toBool(json['notification_enabled']),
      darkMode: _toBool(json['dark_mode']),
      locationEnabled: _toBool(json['location_enabled']),
      language: json['language'],
      currency: json['currency'],
      supportEmail: json['support_email'],
      supportPhone: json['support_phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_enabled': notificationEnabled,
      'dark_mode': darkMode,
      'location_enabled': locationEnabled,
      'language': language,
      'currency': currency,
      'support_email': supportEmail,
      'support_phone': supportPhone,
    };
  }

  static bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    return value.toString() == '1' || value.toString().toLowerCase() == 'true';
  }
}


class UploadResponseModel {
  final bool? status;
  final String? message;
  final UploadData? data;

  UploadResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory UploadResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? UploadData.fromJson(json['data'])
          : null,
    );
  }
}
class UploadData {
  final String? fileName;
  final String? fileUrl;
  final String? filePath;
  final int? fileSize;
  final String? fileType;

  UploadData({
    this.fileName,
    this.fileUrl,
    this.filePath,
    this.fileSize,
    this.fileType,
  });

  factory UploadData.fromJson(Map<String, dynamic> json) {
    return UploadData(
      fileName: json['file_name'],
      fileUrl: json['file_url'],
      filePath: json['file_path'],
      fileSize: _toInt(json['file_size']),
      fileType: json['file_type'],
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }
}
