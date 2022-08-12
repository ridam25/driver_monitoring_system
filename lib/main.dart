import 'package:driver_monitoring/src/views/auth.dart';
import 'package:driver_monitoring/src/views/fire_auth.dart';
import 'package:driver_monitoring/src/views/home.dart';
import 'package:driver_monitoring/src/views/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  await Auth.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: FireAuth(
        key: Key('auth'),
        authPage: Login(),
        home: Home(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
