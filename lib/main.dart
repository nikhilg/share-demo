import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'features/app/items/pages/borrowed_items_screen.dart';
import 'features/app/items/pages/add_item.dart';
import 'features/app/items/pages/show_items.dart';
import 'features/app/splash_screen/splash_screen.dart';
import 'features/user_auth/presentation/pages/home_page.dart';
import 'features/user_auth/presentation/pages/login_page.dart';
import 'features/user_auth/presentation/pages/sign_up_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: , II "AIzaSyAlWXbantYsTl1RISkkXuVJJ2DFyrfTyoQ",
            appId: "1:1038101427498:web:2ecab99422b447ea6ada53",
            messagingSenderId: "1038101427498",
            projectId: "share-demo-466c9"));
  }
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Share App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => SplashScreen(
              child: LoginPage(),
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/showItems': (context) => ShowItems(),
        '/addItems': (context) => AddItem(),
        '/borrowedItems': (context) => BorrowedItemsScreen(),
      },
    );
  }
}
