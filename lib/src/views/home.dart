import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:driver_monitoring/src/models/contact.dart';
import 'package:driver_monitoring/src/models/prevLog.dart';
import 'package:driver_monitoring/src/services/contactService.dart';
import 'package:driver_monitoring/src/services/prevLogService.dart';
import 'package:driver_monitoring/src/views/alarmSound.dart';
import 'package:driver_monitoring/src/views/auth.dart';
import 'package:driver_monitoring/src/views/previousLogs.dart';
import 'package:driver_monitoring/src/views/sosContacts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int _duration = 10;
  final CountDownController _controller = CountDownController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool playAudio = false;
  final box = GetStorage();
  bool isStart = true;
  bool isPause = true;
  @override
  void initState() {
    super.initState();
    checkContactLength();
  }

  void toggleSOS() async {
    print("Playing audio :$playAudio");
    if (playAudio) {
      await _audioPlayer.play(AssetSource('${box.read("alarm") ?? "one"}.wav'));
      _audioPlayer.onPlayerComplete.listen((event) {
        toggleSOS();
      });
    } else {
      await _audioPlayer.stop();
    }
  }

  ContactService contactsDb = ContactService();

  fetchContacts() async {
    List<ContactModel>? contcts = await contactsDb.fetchContacts();
    if (contcts == null || contcts.length <= 3) {
      return true;
    }
    return false;
  }

  void checkContactLength() async {
    bool gotoSoS = await fetchContacts();
    if (gotoSoS) {
      Get.to(SoSContacts());
    }
  }

  DateTime? startTime = null;
  DateTime? endTime = null;

  PrevLogService logsDb = PrevLogService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Home".text.make()),
      drawer: Drawer(
        child: VStack(
          [
            DrawerHeader(child: "Satark".text.makeCentered()),
            ElevatedButton(
              onPressed: () => Get.to(() => SoSContacts()),
              child: "SOS Contacts".text.make(),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => const AlarmSound()),
              child: "Change Alarm Sound".text.make(),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => PreviousLogs()),
              child: "Previous Logs".text.make(),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => SoSContacts()),
              child: "Configure SOS delay".text.make(),
            ),
            ElevatedButton(
              onPressed: () => Auth().logout(),
              child: "Logout".text.make(),
            ),
          ],
          crossAlignment: CrossAxisAlignment.center,
        ),
      ),
      body: VStack(
        [
          CircularCountDownTimer(
            duration: _duration,
            initialDuration: 0,
            controller: _controller,
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,
            ringColor: Colors.grey[300]!,
            ringGradient: null,
            fillColor: Vx.blue700,
            fillGradient: null,
            backgroundColor: Colors.white,
            backgroundGradient: null,
            strokeWidth: 20.0,
            strokeCap: StrokeCap.round,
            textStyle: const TextStyle(
                fontSize: 33.0, color: Vx.blue700, fontWeight: FontWeight.bold),
            textFormat: CountdownTextFormat.HH_MM_SS,
            isReverse: false,
            isReverseAnimation: false,
            isTimerTextShown: true,
            autoStart: false,
            onStart: () {
              debugPrint('Countdown Started');
            },
            onComplete: () {
              debugPrint('Countdown Ended');
              setState(() {
                _controller.restart();
                _controller.pause();
                isStart = true;
                playAudio = true;
              });
              toggleSOS();
            },
          ),
          playAudio
              ? "Press SOS button to stop alarm".text.makeCentered()
              : Container(),
          TextButton(
            onPressed: () async {
              if (isStart) {
                _controller.start();
                startTime = DateTime.now();
              } else {
                _controller.restart();
                _controller.pause();
                endTime = DateTime.now();
                await logsDb.addItem(
                  PrevLog(duration: endTime!.difference(startTime!).inSeconds),
                );
              }
              setState(() {
                isStart = !isStart;
              });
            },
            child: isStart
                ? "Start a new journey".text.make()
                : "End the current journey".text.make(),
          ),
        ],
        crossAlignment: CrossAxisAlignment.center,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            playAudio = !playAudio;
          });
          toggleSOS();
        },
        child: "SOS".text.make(),
      ),
    );
  }
}
