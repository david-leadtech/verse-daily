import React from "react";
import { StyleSheet, View, Pressable } from "react-native";
import { LinearGradient } from "expo-linear-gradient";

const GRADIENT_PRESETS: [string, string, string][] = [
  ["#7C3AED", "#4F46E5", "#2563EB"],
  ["#EC4899", "#8B5CF6", "#6366F1"],
  ["#F59E0B", "#EF4444", "#EC4899"],
  ["#10B981", "#3B82F6", "#6366F1"],
  ["#1E3A5F", "#2D5F8B", "#4A90D9"],
  ["#8B5A2B", "#D4A017", "#F5DEB3"],
  ["#4A1A6B", "#7C3AED", "#A78BFA"],
  ["#0F4C75", "#3282B8", "#BBE1FA"],
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
