import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ToastScreen extends StatefulWidget {
  ToastScreen({super.key});

  static const batteryChannel = MethodChannel("BatteryChannel");

  @override
  State<ToastScreen> createState() => _ToastScreenState();
}

class _ToastScreenState extends State<ToastScreen> {
  var channel = const MethodChannel("ShowToast");

  showToast() {
    channel.invokeMethod("showToast");//this method call method in mainActivity class methods
  }

  showCharge() async {
    final argument = {'name': "Binshad"};
    final int newBatterLevel =
        await ToastScreen.batteryChannel.invokeMethod('getBattery', argument);//this method call method in mainActivity class methods
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
                onPressed: showCharge, child: const Text("show charge"))
          ],
        ),
      ),
    );
  }
}
