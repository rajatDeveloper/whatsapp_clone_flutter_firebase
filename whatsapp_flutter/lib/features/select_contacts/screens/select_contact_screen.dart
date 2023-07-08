import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/common/widgets/error.dart';
import 'package:whatsapp_flutter/common/widgets/loder.dart';
import 'package:whatsapp_flutter/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whatsapp_flutter/utils/functions.dart';

class ContactScreen extends ConsumerWidget {
  static const String routeName = '/selectContactScreen';
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Contact',
            style:
                TextStyle(fontSize: getFontSize(15, getDeviceWidth(context))),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: ref.watch(getConatactsProvider).when(
            data: (contactsList) => ListView.builder(
                  itemCount: contactsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(contactsList[index].displayName),
                    );
                  },
                ),
            error: (err, trace) {
              return ErrorScreen(error: err.toString());
            },
            loading: () {
              return const Loder();
            }));
  }
}
