import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

final userId = Random().nextInt(999);

class CallPageZego extends StatelessWidget {
  const CallPageZego({
    Key? key,
    required this.callID,
  }) : super(key: key);
  final String callID;

  // Function to generate a random userID

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID:
          902502853, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          '38e0caf57bddc58a3e07cb83961ac26a21ad01f93e4a0a51201ccb364722da27', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: userId.toString(), // Use the random userID
      userName: 'userName_$userId', // Ensure that userName is set correctly.
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
