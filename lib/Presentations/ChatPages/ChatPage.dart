import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../Models/User.dart';
import 'ChatCard.dart';
import 'chatscreen.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  List<User> users = [];
  List<String> rooms = [];
  List<String> recentMessages = [];
  List<bool> mutedChats = [];
  List<bool> blockedChats = [];
  List<bool> important = [];
  List<DateTime> time = [];
  late TabController _tabController;
  String userid = '';
  String id = '';
  String name = '';

  // New variables for multi-select
  List<bool> _isSelectedList = [];
  List<bool> _isSelectedImportantList = [];
  bool _isMultiSelectMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    userID();
  }

  Future<void> userID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('uid') ?? '';
      name = prefs.getString('name') ?? '';
    });
    await fetchChatData();
  }

  Future<void> fetchChatData() async {
    try {
      final String baseUrl = 'http://10.0.2.2:8000/api';
      final response =
          await http.get(Uri.parse('${baseUrl}/chat-users?useruid=$userid'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          users = data.isNotEmpty
              ? data.map((json) => User.fromJson(json['user'])).toList()
              : [];
          rooms = data.isNotEmpty
              ? data.map<String>((json) => json['roomId'] as String).toList()
              : [];

          recentMessages = data.isNotEmpty
              ? data
                  .map<String>((json) => json['mostRecentMessage'] != null
                      ? json['mostRecentMessage']['message'] as String
                      : '')
                  .toList()
              : [];

          mutedChats = data.isNotEmpty
              ? data
                  .map<bool>((json) => json['mostRecentMessage'] != null
                      ? json['mostRecentMessage']['Mute'] as bool
                      : false)
                  .toList()
              : [];

          blockedChats = data.isNotEmpty
              ? data
                  .map<bool>((json) => json['mostRecentMessage'] != null
                      ? json['mostRecentMessage']['Block'] as bool
                      : false)
                  .toList()
              : [];

          important = data.isNotEmpty
              ? data
                  .map<bool>((json) => json['mostRecentMessage'] != null
                      ? json['mostRecentMessage']['important'] as bool
                      : false)
                  .toList()
              : [];

          time = data.isNotEmpty
              ? data
                  .map<DateTime>((json) => json['mostRecentMessage'] != null
                      ? DateTime.parse(
                          json['mostRecentMessage']['timestamp'] as String)
                      : DateTime.now())
                  .toList()
              : [];

          // Initialize selection lists
          _isSelectedList = List.filled(users.length, false);
          _isSelectedImportantList = List.filled(
              users.where((user) => important[users.indexOf(user)]).length,
              false);
        });
      } else {
        throw Exception('Failed to load chat data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // New method to handle multi-select deletion
  Future<void> deleteSelectedChats() async {
    // Determine which list of rooms to delete based on the current tab
    List<String> roomsToDelete = [];
    List<bool> currentSelectedList =
        _tabController.index == 0 ? _isSelectedList : _isSelectedImportantList;

    // Get the current list of users based on the tab
    List<User> currentUsers = _tabController.index == 0
        ? users
        : users.where((user) => important[users.indexOf(user)]).toList();

    for (int i = 0; i < currentSelectedList.length; i++) {
      if (currentSelectedList[i]) {
        // Find the index of the user in the original users list
        int originalIndex = users.indexOf(currentUsers[i]);
        roomsToDelete.add(rooms[originalIndex]);
      }
    }
    print(roomsToDelete.isEmpty);
    if (roomsToDelete.isEmpty) return;
    // print(roomsToDelete.isEmpty);

    try {
      print('object');
      final String baseUrl = 'http://10.0.2.2:8000/api';
      final response = await http.post(Uri.parse('${baseUrl}/delete-chats'),
          body: jsonEncode({'roomid': roomsToDelete}),
          headers: {'Content-Type': 'application/json'});
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        // Refresh data after deletion
        await fetchChatData();

        // Exit multi-select mode
        setState(() {
          _isMultiSelectMode = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Chats deleted successfully')));
      } else {
        throw Exception('Failed to delete chats');
      }
    } catch (e) {
      print('Error deleting chats: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete chats')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isMultiSelectMode
            ? Text(
                '${_tabController.index == 0 ? _isSelectedList.where((isSelected) => isSelected).length : _isSelectedImportantList.where((isSelected) => isSelected).length} Selected')
            : null,
        actions: _isMultiSelectMode
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Chats'),
                          content: Text(
                              'Are you sure you want to delete the selected chats?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                deleteSelectedChats();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ]
            : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chats",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    fontSize: 35,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    setState(() {
                      _isMultiSelectMode = !_isMultiSelectMode;
                      // Reset selection lists when entering/exiting multi-select mode
                      _isSelectedList = List.filled(users.length, false);
                      _isSelectedImportantList = List.filled(
                          users
                              .where((user) => important[users.indexOf(user)])
                              .length,
                          false);
                    });
                  },
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.purple,
            tabs: [
              Tab(text: "All Chats"),
              Tab(text: "Important"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ChatList(
                  users: users,
                  roomId: rooms,
                  uid: userid,
                  recentMessages: recentMessages,
                  time: time,
                  name: name,
                  muteChats: mutedChats,
                  blockChats: blockedChats,
                  important: important,
                  isMultiSelectMode: _isMultiSelectMode,
                  isSelectedList: _isSelectedList,
                  onSelectionChanged: (index, isSelected) {
                    setState(() {
                      _isSelectedList[index] = isSelected;
                    });
                  },
                ),
                ChatList(
                  users: users
                      .asMap()
                      .entries
                      .where((entry) => important[entry.key])
                      .map((entry) => entry.value)
                      .toList(),
                  roomId: rooms
                      .asMap()
                      .entries
                      .where((entry) => important[entry.key])
                      .map((entry) => entry.value)
                      .toList(),
                  uid: userid,
                  recentMessages: recentMessages
                      .asMap()
                      .entries
                      .where((entry) => important[entry.key])
                      .map((entry) => entry.value)
                      .toList(),
                  time: time
                      .asMap()
                      .entries
                      .where((entry) => important[entry.key])
                      .map((entry) => entry.value)
                      .toList(),
                  name: name,
                  muteChats: mutedChats
                      .asMap()
                      .entries
                      .where((entry) => important[entry.key])
                      .map((entry) => entry.value)
                      .toList(),
                  blockChats: blockedChats
                      .asMap()
                      .entries
                      .where((entry) => important[entry.key])
                      .map((entry) => entry.value)
                      .toList(),
                  important:
                      important.where((isImportant) => isImportant).toList(),
                  isMultiSelectMode: _isMultiSelectMode,
                  isSelectedList: _isSelectedImportantList,
                  onSelectionChanged: (index, isSelected) {
                    setState(() {
                      // Update the selection in the important list
                      _isSelectedImportantList[index] = isSelected;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  final List<User> users;
  final List<String> roomId;
  final List<String> recentMessages;
  final List<bool> muteChats;
  final List<bool> important;
  final List<bool> blockChats;
  final List<DateTime> time;
  final String uid;
  final String name;

  // New parameters for multi-select
  final bool isMultiSelectMode;
  final List<bool> isSelectedList;
  final Function(int, bool)? onSelectionChanged;

  ChatList({
    required this.users,
    required this.roomId,
    required this.uid,
    required this.recentMessages,
    required this.time,
    required this.name,
    required this.muteChats,
    required this.blockChats,
    required this.important,
    this.isMultiSelectMode = false,
    this.isSelectedList = const [],
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure all lists are the same length
    if (users.isEmpty ||
        roomId.isEmpty ||
        recentMessages.isEmpty ||
        time.isEmpty ||
        users.length != roomId.length ||
        users.length != recentMessages.length ||
        users.length != time.length) {
      return Center(child: Text("No chats available"));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        // Determine if this chat is selected (for multi-select mode)
        final isSelected = isMultiSelectMode &&
            index < isSelectedList.length &&
            isSelectedList[index];

        return GestureDetector(
          onTap: isMultiSelectMode
              ? () {
                  // Toggle selection in multi-select mode
                  if (onSelectionChanged != null) {
                    onSelectionChanged!(index, !(isSelectedList[index]));
                  }
                }
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        senderId: uid,
                        receiverId: user.uid,
                        roomId: roomId[index],
                        user: user,
                        name: name,
                        block: blockChats[index],
                        mute: muteChats[index],
                        important: important[index],
                      ),
                    ),
                  );
                },
          child: Container(
            color: isSelected ? Colors.blue.withOpacity(0.2) : null,
            child: Stack(
              children: [
                ChatCard(
                  name: user.name,
                  date: DateFormat('HH:mm').format(time[index]),
                  lastMessage: recentMessages[index],
                  unreadCount: 0,
                  ProfilePicture: user.picture,
                ),
                if (isMultiSelectMode)
                  Positioned(
                    right: 10,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          if (onSelectionChanged != null && value != null) {
                            onSelectionChanged!(index, value);
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
