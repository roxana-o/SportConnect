import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:my_project/Provider/themes.dart';
import 'package:my_project/dataController.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'P_home_screen.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  //await Settings.init(cacheProvider: SharePreferenceCache());

   Get.put(DataManager());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (BuildContext context)=>Themes()..init(),
      child: Consumer<Themes>(
        builder: (context, Themes notify, child){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title:'Dark Mode',

            themeMode: notify.dark? ThemeMode.dark : ThemeMode.light,

            darkTheme: notify.dark? notify.darkMode : notify.lightMode,

            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 17, 103, 161)),
              useMaterial3: true,

             ),
             home: FirstPage(),  //CreateProfile(),
             );
        },
        )
    );
    
  }
    
    /*MaterialApp(
      title: 'Flutter Demo',
      home:  FirstPage(), //CreateNewEvent(),//Authentication(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
  */
}
