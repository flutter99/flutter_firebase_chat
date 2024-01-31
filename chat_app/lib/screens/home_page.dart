import 'package:chat_app/screens/signin_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  /// variables
  bool search = false;
  String? myName, myUserName, myEmail, myProfilePic;
  Stream? chatRoomStream;
  List<dynamic> queryResultSet = [];
  List<dynamic> tempSearchStore = [];


  /// get the share prefs method
  getTheSharedPrefs() async {
    myName = await LocalDatabase().getUserDisplayName();
    myUserName = await LocalDatabase().getUserName();
    myEmail = await LocalDatabase().getUserEmail();
    myProfilePic = await LocalDatabase().getUserPic();
    setState(() {});
  }

  /// on the load method
  onTheLoad() async {
    await getTheSharedPrefs();
    chatRoomStream = await DatabaseMethod().getChatRooms();
    setState(() {});
  }

  /// get chat room id by username method
  getChatRoomIDByUserName(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$b\_$a";
    }
  }

  /// initiateSearch method
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });

    var capitalizeValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    print(capitalizeValue);

    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethod().searchUser(value).then(
        (QuerySnapshot docs) {
          for (int i = 0; i < docs.docs.length; ++i) {
            queryResultSet.add(docs.docs[i].data());
          }
        },
      );
    } else {
      tempSearchStore = [];
      queryResultSet.forEach(
        (element) {
          if (element['username'].startsWith(capitalizeValue)) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        },
      );
    }
  }

  /// chat room list method
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 24),
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  print(documentSnapshot);
                  return ChatRoomListTile(
                    onTap: (){

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ChatPage(
                      //       name: data['name'],
                      //       profilePic: data['photo'],
                      //       userName: data['username'],
                      //     ),
                      //   ),
                      // );
                    },
                    lastMessage: documentSnapshot['lastMessage'],
                    chatRoomId: documentSnapshot.id,
                    myUserName: myUserName!,
                    time: documentSnapshot['lastMessageSendTs'],
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  /// INIT STATE
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onTheLoad();
  }

  /// MAIN BUILD WIDGET
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      resizeToAvoidBottomInset: false,

      ///
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          await FirebaseAuth.instance.signOut().then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Logout Successfully',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignInScreen(),
              ),
            );
          });
        },
        child: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),

      /// body
      body: Column(
        children: [
          /// heading
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 50.0,
              bottom: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                search == true
                    ? Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            initiateSearch(value);
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search anything here...',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : const Text(
                        "Chat App",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                GestureDetector(
                  onTap: () {
                    if (search == false) {
                      setState(() {
                        search = true;
                      });
                      print(search);
                    } else {
                      setState(() {
                        search = false;
                      });
                      print(search);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      search == true ? Icons.close : Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: search
                  ? ListView(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      children: tempSearchStore.map((element) {
                        return buildResultCard(element);
                      }).toList(),
                    )
                  : chatRoomList(),
            ),
          )
        ],
      ),
    );
  }

  /// BUILD RESULT CARD WIDGET
  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        var chatRoomId = getChatRoomIDByUserName(
          myUserName!,
          data['username'],
        );

        Map<String, dynamic> chatRoomInfoMap = {
          'users': [myUserName, data['username']],
        };

        await DatabaseMethod().createChatRoom(chatRoomId, chatRoomInfoMap);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              name: data['name'],
              profilePic: data['photo'],
              userName: data['username'],
            ),
          ),
        );

        search = false;
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    data['photo'],
                    height: 70,
                    width: 70,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      data['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      data['username'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/// CHAT ROOM LIST TILE
class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUserName, time;
  final VoidCallback onTap;

  const ChatRoomListTile({
    super.key,
    required this.lastMessage,
    required this.chatRoomId,
    required this.myUserName,
    required this.time,
    required this.onTap,
  });

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePic = '', name = '', username = '', id = '';

  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll("_", "").replaceAll(widget.myUserName, "");

    try {
      QuerySnapshot querySnapshot =
          await DatabaseMethod().getUserInfo(username);

      if (querySnapshot.docs.isNotEmpty) {
        var userInfo = querySnapshot.docs[0].data();
        name = '${querySnapshot.docs[0]["name"]}';
        profilePic = '${querySnapshot.docs[0]["photo"]}';
        id = '${querySnapshot.docs[0]["id"]}';
      } else {
        print("No user found with username $username");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getThisUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profilePic == ''
                    ? const CircularProgressIndicator()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          profilePic,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.lastMessage,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  widget.time,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
