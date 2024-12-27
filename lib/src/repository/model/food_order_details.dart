class User {
  int id;
  String fName;
  String lName;
  String phone;
  String email;
  String? image;
  int isPhoneVerified;
  String? emailVerifiedAt;
  String? emailVerificationToken;
  String cmFirebaseToken;
  String createdAt;
  String updatedAt;
  int status;
  int orderCount;
  String empId;
  int departmentId;
  int isVeg;
  int isSatOpted;
  String deviceId;
  int isInvalidDevice;
  int isBreakfast;
  int isLunch;
  int isDinner;

  User({
    required this.id,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.email,
    this.image,
    required this.isPhoneVerified,
    this.emailVerifiedAt,
    this.emailVerificationToken,
    required this.cmFirebaseToken,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.orderCount,
    required this.empId,
    required this.departmentId,
    required this.isVeg,
    required this.isSatOpted,
    required this.deviceId,
    required this.isInvalidDevice,
    required this.isBreakfast,
    required this.isLunch,
    required this.isDinner,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fName: json['f_name'],
      lName: json['l_name'],
      phone: json['phone'],
      email: json['email'],
      image: json['image'],
      isPhoneVerified: json['is_phone_verified'],
      emailVerifiedAt: json['email_verified_at'],
      emailVerificationToken: json['email_verification_token'],
      cmFirebaseToken: json['cm_firebase_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      orderCount: json['order_count'],
      empId: json['emp_id'],
      departmentId: json['department_id'],
      isVeg: json['is_veg'],
      isSatOpted: json['is_sat_opted'],
      deviceId: json['device_id'],
      isInvalidDevice: json['is_invalid_device'],
      isBreakfast: json['is_breakfast'],
      isLunch: json['is_lunch'],
      isDinner: json['is_dinner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'f_name': fName,
      'l_name': lName,
      'phone': phone,
      'email': email,
      'image': image,
      'is_phone_verified': isPhoneVerified,
      'email_verified_at': emailVerifiedAt,
      'email_verification_token': emailVerificationToken,
      'cm_firebase_token': cmFirebaseToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'order_count': orderCount,
      'emp_id': empId,
      'department_id': departmentId,
      'is_veg': isVeg,
      'is_sat_opted': isSatOpted,
      'device_id': deviceId,
      'is_invalid_device': isInvalidDevice,
      'is_breakfast': isBreakfast,
      'is_lunch': isLunch,
      'is_dinner': isDinner,
    };
  }
}

enum OptInType {
  delivered,
  pending,
  canceled;

  String get value {
    switch (this) {
      case OptInType.delivered:
        return 'Delivered';
      case OptInType.pending:
        return 'Pending';
      case OptInType.canceled:
        return 'Canceled';
    }
  }

  static OptInType fromString(String value) {
    switch (value) {
      case 'Delivered':
        return OptInType.delivered;
      case 'Pending':
        return OptInType.pending;
      case 'Canceled':
        return OptInType.canceled;
      default:
        throw ArgumentError('Invalid value');
    }
  }
}

class OptIns {
  OptInType? breakfast;
  OptInType? lunch;
  OptInType? dinner;

  OptIns({this.breakfast, this.lunch, this.dinner});

  factory OptIns.fromJson(Map<dynamic, dynamic> json) {
    return OptIns(
      breakfast: OptInType.fromString(json['breakfast']),
      lunch: OptInType.fromString(json['lunch']),
      dinner: OptInType.fromString(json['dinner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast?.value,
      'lunch': lunch?.value,
      'dinner': dinner?.value,
    };
  }
}

class Report {
  String date;
  OptIns optIns;

  Report({
    required this.date,
    required this.optIns,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      date: json['date'],
      optIns: json['opt_ins'] is Map<String, dynamic>
          ? OptIns.fromJson(json['opt_ins'])
          : OptIns(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'opt_ins': optIns.toJson(),
    };
  }
}

class FoodOrderDetails {
  User user;
  List<Report> reports;

  FoodOrderDetails({
    required this.user,
    required this.reports,
  });

  factory FoodOrderDetails.fromJson(Map<String, dynamic> json) {
    var list = json['reports'] as List<dynamic>;
    List<Report> reportList = list.map((i) => Report.fromJson(i)).toList();

    return FoodOrderDetails(
      user: User.fromJson(json['user']),
      reports: reportList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'reports': reports.map((report) => report.toJson()).toList(),
    };
  }
}
