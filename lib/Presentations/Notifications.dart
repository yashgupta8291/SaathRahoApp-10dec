import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool IsAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !IsAvailable
          ? AppBar(
              backgroundColor: Colors.transparent,
              scrolledUnderElevation: 0,
            )
          : null,
      body: IsAvailable
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset("assets/images/logo.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "No new notification till yet",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 10),
                    ),
                  ),
                  Text(
                    "Always check to get best offers and deals",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 11),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 150,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: Text(
                        "yydsgcvcd sdnfjdhsfbvds jhxxbvhd xcnjvb xdbvbjh....................",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
    );
  }
}
