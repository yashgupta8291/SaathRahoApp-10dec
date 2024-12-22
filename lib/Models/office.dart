class Office {
  final String title;
  final String userUid;
  final String officeLocation;
  final String officeTitle;
  final String price;
  final String officeFloorNo;
  final String location;
  final String officeTotalFloor;
  final String carpetArea;
  final String officeFacing;
  final String officeDeposit;
  final String pincode;
  final String city;
  final String parkingAvailable;
  final String noOfCabins;
  final String noOfBathrooms;
  final String furnished;
  final String listedBy;
  final List<String> amenities;
  final String officeDescription;
  final bool isApproved;
  final bool featureListing;
  final List<String> image;
  final String createdAt;
  final String officeId;

  Office({
    required this.title,
    required this.userUid,
    required this.city,
    required this.pincode,
    required this.officeLocation,
    required this.officeTitle,
    required this.price,
    required this.officeFloorNo,
    required this.officeTotalFloor,
    required this.carpetArea,
    required this.officeFacing,
    required this.officeDeposit,
    required this.parkingAvailable,
    required this.noOfCabins,
    required this.noOfBathrooms,
    required this.furnished,
    required this.listedBy,
    required this.amenities,
    required this.officeDescription,
    required this.location,
    required this.isApproved,
    required this.image,
    required this.featureListing,
    required this.createdAt,
    required this.officeId,
  });

  // Factory to create an Office instance from JSON
  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      title: json['title'] ?? '',
      pincode: json['pincode'] ?? '',
      city: json['city'] ?? '',
      userUid: json['uid'] ?? '',
      officeLocation: json['location'] ?? '',
      officeTitle: json['title'] ?? '',
      price: json['monthlyMaintenance'] ?? '',
      officeFloorNo: json['floorNo'] ?? '',
      officeTotalFloor: json['totalFloor'] ?? '',
      carpetArea: json['carpetArea'] ?? '',
      officeFacing: json['facing'] ?? '',
      officeDeposit: json['deposit'] ?? '',
      parkingAvailable: json['parking'] ?? '',
      noOfCabins: json['cabins'] ?? '',
      noOfBathrooms: json['bathroom'] ?? '',
      furnished: json['furnished'] ?? '',
      listedBy: json['listedBy'] ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      officeDescription: json['description'] ?? '',
      isApproved: json['isApproved'] ?? false,
      featureListing: json['featureListing'] ?? false,
      image: List<String>.from(json['images'] ?? []),
      createdAt: json['createdAt'] ?? '',
      location: json['location'] ?? '',
      officeId: json['_id'] ?? '',
    );
  }

  // Method to convert Office instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'uid': userUid,
      'location': officeLocation,
      'officeTitle': officeTitle,
      'price': price,
      'floorNo': officeFloorNo,
      'totalFloor': officeTotalFloor,
      'carpetArea': carpetArea,
      'facing': officeFacing,
      'deposit': officeDeposit,
      'parking': parkingAvailable,
      'cabins': noOfCabins,
      'bathroom': noOfBathrooms,
      'furnished': furnished,
      'featureListing': featureListing,
      'listedBy': listedBy,
      'amenities': amenities,
      'description': officeDescription,
      'location': location,
      'isApproved': isApproved,
      'images': image,
      'pincode': pincode,
      'city': city,
      'createdAt': createdAt,
      '_id': officeId,
    };
  }
}
