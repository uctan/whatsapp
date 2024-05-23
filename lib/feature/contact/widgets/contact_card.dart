import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tanapp/common/extension/custom_theme_extension.dart';
import 'package:tanapp/common/models/user_model.dart';
import 'package:tanapp/common/utils/coloors.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contactSource,
    required this.onTap,
  });

  final UserModel contactSource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      dense: true,
      leading: CircleAvatar(
        backgroundColor: context.theme.greyColor!.withOpacity(0.3),
        radius: 20,
        backgroundImage: contactSource.profileImageUrl.isNotEmpty
            ? CachedNetworkImageProvider(contactSource.profileImageUrl)
            : null,
        child: contactSource.profileImageUrl.isEmpty
            ? Icon(
                Icons.person,
                size: 30,
                color: Theme.of(context).textTheme.bodyText2!.color,
              )
            : null,
      ),
      title: Text(
        contactSource.username,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: contactSource.profileImageUrl.isEmpty
          ? null
          : Text(
              "Hey there! I'm using WhatsApp",
              style: TextStyle(
                color: context.theme.greyColor,
                fontWeight: FontWeight.w600,
              ),
            ),
      trailing: contactSource.profileImageUrl.isEmpty
          ? TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                foregroundColor: Coloors.greenDark,
              ),
              child: const Text('INVITE'),
            )
          : null,
    );
  }
}
