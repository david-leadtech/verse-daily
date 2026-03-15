import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../services/api_service.dart';
import 'splash_screen.dart';
import 'onboarding_screen.dart';
import 'divine_offer_screen.dart';
import 'paywall_weekly_screen.dart';
import 'paywall_annual_screen.dart';
import 'app_shell.dart';

enum _GateStage {
  splash,
  onboarding,
  divineOffer,
  paywallWeekly,
  paywallAnnual,
  app,
}

class AppGate extends StatefulWidget {
  final ApiService apiService;

  const AppGate({super.key, required this.apiService});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  _GateStage _stage = _GateStage.splash;
  bool _splashDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkOnboardingState();
  }

  void _checkOnboardingState() {
    final onboarding = context.read<OnboardingProvider>();
    if (onboarding.hasCompletedOnboarding == true && _splashDone) {
      setState(() => _stage = _GateStage.app);
    }
  }

  void _onSplashComplete() {
    if (_splashDone) return;
    _splashDone = true;
    final onboarding = context.read<OnboardingProvider>();
    if (onboarding.hasCompletedOnboarding == true) {
      setState(() => _stage = _GateStage.app);
    } else {
      setState(() => _stage = _GateStage.onboarding);
    }
  }

  void _onOnboardingComplete() {
    setState(() => _stage = _GateStage.divineOffer);
  }

  void _onDivineOfferContinue() {
    setState(() => _stage = _GateStage.paywallWeekly);
  }

  void _onPaywallWeeklyClose() {
    final onboarding = context.read<OnboardingProvider>();
    onboarding.completeOnboarding();
    setState(() => _stage = _GateStage.app);
  }

  void _onSkipToAnnual() {
    setState(() => _stage = _GateStage.paywallAnnual);
  }

  void _onPaywallAnnualClose() {
    final onboarding = context.read<OnboardingProvider>();
    onboarding.completeOnboarding();
    setState(() => _stage = _GateStage.app);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<OnboardingProvider>();

    switch (_stage) {
      case _GateStage.splash:
        return SplashScreen(onComplete: _onSplashComplete);
      case _GateStage.onboarding:
        return OnboardingScreen(onComplete: _onOnboardingComplete);
      case _GateStage.divineOffer:
        return DivineOfferScreen(onContinue: _onDivineOfferContinue);
      case _GateStage.paywallWeekly:
        return PaywallWeeklyScreen(
          onClose: _onPaywallWeeklyClose,
          onSkipToAnnual: _onSkipToAnnual,
        );
      case _GateStage.paywallAnnual:
        return PaywallAnnualScreen(onClose: _onPaywallAnnualClose);
      case _GateStage.app:
        return AppShell(apiService: widget.apiService);
    }
  }
}
