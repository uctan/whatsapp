import 'package:flutter/material.dart';
import 'package:tanapp/common/extension/custom_theme_extension.dart';

class YelloCard extends StatelessWidget {
  const YelloCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.theme.yellowCardBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "Message and calls are end to end encrypted. No one outside of this chat, not even WhatsAPP, can read or listen to them. Tap to learn more",
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 13, color: context.theme.yellowCardTextColor),
      ),
    );
  }
}
