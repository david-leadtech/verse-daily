import React, { useState, useRef, useEffect } from "react";
import {
  StyleSheet,
  Text,
  View,
  Pressable,
  Platform,
  Alert,
  Animated,
  ImageBackground,
  ScrollView,
} from "react-native";
import { Feather } from "@expo/vector-icons";
import { LinearGradient } from "expo-linear-gradient";
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
  const topInset = isWeb ? 67 : insets.top;
  const bottomInset = isWeb ? 34 : insets.bottom;

  const contentFade = useRef(new Animated.Value(0)).current;
  const contentSlideY = useRef(new Animated.Value(30)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.timing(contentFade, { toValue: 1, duration: 600, delay: 200, useNativeDriver: true }),
      Animated.spring(contentSlideY, { toValue: 0, tension: 50, friction: 8, delay: 200, useNativeDriver: true }),
    ]).start();
  }, []);

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

  const trialEndDate = new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  });

  return (
    <View style={[styles.container, { paddingBottom: bottomInset + 12 }]}>
      <ImageBackground
        source={require("@/assets/images/paywall-hero.png")}
        style={styles.heroImage}
        resizeMode="cover"
      >
        <LinearGradient
          colors={["rgba(10, 5, 2, 0.3)", "rgba(10, 5, 2, 0.1)", Colors.light.background]}
          locations={[0, 0.5, 1]}
          style={StyleSheet.absoluteFillObject}
        />

        <View style={[styles.topBar, { paddingTop: topInset + 8 }]}>
          <Pressable onPress={onSkipToAnnual} style={styles.restoreBtn}>
            <Text style={styles.restoreText}>Restore</Text>
          </Pressable>
          <Pressable
            onPress={onSkipToAnnual}
            style={({ pressed }) => [styles.closeBtn, { opacity: pressed ? 0.7 : 1 }]}
          >
            <Feather name="x" size={20} color="rgba(255,255,255,0.9)" />
          </Pressable>
        </View>

        <View style={styles.heroContent}>
          <Text style={styles.heroEyebrow}>PREMIUM</Text>
          <Text style={styles.heroTitle}>Unlock the Full</Text>
          <Text style={styles.heroTitleAccent}>Scripture Experience</Text>
        </View>
      </ImageBackground>

      <Animated.View
        style={[
          styles.bodyContent,
          { opacity: contentFade, transform: [{ translateY: contentSlideY }] },
        ]}
      >
        <ScrollView
          showsVerticalScrollIndicator={false}
          contentContainerStyle={styles.scrollContent}
        >
          <Text style={styles.bodySubtitle}>
            Everything you need for a deeper, more meaningful walk with Christ — every single day.
          </Text>

          <View style={styles.featuresGrid}>
            <View style={styles.featureItem}>
              <View style={styles.featureIcon}>
                <Feather name="book-open" size={16} color="#8B4513" />
              </View>
              <Text style={styles.featureText}>Unlimited{"\n"}Devotionals</Text>
            </View>
            <View style={styles.featureItem}>
              <View style={styles.featureIcon}>
                <Feather name="globe" size={16} color="#8B4513" />
              </View>
              <Text style={styles.featureText}>All Bible{"\n"}Translations</Text>
            </View>
            <View style={styles.featureItem}>
              <View style={styles.featureIcon}>
                <Feather name="image" size={16} color="#8B4513" />
              </View>
              <Text style={styles.featureText}>Verse{"\n"}Wallpapers</Text>
            </View>
            <View style={styles.featureItem}>
              <View style={styles.featureIcon}>
                <Feather name="zap" size={16} color="#8B4513" />
              </View>
              <Text style={styles.featureText}>Ad-Free{"\n"}Experience</Text>
            </View>
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
            <View style={styles.trialToggleLeft}>
              <Feather name="gift" size={18} color={freeTrialEnabled ? "#5B7D3A" : Colors.light.textSecondary} />
              <Text style={styles.trialToggleLabel}>Free Trial Enabled</Text>
            </View>
            <View style={[styles.checkbox, freeTrialEnabled && styles.checkboxActive]}>
              {freeTrialEnabled && <Feather name="check" size={16} color="#FFF" />}
            </View>
          </Pressable>

          <View style={styles.pricingBreakdown}>
            <View style={styles.pricingRow}>
              <View style={styles.pricingLeft}>
                <View style={[styles.pricingDot, { backgroundColor: freeTrialEnabled ? "#5B7D3A" : Colors.light.accent }]} />
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
              <View style={[styles.pricingRow, { marginTop: 4 }]}>
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
        </ScrollView>
      </Animated.View>

      <View style={styles.bottomSection}>
        <Pressable
          onPress={handleSubscribe}
          style={({ pressed }) => [
            styles.subscribeBtn,
            { opacity: pressed ? 0.92 : 1, transform: [{ scale: pressed ? 0.98 : 1 }] },
          ]}
        >
          <Text style={styles.subscribeBtnText}>
            {freeTrialEnabled ? "Start Free Trial" : "Subscribe Now"}
          </Text>
        </Pressable>

        <View style={styles.footerLinks}>
          <Feather name="lock" size={11} color={Colors.light.tabIconDefault} />
          <Text style={styles.securedText}>Secured with Apple</Text>
          <Text style={styles.footerDot}>·</Text>
          <Pressable>
            <Text style={styles.termsText}>Terms</Text>
          </Pressable>
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.light.background,
  },
  heroImage: {
    height: 280,
    justifyContent: "space-between",
  },
  topBar: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    paddingHorizontal: 20,
  },
  restoreBtn: {
    paddingHorizontal: 14,
    paddingVertical: 6,
    borderRadius: 16,
    backgroundColor: "rgba(0,0,0,0.3)",
  },
  restoreText: {
    fontSize: 13,
    fontFamily: "Inter_500Medium",
    color: "rgba(255,255,255,0.85)",
  },
  closeBtn: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: "rgba(0,0,0,0.3)",
    alignItems: "center",
    justifyContent: "center",
  },
  heroContent: {
    paddingHorizontal: 24,
    paddingBottom: 24,
  },
  heroEyebrow: {
    fontSize: 11,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.accent,
    letterSpacing: 3,
    marginBottom: 6,
  },
  heroTitle: {
    fontSize: 30,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
    lineHeight: 38,
  },
  heroTitleAccent: {
    fontSize: 30,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.accent,
    lineHeight: 38,
  },
  bodyContent: {
    flex: 1,
    marginTop: -8,
  },
  scrollContent: {
    paddingHorizontal: 24,
    paddingTop: 4,
  },
  bodySubtitle: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
    lineHeight: 22,
    marginBottom: 20,
  },
  featuresGrid: {
    flexDirection: "row",
    flexWrap: "wrap",
    gap: 10,
    marginBottom: 18,
  },
  featureItem: {
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
    width: "47%",
    backgroundColor: Colors.light.surface,
    borderRadius: 12,
    paddingVertical: 12,
    paddingHorizontal: 12,
    borderWidth: 1,
    borderColor: Colors.light.borderLight,
  },
  featureIcon: {
    width: 32,
    height: 32,
    borderRadius: 8,
    backgroundColor: "rgba(197, 150, 58, 0.12)",
    alignItems: "center",
    justifyContent: "center",
  },
  featureText: {
    fontSize: 12,
    fontFamily: "Inter_500Medium",
    color: Colors.light.text,
    lineHeight: 16,
  },
  trialToggleRow: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    backgroundColor: Colors.light.surface,
    borderRadius: 14,
    paddingVertical: 14,
    paddingHorizontal: 16,
    borderWidth: 1,
    borderColor: Colors.light.border,
    marginBottom: 14,
  },
  trialToggleLeft: {
    flexDirection: "row",
    alignItems: "center",
    gap: 10,
  },
  trialToggleLabel: {
    fontSize: 15,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.text,
  },
  checkbox: {
    width: 26,
    height: 26,
    borderRadius: 13,
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
    gap: 10,
    paddingHorizontal: 4,
    marginBottom: 16,
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
    fontFamily: "Inter_500Medium",
    color: Colors.light.textSecondary,
  },
  bottomSection: {
    paddingHorizontal: 24,
    gap: 10,
  },
  subscribeBtn: {
    borderRadius: 16,
    backgroundColor: Colors.light.accent,
    paddingVertical: 18,
    alignItems: "center",
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
  },
  securedText: {
    fontSize: 12,
    fontFamily: "Inter_400Regular",
    color: Colors.light.tabIconDefault,
  },
  footerDot: {
    fontSize: 12,
    color: Colors.light.tabIconDefault,
  },
  termsText: {
    fontSize: 12,
    fontFamily: "Inter_500Medium",
    color: Colors.light.accent,
    textDecorationLine: "underline",
  },
});
