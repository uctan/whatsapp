import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tanapp/common/models/user_model.dart';
import 'package:tanapp/feature/auth/pages/login_page.dart';
import 'package:tanapp/feature/auth/pages/usser_info_page.dart';
import 'package:tanapp/feature/auth/pages/verication_page.dart';
import 'package:tanapp/feature/chat/pages/call_page.dart';
import 'package:tanapp/feature/chat/pages/chat_page.dart';
import 'package:tanapp/feature/chat/pages/profile_page.dart';
import 'package:tanapp/feature/contact/pages/contact_page.dart';

import 'package:tanapp/feature/home/pages/home_page.dart';
import 'package:tanapp/feature/welcome/pages/welcom_page.dart';

class Routes {
  static const String welcome = 'welcome';
  static const String login = 'login';
  static const String verification = 'verification';
  static const String userInfo = 'user-info';
  static const String home = 'home';
  static const String contact = 'contact';
  static const String chat = 'chat';
  static const String profile = 'profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        );
      case login:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );
      case verification:
        final Map args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => VerificationPage(
            smsCodeId: args['smsCodeId'],
            phoneNumber: args['phoneNumber'],
          ),
        );
      case userInfo:
        final String? profileImageUrl = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (context) => UserInfoPage(
            profileImageUrl: profileImageUrl,
          ),
        );
      case home:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case contact:
        return MaterialPageRoute(
          builder: (context) => const ContactPage(),
        );
      case chat:
        final UserModel user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (context) => ChatPage(
            user: user,
          ),
        );
      // case callvideo:
      //   return MaterialPageRoute(
      //     builder: (context) => const CallPage(
      //       builder
      //     ),
      //   );
      case profile:
        final UserModel user = settings.arguments as UserModel;
        return PageTransition(
          child: ProfilePage(
            user: user,
          ),
          type: PageTransitionType.fade,
          duration: const Duration(
            microseconds: 800,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('No Page Route Provided'),
            ),
          ),
        );
    }
  }
}
