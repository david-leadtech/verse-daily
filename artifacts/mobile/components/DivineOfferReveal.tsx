import React, { useEffect, useRef } from "react";
import {
  StyleSheet,
  Text,
  View,
  Animated,
  Dimensions,
  Pressable,
  Platform,
  ImageBackground,
} from "react-native";
import { LinearGradient } from "expo-linear-gradient";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import * as Haptics from "expo-haptics";

const { width, height } = Dimensions.get("window");

interface DivineOfferRevealProps {
  onContinue: () => void;
}

export default function DivineOfferReveal({ onContinue }: DivineOfferRevealProps) {
  const insets = useSafeAreaInsets();
  const isWeb = Platform.OS === "web";
  const bottomInset = isWeb ? 34 : insets.bottom;

  const glowOpacity = useRef(new Animated.Value(0)).current;
  const cardTranslateY = useRef(new Animated.Value(-120)).current;
  const cardOpacity = useRef(new Animated.Value(0)).current;
  const crossOpacity = useRef(new Animated.Value(0)).current;
  const crossScale = useRef(new Animated.Value(0.5)).current;
  const bottomFade = useRef(new Animated.Value(0)).current;
  const shimmerAnim = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.stagger(100, [
      Animated.parallel([
        Animated.timing(glowOpacity, { toValue: 1, duration: 400, useNativeDriver: true }),
        Animated.timing(crossOpacity, { toValue: 1, duration: 350, useNativeDriver: true }),
        Animated.timing(crossScale, { toValue: 1, duration: 350, useNativeDriver: true }),
      ]),
      Animated.parallel([
        Animated.timing(cardTranslateY, { toValue: 0, duration: 450, useNativeDriver: true }),
        Animated.timing(cardOpacity, { toValue: 1, duration: 400, useNativeDriver: true }),
      ]),
      Animated.timing(bottomFade, { toValue: 1, duration: 300, useNativeDriver: true }),
    ]).start();

    Animated.loop(
      Animated.sequence([
        Animated.timing(shimmerAnim, { toValue: 1, duration: 2000, useNativeDriver: true }),
        Animated.timing(shimmerAnim, { toValue: 0, duration: 2000, useNativeDriver: true }),
      ])
    ).start();
  }, []);

  const handleContinue = () => {
    if (Platform.OS !== "web") {
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    }
    onContinue();
  };

  const shimmerOpacity = shimmerAnim.interpolate({
    inputRange: [0, 0.5, 1],
    outputRange: [0.3, 0.8, 0.3],
  });

  return (
    <ImageBackground
      source={require("@/assets/images/paywall-hero.png")}
      style={styles.container}
      resizeMode="cover"
    >
      <View style={styles.darkOverlay} />

      <Animated.View style={[styles.glowCircle, { opacity: glowOpacity }]}>
        <LinearGradient
          colors={["rgba(197, 150, 58, 0.4)", "rgba(197, 150, 58, 0.1)", "transparent"]}
          style={styles.glowGradientInner}
          start={{ x: 0.5, y: 0 }}
          end={{ x: 0.5, y: 1 }}
        />
      </Animated.View>

      <Animated.Text
        style={[
          styles.crossIcon,
          { opacity: crossOpacity, transform: [{ scale: crossScale }] },
        ]}
      >
        ✝
      </Animated.Text>

      <Animated.View
        style={[
          styles.offerCard,
          {
            opacity: cardOpacity,
            transform: [{ translateY: cardTranslateY }],
          },
        ]}
      >
        <LinearGradient
          colors={["#FFFCF5", "#F5ECD7", "#EDE0C8"]}
          style={styles.cardGradient}
        >
          <Animated.View style={[styles.shimmerBar, { opacity: shimmerOpacity }]} />

          <Text style={styles.giftEyebrow}>A GIFT FROM ABOVE</Text>
          <Text style={styles.giftTitle}>3 Days Free</Text>
          <Text style={styles.giftSubtitle}>
            Experience the full scripture journey{"\n"}before you commit — no charge.
          </Text>

          <View style={styles.divider} />

          <View style={styles.benefitRow}>
            <Feather name="book-open" size={18} color="#8B4513" />
            <Text style={styles.benefitText}>Unlimited Devotionals</Text>
          </View>
          <View style={styles.benefitRow}>
            <Feather name="globe" size={18} color="#8B4513" />
            <Text style={styles.benefitText}>All Bible Translations</Text>
          </View>
          <View style={styles.benefitRow}>
            <Feather name="image" size={18} color="#8B4513" />
            <Text style={styles.benefitText}>Verse Wallpapers</Text>
          </View>
          <View style={styles.benefitRow}>
            <Feather name="zap" size={18} color="#8B4513" />
            <Text style={styles.benefitText}>No Ads, Ever</Text>
          </View>

          <View style={styles.priceBadge}>
            <Text style={styles.priceStrikethrough}>$9.99/week</Text>
            <Text style={styles.priceFree}>FREE for 3 days</Text>
          </View>
        </LinearGradient>
      </Animated.View>

      <Animated.View
        style={[
          styles.bottomSection,
          { paddingBottom: bottomInset + 16, opacity: bottomFade },
        ]}
      >
        <Pressable
          onPress={handleContinue}
          style={({ pressed }) => [
            styles.continueBtn,
            { opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] },
          ]}
        >
          <Text style={styles.continueBtnText}>Claim Your Free Trial</Text>
          <Feather name="arrow-right" size={20} color="#3C1A00" />
        </Pressable>

        <Pressable onPress={handleContinue}>
          <Text style={styles.skipText}>Maybe later</Text>
        </Pressable>
      </Animated.View>
    </ImageBackground>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  darkOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: "rgba(10, 5, 2, 0.78)",
  },
  glowCircle: {
    position: "absolute",
    top: -20,
    left: width * 0.05,
    right: width * 0.05,
    height: height * 0.3,
  },
  glowGradientInner: {
    flex: 1,
    borderRadius: width,
  },
  crossIcon: {
    position: "absolute",
    top: height * 0.1,
    alignSelf: "center",
    fontSize: 48,
    color: "#C5963A",
  },
  offerCard: {
    position: "absolute",
    top: height * 0.19,
    left: 24,
    right: 24,
    borderRadius: 24,
    overflow: "hidden",
    elevation: 12,
  },
  cardGradient: {
    padding: 26,
    alignItems: "center",
  },
  shimmerBar: {
    position: "absolute",
    top: 0,
    left: 0,
    right: 0,
    height: 3,
    backgroundColor: "#C5963A",
  },
  giftEyebrow: {
    fontSize: 11,
    fontFamily: "Inter_600SemiBold",
    color: "#8B4513",
    letterSpacing: 3,
    marginBottom: 6,
  },
  giftTitle: {
    fontSize: 34,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#2C1810",
    marginBottom: 6,
  },
  giftSubtitle: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: "#7A6B5D",
    textAlign: "center",
    lineHeight: 21,
    marginBottom: 14,
  },
  divider: {
    width: 50,
    height: 1,
    backgroundColor: "#D4C4A8",
    marginBottom: 14,
  },
  benefitRow: {
    flexDirection: "row",
    alignItems: "center",
    gap: 12,
    marginBottom: 10,
    width: "100%",
    paddingHorizontal: 8,
  },
  benefitText: {
    fontSize: 15,
    fontFamily: "Inter_500Medium",
    color: "#3C1A00",
  },
  priceBadge: {
    marginTop: 6,
    backgroundColor: "rgba(197, 150, 58, 0.12)",
    borderRadius: 12,
    paddingHorizontal: 20,
    paddingVertical: 10,
    alignItems: "center",
    gap: 2,
    width: "100%",
  },
  priceStrikethrough: {
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: "#A89888",
    textDecorationLine: "line-through",
  },
  priceFree: {
    fontSize: 17,
    fontFamily: "Inter_700Bold",
    color: "#5B7D3A",
  },
  bottomSection: {
    position: "absolute",
    bottom: 0,
    left: 0,
    right: 0,
    paddingHorizontal: 28,
    alignItems: "center",
    gap: 14,
  },
  continueBtn: {
    width: "100%",
    borderRadius: 16,
    backgroundColor: "#C5963A",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    gap: 10,
    paddingVertical: 18,
  },
  continueBtnText: {
    fontSize: 18,
    fontFamily: "Inter_600SemiBold",
    color: "#3C1A00",
  },
  skipText: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: "rgba(255, 255, 255, 0.5)",
  },
});
