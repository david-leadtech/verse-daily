import React, { useState } from "react";
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
import { useRouter } from "expo-router";
import { LinearGradient } from "expo-linear-gradient";
import * as Haptics from "expo-haptics";
import Colors from "@/constants/colors";
import { useSettings } from "@/contexts/SettingsContext";

interface PlanOption {
  id: string;
  name: string;
  price: string;
  period: string;
  savings?: string;
  popular?: boolean;
}

const PLANS: PlanOption[] = [
  { id: "monthly", name: "Monthly", price: "$4.99", period: "/month" },
  { id: "yearly", name: "Annual", price: "$29.99", period: "/year", savings: "Save 50%", popular: true },
  { id: "lifetime", name: "Lifetime", price: "$79.99", period: "one-time" },
];

const FEATURES = [
  { icon: "book-open", text: "All devotionals & reflections" },
  { icon: "bell-off", text: "Ad-free experience" },
  { icon: "layers", text: "Multiple Bible versions" },
  { icon: "image", text: "Premium verse backgrounds" },
  { icon: "share-2", text: "Custom sharing templates" },
  { icon: "heart", text: "Unlimited favorites" },
];

export default function SubscriptionScreen() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const isWeb = Platform.OS === "web";
  const { settings, updateSettings } = useSettings();
  const [selectedPlan, setSelectedPlan] = useState("yearly");

  const handleSubscribe = () => {
    if (Platform.OS !== "web") {
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
    }
    updateSettings({ isPremium: true });
    Alert.alert(
      "Welcome to Premium!",
      "Thank you for supporting our mission. Enjoy all premium features.",
      [{ text: "Amen!", onPress: () => router.back() }]
    );
  };

  return (
    <View style={styles.container}>
      <ScrollView
        contentContainerStyle={{ paddingBottom: (isWeb ? 34 : insets.bottom) + 20 }}
        showsVerticalScrollIndicator={false}
      >
        <LinearGradient
          colors={["#7C3AED", "#4F46E5", "#2563EB"]}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 1 }}
          style={[styles.heroSection, { paddingTop: (isWeb ? 67 : insets.top) + 12 }]}
        >
          <Pressable
            onPress={() => router.back()}
            style={({ pressed }) => [styles.closeBtn, { opacity: pressed ? 0.7 : 1 }]}
          >
            <Feather name="x" size={24} color="#fff" />
          </Pressable>

          <View style={styles.heroIcon}>
            <Feather name="star" size={36} color="#F59E0B" />
          </View>

          <Text style={styles.heroTitle}>Unlock Premium</Text>
          <Text style={styles.heroSubtitle}>
            Deepen your daily walk with Christ through exclusive content and features
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

        <View style={styles.plansSection}>
          {PLANS.map((plan) => (
            <Pressable
              key={plan.id}
              onPress={() => {
                setSelectedPlan(plan.id);
                if (Platform.OS !== "web") {
                  Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
                }
              }}
              style={[
                styles.planCard,
                selectedPlan === plan.id && styles.planCardSelected,
                plan.popular && styles.planCardPopular,
              ]}
            >
              {plan.popular && (
                <View style={styles.popularBadge}>
                  <Text style={styles.popularBadgeText}>Most Popular</Text>
                </View>
              )}
              <View style={styles.planContent}>
                <View style={styles.planRadio}>
                  <View
                    style={[
                      styles.radioOuter,
                      selectedPlan === plan.id && styles.radioOuterSelected,
                    ]}
                  >
                    {selectedPlan === plan.id && <View style={styles.radioInner} />}
                  </View>
                </View>
                <View style={styles.planInfo}>
                  <Text style={styles.planName}>{plan.name}</Text>
                  <View style={styles.planPricing}>
                    <Text style={styles.planPrice}>{plan.price}</Text>
                    <Text style={styles.planPeriod}>{plan.period}</Text>
                  </View>
                </View>
                {plan.savings && (
                  <View style={styles.savingsBadge}>
                    <Text style={styles.savingsText}>{plan.savings}</Text>
                  </View>
                )}
              </View>
            </Pressable>
          ))}
        </View>

        <Pressable
          onPress={handleSubscribe}
          style={({ pressed }) => [
            styles.subscribeBtn,
            { opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.98 : 1 }] },
          ]}
        >
          <LinearGradient
            colors={["#7C3AED", "#4F46E5"]}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 0 }}
            style={styles.subscribeBtnGradient}
          >
            <Text style={styles.subscribeBtnText}>Start Free Trial</Text>
            <Text style={styles.subscribeBtnSub}>7 days free, then auto-renews</Text>
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
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: "rgba(255,255,255,0.2)",
    alignItems: "center",
    justifyContent: "center",
    marginBottom: 20,
  },
  heroIcon: {
    width: 72,
    height: 72,
    borderRadius: 36,
    backgroundColor: "rgba(255,255,255,0.15)",
    alignItems: "center",
    justifyContent: "center",
    marginBottom: 20,
  },
  heroTitle: {
    fontSize: 28,
    fontFamily: "Inter_700Bold",
    color: "#fff",
    marginBottom: 10,
  },
  heroSubtitle: {
    fontSize: 16,
    fontFamily: "Inter_400Regular",
    color: "rgba(255,255,255,0.8)",
    textAlign: "center",
    lineHeight: 24,
  },
  featuresSection: {
    paddingHorizontal: 24,
    paddingTop: 28,
    paddingBottom: 12,
    gap: 16,
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
    fontSize: 16,
    fontFamily: "Inter_500Medium",
    color: Colors.light.text,
  },
  plansSection: {
    paddingHorizontal: 24,
    paddingTop: 24,
    gap: 10,
  },
  planCard: {
    borderRadius: 16,
    borderWidth: 2,
    borderColor: Colors.light.border,
    backgroundColor: Colors.light.surface,
    overflow: "hidden",
  },
  planCardSelected: {
    borderColor: Colors.light.tint,
  },
  planCardPopular: {},
  popularBadge: {
    backgroundColor: Colors.light.tint,
    paddingVertical: 6,
    alignItems: "center",
  },
  popularBadgeText: {
    fontSize: 12,
    fontFamily: "Inter_700Bold",
    color: "#fff",
    textTransform: "uppercase",
    letterSpacing: 0.5,
  },
  planContent: {
    flexDirection: "row",
    alignItems: "center",
    padding: 18,
    gap: 14,
  },
  planRadio: {},
  radioOuter: {
    width: 22,
    height: 22,
    borderRadius: 11,
    borderWidth: 2,
    borderColor: Colors.light.border,
    alignItems: "center",
    justifyContent: "center",
  },
  radioOuterSelected: {
    borderColor: Colors.light.tint,
  },
  radioInner: {
    width: 12,
    height: 12,
    borderRadius: 6,
    backgroundColor: Colors.light.tint,
  },
  planInfo: {
    flex: 1,
    gap: 2,
  },
  planName: {
    fontSize: 16,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.text,
  },
  planPricing: {
    flexDirection: "row",
    alignItems: "baseline",
    gap: 4,
  },
  planPrice: {
    fontSize: 20,
    fontFamily: "Inter_700Bold",
    color: Colors.light.text,
  },
  planPeriod: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  savingsBadge: {
    backgroundColor: "#10B98115",
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 8,
  },
  savingsText: {
    fontSize: 12,
    fontFamily: "Inter_700Bold",
    color: "#10B981",
  },
  subscribeBtn: {
    marginHorizontal: 24,
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
    fontSize: 18,
    fontFamily: "Inter_700Bold",
    color: "#fff",
  },
  subscribeBtnSub: {
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: "rgba(255,255,255,0.7)",
  },
  disclaimer: {
    fontSize: 12,
    fontFamily: "Inter_400Regular",
    color: Colors.light.tabIconDefault,
    textAlign: "center",
    paddingHorizontal: 40,
    paddingTop: 16,
    lineHeight: 18,
  },
});
