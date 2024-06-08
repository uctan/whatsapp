import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tanapp/feature/home/pages/home_page.dart';

class AddMemebersIngroup extends StatefulWidget {
  final String groupName, groupId;
  final List membersList;
  const AddMemebersIngroup({
    super.key,
    required this.groupName,
    required this.groupId,
    required this.membersList,
  });

  @override
  State<AddMemebersIngroup> createState() => _AddMemebersIngroupState();
}

class _AddMemebersIngroupState extends State<AddMemebersIngroup> {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List membersList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    membersList = widget.membersList;
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("phoneNumber", isEqualTo: _search.text)
        .get()
        .then((value) {
      userMap = value.docs[0].data();
      isLoading = false;
    });
  }

  void onAddMembers() async {
    membersList.add({
      "username": userMap!['username'],
      "phoneNumber": userMap!['phoneNumber'],
      "uid": userMap!['uid'],
      "isAdmin": false,
    });
    await _firestore.collection('groups').doc(widget.groupId).update({
      "members": membersList,
    });

    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('groups')
        .doc(widget.groupId)
        .set({
      "name": widget.groupName,
      "id": widget.groupId,
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => HomePage(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Members"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                alignment: Alignment.center,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            ElevatedButton(
              onPressed: onSearch,
              child: Text("Search"),
            ),
            userMap != null
                ? ListTile(
                    onTap: onAddMembers,
                    leading: Icon(Icons.account_box),
                    title: Text(userMap!['username']),
                    subtitle: Text(userMap!['phoneNumber']),
                    trailing: Icon(Icons.add),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
