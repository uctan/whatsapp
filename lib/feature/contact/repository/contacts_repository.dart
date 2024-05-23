import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanapp/common/models/user_model.dart';

final contactsRepositoryProvider = Provider(
  (ref) {
    return ContactsRepository(firestore: FirebaseFirestore.instance);
  },
);

class ContactsRepository {
  final FirebaseFirestore firestore;

  ContactsRepository({required this.firestore});

  Future<List<List<UserModel>>> getAllContacts() async {
    List<UserModel> firebaseContacts = [];
    List<UserModel> phoneContacts = [];

    try {
      if (await FlutterContacts.requestPermission()) {
        final userCollection = await firestore.collection('users').get();

        // Print data from Firestore to check for duplicates
        for (var firebaseContactData in userCollection.docs) {
          var firebaseContact = UserModel.fromMap(firebaseContactData.data());
          print(
              'Firestore contact: ${firebaseContact.username}, ${firebaseContact.phoneNumber}');
          firebaseContacts.add(firebaseContact);
        }

        final allContactsInThePhone =
            await FlutterContacts.getContacts(withProperties: true);

        for (var contact in allContactsInThePhone) {
          String phoneNumber =
              contact.phones[0].number.replaceAll(' ', '').replaceAll('-', '');
          bool isContactFound = false;

          print('Checking phone contact: ${contact.displayName}, $phoneNumber');

          for (var firebaseContact in firebaseContacts) {
            print(
                'Comparing with Firebase contact: ${firebaseContact.username}, ${firebaseContact.phoneNumber}');
            if (phoneNumber == firebaseContact.phoneNumber) {
              print(
                  'Found matching Firebase contact: ${firebaseContact.username}, ${firebaseContact.phoneNumber}');
              isContactFound = true;
              break;
            }
          }

          if (!isContactFound) {
            print(
                'No matching Firebase contact for: ${contact.displayName}, $phoneNumber');
            phoneContacts.add(
              UserModel(
                username: contact.displayName,
                uid: '',
                profileImageUrl: '',
                active: false,
                lastSeen: 0,
                phoneNumber: phoneNumber,
                groupId: [],
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error getting data from Firestore: $e');
    }

    print('Firebase contacts: ${firebaseContacts.length}');
    print('Phone contacts: ${phoneContacts.length}');

    for (var contact in firebaseContacts) {
      print('Firebase contact: ${contact.username}, ${contact.phoneNumber}');
    }

    for (var contact in phoneContacts) {
      print('Phone contact: ${contact.username}, ${contact.phoneNumber}');
    }

    return [firebaseContacts, phoneContacts];
  }
}
