import 'package:chat_app/screens/signin_screen.dart';
import 'package:chat_app/services/database.dart';
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
  bool search = false;
  List<dynamic> queryResultSet = [];
  List<dynamic> tempSearchStore = [];

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
                    setState(() {
                      search = true;
                    });
                    print(search);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.search,
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
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
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
                      primary: false,
                      shrinkWrap: true,
                      children: tempSearchStore.map((element) {
                        return buildResultCard(element);
                      }).toList(),
                    )
                  : Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.asset(
                                  "assets/user.jpg",
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Bilal Ahmad",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Hello, What are you doing?",
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Text(
                                "04:30 PM",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                "assets/user.jpg",
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.0),
                                Text(
                                  "Ahmad Raza",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Hy, What is going on?",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Text(
                              "05:30 PM",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                "assets/user.jpg",
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.0),
                                Text(
                                  "Hasan Ali",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Hello, How was your day?",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Text(
                              "10:30 AM",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                "assets/user.jpg",
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.0),
                                Text(
                                  "Ahmad Ali",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Hello, Shivam!",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Text(
                              "12:30 AM",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildResultCard(data) {
    return Container(
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
    );
  }
}
