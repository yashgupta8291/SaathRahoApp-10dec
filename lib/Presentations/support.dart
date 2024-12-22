import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportChatScreen extends StatefulWidget {
  @override
  _SupportChatScreenState createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  List<String> selectedOptions = [];
  final List<String> initialOptions = [
    "Order purchasing related?",
    "Refund & Return Policy?",
    "1-1 Consultation with Expert?"
  ];

  final Map<String, List<String>> followUpOptions = {
    "Order purchasing related?": [
      "Payment Issue?",
      "Incomplete Transaction?",
      "Other Issue?"
    ],
    "Refund & Return Policy?": [
      "Return Process?",
      "Refund Eligibility?",
      "Other Question?"
    ],
    "1-1 Consultation with Expert?": [
      "Scheduling?",
      "Consultation Fee?",
      "Other Query?"
    ],
  };

  void onSelectOption(String option) {
    setState(() {
      if (!selectedOptions.contains(option)) {
        selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: ChatHeaderClipper(),
            child: Container(
              width: double.infinity,
              height: 150,
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(252, 246, 189, 50),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chat with',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.support_agent, size: 24, color: Colors.purple),
                    ],
                  ),
                  Text(
                    'RoomieQ person',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 5),
                      child: Icon(Icons.support_agent,
                          size: 24, color: Colors.purple),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(228, 193, 249, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Hi, How can I help you?",
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                  Column(
                    children: initialOptions
                        .map((option) => OptionButton(
                              label: option,
                              onTap: () => onSelectOption(option),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 20),
                  ...selectedOptions.map((option) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(228, 193, 249, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              option,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: const Color.fromARGB(255, 6, 5, 5)),
                            ),
                          ),
                        ),
                        if (followUpOptions.containsKey(option))
                          ...followUpOptions[option]!.map((subOption) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: OptionButton(
                                label: subOption,
                                onTap: () => onSelectOption(subOption),
                              ),
                            );
                          }).toList(),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const OptionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purple),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 15, color: const Color.fromARGB(255, 15, 15, 15)),
          ),
        ),
      ),
    );
  }
}

// Custom Clipper for Header Wave
class ChatHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80); // Move down near the bottom left

    // Create a wave towards the right side
    path.quadraticBezierTo(
        size.width * 0.35, size.height, size.width, size.height - 30);

    path.lineTo(size.width, 0); // Move to the top-right corner
    path.close(); // Close the path to form the shape
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
