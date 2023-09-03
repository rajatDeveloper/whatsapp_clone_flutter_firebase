import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/common/widgets/loder.dart';
import 'package:whatsapp_flutter/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whatsapp_flutter/utils/functions.dart';

final selectedContactGroups = StateProvider<List<Contact>>((ref) => []);

class SelectContactGroup extends ConsumerStatefulWidget {
  const SelectContactGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactGroupState();
}

class _SelectContactGroupState extends ConsumerState<SelectContactGroup> {
  List<int> selectedContactIndex = [];

  void selectContact(int index, Contact contact) {
    if (selectedContactIndex.contains(index)) {
      selectedContactIndex.removeAt(index);
    } else {
      selectedContactIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedContactGroups.state)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getConatactsProvider).when(
        data: (contactList) => Expanded(
            child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                      onTap: () => selectContact(index, contact),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: ListTile(
                            title: Text(
                              contact.displayName,
                              style: TextStyle(
                                  fontSize:
                                      getFontSize(17, getDeviceWidth(context))),
                            ),
                            leading: selectedContactIndex.contains(index)
                                ? const CircleAvatar(
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  )
                                : null),
                      ));
                })),
        error: (err, trace) => Container(),
        loading: () => const Loder());
  }
}
