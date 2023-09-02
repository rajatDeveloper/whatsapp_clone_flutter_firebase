import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/common/widgets/loder.dart';
import 'package:whatsapp_flutter/features/status/controller/status_controller.dart';
import 'package:whatsapp_flutter/features/status/screens/status_screen.dart';

class StatusContactScreen extends ConsumerWidget {
  const StatusContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: ref.read(statusControllerProvider).getStatus(context: context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loder();
          }
          if (snapshot.hasError) {
            return const Text("error");
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var statusData = snapshot.data![index];

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, StatusScreen.routeName,
                        arguments: statusData);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(statusData.profilePic),
                      ),
                      title: Text(statusData.username),
                    ),
                  ),
                );
              });
        });
  }
}
