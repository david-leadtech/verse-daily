import React, { useState } from "react";
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
  { id: "weekly", name: "Weekly", price: "$9.99", period: "/week" },
  { id: "yearly", name: "Annual", price: "$69.99", period: "/year", savings: "Save 87%", popular: true },
];

const FEATURES = [
  { icon: "book-open", text: "All devotionals & reflections" },
  { icon: "bell-off", text: "Ad-free experience" },
  { icon: "layers", text: "Multiple Bible translations" },
  { icon: "image", text: "Premium verse wallpapers" },
  { icon: "share-2", text: "Beautiful sharing templates" },
  { icon: "heart", text: "Unlimited saved verses" },
];

export default function SubscriptionScreen() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const isWeb = Platform.OS === "web";
  const { updateSettings } = useSettings();
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
        <ImageBackground
          source={require("@/assets/images/paywall-hero.png")}
          style={[styles.heroSection, { paddingTop: (isWeb ? 67 : insets.top) + 12 }]}
          resizeMode="cover"
        >
          <View style={styles.heroOverlay} />
          <Pressable
            onPress={() => router.back()}
            style={({ pressed }) => [styles.closeBtn, { opacity: pressed ? 0.7 : 1 }]}
          >
            <Feather name="x" size={24} color="#F5ECD7" />
          </Pressable>

          <View style={styles.heroTextContent}>
            <Text style={styles.heroTitle}>Unlock Premium</Text>
            <Text style={styles.heroSubtitle}>
              Everything you need for a richer, more personal walk with Christ — every single day.
            </Text>
          </View>
        </ImageBackground>

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
              ]}
            >
              {plan.popular && (
                <View style={styles.popularBadge}>
                  <Text style={styles.popularBadgeText}>Best Value</Text>
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
            colors={["#C5963A", "#8B6914"]}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 0 }}
            style={styles.subscribeBtnGradient}
          >
            <Text style={styles.subscribeBtnText}>Subscribe Now</Text>
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
    height: 260,
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
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: "rgba(0,0,0,0.3)",
    alignItems: "center",
    justifyContent: "center",
    zIndex: 10,
  },
  heroTextContent: {
    paddingHorizontal: 28,
    paddingBottom: 28,
    zIndex: 2,
  },
  heroTitle: {
    fontSize: 28,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#F5ECD7",
    marginBottom: 8,
  },
  heroSubtitle: {
    fontSize: 15,
    fontFamily: "Inter_400Regular",
    color: "rgba(245,236,215,0.75)",
    lineHeight: 22,
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
    fontSize: 15,
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
    borderColor: Colors.light.accent,
  },
  popularBadge: {
    backgroundColor: Colors.light.accent,
    paddingVertical: 6,
    alignItems: "center",
  },
  popularBadgeText: {
    fontSize: 12,
    fontFamily: "Inter_700Bold",
    color: "#FFF",
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
    borderColor: Colors.light.accent,
  },
  radioInner: {
    width: 12,
    height: 12,
    borderRadius: 6,
    backgroundColor: Colors.light.accent,
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
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
  },
  planPeriod: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  savingsBadge: {
    backgroundColor: Colors.light.olive + "20",
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 8,
  },
  savingsText: {
    fontSize: 12,
    fontFamily: "Inter_700Bold",
    color: Colors.light.olive,
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
    color: "#FFF",
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
