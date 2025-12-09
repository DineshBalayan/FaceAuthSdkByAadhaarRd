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
  String appCode = '0000440000ABFAS008';
  String userData = 'bkHxz0us23TKXi26qfcxer90GLZdjHydJyZ37d8OabCiWRqP6JYbIwqvdTb20bF6cxCwoYN5etvpnUYS7y8bMxGAorn/Vwru6LHoI667KQK9TUIi0xOibrVD2dNIX1kPyc9RSCV1VowXLF/Vl+ltMbG67zyVX5rxj7SnHl+B/kMK7d6d2Kn7osOcxsPLDJE/ai5LH2hzOA3YuXVosEpzz9BNE1kiJQIc/R/FLxqP4gRwzoaB9BmEe+rt31JgVJj4tBFKMxbbECjOYrEdI8y+Jeh1e0GCwkZg44RlEgaQ3Xr+5SPe1J8BZKgXyVcapYhhEhE/QJ0/Xm/81N6kEA6wP1MmUv8QbEDigLqX0zJd7+tv4rOHm8DjjuBl0eueN7OZqbFrRs1wJAykGyBoj+zNfkf9I9jBdSnPqbN/dBJMjhW3FyARdvy8ADSrsWIp1nTyyAXz4qXTWghaYUrJMZe1sFd3aCWktDMCtj4+XSAhJuL+X+CpEXNysj5zMl6bur2VIVMQEbwl42PvGcTVtBZzNoI4G7xZ5GojnqLPtw+FROVPAB3Ts+g01OjFtatrpSm14TpkKNKA/CC+Dzwkj/8L1x7ll+M/0CHz7/ZF4P4VnLdKiUz3wIS0geWe8EilC+Kd6F3sLAOknR2+oatctOy/OLj2FLP6GUxem6mcMsW4p+JC33g2vsA/9osrtS/Vrpzz51a7Lg3HJHBfxRps6y1wqvrG8E1C7KtS3terc3taO6bqe2I7Wc9+5kvZGBoIQ3nfG97+aGNvOAAbGVh20wdFgFdKaaMvGf6Fi3oWMKiw8elA51Jqi6qYMTPiN2qbvpJ/NYIQmFNXCCb6arAB2nPjGD44SkNhXFjzaXMxjkuqEM3ArexmE6Ih/4f7euHp2x31HygqIF/PiL0mD/zC63X7RB+dWY3Y5coCaQJFbKbTKmxquSBprAmoRKc6RPuXt9gWb0/J2UvxQgFWdL9rAvIsvrzjtNllTN0+2NT4L1x9ixsM8E8Rh8fZkqz2iYklYoyv';
  String status = 'idle';

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Integrator App')),
      body: SingleChildScrollView(child: Padding(padding: EdgeInsetsGeometry.all(30),child: Column(
          mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('appCode:-\n  $appCode'),

            SizedBox(height: 10,),
            Text('data:-\n  $userData'),
            SizedBox(height: 30,),
            Text("Status: $status"),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () async {
                setState(() => status = 'Starting...');
                try {
                  final res = await sdk.launchUI(context, appCode:appCode, userData:userData);

                  if(res!=null && res.isSuccess){
                    setState(() => status = res.encryptedPid ?? 'null');
                  }else{
                    setState(() => status = res?.errorMessage ?? 'null');
                  }
                } catch (e) {
                  setState(() => status = 'error: $e');
                }
              },
              child: const Text('Start Auth'),
            ),
          ],
        ),),
      ),
    );
  }
}
