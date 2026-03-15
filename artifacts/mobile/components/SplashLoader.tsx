import React, { useEffect, useRef } from "react";
import { StyleSheet, Text, View, Animated, Dimensions } from "react-native";
import { LinearGradient } from "expo-linear-gradient";

const { width, height } = Dimensions.get("window");

export default function SplashLoader() {
  const fadeAnim = useRef(new Animated.Value(0)).current;
  const scaleAnim = useRef(new Animated.Value(0.8)).current;
  const pulseAnim = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.timing(fadeAnim, {
        toValue: 1,
        duration: 800,
        useNativeDriver: true,
      }),
      Animated.spring(scaleAnim, {
        toValue: 1,
        tension: 50,
        friction: 7,
        useNativeDriver: true,
      }),
    ]).start();

    Animated.loop(
      Animated.sequence([
        Animated.timing(pulseAnim, {
          toValue: 0.4,
          duration: 1200,
          useNativeDriver: true,
        }),
        Animated.timing(pulseAnim, {
          toValue: 1,
          duration: 1200,
          useNativeDriver: true,
        }),
      ])
    ).start();
  }, []);

  return (
    <LinearGradient
      colors={["#3C1A00", "#5C2D0E", "#8B4513"]}
      start={{ x: 0, y: 0 }}
      end={{ x: 0.5, y: 1 }}
      style={styles.container}
    >
      <Animated.View
        style={[
          styles.content,
          { opacity: fadeAnim, transform: [{ scale: scaleAnim }] },
        ]}
      >
        <View style={styles.crossContainer}>
          <Text style={styles.crossIcon}>✝</Text>
        </View>

        <Text style={styles.title}>Bible Verse</Text>
        <Text style={styles.titleAccent}>Daily</Text>

        <Animated.View style={[styles.loadingDots, { opacity: pulseAnim }]}>
          <View style={styles.dot} />
          <View style={styles.dot} />
          <View style={styles.dot} />
        </Animated.View>

        <Text style={styles.tagline}>
          His word is a lamp unto your feet
        </Text>
      </Animated.View>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
  },
  content: {
    alignItems: "center",
    gap: 8,
  },
  crossContainer: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: "rgba(197, 150, 58, 0.2)",
    alignItems: "center",
    justifyContent: "center",
    marginBottom: 20,
    borderWidth: 1,
    borderColor: "rgba(197, 150, 58, 0.3)",
  },
  crossIcon: {
    fontSize: 40,
    color: "#C5963A",
  },
  title: {
    fontSize: 36,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#F5ECD7",
    letterSpacing: 1,
  },
  titleAccent: {
    fontSize: 28,
    fontFamily: "PlayfairDisplay_400Regular_Italic",
    color: "#C5963A",
    marginTop: -4,
  },
  loadingDots: {
    flexDirection: "row",
    gap: 8,
    marginTop: 32,
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: "#C5963A",
  },
  tagline: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: "rgba(245, 236, 215, 0.6)",
    marginTop: 12,
    fontStyle: "italic",
  },
});
