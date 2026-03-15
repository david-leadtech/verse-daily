import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onOpenSubscription;

  const SettingsScreen({
    super.key,
    required this.onBack,
    required this.onOpenSubscription,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: const Icon(FeatherIcons.chevronLeft,
                        size: 24, color: AppColors.tint),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text('Settings', style: AppTheme.playfairBold(18)),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 24, bottom: 40),
              children: [
                _sectionTitle('Preferences'),
                _card([
                  _settingRow(
                    icon: FeatherIcons.bell,
                    iconColor: AppColors.navy,
                    label: 'Daily Notifications',
                    description: 'Receive your daily verse reminder',
                    trailing: Switch.adaptive(
                      value: settings.notificationsEnabled,
                      onChanged: (val) =>
                          settings.updateSettings(notificationsEnabled: val),
                      activeColor: AppColors.accent,
                      inactiveTrackColor: AppColors.border,
                    ),
                  ),
                  _divider(),
                  _settingRow(
                    icon: FeatherIcons.clock,
                    iconColor: AppColors.accent,
                    label: 'Notification Time',
                    description: settings.notificationTime,
                    trailing: const Icon(FeatherIcons.chevronRight,
                        size: 18, color: AppColors.tabIconDefault),
                  ),
                  _divider(),
                  _settingRow(
                    icon: FeatherIcons.book,
                    iconColor: AppColors.tint,
                    label: 'Bible Version',
                    description: settings.bibleVersion,
                    trailing: const Icon(FeatherIcons.chevronRight,
                        size: 18, color: AppColors.tabIconDefault),
                  ),
                ]),
                const SizedBox(height: 28),
                _sectionTitle('Premium'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: onOpenSubscription,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.25),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(FeatherIcons.award,
                                  size: 20, color: AppColors.accent),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      settings.isPremium
                                          ? 'Premium Active'
                                          : 'Upgrade to Premium',
                                      style: AppTheme.interSemiBold(17),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      settings.isPremium
                                          ? 'Thank you for supporting our mission'
                                          : 'Unlock all devotionals, remove ads, and more',
                                      style:
                                          AppTheme.interRegular(14).copyWith(
                                        color: AppColors.textSecondary,
                                        height: 1.429,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (!settings.isPremium) ...[
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: onOpenSubscription,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.tint,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'View Plans',
                                  style: AppTheme.interSemiBold(15).copyWith(
                                    color: const Color(0xFFF5ECD7),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _sectionTitle('About'),
                _card([
                  _settingLink(FeatherIcons.info, AppColors.olive, 'About'),
                  _divider(),
                  _settingLink(
                      FeatherIcons.shield, AppColors.navy, 'Privacy Policy'),
                  _divider(),
                  _settingLink(
                      FeatherIcons.fileText, AppColors.crimson, 'Terms of Use'),
                  _divider(),
                  _settingLink(
                      FeatherIcons.mail, AppColors.tint, 'Contact Support'),
                ]),
                const SizedBox(height: 28),
                Center(
                  child: Text(
                    'Bible Verse Daily v1.0.0',
                    style: AppTheme.interRegular(13).copyWith(
                      color: AppColors.tabIconDefault,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Text(
        title.toUpperCase(),
        style: AppTheme.interSemiBold(13).copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: AppColors.borderLight,
      margin: const EdgeInsets.only(left: 66),
    );
  }

  Widget _settingRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String description,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: iconColor.withOpacity(0.08),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTheme.interMedium(16)),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTheme.interRegular(13).copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _settingLink(IconData icon, Color iconColor, String label) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: iconColor.withOpacity(0.08),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: AppTheme.interMedium(16)),
          ),
          const Icon(FeatherIcons.chevronRight,
              size: 18, color: AppColors.tabIconDefault),
        ],
      ),
    );
  }
}
