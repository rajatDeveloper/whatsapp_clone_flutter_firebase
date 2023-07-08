import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/features/select_contacts/repo/select_contacts_repo.dart';

final getConatactsProvider = FutureProvider((ref) async {
  final selectConatctRepo = ref.watch(selectContactRepoProvider);
  return await selectConatctRepo.getContacts();
});
