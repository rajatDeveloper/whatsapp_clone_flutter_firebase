import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/features/call/controller/call_controller.dart';

class CallPickupScreen extends ConsumerStatefulWidget {
  const CallPickupScreen({super.key, required this.scaffold});
  final Widget scaffold;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CallPickupScreenState();
}

class _CallPickupScreenState extends ConsumerState<CallPickupScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: ref.watch(callControllerProvider).callStream,
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data!.data() != null){
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            if(data['hasDialled']){
              return widget.scaffold;
            }
          }
        });
  }
}
