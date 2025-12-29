import 'package:flutter/material.dart';
import 'aadhaar_sdk_entry.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AadhaarSdkApp());
}

class AadhaarSdkApp extends StatelessWidget {
  const AadhaarSdkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AadhaarSdkEntry(),
    );
  }
}
