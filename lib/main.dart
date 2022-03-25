import 'package:alumni_app/provider/chat_provider.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/provider/people_to_profile.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/splash.dart';
import 'package:alumni_app/services/media_query.dart';
import 'package:alumni_app/utilites/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SizeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: PeopleToProfile()),
        ChangeNotifierProvider(create: (context) => CurrentUserProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
        // this is needed to provide providers to places where there is no build context
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Splash(),
      ),
    );
  }
}
