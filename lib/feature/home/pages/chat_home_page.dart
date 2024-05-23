import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tanapp/common/extension/custom_theme_extension.dart';
import 'package:tanapp/common/models/last_message_model.dart';
import 'package:tanapp/common/models/user_model.dart';
import 'package:tanapp/common/routes/routes.dart';
import 'package:tanapp/common/utils/coloors.dart';
import 'package:tanapp/feature/chat/controller/chat_controller.dart';

class ChatHomePage extends ConsumerWidget {
  const ChatHomePage({super.key});

  naviageToContactPage(context) {
    Navigator.pushNamed(context, Routes.contact);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder<List<LastMessageModel>>(
        stream: ref.watch(ChatControllerProvider).getAllLastMessageList(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Coloors.greenDark,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final lastMessageData = snapshot.data![index];
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.chat,
                    arguments: UserModel(
                      username: lastMessageData.username,
                      uid: lastMessageData.contactId,
                      profileImageUrl: lastMessageData.profileImageUrl,
                      active: true,
                      lastSeen: 0,
                      phoneNumber: '10',
                      groupId: [],
                    ),
                  );
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(lastMessageData.username),
                    Text(
                      DateFormat.Hm().format(lastMessageData.timeSent),
                      style: TextStyle(
                        fontSize: 13,
                        color: context.theme.greyColor,
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    lastMessageData.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.theme.greyColor,
                    ),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    lastMessageData.profileImageUrl,
                  ),
                  radius: 24,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => naviageToContactPage(context),
        child: const Icon(Icons.chat),
      ),
    );
  }
}
