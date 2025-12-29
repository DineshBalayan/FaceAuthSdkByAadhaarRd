import 'package:aadhaar_auth_sdk/src/aadhaar_auth_start_channel.dart';
import 'package:flutter/material.dart';

class AadhaarSdkEntry extends StatefulWidget {
  const AadhaarSdkEntry({super.key});

  @override
  State<AadhaarSdkEntry> createState() => _AadhaarSdkEntryState();
}

class _AadhaarSdkEntryState extends State<AadhaarSdkEntry> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FaceAuthStartChannel.register(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
