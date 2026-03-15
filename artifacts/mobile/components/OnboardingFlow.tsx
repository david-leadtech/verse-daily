import React, { useState, useRef } from "react";
import {
  StyleSheet,
  Text,
  View,
  Dimensions,
  Pressable,
  Platform,
  FlatList,
  ImageBackground,
} from "react-native";
import { Feather } from "@expo/vector-icons";
import { LinearGradient } from "expo-linear-gradient";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import * as Haptics from "expo-haptics";

const { width, height } = Dimensions.get("window");

interface OnboardingFlowProps {
  onComplete: () => void;
}

const SLIDES = [
  {
    image: require("@/assets/images/onboarding-1.png"),
    eyebrow: "HIS WORD AWAITS",
    title: "Be still, and\nknow He is God",
    description:
      "Each morning, a verse chosen just for you — a quiet moment with the One who knows your heart before you speak.",
  },
  {
    image: require("@/assets/images/onboarding-2.png"),
    eyebrow: "DRAW NEAR",
    title: "Let His presence\nfill your day",
    description:
      "Devotionals that speak to what you're really going through — because God meets you right where you are, not where you think you should be.",
  },
  {
    image: require("@/assets/images/onboarding-3.png"),
    eyebrow: "REMEMBER HIS PROMISES",
    title: "Hold on to the\nverses that hold you",
    description:
      "Save the words that brought you strength, comfort, or tears. Build a collection of God's promises that you can return to whenever your soul needs them.",
  },
];

export default function OnboardingFlow({ onComplete }: OnboardingFlowProps) {
  const insets = useSafeAreaInsets();
  const isWeb = Platform.OS === "web";
  const [currentIndex, setCurrentIndex] = useState(0);
  const flatListRef = useRef<FlatList>(null);
  const topInset = isWeb ? 67 : insets.top;
  const bottomInset = isWeb ? 34 : insets.bottom;

  const handleNext = () => {
    if (Platform.OS !== "web") {
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    }
    if (currentIndex < SLIDES.length - 1) {
      const next = currentIndex + 1;
      setCurrentIndex(next);
      flatListRef.current?.scrollToIndex({ index: next, animated: true });
    } else {
      onComplete();
    }
  };

  const handleSkip = () => {
    onComplete();
  };

  return (
    <View style={styles.container}>
      <FlatList
        ref={flatListRef}
        data={SLIDES}
        horizontal
        pagingEnabled
        scrollEnabled={false}
        showsHorizontalScrollIndicator={false}
        keyExtractor={(_, i) => String(i)}
        renderItem={({ item }) => (
          <ImageBackground
            source={item.image}
            style={[styles.slide, { width }]}
            resizeMode="cover"
          >
            <LinearGradient
              colors={["rgba(10, 5, 2, 0.15)", "rgba(10, 5, 2, 0.5)", "rgba(10, 5, 2, 0.95)"]}
              locations={[0, 0.35, 0.7]}
              style={StyleSheet.absoluteFillObject}
            />
          </ImageBackground>
        )}
      />

      {currentIndex < SLIDES.length - 1 && (
        <Pressable
          onPress={handleSkip}
          style={[styles.skipBtn, { top: topInset + 12 }]}
        >
          <Text style={styles.skipText}>Skip</Text>
        </Pressable>
      )}

      <View
        style={[
          styles.bottomContent,
          { paddingBottom: bottomInset + 100 },
        ]}
        pointerEvents="none"
      >
        <Text style={styles.eyebrow}>{SLIDES[currentIndex].eyebrow}</Text>
        <Text style={styles.slideTitle}>{SLIDES[currentIndex].title}</Text>
        <Text style={styles.slideDescription}>{SLIDES[currentIndex].description}</Text>
      </View>

      <View style={[styles.footer, { paddingBottom: bottomInset + 16 }]}>
        <View style={styles.dots}>
          {SLIDES.map((_, i) => (
            <View
              key={i}
              style={[styles.dot, currentIndex === i && styles.dotActive]}
            />
          ))}
        </View>

        <Pressable
          onPress={handleNext}
          style={({ pressed }) => [
            styles.nextButton,
            { opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] },
          ]}
        >
          <Text style={styles.nextButtonText}>
            {currentIndex === SLIDES.length - 1 ? "Begin My Journey" : "Continue"}
          </Text>
          <Feather
            name={currentIndex === SLIDES.length - 1 ? "check" : "arrow-right"}
            size={20}
            color="#3C1A00"
          />
        </Pressable>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#0A0502",
  },
  slide: {
    flex: 1,
  },
  bottomContent: {
    position: "absolute",
    bottom: 0,
    left: 0,
    right: 0,
    paddingHorizontal: 28,
    gap: 10,
  },
  eyebrow: {
    fontSize: 11,
    fontFamily: "Inter_600SemiBold",
    color: "#E8C868",
    letterSpacing: 3,
    textShadowColor: "rgba(0, 0, 0, 0.5)",
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 3,
  },
  slideTitle: {
    fontSize: 34,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#FFFFFF",
    lineHeight: 42,
    textShadowColor: "rgba(0, 0, 0, 0.6)",
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 4,
  },
  slideDescription: {
    fontSize: 15,
    fontFamily: "Inter_400Regular",
    color: "rgba(255, 255, 255, 0.85)",
    lineHeight: 24,
    maxWidth: 330,
    textShadowColor: "rgba(0, 0, 0, 0.5)",
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 3,
  },
  skipBtn: {
    position: "absolute",
    right: 20,
    zIndex: 20,
    paddingHorizontal: 18,
    paddingVertical: 9,
    borderRadius: 20,
    backgroundColor: "rgba(0,0,0,0.45)",
  },
  skipText: {
    fontSize: 14,
    fontFamily: "Inter_600SemiBold",
    color: "rgba(255, 255, 255, 0.9)",
  },
  footer: {
    position: "absolute",
    bottom: 0,
    left: 0,
    right: 0,
    paddingHorizontal: 28,
    alignItems: "center",
    gap: 12,
  },
  dots: {
    flexDirection: "row",
    gap: 10,
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: "rgba(197, 150, 58, 0.3)",
  },
  dotActive: {
    backgroundColor: "#C5963A",
    width: 28,
  },
  nextButton: {
    width: "100%",
    borderRadius: 16,
    backgroundColor: "#C5963A",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    gap: 10,
    paddingVertical: 18,
  },
  nextButtonText: {
    fontSize: 18,
    fontFamily: "Inter_600SemiBold",
    color: "#3C1A00",
  },
});
