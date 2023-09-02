import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/colors.dart';
import 'package:whatsapp_flutter/features/auth/controller/authController.dart';
import 'package:whatsapp_flutter/features/status/controller/status_controller.dart';

class ConfromStatusScreen extends ConsumerWidget {
  static const String routeName = '/confromStatusScreen';
  final File file;
  const ConfromStatusScreen({super.key, required this.file});

  void addStatus(
    WidgetRef ref,
    BuildContext context,
  ) {
    ref.read(statusControllerProvider).addStatus(file: file, context: context);
    Navigator.pop(context);
  }
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: tabColor,
        onPressed: () => addStatus(ref, context),
        child: const Icon(Icons.done),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AspectRatio(aspectRatio: 9 / 16, child: Image.file(file))
            ],
          ),
        ),
      ),
    );
  }
}
