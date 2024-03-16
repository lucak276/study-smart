import 'package:flutter/material.dart';
import 'package:study_smart/pages/authentication/mobile.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const LoginMobile();
          } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
            return const Text('hallo');
          } else {
            return const Text('hallo');
          }
        },
      ),
    );
  }
}
