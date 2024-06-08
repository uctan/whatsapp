import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tanapp/feature/groups/add_mebers_groupchat.dart';
import 'package:tanapp/feature/groups/create_group/add_members.dart';
import 'package:tanapp/feature/home/pages/home_page.dart';

class GroupInfo extends StatefulWidget {
  final String groupId, groupName;
  const GroupInfo({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List membersList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print("Group ID: ${widget.groupId}");
    print("Group Name: ${widget.groupName}");
    getGroupMembers();
  }

  void getGroupMembers() async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('groups').doc(widget.groupId).get();

      setState(() {
        membersList = documentSnapshot['members'];
        print('Data from firestore: $membersList');
        isLoading = false;
      });
    } catch (e) {
      print('Error getting group members: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void showRemoveDialog(int index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: ListTile(
            onTap: () => removeUser(index),
            title: Text("Remove This member"),
          ),
        );
      },
    );
  }

  void removeUser(int index) async {
    if (checkAdmin()) {
      if (_auth.currentUser!.uid != membersList[index]['uid']) {
        String uid = membersList[index]['uid']; // Lưu uid trước khi xóa
        membersList.removeAt(index);
        setState(() {
          isLoading = true;
        });

        await _firestore.collection('groups').doc(widget.groupId).update({
          "members": membersList,
        });
        print("uidnha ${uid}");

        await _firestore
            .collection('users')
            .doc(uid)
            .collection('groups')
            .doc(widget.groupId)
            .delete();
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } else {
      print("Can't Remove");
      Navigator.of(context).pop();
    }
  }

  bool checkAdmin() {
    bool isAdmin = false;
    membersList.forEach(
      (element) {
        if (element['uid'] == _auth.currentUser!.uid) {
          isAdmin = element['isAdmin'];
        }
      },
    );
    return isAdmin;
  }

  void onLeaveGroup() async {
    if (!checkAdmin()) {
      setState(() {
        isLoading = true;
      });
      String uid = _auth.currentUser!.uid;
      for (int i = 0; i < membersList.length; i++) {
        if (membersList[i]['uid'] == uid) {
          membersList.removeAt(i);
        }
      }
      await _firestore.collection('groups').doc(widget.groupId).update({
        "members": membersList,
      });

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
    } else {
      print("Can't left group");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: BackButton(),
              ),
              Container(
                height: size.height / 8,
                width: size.width / 1.1,
                child: Row(
                  children: [
                    Container(
                      height: size.height / 11,
                      width: size.width / 11,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Icon(
                        Icons.group,
                        color: Colors.white,
                        size: size.width / 10,
                      ),
                    ),
                    SizedBox(
                      width: size.width / 20,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.groupName,
                          style: TextStyle(
                            fontSize: size.width / 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height / 20,
              ),
              Container(
                width: size.width / 1.1,
                child: Text(
                  "${membersList.length} Members",
                  style: TextStyle(
                    fontSize: size.width / 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 20,
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: membersList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => showRemoveDialog(index),
                      leading: Icon(
                        Icons.account_circle,
                      ),
                      title: Text(
                        membersList[index]['username'],
                        style: TextStyle(
                          fontSize: size.width / 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(membersList[index]['phoneNumber']),
                      trailing:
                          Text(membersList[index]['isAdmin'] ? "Admin" : ""),
                    );
                  },
                ),
              ),
              ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddMemebersIngroup(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      membersList: membersList,
                    ),
                  ),
                ),
                leading: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                title: Text(
                  "Add Member Group",
                  style: TextStyle(
                    fontSize: size.width / 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                onTap: onLeaveGroup,
                leading: Icon(
                  Icons.logout,
                  color: Colors.redAccent,
                ),
                title: Text(
                  "Leave Group",
                  style: TextStyle(
                    fontSize: size.width / 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              // SizedBox(height: size.height / 10),
            ],
          ),
        ),
      ),
    );
  }
}
