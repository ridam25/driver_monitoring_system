import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get_storage/get_storage.dart';
import 'package:velocity_x/velocity_x.dart';

class AlarmSound extends StatefulWidget {
  const AlarmSound({Key? key}) : super(key: key);

  @override
  State<AlarmSound> createState() => _AlarmSoundState();
}

class _AlarmSoundState extends State<AlarmSound> {
  final box = GetStorage();

  late var _alarmSound;

  @override
  void initState() {
    super.initState();
    _alarmSound = box.read('alarm') ?? "one";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Alarm Sound".text.make(),
      ),
      body: VStack([
        RadioListTile(
          title: Text("Sound One"),
          value: "one",
          groupValue: _alarmSound,
          onChanged: (value) {
            setState(() {
              _alarmSound = value.toString();
              print(_alarmSound);
              box.write('alarm', _alarmSound);
            });
          },
        ),
        RadioListTile(
          title: Text("Sound Two"),
          value: "two",
          groupValue: _alarmSound,
          onChanged: (value) {
            setState(() {
              _alarmSound = value.toString();
              print(_alarmSound);
              box.write('alarm', _alarmSound);
            });
          },
        ),
        RadioListTile(
          title: Text("Sound Three"),
          value: "three",
          groupValue: _alarmSound,
          onChanged: (value) {
            setState(() {
              _alarmSound = value.toString();
              print(_alarmSound);
              box.write('alarm', _alarmSound);
            });
          },
        ),
      ]),
    );
  }
}
