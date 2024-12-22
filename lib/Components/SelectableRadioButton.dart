import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectableRadioButtons extends StatefulWidget {
  final List<String> options;
  final String label;
  final String buttonKey; // Unique key for each button set
  final Function(String, int) onSelectionChanged; // Callback with key

  SelectableRadioButtons({
    required this.options,
    required this.label,
    required this.buttonKey,
    required this.onSelectionChanged,
  });

  @override
  _SelectableRadioButtonsState createState() => _SelectableRadioButtonsState();
}

class _SelectableRadioButtonsState extends State<SelectableRadioButtons> {
  int _selectedIndex = -1; // Initial value, no option selected

  bool get isValid => _selectedIndex != -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: GoogleFonts.poppins(fontSize: 11)),
        SizedBox(height: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.options.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onSelectionChanged(widget.buttonKey, _selectedIndex);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  width: 100,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: _selectedIndex == index ? Colors.blue : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: _selectedIndex == index
                            ? Colors.blue
                            : isValid
                            ? Colors.grey
                            : Colors.red, // Border turns red if not valid
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.options[index],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: _selectedIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
