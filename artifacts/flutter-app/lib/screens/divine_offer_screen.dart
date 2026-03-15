import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';

class DivineOfferScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const DivineOfferScreen({super.key, required this.onContinue});

  @override
  State<DivineOfferScreen> createState() => _DivineOfferScreenState();
}

class _DivineOfferScreenState extends State<DivineOfferScreen>
    with TickerProviderStateMixin {
  late final AnimationController _crossController;
  late final AnimationController _line1Controller;
  late final AnimationController _line2Controller;
  late final AnimationController _line3Controller;
  late final AnimationController _fadeOutController;
  late final AnimationController _glowController;

  late final Animation<double> _crossFade;
  late final Animation<double> _crossScale;
  late final Animation<double> _line1Fade;
  late final Animation<Offset> _line1Slide;
  late final Animation<double> _line2Fade;
  late final Animation<Offset> _line2Slide;
  late final Animation<double> _line3Fade;
  late final Animation<Offset> _line3Slide;
  late final Animation<double> _screenFadeOut;
  late final Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();

    _crossController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _line1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _line2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _line3Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _crossFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _crossController, curve: Curves.easeOut),
    );
    _crossScale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _crossController, curve: Curves.easeOut),
    );
    _line1Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _line1Controller, curve: Curves.easeOut),
    );
    _line1Slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _line1Controller, curve: Curves.easeOut),
    );
    _line2Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _line2Controller, curve: Curves.easeOut),
    );
    _line2Slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _line2Controller, curve: Curves.easeOut),
    );
    _line3Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _line3Controller, curve: Curves.easeOut),
    );
    _line3Slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _line3Controller, curve: Curves.easeOut),
    );
    _screenFadeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeIn),
    );
    _glowPulse = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _glowController.repeat(reverse: true);
    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await _crossController.forward();
    await Future.delayed(const Duration(milliseconds: 250));
    await _line1Controller.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _line2Controller.forward();
    await Future.delayed(const Duration(milliseconds: 250));
    await _line3Controller.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    await _fadeOutController.forward();
    if (mounted) widget.onContinue();
  }

  @override
  void dispose() {
    _crossController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _line3Controller.dispose();
    _fadeOutController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _screenFadeOut,
      builder: (context, _) {
        return Opacity(
          opacity: _screenFadeOut.value,
          child: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/paywall-hero.png',
                  fit: BoxFit.cover,
                ),
                Container(color: const Color(0xD10A0502)),
                Positioned(
                  top: size.height * 0.15,
                  left: size.width * 0.1,
                  right: size.width * 0.1,
                  height: size.height * 0.25,
                  child: AnimatedBuilder(
                    animation: _glowPulse,
                    builder: (context, _) {
                      return Opacity(
                        opacity: _glowPulse.value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(size.width),
                            gradient: const RadialGradient(
                              colors: [
                                Color(0x4DC5963A),
                                Color(0x0DC5963A),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _crossFade,
                          builder: (context, _) {
                            return Opacity(
                              opacity: _crossFade.value,
                              child: Transform.scale(
                                scale: _crossScale.value,
                                child: const Icon(
                                  FeatherIcons.plus,
                                  size: 44,
                                  color: AppColors.accent,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        SlideTransition(
                          position: _line1Slide,
                          child: FadeTransition(
                            opacity: _line1Fade,
                            child: Text(
                              'Your faith has brought\nyou here',
                              textAlign: TextAlign.center,
                              style: AppTheme.playfairItalic(26).copyWith(
                                color: Colors.white.withOpacity(0.9),
                                height: 1.385,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SlideTransition(
                          position: _line2Slide,
                          child: FadeTransition(
                            opacity: _line2Fade,
                            child: Text(
                              'And God has prepared\nsomething special for you',
                              textAlign: TextAlign.center,
                              style: AppTheme.playfairBold(22).copyWith(
                                color: Colors.white,
                                height: 1.455,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SlideTransition(
                          position: _line3Slide,
                          child: FadeTransition(
                            opacity: _line3Fade,
                            child: Text(
                              'A gift to deepen your walk...',
                              textAlign: TextAlign.center,
                              style: AppTheme.interMedium(18).copyWith(
                                color: AppColors.accent,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
