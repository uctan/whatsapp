import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tanapp/common/extension/custom_theme_extension.dart';
import 'package:tanapp/common/helper/last_seen_message.dart';
import 'package:tanapp/common/models/message_model.dart';
import 'package:tanapp/common/models/user_model.dart';
import 'package:tanapp/common/routes/routes.dart';
import 'package:tanapp/common/widgets/custom_icon_button.dart';
import 'package:tanapp/feature/auth/controller/auth_controller.dart';
import 'package:tanapp/feature/chat/controller/chat_controller.dart';
import 'package:tanapp/feature/chat/widget/chat_text_field.dart';
import 'package:tanapp/feature/chat/widget/message_card.dart';
import 'package:tanapp/feature/chat/widget/show_date_card.dart';
import 'package:tanapp/feature/chat/widget/yellow_card.dart';

final pageStorageBucket = PageStorageBucket();

class ChatPage extends ConsumerWidget {
  ChatPage({
    super.key,
    required this.user,
  });
  final UserModel user;
  final ScrollController scrollController = ScrollController();

  bool isUserActive(int lastSeen, int activeThresholdInSeconds) {
    DateTime now = DateTime.now();
    Duration differenceDuration = now.difference(
      DateTime.fromMicrosecondsSinceEpoch(lastSeen),
    );

    // Nếu thời gian chênh lệch nhỏ hơn ngưỡng, người dùng được coi là active
    return differenceDuration.inSeconds <= activeThresholdInSeconds;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // backgroundColor: context.theme.chatPageBgColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              const Icon(
                Icons.arrow_back,
              ),
              Hero(
                tag: 'profile',
                child: Container(
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.profile,
              arguments: user,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                StreamBuilder(
                  stream:
                      ref.read(authControllerProvider).getUserPresenceStatus(
                            uid: user.uid,
                          ),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState != ConnectionState.active) {
                      return const Text(
                        'Connect',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text(
                        'Error',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Text(
                        'No Data',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      );
                    }

                    final singleUserModel = snapshot.data!;
                    final lastMessage =
                        lastSeenMessage(singleUserModel.lastSeen);

                    // Sử dụng hàm isUserActive để kiểm tra trạng thái hoạt động
                    final isActive =
                        isUserActive(singleUserModel.lastSeen, 300); // 5 phút

                    debugPrint('User active: ${singleUserModel.active}');
                    debugPrint('User last seen: ${singleUserModel.lastSeen}');
                    debugPrint('Calculated last message: $lastMessage');
                    debugPrint('Calculated isActive: $isActive');

                    return Text(
                      isActive ? "Online" : "$lastMessage ago",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          CustomIconButton(
            onTap: () {},
            icon: Icons.video_call,
          ),
          CustomIconButton(onTap: () {}, icon: Icons.call),
          CustomIconButton(
            onTap: () {},
            icon: Icons.more_vert_outlined,
          ),
        ],
      ),
      body: Stack(
        children: [
          Image(
            height: double.maxFinite,
            width: double.maxFinite,
            image: AssetImage('assets/images/doodle_bg.png'),
            fit: BoxFit.cover,
            color: context.theme.chatPageBgColor,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: StreamBuilder(
              stream: ref
                  .watch(ChatControllerProvider)
                  .getAllOneToOneMessage(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return ListView.builder(
                      itemCount: 15,
                      itemBuilder: (_, index) {
                        final random = Random().nextInt(14);
                        return Container(
                          alignment: random.isEven
                              ? Alignment.center
                              : Alignment.centerLeft,
                          margin: EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            left: random.isEven ? 150 : 15,
                            right: random.isEven ? 15 : 150,
                          ),
                          child: ClipPath(
                            clipper: UpperNipMessageClipperTwo(
                              random.isEven
                                  ? MessageType.send
                                  : MessageType.receive,
                              nipWidth: 8,
                              nipHeight: 10,
                              bubbleRadius: 12,
                            ),
                            child: Shimmer.fromColors(
                              baseColor: random.isEven
                                  ? context.theme.greyColor!.withOpacity(.3)
                                  : context.theme.greyColor!.withOpacity(.2),
                              highlightColor: random.isEven
                                  ? context.theme.greyColor!.withOpacity(.4)
                                  : context.theme.greyColor!.withOpacity(.3),
                              child: Container(
                                height: 40,
                                width:
                                    170 + double.parse((random * 2).toString()),
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      });
                }
                return PageStorage(
                  bucket: pageStorageBucket,
                  child: ListView.builder(
                    key: const PageStorageKey('chat_page_list'),
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    controller: scrollController,
                    itemBuilder: (_, index) {
                      final message = snapshot.data![index];
                      final isSender = message.senderId ==
                          FirebaseAuth.instance.currentUser!.uid;

                      final haveNip = (index == 0) ||
                          (index == snapshot.data!.length - 1 &&
                              message.senderId !=
                                  snapshot.data![index - 1].senderId) ||
                          (message.senderId !=
                                  snapshot.data![index - 1].senderId &&
                              message.senderId ==
                                  snapshot.data![index + 1].senderId) ||
                          (message.senderId !=
                                  snapshot.data![index - 1].senderId &&
                              message.senderId !=
                                  snapshot.data![index + 1].senderId);
                      final isShowDateCard = (index == 0) ||
                          ((index == snapshot.data!.length - 1) &&
                              (message.timeSent.day >
                                  snapshot.data![index - 1].timeSent.day)) ||
                          (message.timeSent.day >
                                  snapshot.data![index - 1].timeSent.day &&
                              message.timeSent.day <=
                                  snapshot.data![index + 1].timeSent.day);

                      return Column(
                        children: [
                          if (index == 0) YelloCard(),
                          if (isShowDateCard)
                            ShowDateCard(date: message.timeSent),
                          MessageCard(
                            isSender: isSender,
                            haveNip: haveNip,
                            message: message,
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: const Alignment(0, 1),
            child: ChatTextField(
              receiverId: user.uid,
              scrollController: scrollController,
            ),
          ),
        ],
      ),
    );
  }
}
