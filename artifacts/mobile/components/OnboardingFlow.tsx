import React, { useState, useRef } from "react";
import {
  StyleSheet,
  Text,
  View,
  Dimensions,
  Pressable,
  Platform,
  FlatList,
} from "react-native";
import { LinearGradient } from "expo-linear-gradient";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import * as Haptics from "expo-haptics";

const { width, height } = Dimensions.get("window");

interface OnboardingFlowProps {
  onComplete: () => void;
}

const SLIDES = [
  {
    icon: "✝",
    title: "Daily Scripture",
    subtitle: "Begin each day\nwith God\u2019s Word",
    description:
      "Receive a carefully selected Bible verse every morning to guide, inspire, and strengthen your faith throughout the day.",
    gradient: ["#3C1A00", "#5C2D0E", "#8B4513"] as [string, string, string],
  },
  {
    icon: "📖",
    title: "Devotional Readings",
    subtitle: "Deepen your\nunderstanding",
    description:
      "Explore daily devotionals with rich reflections, spiritual insights, and practical applications to grow closer to Christ.",
    gradient: ["#1E3A5F", "#2D5070", "#3C6A8A"] as [string, string, string],
  },
  {
    icon: "🕊",
    title: "Save & Share",
    subtitle: "Treasure His\npromises",
    description:
      "Save your favorite verses, share scripture with loved ones, and build a personal collection of God\u2019s promises.",
    gradient: ["#5B3A20", "#8B4513", "#C5963A"] as [string, string, string],
  },
];

export default function OnboardingFlow({ onComplete }: OnboardingFlowProps) {
  const insets = useSafeAreaInsets();
  const isWeb = Platform.OS === "web";
  const [currentIndex, setCurrentIndex] = useState(0);
  const flatListRef = useRef<FlatList>(null);

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
          <LinearGradient
            colors={item.gradient}
            start={{ x: 0, y: 0 }}
            end={{ x: 0.5, y: 1 }}
            style={[styles.slide, { width }]}
          >
            <View style={[styles.slideContent, { paddingTop: (isWeb ? 67 : insets.top) + 40 }]}>
              <View style={styles.iconContainer}>
                <Text style={styles.slideIcon}>{item.icon}</Text>
              </View>

              <Text style={styles.slideTitle}>{item.title}</Text>
              <Text style={styles.slideSubtitle}>{item.subtitle}</Text>
              <Text style={styles.slideDescription}>{item.description}</Text>
            </View>
          </LinearGradient>
        )}
      />

      <View style={[styles.footer, { paddingBottom: (isWeb ? 34 : insets.bottom) + 20 }]}>
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
          <LinearGradient
            colors={["#C5963A", "#8B6914"]}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 0 }}
            style={styles.nextButtonGradient}
          >
            <Text style={styles.nextButtonText}>
              {currentIndex === SLIDES.length - 1 ? "Get Started" : "Continue"}
            </Text>
            <Feather
              name={currentIndex === SLIDES.length - 1 ? "check" : "arrow-right"}
              size={20}
              color="#FFF"
            />
          </LinearGradient>
        </Pressable>

        {currentIndex < SLIDES.length - 1 && (
          <Pressable onPress={handleSkip} style={styles.skipButton}>
            <Text style={styles.skipText}>Skip</Text>
          </Pressable>
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#3C1A00",
  },
  slide: {
    flex: 1,
  },
  slideContent: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    paddingHorizontal: 40,
    paddingBottom: 200,
  },
  iconContainer: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: "rgba(197, 150, 58, 0.15)",
    alignItems: "center",
    justifyContent: "center",
    marginBottom: 32,
    borderWidth: 1,
    borderColor: "rgba(197, 150, 58, 0.25)",
  },
  slideIcon: {
    fontSize: 48,
  },
  slideTitle: {
    fontSize: 16,
    fontFamily: "Inter_600SemiBold",
    color: "#C5963A",
    textTransform: "uppercase",
    letterSpacing: 3,
    marginBottom: 12,
  },
  slideSubtitle: {
    fontSize: 34,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#F5ECD7",
    textAlign: "center",
    lineHeight: 42,
    marginBottom: 20,
  },
  slideDescription: {
    fontSize: 16,
    fontFamily: "Inter_400Regular",
    color: "rgba(245, 236, 215, 0.7)",
    textAlign: "center",
    lineHeight: 26,
    maxWidth: 320,
  },
  footer: {
    position: "absolute",
    bottom: 0,
    left: 0,
    right: 0,
    paddingHorizontal: 32,
    alignItems: "center",
    gap: 16,
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
    overflow: "hidden",
  },
  nextButtonGradient: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    gap: 10,
    paddingVertical: 18,
  },
  nextButtonText: {
    fontSize: 18,
    fontFamily: "Inter_600SemiBold",
    color: "#FFF",
  },
  skipButton: {
    paddingVertical: 8,
  },
  skipText: {
    fontSize: 15,
    fontFamily: "Inter_500Medium",
    color: "rgba(245, 236, 215, 0.5)",
  },
});
