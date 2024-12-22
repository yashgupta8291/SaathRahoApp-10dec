import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/User.dart';
import '../Presentations/ChatPages/chatscreen.dart';

class BottomNavBarWithRoundCorners extends StatelessWidget {
  final User user;
  final String location;
  final String picture;
  final String Targetid;

  const BottomNavBarWithRoundCorners(
      {super.key,
      required this.user,
      required this.location,
      required this.picture,
      required this.Targetid});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        border: Border.all(
          color: Colors.grey.withOpacity(1),
          width: 1, // Border width
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(picture),
              backgroundColor: Colors.grey,
              radius: 25,
              child: Padding(
                padding: EdgeInsets.only(left: 8.0), // Set the left padding
              ),
            ),
            const SizedBox(width: 13), // Space between the avatar and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: TextStyle(fontSize: 16)),
                  Text(location, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String uid = prefs.getString('uid')!;
                String name = prefs.getString('name')!;
                print(uid + Targetid);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ChatScreen(
                      roomId:
                          uid + Targetid, // Ensure roomId is properly handled
                      senderId: uid,
                      receiverId: Targetid,
                      user: user,
                      name: name,
                      block: false,
                      mute: false, important: false,
                    );
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
                backgroundColor: Colors.green,
              ),
              child: const Icon(Icons.chat, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
