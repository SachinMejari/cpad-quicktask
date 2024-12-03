import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = "HfiE8dFvkcFkxgUUsv9Kh6wNRD4Xh3c9rDOWFKS9";
  const keyClientKey = "MTzCF0xmoKM81XfpUyllA3E4133vUySybxZ9D6G8";
  const keyParseServerUrl = "https://parseapi.back4app.com/";

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
  );

  runApp(const QuickTaskApp());
}

class QuickTaskApp extends StatelessWidget {
  const QuickTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => TaskProvider()), // Add TaskProvider here
      ],
      child: MaterialApp(
        title: 'QuickTask',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthScreen(),
          '/home': (context) => HomeScreen(),
          '/login': (context) => const AuthScreen(), // Add the login route
        },
      ),
    );
  }
}
