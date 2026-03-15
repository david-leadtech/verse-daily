import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isAnimating = false;

  late final AnimationController _textFadeController;
  late final AnimationController _imageController;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<Offset> _eyebrowSlide;

  static const _slides = [
    _SlideData(
      image: 'assets/images/onboarding-1.png',
      eyebrow: 'HIS WORD AWAITS',
      title: 'Be still, and\nknow He is God',
      description:
          'Each morning, a verse chosen just for you \u2014 a quiet moment with the One who knows your heart before you speak.',
      centered: false,
    ),
    _SlideData(
      image: 'assets/images/onboarding-2.png',
      eyebrow: 'DRAW NEAR',
      title: 'Let His presence\nfill your day',
      description:
          'Devotionals that speak to what you\u2019re really going through \u2014 because God meets you right where you are, not where you think you should be.',
      centered: true,
    ),
    _SlideData(
      image: 'assets/images/onboarding-3.png',
      eyebrow: 'REMEMBER HIS PROMISES',
      title: 'Hold on to the\nverses that hold you',
      description:
          'Save the words that brought you strength, comfort, or tears. Build a collection of God\u2019s promises that you can return to whenever your soul needs them.',
      centered: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _imageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeOut),
    );
    _eyebrowSlide = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeOut),
    );

    _textFadeController.forward();
  }

  @override
  void dispose() {
    _textFadeController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _animateToSlide(int nextIndex) {
    if (_isAnimating) return;
    _isAnimating = true;

    _textFadeController.reverse().then((_) {
      setState(() => _currentIndex = nextIndex);
      _textFadeController.forward().then((_) {
        _isAnimating = false;
      });
    });
  }

  void _handleNext() {
    if (_currentIndex < _slides.length - 1) {
      _animateToSlide(_currentIndex + 1);
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentIndex];
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            child: Image.asset(
              slide.image,
              key: ValueKey(slide.image),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x33080402),
                  Color(0x73080402),
                  Color(0xF8080402),
                ],
                stops: [0, 0.4, 0.72],
              ),
            ),
            child: const SizedBox.expand(),
          ),
          if (_currentIndex < _slides.length - 1)
            Positioned(
              top: topPadding + 12,
              right: 20,
              child: GestureDetector(
                onTap: widget.onComplete,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0x73000000),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Skip',
                    style: AppTheme.interSemiBold(14).copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: bottomPadding + 110,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: AnimatedBuilder(
                animation: _textFade,
                builder: (context, _) {
                  return Opacity(
                    opacity: _textFade.value,
                    child: Column(
                      crossAxisAlignment: slide.centered
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        SlideTransition(
                          position: _eyebrowSlide,
                          child: Text(
                            slide.eyebrow,
                            textAlign: slide.centered
                                ? TextAlign.center
                                : TextAlign.left,
                            style: AppTheme.interSemiBold(11).copyWith(
                              color: const Color(0xFFE8C868),
                              letterSpacing: 3,
                              shadows: [
                                const Shadow(
                                  color: Color(0x99000000),
                                  offset: Offset(0, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SlideTransition(
                          position: _textSlide,
                          child: Text(
                            slide.title,
                            textAlign: slide.centered
                                ? TextAlign.center
                                : TextAlign.left,
                            style: AppTheme.playfairBold(34).copyWith(
                              color: Colors.white,
                              height: 1.235,
                              shadows: [
                                const Shadow(
                                  color: Color(0xB3000000),
                                  offset: Offset(0, 2),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SlideTransition(
                          position: _textSlide,
                          child: Text(
                            slide.description,
                            textAlign: slide.centered
                                ? TextAlign.center
                                : TextAlign.left,
                            style: AppTheme.interRegular(15).copyWith(
                              color: Colors.white.withOpacity(0.88),
                              height: 1.6,
                              shadows: [
                                const Shadow(
                                  color: Color(0x99000000),
                                  offset: Offset(0, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding:
                  EdgeInsets.fromLTRB(28, 0, 28, bottomPadding + 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: _currentIndex == i ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentIndex == i
                              ? AppColors.accent
                              : Colors.white.withOpacity(0.25),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: const Color(0xFF3C1A00),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentIndex == _slides.length - 1
                                ? 'Begin My Journey'
                                : 'Continue',
                            style: AppTheme.interSemiBold(18).copyWith(
                              color: const Color(0xFF3C1A00),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            _currentIndex == _slides.length - 1
                                ? FeatherIcons.check
                                : FeatherIcons.arrowRight,
                            size: 20,
                            color: const Color(0xFF3C1A00),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideData {
  final String image;
  final String eyebrow;
  final String title;
  final String description;
  final bool centered;

  const _SlideData({
    required this.image,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.centered,
  });
}
