import React from "react";
import { StyleSheet, View, Pressable } from "react-native";
import { LinearGradient } from "expo-linear-gradient";

const GRADIENT_PRESETS: [string, string, string][] = [
  ["#8B4513", "#6B3410", "#4A2508"],
  ["#6B3410", "#8B2252", "#4A1A3D"],
  ["#C5963A", "#8B4513", "#5C2D0E"],
  ["#5B7D3A", "#3C5A20", "#2C4010"],
  ["#1E3A5F", "#2D5070", "#3C6A8A"],
  ["#8B6914", "#C5963A", "#E8D5A3"],
  ["#4A2508", "#6B3410", "#8B4513"],
  ["#3C1A00", "#5C2D0E", "#8B4513"],
];

interface GradientCardProps {
  children: React.ReactNode;
  gradientIndex?: number;
  onPress?: () => void;
  style?: object;
  borderRadius?: number;
}

export default function GradientCard({
  children,
  gradientIndex = 0,
  onPress,
  style,
  borderRadius = 20,
}: GradientCardProps) {
  const colors = GRADIENT_PRESETS[gradientIndex % GRADIENT_PRESETS.length]!;

  const content = (
    <LinearGradient
      colors={colors}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
      style={[styles.gradient, { borderRadius }, style]}
    >
      {children}
    </LinearGradient>
  );

  if (onPress) {
    return (
      <Pressable
        onPress={onPress}
        style={({ pressed }) => [{ opacity: pressed ? 0.95 : 1, transform: [{ scale: pressed ? 0.98 : 1 }] }]}
      >
        {content}
      </Pressable>
    );
  }

  return content;
}

export { GRADIENT_PRESETS };

const styles = StyleSheet.create({
  gradient: {
    overflow: "hidden",
  },
});
