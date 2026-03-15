import React, { useState, useRef, useEffect } from "react";
import {
  StyleSheet,
  Text,
  View,
  Dimensions,
  Pressable,
  Platform,
  Animated,
  Image,
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
    textAlign: "left" as const,
  },
  {
    image: require("@/assets/images/onboarding-2.png"),
    eyebrow: "DRAW NEAR",
    title: "Let His presence\nfill your day",
    description:
      "Devotionals that speak to what you're really going through — because God meets you right where you are, not where you think you should be.",
    textAlign: "center" as const,
  },
  {
    image: require("@/assets/images/onboarding-3.png"),
    eyebrow: "REMEMBER HIS PROMISES",
    title: "Hold on to the\nverses that hold you",
    description:
      "Save the words that brought you strength, comfort, or tears. Build a collection of God's promises that you can return to whenever your soul needs them.",
    textAlign: "left" as const,
  },
];

export default function OnboardingFlow({ onComplete }: OnboardingFlowProps) {
  const insets = useSafeAreaInsets();
  const isWeb = Platform.OS === "web";
  const [currentIndex, setCurrentIndex] = useState(0);
  const topInset = isWeb ? 67 : insets.top;
  const bottomInset = isWeb ? 34 : insets.bottom;

  const isAnimating = useRef(false);
  const imageOpacities = useRef(SLIDES.map((_, i) => new Animated.Value(i === 0 ? 1 : 0))).current;
  const textFade = useRef(new Animated.Value(1)).current;
  const textSlideY = useRef(new Animated.Value(0)).current;
  const eyebrowSlideX = useRef(new Animated.Value(0)).current;
  const dotScale = useRef(SLIDES.map(() => new Animated.Value(1))).current;

  useEffect(() => {
    Animated.parallel([
      Animated.spring(textFade, { toValue: 1, useNativeDriver: true, tension: 60, friction: 8 }),
      Animated.spring(textSlideY, { toValue: 0, useNativeDriver: true, tension: 50, friction: 8 }),
      Animated.spring(eyebrowSlideX, { toValue: 0, useNativeDriver: true, tension: 50, friction: 8 }),
    ]).start();
  }, []);

  const animateToSlide = (nextIndex: number) => {
    if (isAnimating.current) return;
    isAnimating.current = true;

    Animated.parallel([
      Animated.timing(textFade, { toValue: 0, duration: 200, useNativeDriver: true }),
      Animated.timing(textSlideY, { toValue: 30, duration: 200, useNativeDriver: true }),
      Animated.timing(eyebrowSlideX, { toValue: -20, duration: 200, useNativeDriver: true }),
    ]).start(() => {
      setCurrentIndex(nextIndex);

      textSlideY.setValue(40);
      eyebrowSlideX.setValue(30);

      Animated.parallel([
        ...imageOpacities.map((opacity, i) =>
          Animated.timing(opacity, {
            toValue: i === nextIndex ? 1 : 0,
            duration: 600,
            useNativeDriver: true,
          })
        ),
        Animated.sequence([
          Animated.delay(150),
          Animated.parallel([
            Animated.spring(textFade, { toValue: 1, useNativeDriver: true, tension: 50, friction: 8 }),
            Animated.spring(textSlideY, { toValue: 0, useNativeDriver: true, tension: 50, friction: 8 }),
            Animated.spring(eyebrowSlideX, { toValue: 0, useNativeDriver: true, tension: 50, friction: 8 }),
          ]),
        ]),
        ...dotScale.map((scale, i) =>
          Animated.sequence([
            Animated.timing(scale, { toValue: i === nextIndex ? 1.3 : 0.8, duration: 150, useNativeDriver: true }),
            Animated.spring(scale, { toValue: 1, useNativeDriver: true, tension: 100, friction: 6 }),
          ])
        ),
      ]).start(() => {
        isAnimating.current = false;
      });
    });
  };

  const handleNext = () => {
    if (Platform.OS !== "web") {
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    }
    if (currentIndex < SLIDES.length - 1) {
      animateToSlide(currentIndex + 1);
    } else {
      onComplete();
    }
  };

  const handleSkip = () => {
    onComplete();
  };

  const slide = SLIDES[currentIndex];
  const isCentered = slide.textAlign === "center";

  return (
    <View style={styles.container}>
      {SLIDES.map((s, i) => (
        <Animated.View
          key={i}
          style={[StyleSheet.absoluteFillObject, { opacity: imageOpacities[i] }]}
        >
          <Image source={s.image} style={styles.bgImage} resizeMode="cover" />
        </Animated.View>
      ))}

      <LinearGradient
        colors={["rgba(8, 4, 2, 0.2)", "rgba(8, 4, 2, 0.45)", "rgba(8, 4, 2, 0.97)"]}
        locations={[0, 0.4, 0.72]}
        style={StyleSheet.absoluteFillObject}
        pointerEvents="none"
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
          { paddingBottom: bottomInset + 110 },
          isCentered && styles.bottomContentCentered,
        ]}
        pointerEvents="none"
      >
        <Animated.Text
          style={[
            styles.eyebrow,
            isCentered && styles.eyebrowCentered,
            { opacity: textFade, transform: [{ translateX: eyebrowSlideX }] },
          ]}
        >
          {slide.eyebrow}
        </Animated.Text>
        <Animated.Text
          style={[
            styles.slideTitle,
            isCentered && styles.slideTitleCentered,
            { opacity: textFade, transform: [{ translateY: textSlideY }] },
          ]}
        >
          {slide.title}
        </Animated.Text>
        <Animated.Text
          style={[
            styles.slideDescription,
            isCentered && styles.slideDescriptionCentered,
            { opacity: textFade, transform: [{ translateY: textSlideY }] },
          ]}
        >
          {slide.description}
        </Animated.Text>
      </View>

      <View style={[styles.footer, { paddingBottom: bottomInset + 16 }]}>
        <View style={styles.dots}>
          {SLIDES.map((_, i) => (
            <Animated.View
              key={i}
              style={[
                styles.dot,
                currentIndex === i && styles.dotActive,
                { transform: [{ scale: dotScale[i] }] },
              ]}
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
  bgImage: {
    width,
    height: "100%",
  },
  bottomContent: {
    position: "absolute",
    bottom: 0,
    left: 0,
    right: 0,
    paddingHorizontal: 28,
    gap: 10,
  },
  bottomContentCentered: {
    alignItems: "center",
  },
  eyebrow: {
    fontSize: 11,
    fontFamily: "Inter_600SemiBold",
    color: "#E8C868",
    letterSpacing: 3,
    textShadowColor: "rgba(0, 0, 0, 0.6)",
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 4,
  },
  eyebrowCentered: {
    textAlign: "center",
  },
  slideTitle: {
    fontSize: 34,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#FFFFFF",
    lineHeight: 42,
    textShadowColor: "rgba(0, 0, 0, 0.7)",
    textShadowOffset: { width: 0, height: 2 },
    textShadowRadius: 6,
  },
  slideTitleCentered: {
    textAlign: "center",
  },
  slideDescription: {
    fontSize: 15,
    fontFamily: "Inter_400Regular",
    color: "rgba(255, 255, 255, 0.88)",
    lineHeight: 24,
    maxWidth: 330,
    textShadowColor: "rgba(0, 0, 0, 0.6)",
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 4,
  },
  slideDescriptionCentered: {
    textAlign: "center",
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
    backgroundColor: "rgba(255, 255, 255, 0.25)",
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
