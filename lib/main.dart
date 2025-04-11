import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_survey/firebase/firebase_options.dart';
import 'package:school_survey/pages/commoncement_pages/model/hive_commencement/general_data_hive.dart';
import 'package:school_survey/pages/commoncement_pages/model/hive_commencement/schoold_data_hive.dart';
import 'package:school_survey/router.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Hive.initFlutter();
    final appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);

    Hive.registerAdapter(SchoolDataAdapter());
    Hive.registerAdapter(GeneralDataAdapter());

    await Hive.openBox('surveyBox');
    print('success');
  } catch (e) {
    print('firebase error$e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(primarySwatch: Colors.teal),
    );
  }
}
