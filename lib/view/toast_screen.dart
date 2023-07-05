
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:methodchannelprojects/view/map_scrn.dart';
import 'package:methodchannelprojects/view/password_generator.dart';

class ToastScreen extends StatefulWidget {
  const ToastScreen({super.key});

  static const batteryChannel = MethodChannel("BatteryChannel");

  @override
  State<ToastScreen> createState() => _ToastScreenState();
}

class _ToastScreenState extends State<ToastScreen> {
  var channel = const MethodChannel("ShowToast");

  showToast() {
    channel.invokeMethod(
        "showToast"); //this method call method in mainActivity class methods
  }

  showCharge() async {
    final argument = {'name': "Binshad"};
    final int newBatterLevel = await ToastScreen.batteryChannel.invokeMethod(
        'getBattery',
        argument); //this method call method in mainActivity class methods
    setState(() {
      chargeState = newBatterLevel.toString();
    });
  }

  var chargeState = "Waiting";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: ElevatedButton(
                    onPressed: showToast, child: const Text("Show Toast"))),
            Text(chargeState),
            ElevatedButton(
                onPressed: showCharge, child: const Text("show charge")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PasswordGeneratorScreen(),
                      ));
                },
                child: const Text("Password Generator page")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(),));
                  // NotificationApi.showNotification(
                  //     "Mohammed Binshad",
                  //     "Hey! Do we have everything we need for the lunch",
                  //     "Binshad.app");
                },
                child: const Text("Simple Notification"))
          ],
        ),
      ),
    );
  }
}
