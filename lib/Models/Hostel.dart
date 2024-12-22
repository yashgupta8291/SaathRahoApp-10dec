class Hostel {
  final String id;
  final String title;
  final String categoryOfPeople; // Maps to 'category'
  final String visitorsAllowed; // Maps to 'visitors'
  final String bathrooms; // Maps to 'bathroom'
  final String diningFacility; // Maps to 'dining'
  final String location;
  final String furnished;
  final String parking;
  final String electricity;
  final String pincode;
  final String city;
  final String sharing;
  final List<String> amenities;
  final String deposit;
  final int price; // Maps to 'maintenance'
  final int rent; // Maps to 'maintenance'
  final String totalFloors; // Maps to 'totalFloor'
  final bool isApproved;
  final bool featureListing;
  final String description;
  final List<String> image; // Maps to 'images'
  final String userUid; // Maps to 'uid'
  final DateTime createdAt;

  Hostel({
    required this.rent,
    required this.id,
    required this.title,
    required this.categoryOfPeople,
    required this.visitorsAllowed,
    required this.bathrooms,
    required this.diningFacility,
    required this.pincode,
    required this.city,
    required this.location,
    required this.furnished,
    required this.parking,
    required this.electricity,
    required this.sharing,
    required this.featureListing,
    required this.amenities,
    required this.deposit,
    required this.price,
    required this.totalFloors,
    required this.description,
    required this.image,
    required this.userUid,
    required this.isApproved,
    required this.createdAt,
  });

  factory Hostel.fromJson(Map<String, dynamic> json) {
    return Hostel(
      id: json['uid'] ?? '',
      title: json['hostelName'] ?? '',
      categoryOfPeople: json['category'] ?? '',
      visitorsAllowed: json['visitors'] ?? '',
      bathrooms: json['bathroom'] ?? '',
      diningFacility: json['dining'] ?? '',
      location: json['location'] ?? '',
      furnished: json['furnished'] ?? '',
      parking: json['parking'] ?? '',
      electricity: json['electricity'] ?? '',
      sharing: json['sharing'] ?? '',
      pincode: json['pincode'] ?? '',
      city: json['city'] ?? '',
      amenities:
          json['amenities'] != null ? List<String>.from(json['amenities']) : [],
      deposit: json['deposit'] ?? '',
      price: json['maintenance'] ?? '',
      totalFloors: json['totalFloor'] ?? '',
      description: json['description'] ?? '',
      rent: json['rent'] ?? '',
      image:
          json['images'] != null ? List<String>.from(json['images']) : [],
      userUid: json['uid'] ?? '',
      isApproved: json['isApproved'] ?? false,
      featureListing: json['FeatureListing'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
