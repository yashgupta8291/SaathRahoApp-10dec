import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maan/ApiServices/ApiServices.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

import '../../ApiServices/NotificationServices.dart';
import '../../Components/chatPopUps.dart';
import '../../Models/User.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String senderId;
  final String receiverId;
  final String name;
  final User user;
  final bool block;
  final bool mute;
  final bool important;

  ChatScreen({
    required this.roomId,
    required this.senderId,
    required this.receiverId,
    required this.user,
    required this.name,
    required this.block,
    required this.mute,
    required this.important,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];
  ScrollController _scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  bool isSeen = false;
  bool _isUserScrolling = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late bool block;
  late bool mute;
  late bool important;
  bool _shouldAutoScroll = true;
  @override
  void initState() {
    super.initState();
    block = widget.block;
    mute = widget.mute;
    important = widget.important;
    connectToSocket();
// Add scroll listener to detect manual scrolling
    _scrollController.addListener(() {
      // If user scrolls up, disable auto-scrolling
      if (_scrollController.position.pixels < _scrollController.position.maxScrollExtent) {
        _shouldAutoScroll = false;
      }
    });

    // Modified scroll listener
    // Use post-frame callback to ensure initial scroll works after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }


  void _scrollToBottom() {
    // Only scroll to bottom if auto-scroll is enabled
    if (_shouldAutoScroll && _scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      final messageData = {
        'roomId': widget.roomId,
        'senderId': widget.senderId,
        'important': widget.important,
        'receiverId': widget.receiverId,
        'message': messageController.text,
        'timestamp': DateTime.now().toIso8601String(),
        'image': null, // No image initially
        'Seen': false, // Initially false, as the message is not seen
      };

      socket.emit('send_message', messageData);
      setState(() {
        // messages.add(messageData);
        messageController.clear();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void markMessageAsSeen(String messageId) {
    print('Marking message as seen: $messageId');
    socket.emit('mark_seen', messageId);
  }

  void connectToSocket() {
    socket = IO.io(
      'http://10.0.2.2:8000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();
    socket.onConnect((_) {
      print('Connected to socket');
      socket.emit('join_room', widget.roomId);

      socket.on('load_previous_messages', (data) {
        setState(() {
          messages = List<Map<String, dynamic>>.from(data);
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      });

      socket.on('receive_message', (data) {
        setState(() {
          messages.add(data);
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      });
    });
  }

  void _markVisibleMessagesAsSeen() {
    for (var message in messages) {
      // Check if the message is from the other user and not already seen
      if (message['receiverId'] != widget.senderId &&
          message['Seen'] == false) {
        // Use a null check and ensure we have a valid ID
        if (message['_id'] != null) {
          markMessageAsSeen(message['_id'].toString());
        } else {
          print('Message ID is null, cannot mark as seen');
        }
      }
    }
  }

  // Function to pick an image
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final messageData = {
        'roomId': widget.roomId,
        'senderId': widget.senderId,
        'receiverId': widget.receiverId,
        'important': widget.important,
        'message': '', // Empty message for image
        'timestamp': DateTime.now().toIso8601String(),
        'image': image.path,
        'Seen': false, // Path of the selected image
      };
      print('object');
      socket.emit('send_message', messageData);
      setState(() {
        print('object');
        messages.add(messageData);
      });
    }
  }

  String getMessageDateHeader(String timestamp) {
    final messageDate = DateTime.parse(timestamp);
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDay =
    DateTime(messageDate.year, messageDate.month, messageDate.day);

    if (messageDay == DateTime(now.year, now.month, now.day)) {
      return 'Today';
    } else if (messageDay ==
        DateTime(yesterday.year, yesterday.month, yesterday.day)) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(messageDate);
    }
  }

  List<Widget> buildMessagesWithDateSeparators() {
    List<Widget> messageWidgets = [];
    String? currentDateHeader;

    // Sort messages by timestamp
    messages.sort((a, b) => DateTime.parse(a['timestamp'])
        .compareTo(DateTime.parse(b['timestamp'])));

    for (var msg in messages) {
      String dateHeader = getMessageDateHeader(msg['timestamp']);

      // Add date separator if it's a new date
      if (currentDateHeader != dateHeader) {
        messageWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  dateHeader,
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
        currentDateHeader = dateHeader;
      }

      // Add message bubble
      bool isReceived = msg['senderId'] != widget.senderId;
      messageWidgets.add(
        _buildChatBubble(
            msg['message'], msg['timestamp'], isReceived, msg['image']),
      );
    }

    return messageWidgets;
  }

  AppBar buildCustomAppBar(BuildContext context, String senderName) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(radius: 20, child: Icon(Icons.person)),
          SizedBox(width: 10),
          Text(
            senderName,
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              ApiFunctions.toggleImportant(widget.roomId);
              setState(() {
                important = !important;
              });
            },
            icon: Icon(
                !important ? CupertinoIcons.heart : CupertinoIcons.heart_fill,
                color: Colors.black)),
        PopupMenuButton<String>(
          color: Colors.white,
          icon: Icon(Icons.more_vert, color: Colors.black),
          onSelected: (value) {
            // Handle menu item click here
            switch (value) {
              case 'Option 1':
                showMuteChatDialog(context, () {
                  if (mute == false) {
                    ApiFunctions.muteNotifications(widget.roomId);
                  } else {
                    ApiFunctions.unmuteNotifications(widget.roomId);
                  }
                  setState(() {
                    mute = !mute;
                  });
                  print('Mute Chat');
                }, senderName, mute);
                break;
              case 'Option 2':
                showReportChatDialog(context, () async {
                  await ApiFunctions()
                      .reportUser(widget.senderId, widget.receiverId, 'reason');
                  print('Report Chat');
                }, senderName);
                break;
              case 'Option 3':
                showBlockChatDialog(context, () async {
                  if (!block) {
                    ApiFunctions.blockUser(widget.roomId);
                  } else {
                    ApiFunctions.unblockUser(widget.roomId);
                  }
                  setState(() {
                    block = !block;
                  });
                }, senderName, block);
                break;
              case 'Option 4':
                showDeleteChatDialog(context, () async {
                  await ApiFunctions().deleteRoomChat(widget.roomId);
                  Navigator.pop(context);
                  print('Delete Chat');
                });
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'Option 1',
              child: Text(
                  !widget.mute ? 'Mute Notification' : 'Unmute Notification',
                  style: GoogleFonts.poppins(
                      color: Colors.black, fontWeight: FontWeight.w500)),
            ),
            PopupMenuItem(
              value: 'Option 2',
              child: Text('Report Chat',
                  style: GoogleFonts.poppins(
                      color: Colors.black, fontWeight: FontWeight.w500)),
            ),
            PopupMenuItem(
              value: 'Option 3',
              child: Text(!widget.block ? 'Block Chat' : 'Unblock Chat',
                  style: GoogleFonts.poppins(
                      color: Colors.black, fontWeight: FontWeight.w500)),
            ),
            PopupMenuItem(
              value: 'Option 4',
              child: Text('Delete Chat',
                  style: GoogleFonts.poppins(
                      color: Colors.black, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ],
      backgroundColor: Colors.grey[300],
      elevation: 0,
    );
  }

  @override
  void dispose() {
    socket.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.mute);
    print(widget.block);
    return Scaffold(
      appBar: buildCustomAppBar(context, widget.user.name),
      body: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification) {
                  // Check if user is at the bottom, if so, re-enable auto-scroll
                  if (_scrollController.position.pixels ==
                      _scrollController.position.maxScrollExtent) {
                    _shouldAutoScroll = true;
                  }

                  _markVisibleMessagesAsSeen();
                }
                return false;
              },
              child: ListView(
                key: _listKey,
                controller: _scrollController,
                children: buildMessagesWithDateSeparators(),
              ),
            ),
          ),
          if (!block) _buildMessageInput(),
          if (block)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey[200],
                width: double.infinity,
                child: Center(child: Text('Blocked Chats')),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(
      String text, String time, bool isReceived, String? image) {
    DateTime parsedTime = DateTime.parse(time);
    print('Original Time: $time');
    print('Parsed Time (UTC): $parsedTime');
    print('Parsed Time (Local): ${parsedTime.toLocal()}');

    String formattedTime = DateFormat('hh:mm a').format(parsedTime.toLocal());
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 1.0, right: 1.0),
      child: Column(
        crossAxisAlignment:
        isReceived ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          // Check if the message contains an image
          if (image != null && image.isNotEmpty)
            Image.file(File(image), width: 200, height: 200, fit: BoxFit.cover),
          if (text.isNotEmpty)
            BubbleNormal(
              text: text,
              color: isReceived ? Colors.grey[300]! : Colors.green[100]!,
              tail: true,
              bubbleRadius: 12,
              isSender: !isReceived,
              seen: isSeen,
              textStyle:
              GoogleFonts.poppins(color: Colors.black54, fontSize: 13),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: 4.0,
              left: isReceived ? 8 : 10,
              right: isReceived ? 10 : 8,
            ),
            child: Text(
              formattedTime,
              style: GoogleFonts.poppins(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.image, color: Colors.black),
            onPressed: pickImage, // Pick image on button press
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(hintText: 'Enter message'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              sendMessage();
              if (!widget.mute)
                SendChatNotification.sendChatNotification(
                    widget.user.uid, widget.name);
            },
          ),
        ],
      ),
    );
  }
}