import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiServices/FirebaseInit.dart';
import 'GetX/binding.dart';
import 'Presentations/Payment.dart';
import 'Presentations/splashScreen/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.initialize("6aeb646b-13ad-4bae-b271-89cb98c3711e");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MobileAds.instance.initialize();
  RazorpayService.initialize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeOneSignal();
  runApp(MyApp());
}

Future<void> initializeOneSignal() async {
  try {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    await OneSignal.Notifications.requestPermission(true);
    OneSignal.Notifications.clearAll();
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.notification.display();
    });
    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });
    OneSignal.Notifications.addClickListener((event) {
      print("Notification clicked: ${event.notification.additionalData}");
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = await prefs.getString('uid') ?? " ";
    print(userId);
    await OneSignal.login(userId!);
    print(OneSignal.User.pushSubscription);
  } catch (e) {
    print("Error initializing OneSignal: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: AppBindings(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
          ),
          home: FirstScreen(),
        );
      },
    );
  }
}
