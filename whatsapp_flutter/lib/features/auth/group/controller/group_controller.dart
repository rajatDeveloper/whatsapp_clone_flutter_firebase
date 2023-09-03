import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/features/auth/group/repo/group_repo.dart';

final groupControllerProvider = Provider((ref) {
  return GroupController(
    groupRepo: ref.read(groupRepoProvider),
    ref: ref,
  );
});

class GroupController {
  final GroupRepo groupRepo;
  final ProviderRef ref;

  GroupController({required this.groupRepo, required this.ref});

  void createGroup({
    required BuildContext context,
    required String groupName,
    required File groupPic,
    required List<Contact> selectedContacts,
  }) {
    groupRepo.createGroup(
        context: context,
        groupName: groupName,
        groupPic: groupPic,
        selectedContacts: selectedContacts);
  }
}
