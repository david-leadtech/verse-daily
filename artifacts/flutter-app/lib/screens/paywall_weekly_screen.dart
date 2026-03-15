import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../providers/settings_provider.dart';

class PaywallWeeklyScreen extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onSkipToAnnual;

  const PaywallWeeklyScreen({
    super.key,
    required this.onClose,
    required this.onSkipToAnnual,
  });

  @override
  State<PaywallWeeklyScreen> createState() => _PaywallWeeklyScreenState();
}

class _PaywallWeeklyScreenState extends State<PaywallWeeklyScreen> {
  bool _freeTrialEnabled = true;

  void _handleSubscribe() {
    final settings = context.read<SettingsProvider>();
    settings.updateSettings(isPremium: true);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_freeTrialEnabled
            ? 'Your free trial has started!'
            : 'Welcome to Premium!'),
        content: Text(_freeTrialEnabled
            ? 'You have 3 days to explore everything \u2014 no charge. We hope it blesses your journey.'
            : 'Thank you for investing in your faith. We pray this blesses your daily walk.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onClose();
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
    final trialEndDate = DateFormat('MMM d, yyyy')
        .format(DateTime.now().add(const Duration(days: 3)));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(
            height: 180,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/paywall-hero.png',
                  fit: BoxFit.cover,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.background.withOpacity(0),
                        AppColors.background.withOpacity(0.4),
                        AppColors.background,
                      ],
                      stops: const [0, 0.55, 1],
                    ),
                  ),
                  child: const SizedBox.expand(),
                ),
                Positioned(
                  top: topPadding + 6,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: widget.onSkipToAnnual,
                        child: Text(
                          'Restore purchase',
                          style: AppTheme.interMedium(14).copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onSkipToAnnual,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: const Icon(
                            FeatherIcons.x,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, bottomPadding + 16),
              child: Column(
                children: [
                  Text(
                    'Unlock the Full',
                    style: AppTheme.playfairBold(28).copyWith(
                      color: AppColors.text,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Scripture Experience',
                    style: AppTheme.playfairBold(28).copyWith(
                      color: AppColors.accent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Everything you need for a deeper, more meaningful walk with Christ \u2014 every single day.',
                    style: AppTheme.interRegular(14).copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      'Unlimited Devotionals, No Ads, All Bible Translations, Verse Wallpapers & More!\n${_freeTrialEnabled ? "Free for 3 days, then \$9.99/week" : "\$9.99/week"}',
                      style: AppTheme.interRegular(15).copyWith(
                        color: AppColors.textSecondary,
                        height: 1.533,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _freeTrialEnabled = !_freeTrialEnabled),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Free Trial Enabled',
                            style: AppTheme.interSemiBold(16),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _freeTrialEnabled
                                  ? AppColors.accent
                                  : Colors.transparent,
                              border: Border.all(
                                color: _freeTrialEnabled
                                    ? AppColors.accent
                                    : AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: _freeTrialEnabled
                                ? const Icon(FeatherIcons.check,
                                    size: 16, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Today',
                                        style: AppTheme.interSemiBold(15)),
                                    Text('Due $trialEndDate',
                                        style: AppTheme.interRegular(13)
                                            .copyWith(
                                                color:
                                                    AppColors.textSecondary)),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _freeTrialEnabled ? 'Free' : '\$9.99',
                                  style: AppTheme.interBold(15).copyWith(
                                    color: _freeTrialEnabled
                                        ? AppColors.success
                                        : AppColors.text,
                                  ),
                                ),
                                Text(
                                  _freeTrialEnabled ? '\$0.00' : '\$9.99',
                                  style: AppTheme.interMedium(13).copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (_freeTrialEnabled) ...[
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 3,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.border,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Then weekly',
                                    style: AppTheme.interRegular(13).copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '\$9.99',
                                style: AppTheme.interMedium(13).copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSubscribe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _freeTrialEnabled ? 'Try Free' : 'Subscribe Now',
                        style: AppTheme.interBold(18).copyWith(
                          color: const Color(0xFF2C1810),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(FeatherIcons.lock,
                          size: 12, color: AppColors.tabIconDefault),
                      const SizedBox(width: 6),
                      Text(
                        'Secured with Apple',
                        style: AppTheme.interRegular(13).copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Terms & Conditions',
                      style: AppTheme.interMedium(13).copyWith(
                        color: AppColors.accent,
                        decoration: TextDecoration.underline,
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
