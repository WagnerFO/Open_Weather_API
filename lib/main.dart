import 'package:flutter/material.dart';
import 'package:flutter_application/core/navigation/app_router.dart';
import 'package:flutter_application/core/navigation/navigation_key.dart';
import 'package:flutter_application/presentation/widgets/base_screen.dart';
import 'package:flutter_application/presentation/widgets/edge_menu.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('pt', 'BR')],
      locale: const Locale('pt', 'BR'),
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return EdgeMenu(key: menuKey, child: child!);
      },
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.home,
    );
  }
}
