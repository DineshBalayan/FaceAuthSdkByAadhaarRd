import 'package:aadhaar_auth_sdk/src/aadhaar_auth_start_channel.dart';
import 'package:flutter/material.dart';

import 'aadhaar_auth_page.dart';

final GlobalKey<NavigatorState> sdkNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AadhaarStartChannel.register();
  runApp(const _SdkBootstrap());
}

class _SdkBootstrap extends StatelessWidget {
  const _SdkBootstrap();

  @override
  Widget build(BuildContext context) {

    debugPrint("AADHAAR_AUTH_SDK:- main() called");
    return  MaterialApp(
      initialRoute: "/aadhaar_auth",
      routes: {
        "/aadhaar_auth": (_) => AadhaarAuthPage(),
      },
    );
  }
}