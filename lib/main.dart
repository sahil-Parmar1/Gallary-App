import 'package:flutter/material.dart';
import 'package:gallary_app/functions.dart';
import 'package:gallary_app/hivestorage/media.dart';
import 'package:gallary_app/providerdirectory/Pageprovider.dart';
import 'package:gallary_app/providerdirectory/mediaprovider.dart';
import 'package:gallary_app/screens/homescreen.dart';
import "package:provider/provider.dart";
import 'package:hive_flutter/hive_flutter.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await Hive.initFlutter();
 Hive.registerAdapter(MediaAdapter());
 Box<Media> mediabox=await Hive.openBox<Media>("media");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_)=>PageProvider(),),
    ChangeNotifierProvider(
      create: (_)=>MediaListProvider(mediabox),),
  ],
  child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 @override
 void initState()
 {
   super.initState();
   startups();
 }
 // Function to run at app startup
   void startups() async {
     List<String> deviceLocations = await sharedpref.gettosharedlist("deviceLocations");

     if (deviceLocations.isEmpty) {
       print("device location is empty");
       await Future.wait([
         requestPermission(),  // Runs first
         getDeviceLocation()   // Runs at the same time
       ]);
       fetchSongslist(context);
     }
     else
     {
       print("$deviceLocations");
       fetchSongslist(context);
     }
   }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

