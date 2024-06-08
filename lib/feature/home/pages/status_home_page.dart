import 'package:flutter/material.dart';
import 'package:tanapp/feature/groups/group_chat_screen.dart';

class StatusHomePage extends StatelessWidget {
  const StatusHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Group Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => GroupChatHomeScreen(),
            ),
          );
        },
        child: const Icon(Icons.group),
      ),
    );
  }
}
