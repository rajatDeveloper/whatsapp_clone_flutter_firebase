import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/colors.dart';
import 'package:whatsapp_flutter/common/widgets/custom_btn.dart';
import 'package:whatsapp_flutter/features/auth/controller/authController.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = "/login";
  LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = "";
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (val) {
          setState(() {
            _countryCode = "+${val.phoneCode}";
          });
        });
  }

  void sendPhoneNumber() {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isNotEmpty) {
      //widegts to intreacr with provider
      ref.read(authControllerProvider).signInWithPhnNumber(
            context: context,
            phoneNumber: "${_countryCode}${phoneNumber}",
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text("Enter your phone number"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Center(
              child:
                  Text("We will send you an SMS to verify your phone number"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  pickCountry();
                },
                child: const Text("Select country/region")),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(_countryCode),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.8,
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        hintText: "Phone number",
                        hintStyle: TextStyle(color: greyColor)),
                  ),
                )
              ],
            ),
            SizedBox(
              height: size.height * 0.6,
            ),
            SizedBox(
                width: size.width,
                child: CustomButton(
                    text: "Next",
                    onPressed: () {
                      sendPhoneNumber();
                    }))
          ],
        ),
      ),
    );
  }
}
