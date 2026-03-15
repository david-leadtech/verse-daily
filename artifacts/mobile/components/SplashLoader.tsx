import React, { useEffect, useRef } from "react";
import { StyleSheet, Text, View, Animated, Dimensions, ImageBackground } from "react-native";

const { width, height } = Dimensions.get("window");

export default function SplashLoader() {
  const fadeAnim = useRef(new Animated.Value(0)).current;
  const scaleAnim = useRef(new Animated.Value(0.85)).current;
  const subtitleFade = useRef(new Animated.Value(0)).current;
  const dotOpacity = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    Animated.sequence([
      Animated.parallel([
        Animated.timing(fadeAnim, {
          toValue: 1,
          duration: 900,
          useNativeDriver: true,
        }),
        Animated.spring(scaleAnim, {
          toValue: 1,
          tension: 40,
          friction: 7,
          useNativeDriver: true,
        }),
      ]),
      Animated.timing(subtitleFade, {
        toValue: 1,
        duration: 600,
        useNativeDriver: true,
      }),
    ]).start();

    Animated.loop(
      Animated.sequence([
        Animated.timing(dotOpacity, {
          toValue: 0.3,
          duration: 900,
          useNativeDriver: true,
        }),
        Animated.timing(dotOpacity, {
          toValue: 1,
          duration: 900,
          useNativeDriver: true,
        }),
      ])
    ).start();
  }, []);

  return (
    <ImageBackground
      source={require("@/assets/images/splash-bg.png")}
      style={styles.container}
      resizeMode="cover"
    >
      <View style={styles.overlay} />

      <Animated.View
        style={[
          styles.content,
          { opacity: fadeAnim, transform: [{ scale: scaleAnim }] },
        ]}
      >
        <Text style={styles.crossIcon}>✝</Text>

        <Text style={styles.title}>Bible Verse</Text>
        <Text style={styles.titleAccent}>Daily</Text>

        <Animated.View style={[styles.loadingDots, { opacity: dotOpacity }]}>
          <View style={styles.dot} />
          <View style={styles.dot} />
          <View style={styles.dot} />
        </Animated.View>
      </Animated.View>

      <Animated.View style={[styles.bottomSection, { opacity: subtitleFade }]}>
        <Text style={styles.tagline}>
          Thy word is a lamp unto my feet,{"\n"}and a light unto my path.
        </Text>
        <Text style={styles.taglineRef}>Psalm 119:105</Text>
      </Animated.View>
    </ImageBackground>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  overlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: "rgba(30, 12, 2, 0.65)",
  },
  content: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    paddingBottom: 80,
  },
  crossIcon: {
    fontSize: 52,
    color: "#C5963A",
    marginBottom: 16,
  },
  title: {
    fontSize: 42,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#F5ECD7",
    letterSpacing: 1,
  },
  titleAccent: {
    fontSize: 30,
    fontFamily: "PlayfairDisplay_400Regular_Italic",
    color: "#C5963A",
    marginTop: -2,
  },
  loadingDots: {
    flexDirection: "row",
    gap: 10,
    marginTop: 36,
  },
  dot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: "#C5963A",
  },
  bottomSection: {
    position: "absolute",
    bottom: 60,
    left: 0,
    right: 0,
    alignItems: "center",
    paddingHorizontal: 40,
  },
  tagline: {
    fontSize: 15,
    fontFamily: "PlayfairDisplay_400Regular_Italic",
    color: "rgba(245, 236, 215, 0.8)",
    textAlign: "center",
    lineHeight: 24,
  },
  taglineRef: {
    fontSize: 12,
    fontFamily: "Inter_500Medium",
    color: "#C5963A",
    marginTop: 8,
    letterSpacing: 1,
  },
});
