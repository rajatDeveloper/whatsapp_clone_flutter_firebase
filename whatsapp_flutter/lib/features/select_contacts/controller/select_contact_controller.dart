import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/features/select_contacts/repo/select_contacts_repo.dart';

final getConatactsProvider = FutureProvider((ref) async {
  final selectConatctRepo = ref.watch(selectContactRepoProvider);
  return await selectConatctRepo.getContacts();
});

final selectContactControllerProvider =
    Provider((ref) => SelectContactController(
          ref: ref,
          selectContactRepo: ref.watch(selectContactRepoProvider),
        ));

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepo selectContactRepo;

  SelectContactController({required this.ref, required this.selectContactRepo});

  void selectContact({
    required Contact selectedContact,
    required BuildContext context,
  }) {
    selectContactRepo.selectContact(
        selectedContact: selectedContact, context: context);
  }
}
