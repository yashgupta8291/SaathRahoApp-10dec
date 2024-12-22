import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showDeleteChatDialog(BuildContext context, VoidCallback action) {
  // Fixed VoidCallback type
  bool isChecked = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.all(14),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text("Are you sure you want to",
                              style: GoogleFonts.poppins(fontSize: 13)),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Delete Chat?",
                            style: GoogleFonts.poppins(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.red[100], shape: BoxShape.circle),
                      child: const Icon(Icons.delete_forever_rounded,
                          color: Colors.red, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "All the media and chats will be removed permanently",
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 1.0, top: 10),
                        child: Text(
                          "I understand that chats will not be recoverable once deleted.",
                          style: GoogleFonts.poppins(
                              fontSize: 10, color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          isChecked ? Colors.red : Colors.grey[300],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: isChecked
                        ? () {
                            action();
                            Navigator.pop(context); // Close the dialog
                          }
                        : null, // Disable button if not checked
                    child: Text('Delete',
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.black)),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> showReportChatDialog(
    BuildContext context, VoidCallback action, String Name) {
  // Fixed VoidCallback type
  bool isChecked = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.all(14),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Report?",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        Name,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 1.0, top: 10),
                        child: Text(
                          "The person will no longer be able to message you and we suspect this person.",
                          style: GoogleFonts.poppins(
                              fontSize: 10, color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          isChecked ? Colors.red : Colors.grey[300],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: isChecked
                        ? () {
                            action();
                            Navigator.pop(context); // Close the dialog
                          }
                        : null, // Disable button if not checked
                    child: Text('Report',
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.black)),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> showMuteChatDialog(
    BuildContext context, VoidCallback action, String Name, bool isMute) {
  // Fixed VoidCallback type
  bool isChecked = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.all(14),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        !isMute
                            ? "Mute Notifications?"
                            : "Unmute Notifications?",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        Name,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 1.0, top: 10),
                        child: Text(
                          !isMute
                              ? "The person will no longer be able to send you notifications."
                              : 'The person will  be able to send you notifications.',
                          style: GoogleFonts.poppins(
                              fontSize: 10, color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          isChecked ? Colors.red : Colors.grey[300],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: isChecked
                        ? () {
                            action();
                            Navigator.pop(context); // Close the dialog
                          }
                        : null, // Disable button if not checked
                    child: Text(!isMute ? 'Mute' : 'Unmute',
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.black)),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> showBlockChatDialog(
    BuildContext context, VoidCallback onBlock, String name, bool blocked) {
  String selectedReason =
      ""; // Declare outside the StatefulBuilder to retain state.

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.all(14),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                  ],
                ),
                Center(
                  child: Text(
                    !blocked ? "Block Chat" : "Unblock Chat",
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    !blocked
                        ? "$name, won't be able to message you anymore"
                        : "$name be able to message you anymore",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (!blocked)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Reason for blocking:",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      RadioListTile<String>(
                        title: Text(
                          "No longer needed",
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: Colors.black),
                        ),
                        value: "No longer needed",
                        groupValue: selectedReason,
                        onChanged: (value) {
                          setState(() {
                            selectedReason = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text(
                          "Spam person",
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: Colors.black),
                        ),
                        value: "Spam person",
                        groupValue: selectedReason,
                        onChanged: (value) {
                          setState(() {
                            selectedReason = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text(
                          "Offensive messages",
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: Colors.black),
                        ),
                        value: "Offensive messages",
                        groupValue: selectedReason,
                        onChanged: (value) {
                          setState(() {
                            selectedReason = value!;
                          });
                        },
                      ),
                    ],
                  ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    onPressed: () {
                      if (blocked) {
                        onBlock();
                        Navigator.pop(context);
                      }

                      if (!blocked && selectedReason.isNotEmpty) {
                        onBlock();
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      !blocked ? "Block" : "Unblock",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
