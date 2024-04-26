import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yanta/getIt.dart';
import 'package:yanta/view_model/theme_change.dart';

import 'view/splash_screen.dart';

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(),
      child: Builder(
        builder: (BuildContext context) {
          final themeChanger = Provider.of<ThemeChanger>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Dark Theme Demo',
            themeMode: themeChanger.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              // primarySwatch: Colors.purple,
              primarySwatch: const MaterialColor(
                0xff7154cd,
                <int, Color>{
                  50: Color(0xFFECE8F6),
                  100: Color(0xFFD0C6E2),
                  200: Color(0xFFB3A4CE),
                  300: Color(0xFF9581BA),
                  400: Color(0xFF7C64AB),
                  500: Color(0xFF7154CD), // Primary color
                  600: Color(0xFF644AB7),
                  700: Color(0xFF5941A1),
                  800: Color(0xFF4E388B),
                  900: Color(0xFF422F75),
                },
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
    // return MaterialApp(
    //   title: 'Yanta',
    //   theme: ThemeData(
    //     // This is the theme of your application.
    //     //
    //     // TRY THIS: Try running your application with "flutter run". You'll see
    //     // the application has a blue toolbar. Then, without quitting the app,
    //     // try changing the seedColor in the colorScheme below to Colors.green
    //     // and then invoke "hot reload" (save your changes or press the "hot
    //     // reload" button in a Flutter-supported IDE, or press "r" if you used
    //     // the command line to start the app).
    //     //
    //     // Notice that the counter didn't reset back to zero; the application
    //     // state is not lost during the reload. To reset the state, use hot
    //     // restart instead.
    //     //
    //     // This works for code too, not just values: Most code changes can be
    //     // tested with just a hot reload.
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   home: const MyHomePage(title: 'Flutter Demo Home Page'),
    // );
  }
}
