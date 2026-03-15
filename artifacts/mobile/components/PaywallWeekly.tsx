import React, { useState } from "react";
import {
  StyleSheet,
  Text,
  View,
  Pressable,
  Platform,
  Alert,
  Switch,
} from "react-native";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import * as Haptics from "expo-haptics";
import Colors from "@/constants/colors";
import { useSettings } from "@/contexts/SettingsContext";

interface PaywallWeeklyProps {
  onClose: () => void;
  onSkipToAnnual: () => void;
}

export default function PaywallWeekly({ onClose, onSkipToAnnual }: PaywallWeeklyProps) {
  const insets = useSafeAreaInsets();
  const isWeb = Platform.OS === "web";
  const { updateSettings } = useSettings();
  const [freeTrialEnabled, setFreeTrialEnabled] = useState(true);

  const handleSubscribe = () => {
    if (Platform.OS !== "web") {
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
    }
    updateSettings({ isPremium: true });
    Alert.alert(
      freeTrialEnabled ? "Your free trial has started!" : "Welcome to Premium!",
      freeTrialEnabled
        ? "You have 3 days to explore everything — no charge. We hope it blesses your journey."
        : "Thank you for investing in your faith. We pray this blesses your daily walk.",
      [{ text: "Amen!", onPress: onClose }]
    );
  };

  const todayDate = new Date().toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  });

  const trialEndDate = new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  });

  return (
    <View style={[styles.container, { paddingTop: (isWeb ? 67 : insets.top) + 8, paddingBottom: (isWeb ? 34 : insets.bottom) + 12 }]}>
      <View style={styles.topBar}>
        <Pressable onPress={onSkipToAnnual} style={styles.restoreBtn}>
          <Text style={styles.restoreText}>Restore purchase</Text>
        </Pressable>
        <Pressable
          onPress={onSkipToAnnual}
          style={({ pressed }) => [styles.closeBtn, { opacity: pressed ? 0.7 : 1 }]}
        >
          <Feather name="x" size={20} color={Colors.light.textSecondary} />
        </Pressable>
      </View>

      <View style={styles.heroSection}>
        <Text style={styles.heroTitle}>Unlock the Full</Text>
        <Text style={styles.heroTitleAccent}>Scripture Experience</Text>
        <Text style={styles.heroSubtitle}>
          Everything you need for a deeper, more meaningful walk with Christ — every single day.
        </Text>
      </View>

      <View style={styles.featuresCard}>
        <Text style={styles.featuresText}>
          Unlimited Devotionals, No Ads, All Bible Translations, Verse Wallpapers & More!{"\n"}
          {freeTrialEnabled ? "Free for 3 days, then $9.99/week" : "$9.99/week"}
        </Text>
      </View>

      <Pressable
        onPress={() => {
          setFreeTrialEnabled(!freeTrialEnabled);
          if (Platform.OS !== "web") {
            Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
          }
        }}
        style={styles.trialToggleRow}
      >
        <Text style={styles.trialToggleLabel}>Free Trial Enabled</Text>
        <View style={[styles.checkbox, freeTrialEnabled && styles.checkboxActive]}>
          {freeTrialEnabled && <Feather name="check" size={16} color="#FFF" />}
        </View>
      </Pressable>

      <View style={styles.pricingBreakdown}>
        <View style={styles.pricingRow}>
          <View style={styles.pricingLeft}>
            <View style={[styles.pricingDot, { backgroundColor: Colors.light.accent }]} />
            <View>
              <Text style={styles.pricingLabel}>Today</Text>
              <Text style={styles.pricingDueDate}>Due {trialEndDate}</Text>
            </View>
          </View>
          <View style={styles.pricingRight}>
            <Text style={[styles.pricingStatus, { color: freeTrialEnabled ? "#5B7D3A" : Colors.light.text }]}>
              {freeTrialEnabled ? "Free" : "$9.99"}
            </Text>
            <Text style={styles.pricingAmount}>
              {freeTrialEnabled ? "$0.00" : "$9.99"}
            </Text>
          </View>
        </View>
        {freeTrialEnabled && (
          <View style={[styles.pricingRow, { marginTop: 2 }]}>
            <View style={styles.pricingLeft}>
              <View style={[styles.pricingDot, { backgroundColor: Colors.light.border }]} />
              <Text style={styles.pricingDueDate}>Then weekly</Text>
            </View>
            <View style={styles.pricingRight}>
              <Text style={styles.pricingAmount}>$9.99</Text>
            </View>
          </View>
        )}
      </View>

      <View style={{ flex: 1 }} />

      <Pressable
        onPress={handleSubscribe}
        style={({ pressed }) => [
          styles.subscribeBtn,
          { opacity: pressed ? 0.92 : 1, transform: [{ scale: pressed ? 0.98 : 1 }] },
        ]}
      >
        <Text style={styles.subscribeBtnText}>
          {freeTrialEnabled ? "Try Free" : "Subscribe Now"}
        </Text>
      </Pressable>

      <View style={styles.footerLinks}>
        <Feather name="lock" size={12} color={Colors.light.tabIconDefault} />
        <Text style={styles.securedText}>Secured with Apple</Text>
      </View>
      <Pressable>
        <Text style={styles.termsText}>Terms & Conditions</Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.light.background,
    paddingHorizontal: 24,
  },
  topBar: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: 20,
  },
  restoreBtn: {},
  restoreText: {
    fontSize: 14,
    fontFamily: "Inter_500Medium",
    color: Colors.light.accent,
  },
  closeBtn: {
    width: 32,
    height: 32,
    borderRadius: 16,
    alignItems: "center",
    justifyContent: "center",
  },
  heroSection: {
    alignItems: "center",
    marginBottom: 28,
  },
  heroTitle: {
    fontSize: 28,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
    textAlign: "center",
  },
  heroTitleAccent: {
    fontSize: 28,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.accent,
    textAlign: "center",
    marginBottom: 10,
  },
  heroSubtitle: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
    textAlign: "center",
    lineHeight: 22,
    maxWidth: 320,
  },
  featuresCard: {
    backgroundColor: Colors.light.surface,
    borderRadius: 16,
    padding: 20,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: Colors.light.border,
  },
  featuresText: {
    fontSize: 15,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
    lineHeight: 24,
    textAlign: "center",
  },
  trialToggleRow: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    backgroundColor: Colors.light.surface,
    borderRadius: 16,
    padding: 18,
    borderWidth: 1,
    borderColor: Colors.light.border,
    marginBottom: 16,
  },
  trialToggleLabel: {
    fontSize: 16,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.text,
  },
  checkbox: {
    width: 28,
    height: 28,
    borderRadius: 14,
    borderWidth: 2,
    borderColor: Colors.light.border,
    alignItems: "center",
    justifyContent: "center",
  },
  checkboxActive: {
    backgroundColor: Colors.light.accent,
    borderColor: Colors.light.accent,
  },
  pricingBreakdown: {
    gap: 12,
    paddingHorizontal: 4,
  },
  pricingRow: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  pricingLeft: {
    flexDirection: "row",
    alignItems: "center",
    gap: 10,
  },
  pricingDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  pricingLabel: {
    fontSize: 15,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.text,
  },
  pricingDueDate: {
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  pricingRight: {
    alignItems: "flex-end",
    gap: 1,
  },
  pricingStatus: {
    fontSize: 15,
    fontFamily: "Inter_700Bold",
  },
  pricingAmount: {
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  subscribeBtn: {
    borderRadius: 16,
    backgroundColor: Colors.light.accent,
    paddingVertical: 18,
    alignItems: "center",
    marginBottom: 14,
  },
  subscribeBtnText: {
    fontSize: 18,
    fontFamily: "Inter_700Bold",
    color: "#2C1810",
  },
  footerLinks: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    gap: 6,
    marginBottom: 4,
  },
  securedText: {
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: Colors.light.tabIconDefault,
  },
  termsText: {
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: Colors.light.accent,
    textAlign: "center",
    textDecorationLine: "underline",
  },
});
