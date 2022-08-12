import 'package:driver_monitoring/src/models/contact.dart';
import 'package:driver_monitoring/src/models/prevLog.dart';
import 'package:driver_monitoring/src/services/prevLogService.dart';
import 'package:driver_monitoring/src/views/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class PreviousLogs extends StatefulWidget {
  PreviousLogs({Key? key}) : super(key: key);

  @override
  State<PreviousLogs> createState() => _PreviousLogsState();
}

class _PreviousLogsState extends State<PreviousLogs> {
  PrevLogService logsDb = PrevLogService();
  List<PrevLog> logs = [];

  fetchlogs() async {
    var log = await logsDb.fetchLogs();
    setState(() {
      logs = log;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Previous Logs".text.make(),
      ),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: ((context, index) {
          return ListTile(
            title: Text("Previous Log ${index + 1}"),
            subtitle: logs[index].duration.text.make(),
          );
        }),
      ),
    );
  }
}
