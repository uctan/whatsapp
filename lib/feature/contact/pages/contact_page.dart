import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanapp/common/extension/custom_theme_extension.dart';
import 'package:tanapp/common/models/user_model.dart';
import 'package:tanapp/common/routes/routes.dart';
import 'package:tanapp/common/utils/coloors.dart';
import 'package:tanapp/common/widgets/custom_icon_button.dart';
import 'package:tanapp/feature/contact/controllers/contacts_controllers.dart';
import 'package:tanapp/feature/contact/widgets/contact_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  shareSmsLink(phoneNumber) async {
    Uri sms = Uri.parse(
      "sms:$phoneNumber?body=Let's chat on WhatsApp! it's a fast, simple, and secure app we can call each other for free. Get it at https://whatsapp.com/dl/",
    );
    if (await launchUrl(sms)) {
    } else {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select contact',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 3),
            ref.watch(contactControllerProvider).when(
              data: (allContacts) {
                print(
                    'All contacts loaded: ${allContacts[0].length + allContacts[1].length}');
                for (var contact in allContacts[0]) {
                  print(
                      'Firebase contact: ${contact.username}, ${contact.phoneNumber}');
                }
                for (var contact in allContacts[1]) {
                  print(
                      'Phone contact: ${contact.username}, ${contact.phoneNumber}');
                }
                return Text(
                  "${allContacts[0].length} Contacts",
                  style: TextStyle(fontSize: 13),
                );
              },
              error: (e, t) {
                print('Error loading contacts: $e');
                return const SizedBox();
              },
              loading: () {
                print('Loading contacts...');
                return const Text(
                  'counting',
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
          ],
        ),
        actions: [
          CustomIconButton(onTap: () {}, icon: Icons.search),
          CustomIconButton(onTap: () {}, icon: Icons.more_vert_outlined),
        ],
      ),
      body: ref.watch(contactControllerProvider).when(
        data: (allContacts) {
          return ListView.builder(
            itemCount: allContacts[0].length + allContacts[1].length,
            itemBuilder: (context, index) {
              late UserModel contact;

              if (index < allContacts[0].length) {
                contact = allContacts[0][index];
                print(
                    'Displaying Firebase contact: ${contact.username}, ${contact.phoneNumber}');
              } else {
                contact = allContacts[1][index - allContacts[0].length];
                print(
                    'Displaying Phone contact: ${contact.username}, ${contact.phoneNumber}');
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        myListTile(
                          leading: Icons.group,
                          text: 'New group',
                        ),
                        myListTile(
                          leading: Icons.contacts,
                          text: 'New contacts',
                          trailing: Icons.qr_code,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Text(
                            'Contacts on WhatsApp',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: context.theme.greyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ContactCard(
                    onTap: () {
                      if (index < allContacts[0].length) {
                        Navigator.pushNamed(
                          context,
                          Routes.chat,
                          arguments: contact,
                        );
                      } else {
                        shareSmsLink(contact.phoneNumber);
                      }
                    },
                    contactSource: contact,
                  ),
                ],
              );
            },
          );
        },
        error: (e, t) {
          print('Error displaying contacts: $e');
          return Center(
            child: Text('Error: $e'),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(
              color: context.theme.authAppbarTextColor,
            ),
          );
        },
      ),
    );
  }

  ListTile myListTile({
    required IconData leading,
    required String text,
    IconData? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 10,
      ),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Coloors.greenDark,
        child: Icon(
          leading,
          color: Colors.white,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        trailing,
        color: Coloors.greyDark,
      ),
    );
  }
}
