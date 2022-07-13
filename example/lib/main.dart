import 'package:flutter/material.dart';
import 'dart:async';

import 'package:monnify_flutter/common/app_enums/EnumClasses.dart';
import 'package:monnify_flutter/monnify_flutter.dart';
import 'package:monnify_flutter_example/hidden.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _monnifyPlugPlugin = MonnifyFlutter.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // We also handle the message potentially returning null.monnify.
    try {
      final result = await _monnifyPlugPlugin.initializeMonnify(

          ///Enter your API key here from monnify
          apiKey: Hidden.API_KEY,

          ///Enter your contract code here from monnify
          contractCode: Hidden.CONTRACT_CODE,
          applicationMode: ApplicationMode.test);

      print("Initialisation Result:  $result");
    } on Exception {
      print('Failed to get platform version.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Monnify Plugin'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ListView(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                customTextField(hint: "Name:", controller: nameController),
                const SizedBox(
                  height: 10.0,
                ),
                customTextField(hint: "Email:", controller: emailController),
                const SizedBox(
                  height: 10.0,
                ),
                customTextField(hint: "Amount:", controller: amountController),
                const SizedBox(
                  height: 10.0,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      try {
                        final result = await _monnifyPlugPlugin.makePayment(
                            amount: amountController.text,
                            currencyCode: "NGN",
                            customerName: nameController.text,
                            customerEmail: emailController.text,
                            paymentReference: referenceId(),
                            paymentDescription: "Testinggg",
                            paymentMethod: PaymentMethod.all);

                      } catch (error) {
                        print("Errror: $error");
                      }
                    },
                    child: const Text("Pay",
                        style: TextStyle(color: Colors.white, fontSize: 30),),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Randomly generated string
  String referenceId() => DateTime.now().toString();

  ///Custom text field
  Widget customTextField(
      {String? hint,
      TextEditingController? controller,
      FocusNode? focusNode,
      String? errorText,
      Widget? suffixIcon,
      bool readOnly = false,
      TextInputType? textInputType,
      ValueChanged<String>? onChanged,
      Widget? label}) {
    return TextField(
        controller: controller,
        focusNode: focusNode,
        readOnly: readOnly,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          errorText: errorText,
          hintText: hint,
          label: label,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 10),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        onChanged: onChanged,

        // onChanged: controller.onMeterNumberChanged,
        keyboardType: textInputType,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => {});
  }
}
