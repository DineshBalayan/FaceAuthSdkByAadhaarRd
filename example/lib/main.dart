import 'package:face_auth_sdk/face_auth_sdk.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext c) => MaterialApp(home: Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final sdk = FaceAuthSdk.instance;
  String status = 'idle';

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('SDK Example')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(status),
            ElevatedButton(
              onPressed: () async {
                setState(() => status = 'Starting...');
                try {
                  final res = await sdk.launchUI(context);
                  setState(() => status = res?.status ?? 'null');
                } catch (e) {
                  setState(() => status = 'error: $e');
                }
              },
              child: const Text('Start Auth'),
            ),
          ],
        ),
      ),
    );
  }
}
