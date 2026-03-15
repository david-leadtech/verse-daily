import React from "react";
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  Pressable,
  Platform,
  Alert,
} from "react-native";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { LinearGradient } from "expo-linear-gradient";
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
      "Welcome to Premium!",
      "Your annual subscription is now active. God bless your journey!",
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
          colors={["#1E3A5F", "#2D5070", "#3C6A8A"]}
          start={{ x: 0, y: 0 }}
          end={{ x: 0.5, y: 1 }}
          style={[styles.heroSection, { paddingTop: (isWeb ? 67 : insets.top) + 12 }]}
        >
          <Pressable
            onPress={onClose}
            style={({ pressed }) => [styles.closeBtn, { opacity: pressed ? 0.7 : 1 }]}
          >
            <Feather name="x" size={22} color="rgba(245,236,215,0.6)" />
          </Pressable>

          <Text style={styles.waitText}>Wait!</Text>
          <Text style={styles.heroTitle}>Special Offer</Text>
          <Text style={styles.heroSubtitle}>
            Save {savingsPercent}% with our annual plan
          </Text>
        </LinearGradient>

        <View style={styles.comparisonSection}>
          <View style={styles.comparisonCard}>
            <Text style={styles.comparisonLabel}>Weekly Plan</Text>
            <Text style={styles.comparisonPrice}>${weeklyCostPerYear.toFixed(0)}/yr</Text>
            <Text style={styles.comparisonSub}>${weeklyPrice}/week × 52 weeks</Text>
          </View>

          <View style={styles.vsCircle}>
            <Text style={styles.vsText}>VS</Text>
          </View>

          <View style={[styles.comparisonCard, styles.comparisonCardHighlight]}>
            <View style={styles.saveBadge}>
              <Text style={styles.saveBadgeText}>SAVE {savingsPercent}%</Text>
            </View>
            <Text style={styles.comparisonLabel}>Annual Plan</Text>
            <Text style={styles.comparisonPriceHighlight}>${annualPrice}</Text>
            <Text style={styles.comparisonSub}>Just ${(annualPrice / 12).toFixed(2)}/month</Text>
          </View>
        </View>

        <View style={styles.testimonySection}>
          <Text style={styles.testimonyQuote}>
            {"\u201C"}For where your treasure is, there your heart will be also.{"\u201D"}
          </Text>
          <Text style={styles.testimonyRef}>Matthew 6:21</Text>
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
            <Text style={styles.subscribeBtnText}>Get Annual Plan — ${annualPrice}</Text>
            <Text style={styles.subscribeBtnSub}>Best value for your faith journey</Text>
          </LinearGradient>
        </Pressable>

        <Pressable onPress={onClose} style={styles.noThanksBtn}>
          <Text style={styles.noThanksText}>No thanks, continue without premium</Text>
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
    alignItems: "center",
    paddingHorizontal: 32,
    paddingBottom: 36,
  },
  closeBtn: {
    alignSelf: "flex-end",
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: "rgba(245,236,215,0.1)",
    alignItems: "center",
    justifyContent: "center",
    marginBottom: 12,
  },
  waitText: {
    fontSize: 16,
    fontFamily: "Inter_600SemiBold",
    color: "#C5963A",
    textTransform: "uppercase",
    letterSpacing: 3,
    marginBottom: 8,
  },
  heroTitle: {
    fontSize: 32,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#F5ECD7",
    marginBottom: 8,
  },
  heroSubtitle: {
    fontSize: 16,
    fontFamily: "Inter_400Regular",
    color: "rgba(245, 236, 215, 0.7)",
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
    gap: 6,
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
    fontSize: 11,
    fontFamily: "Inter_700Bold",
    color: "#FFF",
    letterSpacing: 0.5,
  },
  comparisonLabel: {
    fontSize: 13,
    fontFamily: "Inter_500Medium",
    color: Colors.light.textSecondary,
  },
  comparisonPrice: {
    fontSize: 22,
    fontFamily: "Inter_700Bold",
    color: Colors.light.textSecondary,
    textDecorationLine: "line-through",
  },
  comparisonPriceHighlight: {
    fontSize: 28,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
  },
  comparisonSub: {
    fontSize: 12,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  vsCircle: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: Colors.light.surfaceSecondary,
    alignItems: "center",
    justifyContent: "center",
    marginHorizontal: -8,
    zIndex: 1,
  },
  vsText: {
    fontSize: 11,
    fontFamily: "Inter_700Bold",
    color: Colors.light.textSecondary,
  },
  testimonySection: {
    marginHorizontal: 28,
    marginTop: 28,
    padding: 24,
    backgroundColor: Colors.light.parchment,
    borderRadius: 16,
    borderLeftWidth: 3,
    borderLeftColor: Colors.light.accent,
    alignItems: "center",
  },
  testimonyQuote: {
    fontSize: 17,
    fontFamily: "PlayfairDisplay_400Regular_Italic",
    color: Colors.light.text,
    textAlign: "center",
    lineHeight: 28,
  },
  testimonyRef: {
    fontSize: 13,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.accent,
    marginTop: 10,
  },
  subscribeBtn: {
    marginHorizontal: 28,
    marginTop: 28,
    borderRadius: 16,
    overflow: "hidden",
  },
  subscribeBtnGradient: {
    paddingVertical: 18,
    alignItems: "center",
    gap: 4,
  },
  subscribeBtnText: {
    fontSize: 17,
    fontFamily: "Inter_700Bold",
    color: "#FFF",
  },
  subscribeBtnSub: {
    fontSize: 12,
    fontFamily: "Inter_400Regular",
    color: "rgba(255,255,255,0.7)",
  },
  noThanksBtn: {
    alignItems: "center",
    paddingVertical: 16,
  },
  noThanksText: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.tabIconDefault,
    textDecorationLine: "underline",
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
