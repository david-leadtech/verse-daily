import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'theme/colors.dart';
import 'services/api_service.dart';
import 'providers/favorites_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/onboarding_provider.dart';
import 'screens/app_gate.dart';
import 'screens/settings_screen.dart';
import 'screens/devotional_detail_screen.dart';
import 'screens/subscription_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://bible-verse-daily.replit.app',
  );

  final apiService = ApiService(baseUrl: apiBaseUrl);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ],
      child: BibleVerseDailyApp(apiService: apiService),
    ),
  );
}

class BibleVerseDailyApp extends StatelessWidget {
  final ApiService apiService;

  const BibleVerseDailyApp({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bible Verse Daily',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AppGate(apiService: apiService),
      onGenerateRoute: (routeSettings) {
        switch (routeSettings.name) {
          case '/settings':
            return MaterialPageRoute(
              builder: (_) => SettingsScreen(
                onBack: () => Navigator.of(_).pop(),
                onOpenSubscription: () {
                  Navigator.of(_).pushNamed('/subscription');
                },
              ),
              settings: routeSettings,
            );
          case '/devotional':
            final args = routeSettings.arguments as Map<String, dynamic>;
            final devotionalId = args['id'] as int;
            return MaterialPageRoute(
              builder: (_) => DevotionalDetailScreen(
                devotionalId: devotionalId,
                apiService: apiService,
                onBack: () => Navigator.of(_).pop(),
              ),
              settings: routeSettings,
            );
          case '/subscription':
            return MaterialPageRoute(
              builder: (_) => SubscriptionScreen(
                onBack: () => Navigator.of(_).pop(),
              ),
              settings: routeSettings,
            );
          default:
            return null;
        }
      },
    );
  }
}
