import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../providers/settings_provider.dart';

class PaywallAnnualScreen extends StatelessWidget {
  final VoidCallback onClose;

  const PaywallAnnualScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    const weeklyPrice = 9.99;
    const annualPrice = 69.99;
    const weeklyCostPerYear = weeklyPrice * 52;
    final savingsPercent =
        ((weeklyCostPerYear - annualPrice) / weeklyCostPerYear * 100).round();

    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    void handleSubscribe() {
      context.read<SettingsProvider>().updateSettings(isPremium: true);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Welcome to the family!'),
          content: const Text(
            'Your annual plan is active. We pray this blesses every single day of your year ahead.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                onClose();
              },
              child: const Text('Amen!'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottomPadding + 20),
        child: Column(
          children: [
            SizedBox(
              height: 280,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/paywall-hero.png',
                    fit: BoxFit.cover,
                  ),
                  Container(color: const Color(0x8C1E0C02)),
                  Positioned(
                    top: topPadding + 12,
                    right: 20,
                    child: GestureDetector(
                      onTap: onClose,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0x4D000000),
                        ),
                        child: Icon(
                          FeatherIcons.x,
                          size: 22,
                          color: const Color(0xB3F5ECD7),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 28,
                    left: 28,
                    right: 28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Before you go...',
                          style: AppTheme.interSemiBold(14).copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'How about\na better deal?',
                          style: AppTheme.playfairBold(32).copyWith(
                            color: Colors.white,
                            height: 1.25,
                            shadows: [
                              const Shadow(
                                color: Color(0x80000000),
                                offset: Offset(0, 1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Save $savingsPercent% with our annual plan \u2014 that\u2019s less than \$6 a month.',
                          style: AppTheme.interRegular(15).copyWith(
                            color: Colors.white.withOpacity(0.85),
                            height: 1.467,
                            shadows: [
                              const Shadow(
                                color: Color(0x66000000),
                                offset: Offset(0, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Weekly',
                            style: AppTheme.interMedium(13).copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${weeklyCostPerYear.toStringAsFixed(0)}',
                            style: AppTheme.interBold(22).copyWith(
                              color: AppColors.tabIconDefault,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'per year',
                            style: AppTheme.interRegular(12).copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.symmetric(horizontal: -6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceSecondary,
                    ),
                    child: const Icon(
                      FeatherIcons.arrowRight,
                      size: 14,
                      color: AppColors.accent,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: AppColors.accent, width: 2),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Annual',
                                style: AppTheme.interMedium(13).copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${annualPrice.toStringAsFixed(2)}',
                                style: AppTheme.playfairBold(30),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${(annualPrice / 12).toStringAsFixed(2)}/mo',
                                style: AppTheme.interRegular(12).copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -12,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'BEST VALUE',
                                style: AppTheme.interBold(10).copyWith(
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.parchment,
                borderRadius: BorderRadius.circular(16),
                border: const Border(
                  left: BorderSide(color: AppColors.accent, width: 3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '\u201CFor where your treasure is,\nthere your heart will be also.\u201D',
                    textAlign: TextAlign.center,
                    style: AppTheme.playfairItalic(18).copyWith(
                      height: 1.556,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\u2014 Matthew 6:21',
                    style: AppTheme.interMedium(13).copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Get Annual for \$${annualPrice.toStringAsFixed(2)}',
                        style: AppTheme.interBold(17).copyWith(
                          color: const Color(0xFF2C1810),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'That\u2019s just \$${(annualPrice / 12).toStringAsFixed(2)} a month',
                        style: AppTheme.interRegular(12).copyWith(
                          color: const Color(0x992C1810),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onClose,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No thanks, I\u2019ll keep it free',
                  style: AppTheme.interRegular(14).copyWith(
                    color: AppColors.tabIconDefault,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Cancel anytime. By subscribing, you agree to our Terms of Use and Privacy Policy.',
                textAlign: TextAlign.center,
                style: AppTheme.interRegular(11).copyWith(
                  color: AppColors.tabIconDefault,
                  height: 1.545,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
