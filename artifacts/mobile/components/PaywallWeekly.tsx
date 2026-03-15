import React, { useState } from "react";
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  Pressable,
  Platform,
  Alert,
  Switch,
} from "react-native";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { LinearGradient } from "expo-linear-gradient";
import * as Haptics from "expo-haptics";
import Colors from "@/constants/colors";
import { useSettings } from "@/contexts/SettingsContext";

interface PaywallWeeklyProps {
  onClose: () => void;
  onSkipToAnnual: () => void;
}

const FEATURES = [
  { icon: "book-open", text: "Unlimited devotionals & reflections" },
  { icon: "bell-off", text: "Ad-free experience" },
  { icon: "layers", text: "Multiple Bible translations" },
  { icon: "image", text: "Premium verse wallpapers" },
  { icon: "share-2", text: "Beautiful sharing templates" },
  { icon: "heart", text: "Unlimited saved verses" },
];

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
      "Welcome to Premium!",
      freeTrialEnabled
        ? "Your 3-day free trial has started. Enjoy all premium features!"
        : "Thank you for your subscription. Enjoy all premium features!",
      [{ text: "Amen!", onPress: onClose }]
    );
  };

  return (
    <View style={styles.container}>
      <ScrollView
        contentContainerStyle={{ paddingBottom: (isWeb ? 34 : insets.bottom) + 20 }}
        showsVerticalScrollIndicator={false}
      >
        <LinearGradient
          colors={["#3C1A00", "#5C2D0E", "#8B4513"]}
          start={{ x: 0, y: 0 }}
          end={{ x: 0.5, y: 1 }}
          style={[styles.heroSection, { paddingTop: (isWeb ? 67 : insets.top) + 12 }]}
        >
          <Pressable
            onPress={onSkipToAnnual}
            style={({ pressed }) => [styles.closeBtn, { opacity: pressed ? 0.7 : 1 }]}
          >
            <Feather name="x" size={22} color="rgba(245,236,215,0.6)" />
          </Pressable>

          <View style={styles.heroIcon}>
            <Text style={styles.heroIconText}>✝</Text>
          </View>

          <Text style={styles.heroTitle}>Unlock the Full</Text>
          <Text style={styles.heroTitleAccent}>Scripture Experience</Text>
          <Text style={styles.heroSubtitle}>
            Walk deeper with Christ every single day
          </Text>
        </LinearGradient>

        <View style={styles.featuresSection}>
          {FEATURES.map((feature, i) => (
            <View key={i} style={styles.featureRow}>
              <View style={styles.featureIcon}>
                <Feather name={feature.icon as any} size={18} color={Colors.light.tint} />
              </View>
              <Text style={styles.featureText}>{feature.text}</Text>
            </View>
          ))}
        </View>

        <View style={styles.trialToggleSection}>
          <View style={styles.trialToggle}>
            <View style={styles.trialToggleInfo}>
              <Text style={styles.trialToggleTitle}>Free Trial</Text>
              <Text style={styles.trialToggleDescription}>
                {freeTrialEnabled
                  ? "3 days free, then $9.99/week"
                  : "Start immediately at $9.99/week"}
              </Text>
            </View>
            <Switch
              value={freeTrialEnabled}
              onValueChange={(val) => {
                setFreeTrialEnabled(val);
                if (Platform.OS !== "web") {
                  Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
                }
              }}
              trackColor={{ false: Colors.light.border, true: Colors.light.accent }}
              thumbColor={freeTrialEnabled ? "#FFF" : "#f4f3f4"}
            />
          </View>
        </View>

        <View style={styles.planCard}>
          <View style={styles.planBadge}>
            <Text style={styles.planBadgeText}>WEEKLY</Text>
          </View>
          <View style={styles.planContent}>
            <View style={styles.planPricing}>
              <Text style={styles.planPrice}>$9.99</Text>
              <Text style={styles.planPeriod}>/week</Text>
            </View>
            {freeTrialEnabled && (
              <View style={styles.trialBadge}>
                <Feather name="gift" size={14} color="#5B7D3A" />
                <Text style={styles.trialBadgeText}>3 days free</Text>
              </View>
            )}
          </View>
        </View>

        <Pressable
          onPress={handleSubscribe}
          style={({ pressed }) => [
            styles.subscribeBtn,
            { opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.98 : 1 }] },
          ]}
        >
          <LinearGradient
            colors={["#C5963A", "#8B6914"]}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 0 }}
            style={styles.subscribeBtnGradient}
          >
            <Text style={styles.subscribeBtnText}>
              {freeTrialEnabled ? "Start Free Trial" : "Subscribe Now"}
            </Text>
            {freeTrialEnabled && (
              <Text style={styles.subscribeBtnSub}>3 days free, then $9.99/week</Text>
            )}
          </LinearGradient>
        </Pressable>

        <Text style={styles.disclaimer}>
          Cancel anytime. No commitment required.{"\n"}By subscribing, you agree to our Terms of
          Use and Privacy Policy.
        </Text>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.light.background,
  },
  heroSection: {
    alignItems: "center",
    paddingHorizontal: 32,
    paddingBottom: 40,
  },
  closeBtn: {
    alignSelf: "flex-end",
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: "rgba(245,236,215,0.1)",
    alignItems: "center",
    justifyContent: "center",
    marginBottom: 16,
  },
  heroIcon: {
    width: 72,
    height: 72,
    borderRadius: 36,
    backgroundColor: "rgba(197, 150, 58, 0.15)",
    alignItems: "center",
    justifyContent: "center",
    marginBottom: 20,
    borderWidth: 1,
    borderColor: "rgba(197, 150, 58, 0.25)",
  },
  heroIconText: {
    fontSize: 36,
    color: "#C5963A",
  },
  heroTitle: {
    fontSize: 26,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#F5ECD7",
  },
  heroTitleAccent: {
    fontSize: 26,
    fontFamily: "PlayfairDisplay_400Regular_Italic",
    color: "#C5963A",
    marginBottom: 10,
  },
  heroSubtitle: {
    fontSize: 15,
    fontFamily: "Inter_400Regular",
    color: "rgba(245, 236, 215, 0.6)",
    textAlign: "center",
  },
  featuresSection: {
    paddingHorizontal: 28,
    paddingTop: 28,
    paddingBottom: 8,
    gap: 14,
  },
  featureRow: {
    flexDirection: "row",
    alignItems: "center",
    gap: 14,
  },
  featureIcon: {
    width: 40,
    height: 40,
    borderRadius: 12,
    backgroundColor: Colors.light.tint + "12",
    alignItems: "center",
    justifyContent: "center",
  },
  featureText: {
    fontSize: 15,
    fontFamily: "Inter_500Medium",
    color: Colors.light.text,
  },
  trialToggleSection: {
    paddingHorizontal: 28,
    paddingTop: 24,
    paddingBottom: 16,
  },
  trialToggle: {
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: Colors.light.surface,
    borderRadius: 16,
    padding: 18,
    borderWidth: 1,
    borderColor: Colors.light.border,
  },
  trialToggleInfo: {
    flex: 1,
    gap: 4,
  },
  trialToggleTitle: {
    fontSize: 16,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.text,
  },
  trialToggleDescription: {
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  planCard: {
    marginHorizontal: 28,
    borderRadius: 16,
    borderWidth: 2,
    borderColor: Colors.light.accent,
    backgroundColor: Colors.light.surface,
    overflow: "hidden",
  },
  planBadge: {
    backgroundColor: Colors.light.accent,
    paddingVertical: 6,
    alignItems: "center",
  },
  planBadgeText: {
    fontSize: 11,
    fontFamily: "Inter_700Bold",
    color: "#FFF",
    textTransform: "uppercase",
    letterSpacing: 1.5,
  },
  planContent: {
    padding: 20,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },
  planPricing: {
    flexDirection: "row",
    alignItems: "baseline",
    gap: 4,
  },
  planPrice: {
    fontSize: 32,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
  },
  planPeriod: {
    fontSize: 16,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  trialBadge: {
    flexDirection: "row",
    alignItems: "center",
    gap: 6,
    backgroundColor: "#5B7D3A15",
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 10,
  },
  trialBadgeText: {
    fontSize: 13,
    fontFamily: "Inter_600SemiBold",
    color: "#5B7D3A",
  },
  subscribeBtn: {
    marginHorizontal: 28,
    marginTop: 24,
    borderRadius: 16,
    overflow: "hidden",
  },
  subscribeBtnGradient: {
    paddingVertical: 18,
    alignItems: "center",
    gap: 4,
  },
  subscribeBtnText: {
    fontSize: 18,
    fontFamily: "Inter_700Bold",
    color: "#FFF",
  },
  subscribeBtnSub: {
    fontSize: 12,
    fontFamily: "Inter_400Regular",
    color: "rgba(255,255,255,0.7)",
  },
  disclaimer: {
    fontSize: 11,
    fontFamily: "Inter_400Regular",
    color: Colors.light.tabIconDefault,
    textAlign: "center",
    paddingHorizontal: 40,
    paddingTop: 16,
    lineHeight: 17,
  },
});
