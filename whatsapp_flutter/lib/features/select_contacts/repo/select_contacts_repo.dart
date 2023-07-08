import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactRepoProvider = Provider((ref) => SelectContactRepo(
      firestore: FirebaseStorage.instance,
    ));

class SelectContactRepo {
  final FirebaseStorage firestore;

  SelectContactRepo({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
        return contacts;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }
}
