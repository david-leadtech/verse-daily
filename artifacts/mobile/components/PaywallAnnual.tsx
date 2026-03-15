import React from "react";
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  Pressable,
  Platform,
  Alert,
  ImageBackground,
} from "react-native";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import * as Haptics from "expo-haptics";
import Colors from "@/constants/colors";
import { useSettings } from "@/contexts/SettingsContext";

interface PaywallAnnualProps {
  onClose: () => void;
}

export default function PaywallAnnual({ onClose }: PaywallAnnualProps) {
  const insets = useSafeAreaInsets();
  const isWeb = Platform.OS === "web";
  const { updateSettings } = useSettings();

  const weeklyPrice = 9.99;
  const annualPrice = 69.99;
  const weeklyCostPerYear = weeklyPrice * 52;
  const savingsPercent = Math.round(((weeklyCostPerYear - annualPrice) / weeklyCostPerYear) * 100);

  const handleSubscribe = () => {
    if (Platform.OS !== "web") {
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
    }
    updateSettings({ isPremium: true });
    Alert.alert(
      "Welcome to the family!",
      "Your annual plan is active. We pray this blesses every single day of your year ahead.",
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
            onPress={onClose}
            style={({ pressed }) => [styles.closeBtn, { top: (isWeb ? 67 : insets.top) + 12, opacity: pressed ? 0.7 : 1 }]}
          >
            <Feather name="x" size={22} color="rgba(245,236,215,0.7)" />
          </Pressable>

          <View style={styles.heroContent}>
            <Text style={styles.heroWait}>Before you go...</Text>
            <Text style={styles.heroTitle}>How about{"\n"}a better deal?</Text>
            <Text style={styles.heroSubtitle}>
              Save {savingsPercent}% with our annual plan — that's less than $6 a month.
            </Text>
          </View>
        </ImageBackground>

        <View style={styles.comparisonSection}>
          <View style={styles.comparisonCard}>
            <Text style={styles.comparisonLabel}>Weekly</Text>
            <Text style={styles.comparisonPriceStriked}>${weeklyCostPerYear.toFixed(0)}</Text>
            <Text style={styles.comparisonSub}>per year</Text>
          </View>

          <View style={styles.vsCircle}>
            <Feather name="arrow-right" size={14} color={Colors.light.accent} />
          </View>

          <View style={[styles.comparisonCard, styles.comparisonCardHighlight]}>
            <View style={styles.saveBadge}>
              <Text style={styles.saveBadgeText}>BEST VALUE</Text>
            </View>
            <Text style={styles.comparisonLabel}>Annual</Text>
            <Text style={styles.comparisonPriceHighlight}>${annualPrice}</Text>
            <Text style={styles.comparisonSub}>${(annualPrice / 12).toFixed(2)}/mo</Text>
          </View>
        </View>

        <View style={styles.quoteSection}>
          <Text style={styles.quoteText}>
            {"\u201C"}For where your treasure is,{"\n"}there your heart will be also.{"\u201D"}
          </Text>
          <Text style={styles.quoteRef}>— Matthew 6:21</Text>
        </View>

        <Pressable
          onPress={handleSubscribe}
          style={({ pressed }) => [
            styles.subscribeBtn,
            { opacity: pressed ? 0.92 : 1, transform: [{ scale: pressed ? 0.98 : 1 }] },
          ]}
        >
          <Text style={styles.subscribeBtnText}>Get Annual for ${annualPrice}</Text>
          <Text style={styles.subscribeBtnSub}>That's just ${(annualPrice / 12).toFixed(2)} a month</Text>
        </Pressable>

        <Pressable onPress={onClose} style={styles.noThanksBtn}>
          <Text style={styles.noThanksText}>No thanks, I'll keep it free</Text>
        </Pressable>

        <Text style={styles.disclaimer}>
          Cancel anytime. By subscribing, you agree to our Terms of Use and Privacy Policy.
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
    height: 280,
    justifyContent: "flex-end",
  },
  heroOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: "rgba(30, 12, 2, 0.55)",
  },
  closeBtn: {
    position: "absolute",
    top: 16,
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
  heroWait: {
    fontSize: 14,
    fontFamily: "Inter_600SemiBold",
    color: "#C5963A",
    marginBottom: 6,
  },
  heroTitle: {
    fontSize: 32,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#FFFFFF",
    lineHeight: 40,
    marginBottom: 8,
    textShadowColor: "rgba(0, 0, 0, 0.5)",
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 4,
  },
  heroSubtitle: {
    fontSize: 15,
    fontFamily: "Inter_400Regular",
    color: "rgba(255, 255, 255, 0.85)",
    lineHeight: 22,
    textShadowColor: "rgba(0, 0, 0, 0.4)",
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 3,
  },
  comparisonSection: {
    flexDirection: "row",
    paddingHorizontal: 20,
    paddingTop: 28,
    gap: 0,
    alignItems: "center",
  },
  comparisonCard: {
    flex: 1,
    backgroundColor: Colors.light.surface,
    borderRadius: 16,
    padding: 20,
    alignItems: "center",
    gap: 4,
    borderWidth: 1,
    borderColor: Colors.light.border,
  },
  comparisonCardHighlight: {
    borderColor: Colors.light.accent,
    borderWidth: 2,
    overflow: "visible",
  },
  saveBadge: {
    position: "absolute",
    top: -12,
    backgroundColor: Colors.light.accent,
    paddingHorizontal: 12,
    paddingVertical: 4,
    borderRadius: 10,
  },
  saveBadgeText: {
    fontSize: 10,
    fontFamily: "Inter_700Bold",
    color: "#FFF",
    letterSpacing: 1,
  },
  comparisonLabel: {
    fontSize: 13,
    fontFamily: "Inter_500Medium",
    color: Colors.light.textSecondary,
    marginTop: 4,
  },
  comparisonPriceStriked: {
    fontSize: 22,
    fontFamily: "Inter_700Bold",
    color: Colors.light.tabIconDefault,
    textDecorationLine: "line-through",
  },
  comparisonPriceHighlight: {
    fontSize: 30,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
  },
  comparisonSub: {
    fontSize: 12,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  vsCircle: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: Colors.light.surfaceSecondary,
    alignItems: "center",
    justifyContent: "center",
    marginHorizontal: -6,
    zIndex: 1,
  },
  quoteSection: {
    marginHorizontal: 24,
    marginTop: 28,
    padding: 24,
    backgroundColor: Colors.light.parchment,
    borderRadius: 16,
    borderLeftWidth: 3,
    borderLeftColor: Colors.light.accent,
    alignItems: "center",
  },
  quoteText: {
    fontSize: 18,
    fontFamily: "PlayfairDisplay_400Regular_Italic",
    color: Colors.light.text,
    textAlign: "center",
    lineHeight: 28,
  },
  quoteRef: {
    fontSize: 13,
    fontFamily: "Inter_500Medium",
    color: Colors.light.accent,
    marginTop: 10,
  },
  subscribeBtn: {
    marginHorizontal: 24,
    marginTop: 28,
    borderRadius: 16,
    backgroundColor: "#C5963A",
    paddingVertical: 18,
    alignItems: "center",
    gap: 3,
  },
  subscribeBtnText: {
    fontSize: 17,
    fontFamily: "Inter_700Bold",
    color: "#2C1810",
  },
  subscribeBtnSub: {
    fontSize: 12,
    fontFamily: "Inter_400Regular",
    color: "rgba(44, 24, 16, 0.6)",
  },
  noThanksBtn: {
    alignItems: "center",
    paddingVertical: 16,
  },
  noThanksText: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.tabIconDefault,
  },
  disclaimer: {
    fontSize: 11,
    fontFamily: "Inter_400Regular",
    color: Colors.light.tabIconDefault,
    textAlign: "center",
    paddingHorizontal: 40,
    lineHeight: 17,
  },
});
