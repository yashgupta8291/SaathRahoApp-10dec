import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AmenitiesScreen extends StatefulWidget {
  final Function(List<String>) onSelectedAmenitiesChanged;

  AmenitiesScreen({required this.onSelectedAmenitiesChanged});

  @override
  _AmenitiesScreenState createState() => _AmenitiesScreenState();
}

class _AmenitiesScreenState extends State<AmenitiesScreen> {
  final List<String> amenities = [
    "Gym",
    "Park",
    "Swimming Pool",
    "Water Purifier",
    "Heater",
    "T.V.",
    "Bed",
    "A.C",
    "Hospital Nearby",
    "Wi-Fi",
  ];
  final List<String> amenitiesImage = [
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
  ];

  List<String> selectedAmenities = [];

  void _toggleSelection(String amenity) {
    setState(() {
      if (selectedAmenities.contains(amenity)) {
        selectedAmenities.remove(amenity);
      } else {
        selectedAmenities.add(amenity);
      }
      widget.onSelectedAmenitiesChanged(
          selectedAmenities); // Pass the updated list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: GridView.builder(
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 1,
                crossAxisSpacing: 20,
                childAspectRatio: 0.3,
              ),
              itemBuilder: (context, index) {
                final amenity = amenities[index];
                final isSelected = selectedAmenities.contains(amenity);

                return GestureDetector(
                  onTap: () => _toggleSelection(amenity),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: SvgPicture.asset(
                          fit: BoxFit.contain,
                          amenitiesImage[index],
                          width: 10,
                          height: 10,
                        ),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.yellow[50]
                              : Colors.yellow[100],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors.transparent,
                              spreadRadius: 0,
                              blurRadius: 3,
                              offset: Offset(5, 5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        amenity,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InterestAmenitiesScreen extends StatefulWidget {
  final Function(List<String>) onSelectedAmenitiesChanged;

  InterestAmenitiesScreen({required this.onSelectedAmenitiesChanged});

  @override
  _InterestAmenitiesScreen createState() => _InterestAmenitiesScreen();
}

class _InterestAmenitiesScreen extends State<InterestAmenitiesScreen> {
  final List<String> amenities = [
    "Fitness",
    "Travel",
    "Alcohol",
    "Party",
    "Sports",
    "Reading",
    "Gaming",
    "Singing",
    "Dancing",
    "Food",
  ];
  final List<String> amenitiesImage = [
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
    "assets/svgs/dumbell.svg",
  ];

  List<String> selectedAmenities = [];

  void _toggleSelection(String amenity) {
    setState(() {
      if (selectedAmenities.contains(amenity)) {
        selectedAmenities.remove(amenity);
      } else {
        selectedAmenities.add(amenity);
      }
      widget.onSelectedAmenitiesChanged(
          selectedAmenities); // Pass the updated list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: GridView.builder(
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 1,
                crossAxisSpacing: 20,
                childAspectRatio: 0.3,
              ),
              itemBuilder: (context, index) {
                final amenity = amenities[index];
                final isSelected = selectedAmenities.contains(amenity);

                return GestureDetector(
                  onTap: () => _toggleSelection(amenity),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: SvgPicture.asset(
                          fit: BoxFit.contain,
                          amenitiesImage[index],
                          width: 10,
                          height: 10,
                        ),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.yellow[50]
                              : Colors.yellow[100],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors.transparent,
                              spreadRadius: 0,
                              blurRadius: 3,
                              offset: Offset(5, 5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        amenity,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyAmenties extends StatefulWidget {
  final Function(List<String>) onSelectedAmenitiesChanged;
  final List<String> propertyAmenities;

  PropertyAmenties({
    required this.onSelectedAmenitiesChanged,
    required this.propertyAmenities,
  });

  @override
  State<PropertyAmenties> createState() => _PropertyAmentiesState();
}

class _PropertyAmentiesState extends State<PropertyAmenties> {
  final List<String> amenities = [
    "Gym",
    "Park",
    "Swimming Pool",
    "Water Purifier",
    "Heater",
    "T.V.",
    "Bed",
    "A.C",
    "Hospital Nearby",
    "Wi-Fi",
  ];

  @override
  Widget build(BuildContext context) {
    final filteredAmenities = amenities
        .where((amenity) => widget.propertyAmenities.contains(amenity))
        .toList();

    return SingleChildScrollView(
      // Wrap the entire column
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amenities',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredAmenities.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final amenity = filteredAmenities[index];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Colors.yellow[100],
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: Offset(5, 5),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      amenity,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class InterestAmenties extends StatefulWidget {
  final Function(List<String>) onSelectedAmenitiesChanged;
  final List<String> propertyAmenities; // Pass in the amenities you want to compare against

  InterestAmenties({
    required this.onSelectedAmenitiesChanged,
    required this.propertyAmenities, // Accept the list of amenities from outside
  });

  @override
  State<InterestAmenties> createState() => _InterestAmentiesState();
}

class _InterestAmentiesState extends State<InterestAmenties> {
  final List<String> amenities = [
    "Fitness",
    "Travel",
    "Alcohol",
    "Party",
    "Sports",
    "Reading",
    "Gaming",
    "Singing",
    "Dancing",
    "Food",
  ];

  @override
  Widget build(BuildContext context) {
    // Filter amenities to include only those present in `propertyAmenities`
    final filteredAmenities = amenities
        .where((amenity) => widget.propertyAmenities.contains(amenity))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true, // Allows GridView to take up only required space
            itemCount: filteredAmenities.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final amenity = filteredAmenities[index];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: Colors.yellow[100], // Default color
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 3,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    amenity,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black87,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
