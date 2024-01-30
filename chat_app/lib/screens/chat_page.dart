import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final String name, profilePic, userName;

  const ChatPage({
    super.key,
    required this.name,
    required this.profilePic,
    required this.userName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  String? myUserName, myName, myProfilePic, myEmail, messageId, chatRoomId;
  Stream? messageStream;

  getChatRoomIDByUserName(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$b\_$a";
    }
  }

  ///
  getSharedPrefs() async {
    myName = await LocalDatabase().getUserDisplayName();
    myUserName = await LocalDatabase().getUserName();
    myProfilePic = await LocalDatabase().getUserPic();
    myEmail = await LocalDatabase().getUserEmail();
    chatRoomId = getChatRoomIDByUserName(myUserName!, widget.userName);
    setState(() {});
  }

  ///
  onTheLoad() async {
    await getSharedPrefs();
    await getAndSetMessage();
    setState(() {});
  }

  ///
  addMessage(bool sendClicked) {
    if (messageController.text.isNotEmpty) {
      String message = messageController.text;
      print(message);
      messageController.clear();

      DateTime time = DateTime.now();

      String formattedDate = DateFormat('h:mma').format(time);

      Map<String, dynamic> messageInfoMap = {
        'message': message,
        'sentBy': myUserName,
        'timeStamp': formattedDate,
        'time': FieldValue.serverTimestamp(),
        'imgUrl': myProfilePic,
      };

      messageId ??= const Uuid().v1();

      DatabaseMethod()
          .addMessage(chatRoomId!, messageId!, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          'lastMessage': message,
          'lastMessageSendTs': formattedDate,
          'time': FieldValue.serverTimestamp(),
          'lastMessageSendBy': myUserName,
        };

        DatabaseMethod().updateLastMessageSend(chatRoomId!, lastMessageInfoMap);
        if (sendClicked) {
          messageId = null;
        }
      });
    }
  }

  ///
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onTheLoad();
  }

  getAndSetMessage() async {
    messageStream = await DatabaseMethod().getChatRoomMessage(chatRoomId!);
    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,

      /// appbar
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.userName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      /// body
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: chatMessage(),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type a message",
                        hintStyle: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      addMessage(true);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment:
            sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4.0),
              decoration: BoxDecoration(
                color: sendByMe
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: sendByMe
                      ? const Radius.circular(24)
                      : const Radius.circular(0),
                  bottomRight: sendByMe
                      ? const Radius.circular(0)
                      : const Radius.circular(24),
                ),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chatMessage() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                padding: const EdgeInsets.only(bottom: 90.0, top: 130.0),
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  return chatMessageTile(
                    documentSnapshot['message'],
                    myUserName == documentSnapshot['sentBy'],
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
