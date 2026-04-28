class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final bool isVerified;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool profileCompleted;
  final DateTime createdAt;
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final String? country;
  final String? city;
  final String? licenseType;
  final List<String> languages;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.isVerified = false,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.profileCompleted = false,
    required this.createdAt,
    this.profileImageUrl,
    this.dateOfBirth,
    this.country,
    this.city,
    this.licenseType,
    this.languages = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      role: map['role'] as String? ?? '',
      isVerified: map['isVerified'] as bool? ?? false,
      isEmailVerified: map['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: map['isPhoneVerified'] as bool? ?? false,
      profileCompleted: map['profileCompleted'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      profileImageUrl: map['profileImageUrl'] as String?,
      dateOfBirth: map['dateOfBirth'] != null 
          ? DateTime.tryParse(map['dateOfBirth'] as String)
          : null,
      country: map['country'] as String?,
      city: map['city'] as String?,
      licenseType: map['licenseType'] as String?,
      languages: (map['languages'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'isVerified': isVerified,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'profileCompleted': profileCompleted,
      'createdAt': createdAt.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'country': country,
      'city': city,
      'licenseType': licenseType,
      'languages': languages,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    bool? isVerified,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? profileCompleted,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      createdAt: createdAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  double get profileCompletionPercentage {
    double count = 0;
    if (name.isNotEmpty) count += 16.6;
    if (email.isNotEmpty) count += 16.6;
    if (phone.isNotEmpty) count += 16.6;
    if (role.isNotEmpty) count += 16.6;
    if (profileImageUrl != null) count += 16.6;
    if (isEmailVerified && isPhoneVerified) count += 16.6;
    return count;
  }

  bool get isFullyVerified => isEmailVerified && isPhoneVerified;
}

class DriverProfileModel {
  final String id;
  final String driverId;
  final List<String> licenses;
  final int experienceYears;
  final List<String> languages;
  final List<String> countriesWorked;
  final bool isAvailable;
  final double rating;
  final GeoPointModel? location;
  final String? currentCity;
  final String? profileImageUrl;
  final String? licenseImageUrl;
  final List<String> attestationUrls;
  final String verificationStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const DriverProfileModel({
    required this.id,
    required this.driverId,
    this.licenses = const [],
    this.experienceYears = 0,
    this.languages = const [],
    this.countriesWorked = const [],
    this.isAvailable = false,
    this.rating = 0,
    this.location,
    this.currentCity,
    this.profileImageUrl,
    this.licenseImageUrl,
    this.attestationUrls = const [],
    this.verificationStatus = 'pending',
    required this.createdAt,
    this.updatedAt,
  });

  factory DriverProfileModel.fromMap(Map<String, dynamic> map, String id) {
    GeoPointModel? loc;
    if (map['location'] != null) {
      loc = GeoPointModel.fromMap(Map<String, dynamic>.from(map['location'] as Map));
    }
    return DriverProfileModel(
      id: id,
      driverId: map['driverId'] as String? ?? '',
      licenses: List<String>.from(map['licenses'] ?? []),
      experienceYears: map['experienceYears'] as int? ?? 0,
      languages: List<String>.from(map['languages'] ?? []),
      countriesWorked: List<String>.from(map['countriesWorked'] ?? []),
      isAvailable: map['isAvailable'] as bool? ?? false,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      location: loc,
      currentCity: map['currentCity'] as String?,
      profileImageUrl: map['profileImageUrl'] as String?,
      licenseImageUrl: map['licenseImageUrl'] as String?,
      attestationUrls: List<String>.from(map['attestationUrls'] ?? []),
      verificationStatus: map['verificationStatus'] as String? ?? 'pending',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'licenses': licenses,
      'experienceYears': experienceYears,
      'languages': languages,
      'countriesWorked': countriesWorked,
      'isAvailable': isAvailable,
      'rating': rating,
      'location': location?.toMap(),
      'currentCity': currentCity,
      'profileImageUrl': profileImageUrl,
      'licenseImageUrl': licenseImageUrl,
      'attestationUrls': attestationUrls,
      'verificationStatus': verificationStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class GeoPointModel {
  final double latitude;
  final double longitude;

  const GeoPointModel({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() => {'latitude': latitude, 'longitude': longitude};

  factory GeoPointModel.fromMap(Map<String, dynamic> map) {
    return GeoPointModel(
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
    );
  }
}

class CompanyProfileModel {
  final String id;
  final String driverId;
  final String companyName;
  final String country;
  final String? logoUrl;
  final String? documentUrl;
  final bool verified;
  final double rating;
  final String verificationStatus;
  final DateTime createdAt;

  const CompanyProfileModel({
    required this.id,
    required this.driverId,
    required this.companyName,
    required this.country,
    this.logoUrl,
    this.documentUrl,
    this.verified = false,
    this.rating = 0,
    this.verificationStatus = 'pending',
    required this.createdAt,
  });

  factory CompanyProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return CompanyProfileModel(
      id: id,
      driverId: map['driverId'] as String? ?? '',
      companyName: map['companyName'] as String? ?? '',
      country: map['country'] as String? ?? '',
      logoUrl: map['logoUrl'] as String?,
      documentUrl: map['documentUrl'] as String?,
      verified: map['verified'] as bool? ?? false,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      verificationStatus: map['verificationStatus'] as String? ?? 'pending',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'companyName': companyName,
      'country': country,
      'logoUrl': logoUrl,
      'documentUrl': documentUrl,
      'verified': verified,
      'rating': rating,
      'verificationStatus': verificationStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class JobModel {
  final String id;
  final String companyId;
  final String companyName;
  final String title;
  final String country;
  final double salary;
  final String vehicleType;
  final String contractDuration;
  final bool visaSponsorship;
  final String? description;
  final DateTime createdAt;

  const JobModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.title,
    required this.country,
    required this.salary,
    required this.vehicleType,
    required this.contractDuration,
    this.visaSponsorship = false,
    this.description,
    required this.createdAt,
  });

  factory JobModel.fromMap(Map<String, dynamic> map, String id) {
    return JobModel(
      id: id,
      companyId: map['companyId'] as String? ?? '',
      companyName: map['companyName'] as String? ?? '',
      title: map['title'] as String? ?? '',
      country: map['country'] as String? ?? '',
      salary: (map['salary'] as num?)?.toDouble() ?? 0,
      vehicleType: map['vehicleType'] as String? ?? '',
      contractDuration: map['contractDuration'] as String? ?? '',
      visaSponsorship: map['visaSponsorship'] as bool? ?? false,
      description: map['description'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'companyName': companyName,
      'title': title,
      'country': country,
      'salary': salary,
      'vehicleType': vehicleType,
      'contractDuration': contractDuration,
      'visaSponsorship': visaSponsorship,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ApplicationModel {
  final String id;
  final String jobId;
  final String driverId;
  final String driverName;
  final String status;
  final DateTime createdAt;

  const ApplicationModel({
    required this.id,
    required this.jobId,
    required this.driverId,
    required this.driverName,
    this.status = 'pending',
    required this.createdAt,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> map, String id) {
    return ApplicationModel(
      id: id,
      jobId: map['jobId'] as String? ?? '',
      driverId: map['driverId'] as String? ?? '',
      driverName: map['driverName'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'driverId': driverId,
      'driverName': driverName,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}