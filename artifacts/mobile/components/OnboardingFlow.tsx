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
import { useSafeAreaInsets } from "react-native-safe-area-context";
import * as Haptics from "expo-haptics";

const { width } = Dimensions.get("window");

interface OnboardingFlowProps {
  onComplete: () => void;
}

const SLIDES = [
  {
    image: require("@/assets/images/onboarding-1.png"),
    eyebrow: "EVERY MORNING",
    title: "Start your day\nwith His Word",
    description:
      "A hand-picked verse delivered to you each morning — because the best days begin with scripture, not scrolling.",
  },
  {
    image: require("@/assets/images/onboarding-2.png"),
    eyebrow: "GO DEEPER",
    title: "Devotionals that\nspeak to your heart",
    description:
      "Short, honest reflections written for real life — for the days when you need peace, strength, or just a quiet moment with God.",
  },
  {
    image: require("@/assets/images/onboarding-3.png"),
    eyebrow: "YOUR JOURNEY",
    title: "Build your own\nscripture collection",
    description:
      "Save the verses that move you. Share them with the people you love. Come back to them whenever you need a reminder.",
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
          <ImageBackground
            source={item.image}
            style={[styles.slide, { width }]}
            resizeMode="cover"
          >
            <View style={styles.slideOverlay} />

            <View style={[styles.slideContent, { paddingBottom: (isWeb ? 34 : insets.bottom) + 220 }]}>
              <View style={styles.slideTextArea}>
                <Text style={styles.eyebrow}>{item.eyebrow}</Text>
                <Text style={styles.slideTitle}>{item.title}</Text>
                <Text style={styles.slideDescription}>{item.description}</Text>
              </View>
            </View>
          </ImageBackground>
        )}
      />

      {currentIndex < SLIDES.length - 1 && (
        <Pressable
          onPress={handleSkip}
          style={[styles.skipBtn, { top: (isWeb ? 67 : insets.top) + 12 }]}
        >
          <Text style={styles.skipText}>Skip</Text>
        </Pressable>
      )}

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
          <Text style={styles.nextButtonText}>
            {currentIndex === SLIDES.length - 1 ? "Get Started" : "Continue"}
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
    backgroundColor: "#1A0E05",
  },
  slide: {
    flex: 1,
  },
  slideOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: "rgba(20, 10, 2, 0.45)",
  },
  slideContent: {
    flex: 1,
    justifyContent: "flex-end",
    paddingHorizontal: 32,
  },
  slideTextArea: {
    gap: 12,
  },
  eyebrow: {
    fontSize: 12,
    fontFamily: "Inter_600SemiBold",
    color: "#C5963A",
    letterSpacing: 3,
  },
  slideTitle: {
    fontSize: 36,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#F5ECD7",
    lineHeight: 44,
  },
  slideDescription: {
    fontSize: 16,
    fontFamily: "Inter_400Regular",
    color: "rgba(245, 236, 215, 0.75)",
    lineHeight: 26,
    maxWidth: 340,
  },
  skipBtn: {
    position: "absolute",
    left: 24,
    zIndex: 20,
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    backgroundColor: "rgba(0,0,0,0.25)",
  },
  skipText: {
    fontSize: 15,
    fontFamily: "Inter_500Medium",
    color: "rgba(245, 236, 215, 0.75)",
  },
  footer: {
    position: "absolute",
    bottom: 0,
    left: 0,
    right: 0,
    paddingHorizontal: 32,
    alignItems: "center",
    gap: 14,
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
