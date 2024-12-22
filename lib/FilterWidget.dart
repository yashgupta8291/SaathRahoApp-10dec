import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, List<String>> filters;
  final Function(Map<String, dynamic>) onApply;

  const FilterBottomSheet({
    Key? key,
    required this.filters,
    required this.onApply,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedFilter;
  Map<String, dynamic> selectedOptions = {};
  RangeValues _priceRange = RangeValues(0, 10000);
  TextEditingController locationController =
      TextEditingController(); // Controller for TextField

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.filters.keys.first;
    widget.filters.keys.forEach((key) {
      selectedOptions[key] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height / 1.2,
      child: Column(
        children: [
          Text(
            "Filters",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: widget.filters.keys.map((filterKey) {
                      return ListTile(
                        title: Text(
                          filterKey,
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        tileColor: selectedFilter == filterKey
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.transparent,
                        onTap: () {
                          setState(() {
                            selectedFilter = filterKey;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedFilter!,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        // Show Price Range Slider only if "Price Range" is selected
                        if (selectedFilter == 'Location Preference')
                          Column(
                            children: [
                              TextField(
                                controller: locationController,
                                decoration: InputDecoration(
                                  labelText: "Enter location",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    // Capture the location input
                                    selectedOptions['Location Preference'] =
                                        value;
                                  });
                                },
                              ),
                            ],
                          )
                        else if (selectedFilter == 'Price Range' ||
                            selectedFilter == 'Budget' ||
                            selectedFilter == 'Build-up Area')
                          // Show the RangeSlider only for Price Range or Budget
                          Column(
                            children: [
                              RangeSlider(
                                values: _priceRange,
                                min: 0,
                                max: 10000,
                                divisions: 100,
                                labels: RangeLabels(
                                  '₹${_priceRange.start.round()}',
                                  '₹${_priceRange.end.round()}',
                                ),
                                onChanged: (RangeValues values) {
                                  setState(() {
                                    _priceRange = values;
                                  });
                                },
                              ),
                              if (selectedFilter == 'Price Range'||selectedFilter == 'Budget')
                                Text(
                                    'Range: ₹${_priceRange.start.round()} - ₹${_priceRange.end.round()}',
                                    style: TextStyle(fontSize: 12)),
                              if (selectedFilter == 'Build-up Area')
                                Text(
                                  'Area: ${_priceRange.start.round()} - ${_priceRange.end.round()}',
                                  style: TextStyle(fontSize: 12),
                                ),
                            ],
                          )
                        else
                          // Show predefined options (ChoiceChip) for all other filters
                          Expanded(
                            child: Wrap(
                              spacing: 10.0,
                              runSpacing: 10.0,
                              children: widget.filters[selectedFilter!]!
                                  .map(
                                    (option) => ChoiceChip(
                                      label: Text(option),
                                      selected:
                                          selectedOptions[selectedFilter] ==
                                              option,
                                      onSelected: (isSelected) {
                                        setState(() {
                                          selectedOptions[selectedFilter!] =
                                              isSelected ? option : null;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    // Reset the selectedOptions and priceRange
                    selectedOptions = {
                      for (var key in widget.filters.keys) key: null
                    };
                    _priceRange =
                        RangeValues(0, 10000); // Correct reset of priceRange
                    locationController.clear(); // Clear the location input
                  });
                },
                child: Text("Reset"),
              ),
              ElevatedButton(
                onPressed: () {
                  // If the Price Range filter is selected, add the selected range
                  if (selectedFilter == 'Price Range') {
                    selectedOptions['Price Range'] =
                        '${_priceRange.start.round()}-${_priceRange.end.round()}';
                  }
                  widget.onApply(selectedOptions); // Apply the filter
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text("Apply"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
