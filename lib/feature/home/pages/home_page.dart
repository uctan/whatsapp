import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanapp/common/mode/theme_notifier.dart';
import 'package:tanapp/common/widgets/custom_icon_button.dart';
import 'package:tanapp/feature/auth/controller/auth_controller.dart';
import 'package:tanapp/feature/chat/widget/custom_list_title.dart';
import 'package:tanapp/feature/home/pages/call_home_page.dart';
import 'package:tanapp/feature/home/pages/chat_home_page.dart';
import 'package:tanapp/feature/home/pages/status_home_page.dart';
// Import the theme notifier

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Timer timer;

  updateUserPresence() {
    ref.read(authControllerProvider).updateUserPresence();
  }

  @override
  void initState() {
    updateUserPresence();
    timer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) => setState(() {}),
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final isDarkMode = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'WhatsApp',
            style: TextStyle(letterSpacing: 1),
          ),
          elevation: 1,
          actions: [
            CustomIconButton(onTap: () {}, icon: Icons.search),
            CustomIconButton(onTap: () {}, icon: Icons.more_vert),
          ],
          bottom: const TabBar(
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(text: 'CHATS'),
              Tab(text: 'GROUPS'),
              Tab(text: 'CALLS'),
            ],
          ),
        ),
        body: Column(
          children: [
            CustomListTitle(
              title: 'Dark Or Light',
              leading: Icons.light_mode,
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  themeNotifier.toggleTheme(value);
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ChatHomePage(),
                  StatusHomePage(),
                  CallHomePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
