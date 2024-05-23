import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanapp/common/extension/custom_theme_extension.dart';
import 'package:tanapp/common/widgets/custom_icon_button.dart';
import 'package:tanapp/feature/auth/controller/auth_controller.dart';
import 'package:tanapp/feature/auth/widget/custom_text_field.dart';

class VerificationPage extends ConsumerWidget {
  const VerificationPage({
    super.key,
    required this.smsCodeId,
    required this.phoneNumber,
  });
  final String smsCodeId;
  final String phoneNumber;

  void verifySmsCode(BuildContext context, WidgetRef ref, String smsCode) {
    ref.read(authControllerProvider).verifySmsCode(
          context: context,
          smsCodeId: smsCodeId,
          smsCode: smsCode,
          mounted: true,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: Text(
          'Verify your number',
          style: TextStyle(
            color: context.theme.authAppbarTextColor,
          ),
        ),
        centerTitle: true,
        actions: [
          CustomIconButton(
            onTap: () {},
            icon: Icons.more_vert,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: context.theme.greyColor,
                  ),
                  children: [
                    const TextSpan(
                      text: "You've to register +399441272. before request sms",
                    ),
                    TextSpan(
                      text: 'Wrong Number?',
                      style: TextStyle(
                        color: context.theme.blueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                hintText: '- - - - - -',
                fontSize: 30,
                autoFocus: true,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 6) {
                    return verifySmsCode(
                      context,
                      ref,
                      value,
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Enter 6-digit code',
              style: TextStyle(color: context.theme.greyColor),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(
                  Icons.message,
                  color: context.theme.greyColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Resend SMS',
                  style: TextStyle(color: context.theme.greyColor),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: context.theme.blueColor!.withOpacity(0.2),
            ),
            Row(
              children: [
                Icon(
                  Icons.call,
                  color: context.theme.greyColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Call me',
                  style: TextStyle(color: context.theme.greyColor),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
