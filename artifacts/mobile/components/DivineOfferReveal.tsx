import React, { useEffect, useRef } from "react";
import {
  StyleSheet,
  Text,
  View,
  Animated,
  Dimensions,
  Platform,
  ImageBackground,
} from "react-native";
import { LinearGradient } from "expo-linear-gradient";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";

const { width, height } = Dimensions.get("window");

interface DivineOfferRevealProps {
  onContinue: () => void;
}

export default function DivineOfferReveal({ onContinue }: DivineOfferRevealProps) {
  const crossFade = useRef(new Animated.Value(0)).current;
  const crossScale = useRef(new Animated.Value(0.5)).current;
  const line1Fade = useRef(new Animated.Value(0)).current;
  const line1SlideY = useRef(new Animated.Value(25)).current;
  const line2Fade = useRef(new Animated.Value(0)).current;
  const line2SlideY = useRef(new Animated.Value(25)).current;
  const line3Fade = useRef(new Animated.Value(0)).current;
  const line3SlideY = useRef(new Animated.Value(25)).current;
  const glowPulse = useRef(new Animated.Value(0.3)).current;
  const screenFadeOut = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    Animated.sequence([
      Animated.delay(300),
      Animated.parallel([
        Animated.timing(crossFade, { toValue: 1, duration: 500, useNativeDriver: true }),
        Animated.timing(crossScale, { toValue: 1, duration: 500, useNativeDriver: true }),
      ]),
      Animated.delay(400),
      Animated.parallel([
        Animated.timing(line1Fade, { toValue: 1, duration: 450, useNativeDriver: true }),
        Animated.timing(line1SlideY, { toValue: 0, duration: 450, useNativeDriver: true }),
      ]),
      Animated.delay(300),
      Animated.parallel([
        Animated.timing(line2Fade, { toValue: 1, duration: 450, useNativeDriver: true }),
        Animated.timing(line2SlideY, { toValue: 0, duration: 450, useNativeDriver: true }),
      ]),
      Animated.delay(400),
      Animated.parallel([
        Animated.timing(line3Fade, { toValue: 1, duration: 500, useNativeDriver: true }),
        Animated.timing(line3SlideY, { toValue: 0, duration: 500, useNativeDriver: true }),
      ]),
      Animated.delay(1200),
      Animated.timing(screenFadeOut, { toValue: 0, duration: 500, useNativeDriver: true }),
    ]).start(() => {
      onContinue();
    });

    Animated.loop(
      Animated.sequence([
        Animated.timing(glowPulse, { toValue: 0.7, duration: 1500, useNativeDriver: true }),
        Animated.timing(glowPulse, { toValue: 0.3, duration: 1500, useNativeDriver: true }),
      ])
    ).start();
  }, []);

  return (
    <Animated.View style={[styles.container, { opacity: screenFadeOut }]}>
      <ImageBackground
        source={require("@/assets/images/paywall-hero.png")}
        style={StyleSheet.absoluteFillObject}
        resizeMode="cover"
      />
      <View style={styles.darkOverlay} />

      <Animated.View style={[styles.glowCircle, { opacity: glowPulse }]}>
        <LinearGradient
          colors={["rgba(197, 150, 58, 0.3)", "rgba(197, 150, 58, 0.05)", "transparent"]}
          style={styles.glowGradientInner}
          start={{ x: 0.5, y: 0 }}
          end={{ x: 0.5, y: 1 }}
        />
      </Animated.View>

      <View style={styles.content}>
          <Animated.View
          style={[
            styles.crossIcon,
            { opacity: crossFade, transform: [{ scale: crossScale }] },
          ]}
        >
          <Feather name="plus" size={44} color="#C5963A" />
        </Animated.View>

        <Animated.Text
          style={[
            styles.line1,
            { opacity: line1Fade, transform: [{ translateY: line1SlideY }] },
          ]}
        >
          Your faith has brought{"\n"}you here
        </Animated.Text>

        <Animated.Text
          style={[
            styles.line2,
            { opacity: line2Fade, transform: [{ translateY: line2SlideY }] },
          ]}
        >
          And God has prepared{"\n"}something special for you
        </Animated.Text>

        <Animated.Text
          style={[
            styles.line3,
            { opacity: line3Fade, transform: [{ translateY: line3SlideY }] },
          ]}
        >
          A gift to deepen your walk...
        </Animated.Text>
      </View>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  darkOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: "rgba(10, 5, 2, 0.82)",
  },
  glowCircle: {
    position: "absolute",
    top: height * 0.15,
    left: width * 0.1,
    right: width * 0.1,
    height: height * 0.25,
  },
  glowGradientInner: {
    flex: 1,
    borderRadius: width,
  },
  content: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    paddingHorizontal: 40,
    paddingBottom: 40,
  },
  crossIcon: {
    marginBottom: 40,
  },
  line1: {
    fontSize: 26,
    fontFamily: "PlayfairDisplay_400Regular_Italic",
    color: "rgba(255, 255, 255, 0.9)",
    textAlign: "center",
    lineHeight: 36,
    marginBottom: 24,
  },
  line2: {
    fontSize: 22,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#FFFFFF",
    textAlign: "center",
    lineHeight: 32,
    marginBottom: 24,
  },
  line3: {
    fontSize: 18,
    fontFamily: "Inter_500Medium",
    color: "#C5963A",
    textAlign: "center",
    letterSpacing: 0.5,
  },
});
