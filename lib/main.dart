import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_crumbl/firebase_options.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/authenticate/auth_page.dart';
import 'package:my_crumbl/services/auth_service.dart';
import 'package:my_crumbl/services/hive_service.dart';
import 'package:my_crumbl/shared/color_schemes.g.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HiveService.init();
  HiveService.listenToFirestoreChanges();

  runApp(const MyCrumbl());
}

class MyCrumbl extends StatelessWidget {
  const MyCrumbl({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().currentUser,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _appTheme(Brightness.light),
        home: const AuthPage(),
      ),
    );
  }

  ThemeData _appTheme(brightness) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        color: baseTheme.colorScheme.tertiary,
        elevation: 0.0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: baseTheme.colorScheme.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          color: baseTheme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }
}
