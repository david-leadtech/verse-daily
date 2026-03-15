import React from "react";
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  Pressable,
  Switch,
  Platform,
} from "react-native";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useRouter } from "expo-router";
import Colors from "@/constants/colors";
import { useSettings } from "@/contexts/SettingsContext";

export default function SettingsScreen() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const isWeb = Platform.OS === "web";
  const { settings, updateSettings } = useSettings();

  return (
    <View style={styles.container}>
      <View style={[styles.header, { paddingTop: (isWeb ? 67 : insets.top) + 12 }]}>
        <Pressable onPress={() => router.back()} style={styles.backBtn}>
          <Feather name="chevron-left" size={24} color={Colors.light.tint} />
        </Pressable>
        <Text style={styles.headerTitle}>Settings</Text>
        <View style={{ width: 36 }} />
      </View>

      <ScrollView
        contentContainerStyle={[styles.scrollContent, { paddingBottom: (isWeb ? 34 : 0) + 40 }]}
      >
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Preferences</Text>
          <View style={styles.card}>
            <View style={styles.settingRow}>
              <View style={[styles.settingIcon, { backgroundColor: Colors.light.navy + "15" }]}>
                <Feather name="bell" size={18} color={Colors.light.navy} />
              </View>
              <View style={styles.settingInfo}>
                <Text style={styles.settingLabel}>Daily Notifications</Text>
                <Text style={styles.settingDescription}>
                  Receive your daily verse reminder
                </Text>
              </View>
              <Switch
                value={settings.notificationsEnabled}
                onValueChange={(val) => updateSettings({ notificationsEnabled: val })}
                trackColor={{ false: Colors.light.border, true: Colors.light.accent }}
                thumbColor={settings.notificationsEnabled ? "#FFF" : "#f4f3f4"}
              />
            </View>
            <View style={styles.divider} />
            <Pressable style={styles.settingRow}>
              <View style={[styles.settingIcon, { backgroundColor: Colors.light.accent + "15" }]}>
                <Feather name="clock" size={18} color={Colors.light.accent} />
              </View>
              <View style={styles.settingInfo}>
                <Text style={styles.settingLabel}>Notification Time</Text>
                <Text style={styles.settingDescription}>{settings.notificationTime}</Text>
              </View>
              <Feather name="chevron-right" size={18} color={Colors.light.tabIconDefault} />
            </Pressable>
            <View style={styles.divider} />
            <Pressable style={styles.settingRow}>
              <View style={[styles.settingIcon, { backgroundColor: Colors.light.tint + "15" }]}>
                <Feather name="book" size={18} color={Colors.light.tint} />
              </View>
              <View style={styles.settingInfo}>
                <Text style={styles.settingLabel}>Bible Version</Text>
                <Text style={styles.settingDescription}>{settings.bibleVersion}</Text>
              </View>
              <Feather name="chevron-right" size={18} color={Colors.light.tabIconDefault} />
            </Pressable>
          </View>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Premium</Text>
          <Pressable
            onPress={() => router.push("/subscription")}
            style={({ pressed }) => [{ opacity: pressed ? 0.95 : 1 }]}
          >
            <View style={styles.premiumCard}>
              <View style={styles.premiumContent}>
                <Text style={styles.premiumIcon}>✝</Text>
                <View style={styles.premiumInfo}>
                  <Text style={styles.premiumTitle}>
                    {settings.isPremium ? "Premium Active" : "Upgrade to Premium"}
                  </Text>
                  <Text style={styles.premiumDescription}>
                    {settings.isPremium
                      ? "Thank you for supporting our mission"
                      : "Unlock all devotionals, remove ads, and more"}
                  </Text>
                </View>
              </View>
              {!settings.isPremium && (
                <View style={styles.premiumButton}>
                  <Text style={styles.premiumButtonText}>View Plans</Text>
                </View>
              )}
            </View>
          </Pressable>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>About</Text>
          <View style={styles.card}>
            <SettingLink icon="info" iconColor={Colors.light.olive} label="About" />
            <View style={styles.divider} />
            <SettingLink icon="shield" iconColor={Colors.light.navy} label="Privacy Policy" />
            <View style={styles.divider} />
            <SettingLink icon="file-text" iconColor={Colors.light.crimson} label="Terms of Use" />
            <View style={styles.divider} />
            <SettingLink icon="mail" iconColor={Colors.light.tint} label="Contact Support" />
          </View>
        </View>

        <Text style={styles.version}>Bible Verse Daily v1.0.0</Text>
      </ScrollView>
    </View>
  );
}

function SettingLink({
  icon,
  iconColor,
  label,
}: {
  icon: string;
  iconColor: string;
  label: string;
}) {
  return (
    <Pressable style={({ pressed }) => [styles.settingRow, { opacity: pressed ? 0.7 : 1 }]}>
      <View style={[styles.settingIcon, { backgroundColor: iconColor + "15" }]}>
        <Feather name={icon as any} size={18} color={iconColor} />
      </View>
      <View style={styles.settingInfo}>
        <Text style={styles.settingLabel}>{label}</Text>
      </View>
      <Feather name="chevron-right" size={18} color={Colors.light.tabIconDefault} />
    </Pressable>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.light.background,
  },
  header: {
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 20,
    paddingBottom: 12,
    borderBottomWidth: 1,
    borderBottomColor: Colors.light.borderLight,
  },
  backBtn: {
    width: 36,
    height: 36,
    borderRadius: 18,
    alignItems: "center",
    justifyContent: "center",
  },
  headerTitle: {
    flex: 1,
    textAlign: "center",
    fontSize: 18,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
  },
  scrollContent: {
    paddingTop: 24,
  },
  section: {
    marginBottom: 28,
    paddingHorizontal: 20,
  },
  sectionTitle: {
    fontSize: 13,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.textSecondary,
    textTransform: "uppercase",
    letterSpacing: 1,
    marginBottom: 10,
  },
  card: {
    backgroundColor: Colors.light.surface,
    borderRadius: 16,
    overflow: "hidden",
    borderWidth: 1,
    borderColor: Colors.light.borderLight,
  },
  settingRow: {
    flexDirection: "row",
    alignItems: "center",
    padding: 16,
    gap: 14,
  },
  settingIcon: {
    width: 36,
    height: 36,
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
  },
  settingInfo: {
    flex: 1,
    gap: 2,
  },
  settingLabel: {
    fontSize: 16,
    fontFamily: "Inter_500Medium",
    color: Colors.light.text,
  },
  settingDescription: {
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  divider: {
    height: 1,
    backgroundColor: Colors.light.borderLight,
    marginLeft: 66,
  },
  premiumCard: {
    backgroundColor: Colors.light.surface,
    borderRadius: 16,
    padding: 20,
    borderWidth: 1,
    borderColor: Colors.light.accent + "40",
    gap: 16,
  },
  premiumContent: {
    flexDirection: "row",
    gap: 14,
    alignItems: "center",
  },
  premiumIcon: {
    fontSize: 28,
    color: Colors.light.accent,
  },
  premiumInfo: {
    flex: 1,
    gap: 4,
  },
  premiumTitle: {
    fontSize: 17,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.text,
  },
  premiumDescription: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
    lineHeight: 20,
  },
  premiumButton: {
    backgroundColor: Colors.light.tint,
    borderRadius: 12,
    paddingVertical: 12,
    alignItems: "center",
  },
  premiumButtonText: {
    fontSize: 15,
    fontFamily: "Inter_600SemiBold",
    color: "#F5ECD7",
  },
  version: {
    textAlign: "center",
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: Colors.light.tabIconDefault,
    marginTop: 8,
  },
});
