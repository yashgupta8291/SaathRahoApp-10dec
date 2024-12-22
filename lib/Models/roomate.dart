class Roommate {
  final String id;
  final String title;
  final String location;
  final String userUid;
  final String hometown;
  final String price;
  final String roomPreference;
  final String languagePreference;
  final String pincode;
  final String city;
  final String preferredGender;
  final String occupation;
  final String moveInDetails;
  final String locationPreference;
  final List<String> interests;
  final List<String> image;
  final String description;
  final bool isApproved;
  final bool featureListing;
  final String categoryType; // Assuming this is another field
  final DateTime createdAt;
  final DateTime updatedAt;

  Roommate({
    required this.id,
    required this.title,
    required this.location,
    required this.userUid,
    required this.price,
    required this.hometown,
    required this.roomPreference,
    required this.languagePreference,
    required this.preferredGender,
    required this.occupation,
    required this.pincode,
    required this.city,
    required this.moveInDetails,
    required this.locationPreference,
    required this.interests,
    required this.description,
    required this.image,
    required this.isApproved,
    required this.featureListing,
    required this.categoryType,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Roommate object from a JSON map
  factory Roommate.fromJson(Map<String, dynamic> json) {
    return Roommate(
      id: json['_id'],
      title: json['name'],
      image: List<String>.from(json['image'] ?? []),
      location: json['location'],
      userUid: json['uid'],
      hometown: json['hometown'],
      price: json['budget'],
      roomPreference: json['roomPreference'],
      languagePreference: json['languagePreference'],
      preferredGender: json['genderPreference'],
      occupation: json['occupation'],
      pincode: json['pincode'],
      city: json['city'],
      moveInDetails: json['moveInDate'],
      locationPreference: json['locationPreference'],
      interests: List<String>.from(json['interests'] ?? []),
      description: json['description'] ?? '',
      isApproved: json['isApproved'] ?? false,
      featureListing: json['FeatureListing'] ?? false,
      categoryType: json['categoryType'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert a Roommate object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': title,
      'images': image,
      'location': location,
      'price': price,
      'uid': userUid,
      'pincode': pincode,
      'city': city,
      'hometown': hometown,
      'roomPreference': roomPreference,
      'languagePreference': languagePreference,
      'genderPreference': preferredGender,
      'occupation': occupation,
      'moveInDate': moveInDetails,
      'locationPreference': locationPreference,
      'interests': interests,
      'description': description,
      'isApproved': isApproved,
      'FeatureListing': featureListing,
      'categoryType': categoryType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
