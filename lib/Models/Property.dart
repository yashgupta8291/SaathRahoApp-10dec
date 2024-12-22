import 'dart:convert';

class Property {
  final String uid;
  final String roomName;
  final String location;
  final String title;
  final String? price;
  final String floorNo;
  final String totalFloor;
  final String carpetArea;
  final String facing;
  final String pincode;
  final String city;
  final String? advance;
  final String bachelors;
  final String bedrooms;
  final String listedBy;
  final String bathroom;
  final String furnished;
  final String parking;
  final String categoryOfPeople;
  final List<String>? amenities;
  final String? description;
  final String? createdAt;
  final bool isApproved;
  final bool featureListing;

  final List<String> image;

  Property({
    required this.uid,
    required this.roomName,
    required this.location,
    required this.title,
    this.price,
    required this.floorNo,
    required this.totalFloor,
    required this.createdAt,
    required this.city,
    required this.pincode,
    required this.carpetArea,
    required this.facing,
    this.advance,
    required this.bachelors,
    required this.bedrooms,
    required this.listedBy,
    required this.bathroom,
    required this.furnished,
    required this.parking,
    required this.categoryOfPeople,
    required this.featureListing,
    required this.image,
    this.amenities,
    this.description,
    this.isApproved = false,

  });

  // Factory method to create a RoomForm object from a JSON map
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      uid: json['uid'],
      roomName: json['roomName'],
      createdAt: json['createdAt'],
      location: json['location'],
      title: json['title'],
      price: json['monthlyMaintenance'],
      floorNo: json['floorNo'],
      totalFloor: json['totalFloor'],
      carpetArea: json['carpetArea'],
      facing: json['facing'],
      advance: json['advance'],
      pincode: json['pincode'],
      city: json['city'],
      bachelors: json['bachelors'],
      bedrooms: json['bedrooms'],
      listedBy: json['listedBy'],
      bathroom: json['bathroom'],
      featureListing: json['featureListing'],
      furnished: json['furnished'],
      parking: json['parking'],
      categoryOfPeople: json['categoryOfPeople'],
      amenities: List<String>.from(json['amenities'] ?? []),
      description: json['description'],
      isApproved: json['isApproved'] ?? false,
      image: List<String>.from(json['images'] ?? []),
    );
  }

  // Method to convert a RoomForm object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'roomName': roomName,
      'location': location,
      'title': title,
      'price': price,
      'floorNo': floorNo,
      'totalFloor': totalFloor,
      'carpetArea': carpetArea,
      'facing': facing,
      'pincode': pincode,
      'city': city,
      'advance': advance,
      'bachelors': bachelors,
      'bedrooms': bedrooms,
      'listedBy': listedBy,
      'bathroom': bathroom,
      'furnished': furnished,
      'parking': parking,
      'categoryOfPeople': categoryOfPeople,
      'amenities': amenities,
      'description': description,
      'isApproved': isApproved,
      'createdAt': createdAt,
      'image': image,
      'featureListing': featureListing,
    };
  }
}
