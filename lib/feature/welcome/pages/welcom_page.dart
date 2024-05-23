import 'package:flutter/material.dart';
import 'package:tanapp/common/extension/custom_theme_extension.dart';
import 'package:tanapp/common/routes/routes.dart';

import 'package:tanapp/common/widgets/custom_elevated_button.dart';
import 'package:tanapp/feature/welcome/widgets/language_button.dart';
import 'package:tanapp/feature/welcome/widgets/privacy_and_terms.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  navigateToLoginPage(context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(
                  'assets/images/circle.png',
                  color: context.theme.circleImageColor,
                  width: 300, // Chiều rộng tùy chỉnh của ảnh
                  height: 300,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Welcome to WhatsAPp',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PrivacyAndTerms(),
                CustomElevatedButton(
                  onPressed: () => navigateToLoginPage(context),
                  text: 'AGREE AND CONTINUE',
                ),
                const SizedBox(
                  height: 50,
                ),
                LanguageButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
