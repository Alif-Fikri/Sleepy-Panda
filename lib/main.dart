import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication/splashscreen.dart';
import '../widgets/signupprovider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:sleepys/helper/ProfileImageProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, 
  ]);

  await initializeDateFormatting('id', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupFormProvider()),
        ChangeNotifierProvider(create: (_) => ProfileImageProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
      },
      theme: ThemeData(
        fontFamily: 'Urbanist',
      ),
    );
  }
}
