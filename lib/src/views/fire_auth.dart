import 'package:flutter/material.dart';
import 'auth.dart';

class FireAuth extends StatelessWidget {
  const FireAuth({Key? key, required this.home, required this.authPage})
      : super(key: key);
  final Widget home;
  final Widget authPage;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().currentUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return home;
        }
        return authPage;
      },
    );
  }
}
