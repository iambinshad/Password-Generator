import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:methodchannelprojects/firebase_options.dart';
import 'package:methodchannelprojects/controller/db/db_fuction.dart';
import 'package:methodchannelprojects/model/password_history_model.dart';
import 'package:methodchannelprojects/view/toast_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); 
  if(!Hive.isAdapterRegistered(PasswordModelAdapter().typeId)){
    Hive.registerAdapter(PasswordModelAdapter());
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider(
          create: (context) => DbClass(),
        )
      ],
      builder: (context, child) => MaterialApp(
        title: 'Method Channel',
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: ToastScreen(),
      ),
    );
  }
}
