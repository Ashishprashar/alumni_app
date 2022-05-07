import 'package:alumni_app/provider/chat_provider.dart';
import 'package:alumni_app/provider/current_user_provider.dart';
import 'package:alumni_app/provider/feed_provider.dart';
import 'package:alumni_app/provider/invite_screen_provider.dart';
import 'package:alumni_app/provider/notification_provider.dart';
import 'package:alumni_app/provider/people_provider.dart';
import 'package:alumni_app/provider/profile_provider.dart';
import 'package:alumni_app/provider/search_provider.dart';
import 'package:alumni_app/screen/home.dart';
import 'package:alumni_app/screen/wrapper.dart';
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
        ChangeNotifierProvider(create: (context) => CurrentUserProvider()),
        ChangeNotifierProvider(create: (context) => FeedProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => InviteProvider()),
        ChangeNotifierProvider(create: (context) => PeopleProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ],
      child: MaterialApp(
        // this is needed to provide providers to places where there is no build context
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Wrapper(),
      ),
    );
  }
}
