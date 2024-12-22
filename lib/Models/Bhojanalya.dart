class Bhojnalaya {
  final String id;
  final String uid;
  final String title;
  final String location;
  final int monthlyCharge1;
  final int monthlyCharge2;
  final String timings;
  final String pincode;
  final String city;
  final int price;
  final List<String> image;
  final String parcelOfFood;
  final String veg;
  final List<String> amenities;
  final String parking;
  final String specialThali;
  final String description;
  final bool isApproved;
  final bool featureListing;
  final DateTime createdAt;
  final DateTime updatedAt;

  Bhojnalaya({
    required this.id,
    required this.uid,
    required this.title,
    required this.location,
    required this.monthlyCharge1,
    required this.monthlyCharge2,
    required this.timings,
    required this.pincode,
    required this.city,
    required this.price,
    required this.image,
    required this.parcelOfFood,
    required this.veg,
    required this.amenities,
    required this.parking,
    required this.specialThali,
    required this.description,
    required this.isApproved,
    required this.featureListing,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Bhojnalaya.fromJson(Map<String, dynamic> json) {
    return Bhojnalaya(
      id: json['_id'] ?? '',
      uid: json['uid'] ?? '',
      pincode: json['pincode'] ?? '',
      city: json['city'] ?? '',
      title: json['bhojanalayName'] ?? '',
      location: json['location'] ?? '',
      monthlyCharge1: int.tryParse(json['monthlyCharge1'].toString()) ?? 0,
      monthlyCharge2: int.tryParse(json['monthlyCharge2'].toString()) ?? 0,
      timings: json['timings'] ?? '',
      price: int.tryParse(json['priceOfThali'].toString()) ?? 0,
      image: List<String>.from(json['images'] ?? []),
      parcelOfFood: json['parcelOfFood'] ?? '',
      veg: json['veg'] ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      parking: json['parking'] ?? '',
      specialThali: json['specialThali'] ?? '',
      description: json['description'] ?? '',
      isApproved: json['isApproved'] ?? false,
      featureListing: json['FeatureListing'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
