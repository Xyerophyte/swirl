import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/swirl_theme.dart';
import 'core/theme/swirl_colors.dart';
import 'data/models/models.dart';
import 'features/navigation/presentation/bottom_navigation.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/onboarding/services/onboarding_service.dart';
import 'features/profile/presentation/style_preferences_page.dart';
import 'features/profile/presentation/edit_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: SwirlApp(),
    ),
  );
}

class SwirlApp extends StatefulWidget {
  const SwirlApp({super.key});

  @override
  State<SwirlApp> createState() => _SwirlAppState();
}

class _SwirlAppState extends State<SwirlApp> {
  bool? _hasCompletedOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final completed = await OnboardingService.hasCompletedOnboarding();
    setState(() {
      _hasCompletedOnboarding = completed;
    });
  }

  void _completeOnboarding() {
    setState(() {
      _hasCompletedOnboarding = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWIRL',
      debugShowCheckedModeBanner: false,
      theme: SwirlTheme.lightTheme,
      home: _hasCompletedOnboarding == null
          ? const Scaffold(
              backgroundColor: SwirlColors.background,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _hasCompletedOnboarding!
              ? const BottomNavigation()
              : const OnboardingScreen(),
      routes: {
        '/home': (context) => const BottomNavigation(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/style-preferences') {
          final user = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) => StylePreferencesPage(user: user),
          );
        }
        if (settings.name == '/edit-profile') {
          final user = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) => EditProfilePage(user: user),
          );
        }
        return null;
      },
    );
  }
}
