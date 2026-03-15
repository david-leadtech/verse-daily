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
  ImageBackground,
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

const FEATURES = [
  { icon: "book-open", label: "Unlimited devotionals", sub: "Fresh content every day" },
  { icon: "bell-off", label: "No ads, ever", sub: "Pure, focused reading" },
  { icon: "layers", label: "All Bible translations", sub: "KJV, NIV, ESV & more" },
  { icon: "heart", label: "Unlimited favorites", sub: "Save every verse that moves you" },
  { icon: "image", label: "Verse wallpapers", sub: "Beautiful images with scripture" },
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
      freeTrialEnabled ? "Your free trial has started!" : "Welcome to Premium!",
      freeTrialEnabled
        ? "You have 3 days to explore everything — no charge. We hope it blesses your journey."
        : "Thank you for investing in your faith. We pray this blesses your daily walk.",
      [{ text: "Amen!", onPress: onClose }]
    );
  };

  return (
    <View style={styles.container}>
      <ScrollView
        contentContainerStyle={{ paddingBottom: (isWeb ? 34 : insets.bottom) + 20 }}
        showsVerticalScrollIndicator={false}
      >
        <ImageBackground
          source={require("@/assets/images/paywall-hero.png")}
          style={[styles.heroSection, { paddingTop: (isWeb ? 67 : insets.top) + 12 }]}
          resizeMode="cover"
        >
          <View style={styles.heroOverlay} />

          <Pressable
            onPress={onSkipToAnnual}
            style={({ pressed }) => [styles.closeBtn, { opacity: pressed ? 0.7 : 1 }]}
          >
            <Feather name="x" size={22} color="rgba(245,236,215,0.7)" />
          </Pressable>

          <View style={styles.heroContent}>
            <Text style={styles.heroEyebrow}>UNLOCK EVERYTHING</Text>
            <Text style={styles.heroTitle}>Go deeper in{"\n"}your faith</Text>
            <Text style={styles.heroSubtitle}>
              Everything you need for a richer, more meaningful walk with Christ.
            </Text>
          </View>
        </ImageBackground>

        <View style={styles.featuresSection}>
          <Text style={styles.featuresSectionTitle}>What you'll get</Text>
          {FEATURES.map((feature, i) => (
            <View key={i} style={styles.featureRow}>
              <View style={styles.featureIcon}>
                <Feather name={feature.icon as any} size={18} color={Colors.light.accent} />
              </View>
              <View style={styles.featureTextArea}>
                <Text style={styles.featureLabel}>{feature.label}</Text>
                <Text style={styles.featureSub}>{feature.sub}</Text>
              </View>
            </View>
          ))}
        </View>

        <View style={styles.trialSection}>
          <View style={styles.trialToggle}>
            <View style={styles.trialToggleInfo}>
              <Text style={styles.trialToggleTitle}>
                {freeTrialEnabled ? "3-day free trial" : "No free trial"}
              </Text>
              <Text style={styles.trialToggleDescription}>
                {freeTrialEnabled
                  ? "Try everything free — cancel anytime before it ends."
                  : "Start your subscription right away at $9.99/week."}
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

        <View style={styles.priceSection}>
          <Text style={styles.priceAmount}>$9.99</Text>
          <Text style={styles.pricePeriod}>/week</Text>
          {freeTrialEnabled && (
            <View style={styles.trialBadge}>
              <Feather name="gift" size={13} color="#5B7D3A" />
              <Text style={styles.trialBadgeText}>First 3 days free</Text>
            </View>
          )}
        </View>

        <Pressable
          onPress={handleSubscribe}
          style={({ pressed }) => [
            styles.subscribeBtn,
            { opacity: pressed ? 0.92 : 1, transform: [{ scale: pressed ? 0.98 : 1 }] },
          ]}
        >
          <Text style={styles.subscribeBtnText}>
            {freeTrialEnabled ? "Start My Free Trial" : "Subscribe Now"}
          </Text>
          {freeTrialEnabled && (
            <Text style={styles.subscribeBtnSub}>then $9.99/week · cancel anytime</Text>
          )}
        </Pressable>

        <Text style={styles.disclaimer}>
          Cancel anytime in your account settings.{"\n"}By subscribing, you agree to our Terms of
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
    height: 300,
    justifyContent: "flex-end",
  },
  heroOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: "rgba(30, 12, 2, 0.55)",
  },
  closeBtn: {
    position: "absolute",
    top: 52,
    right: 20,
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: "rgba(0,0,0,0.3)",
    alignItems: "center",
    justifyContent: "center",
    zIndex: 10,
  },
  heroContent: {
    paddingHorizontal: 28,
    paddingBottom: 28,
    zIndex: 2,
  },
  heroEyebrow: {
    fontSize: 11,
    fontFamily: "Inter_600SemiBold",
    color: "#C5963A",
    letterSpacing: 2.5,
    marginBottom: 8,
  },
  heroTitle: {
    fontSize: 32,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#F5ECD7",
    lineHeight: 40,
    marginBottom: 8,
  },
  heroSubtitle: {
    fontSize: 15,
    fontFamily: "Inter_400Regular",
    color: "rgba(245, 236, 215, 0.75)",
    lineHeight: 22,
  },
  featuresSection: {
    paddingHorizontal: 24,
    paddingTop: 28,
    paddingBottom: 4,
    gap: 16,
  },
  featuresSectionTitle: {
    fontSize: 13,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.textSecondary,
    textTransform: "uppercase",
    letterSpacing: 1.5,
    marginBottom: 4,
  },
  featureRow: {
    flexDirection: "row",
    alignItems: "center",
    gap: 14,
  },
  featureIcon: {
    width: 42,
    height: 42,
    borderRadius: 12,
    backgroundColor: Colors.light.accent + "14",
    alignItems: "center",
    justifyContent: "center",
  },
  featureTextArea: {
    flex: 1,
    gap: 2,
  },
  featureLabel: {
    fontSize: 15,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.text,
  },
  featureSub: {
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  trialSection: {
    paddingHorizontal: 24,
    paddingTop: 24,
    paddingBottom: 8,
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
    gap: 3,
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
    lineHeight: 18,
  },
  priceSection: {
    flexDirection: "row",
    alignItems: "baseline",
    justifyContent: "center",
    paddingTop: 20,
    paddingBottom: 4,
    gap: 4,
    flexWrap: "wrap",
  },
  priceAmount: {
    fontSize: 36,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
  },
  pricePeriod: {
    fontSize: 18,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  trialBadge: {
    flexDirection: "row",
    alignItems: "center",
    gap: 5,
    backgroundColor: "#5B7D3A14",
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: 8,
    marginLeft: 8,
  },
  trialBadgeText: {
    fontSize: 12,
    fontFamily: "Inter_600SemiBold",
    color: "#5B7D3A",
  },
  subscribeBtn: {
    marginHorizontal: 24,
    marginTop: 16,
    borderRadius: 16,
    backgroundColor: "#C5963A",
    paddingVertical: 18,
    alignItems: "center",
    gap: 3,
  },
  subscribeBtnText: {
    fontSize: 18,
    fontFamily: "Inter_700Bold",
    color: "#2C1810",
  },
  subscribeBtnSub: {
    fontSize: 12,
    fontFamily: "Inter_400Regular",
    color: "rgba(44, 24, 16, 0.6)",
  },
  disclaimer: {
    fontSize: 11,
    fontFamily: "Inter_400Regular",
    color: Colors.light.tabIconDefault,
    textAlign: "center",
    paddingHorizontal: 40,
    paddingTop: 14,
    lineHeight: 17,
  },
});
