class AllUniqueStoppageModel {
  bool? status;
 var message;
  int? totalResult;
  List<AllUniqueStoppageData>? data;

  AllUniqueStoppageModel(
      {this.status, this.message, this.totalResult, this.data});

  AllUniqueStoppageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalResult = json['totalResult'];
    if (json['data'] != null) {
      data = <AllUniqueStoppageData>[];
      json['data'].forEach((v) {
        data!.add(new AllUniqueStoppageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['totalResult'] = this.totalResult;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllUniqueStoppageData {
  var lat;
  var lng;
 var address;
 var name;

  AllUniqueStoppageData({this.lat, this.lng, this.address, this.name});

  AllUniqueStoppageData.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['name'] = this.name;
    return data;
  }
}











//
// class AllUniqueStoppageModel {
//   bool? status;
//   var message;
//   int? totalResult;
//   List<AllUniqueStoppageData>? data;
//
//   AllUniqueStoppageModel({
//     this.status,
//     this.message,
//     this.totalResult,
//     this.data,
//   });
//
//   AllUniqueStoppageModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     totalResult = json['totalResult'];
//     if (json['data'] != null) {
//       data = <AllUniqueStoppageData>[];
//       json['data'].forEach((v) {
//         data!.add(new AllUniqueStoppageData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     data['totalResult'] = this.totalResult;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class AllUniqueStoppageData {
//   var lat;
//   var lng;
//   var address;
//   var name;
//
//   AllUniqueStoppageData({this.lat, this.lng, this.address, this.name});
//
//   AllUniqueStoppageData.fromJson(Map<String, dynamic> json) {
//     lat = json['lat'];
//     lng = json['lng'];
//     address = json['address'];
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['lat'] = this.lat;
//     data['lng'] = this.lng;
//     data['address'] = this.address;
//     data['name'] = this.name;
//     return data;
//   }
// }
