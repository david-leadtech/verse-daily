import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../providers/settings_provider.dart';

class _PlanOption {
  final String id;
  final String name;
  final String price;
  final String period;
  final String? savings;
  final bool popular;

  const _PlanOption({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    this.savings,
    this.popular = false,
  });
}

const _plans = [
  _PlanOption(id: 'weekly', name: 'Weekly', price: '\$9.99', period: '/week'),
  _PlanOption(
    id: 'yearly',
    name: 'Annual',
    price: '\$69.99',
    period: '/year',
    savings: 'Save 87%',
    popular: true,
  ),
];

const _features = [
  (FeatherIcons.bookOpen, 'All devotionals & reflections'),
  (FeatherIcons.bellOff, 'Ad-free experience'),
  (FeatherIcons.layers, 'Multiple Bible translations'),
  (FeatherIcons.image, 'Premium verse wallpapers'),
  (FeatherIcons.share2, 'Beautiful sharing templates'),
  (FeatherIcons.heart, 'Unlimited saved verses'),
];

class SubscriptionScreen extends StatefulWidget {
  final VoidCallback onBack;

  const SubscriptionScreen({super.key, required this.onBack});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _selectedPlan = 'yearly';

  void _handleSubscribe() {
    context.read<SettingsProvider>().updateSettings(isPremium: true);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Welcome to Premium!'),
        content: const Text(
          'Thank you for supporting our mission. Enjoy all premium features.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onBack();
            },
            child: const Text('Amen!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottomPadding + 20),
        child: Column(
          children: [
            SizedBox(
              height: 260,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/paywall-hero.png',
                      fit: BoxFit.cover),
                  Container(color: const Color(0x8C1E0C02)),
                  Positioned(
                    top: topPadding + 12,
                    right: 20,
                    child: GestureDetector(
                      onTap: widget.onBack,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0x4D000000),
                        ),
                        child: const Icon(FeatherIcons.x,
                            size: 24, color: Color(0xFFF5ECD7)),
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
                          'Unlock Premium',
                          style: AppTheme.playfairBold(28).copyWith(
                            color: const Color(0xFFF5ECD7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Everything you need for a richer, more personal walk with Christ \u2014 every single day.',
                          style: AppTheme.interRegular(15).copyWith(
                            color: const Color(0xBFF5ECD7),
                            height: 1.467,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
              child: Column(
                children: _features
                    .map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.tint.withOpacity(0.07),
                                ),
                                child:
                                    Icon(f.$1, size: 18, color: AppColors.tint),
                              ),
                              const SizedBox(width: 14),
                              Text(f.$2, style: AppTheme.interMedium(15)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: _plans.map((plan) {
                  final isSelected = _selectedPlan == plan.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPlan = plan.id),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.border,
                            width: 2,
                          ),
                          color: AppColors.surface,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            if (plan.popular)
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                color: AppColors.accent,
                                child: Center(
                                  child: Text(
                                    'BEST VALUE',
                                    style: AppTheme.interBold(12).copyWith(
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: Row(
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.accent
                                            : AppColors.border,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 12,
                                              height: 12,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.accent,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(plan.name,
                                            style:
                                                AppTheme.interSemiBold(16)),
                                        const SizedBox(height: 2),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline:
                                              TextBaseline.alphabetic,
                                          children: [
                                            Text(plan.price,
                                                style:
                                                    AppTheme.playfairBold(20)),
                                            const SizedBox(width: 4),
                                            Text(
                                              plan.period,
                                              style: AppTheme.interRegular(14)
                                                  .copyWith(
                                                color:
                                                    AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (plan.savings != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        color:
                                            AppColors.olive.withOpacity(0.12),
                                      ),
                                      child: Text(
                                        plan.savings!,
                                        style: AppTheme.interBold(12).copyWith(
                                          color: AppColors.olive,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC5963A), Color(0xFF8B6914)],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _handleSubscribe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Subscribe Now',
                      style: AppTheme.interBold(18).copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 16, 40, 0),
              child: Text(
                'Cancel anytime. No commitment required.\nBy subscribing, you agree to our Terms of Use and Privacy Policy.',
                textAlign: TextAlign.center,
                style: AppTheme.interRegular(12).copyWith(
                  color: AppColors.tabIconDefault,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
