import React from "react";
import { StyleSheet, Text, View, Pressable } from "react-native";
import { Feather } from "@expo/vector-icons";
import Colors from "@/constants/colors";

interface DevotionalCardProps {
  id: number;
  title: string;
  category: string;
  readTime: number;
  verseReference: string;
  onPress: () => void;
}

const CATEGORY_ICONS: Record<string, string> = {
  Peace: "sun",
  Strength: "shield",
  Faith: "compass",
  Gratitude: "gift",
  Love: "heart",
  Trust: "anchor",
  Growth: "trending-up",
  Rest: "moon",
  Courage: "zap",
};

const CATEGORY_COLORS: Record<string, string> = {
  Peace: "#3B82F6",
  Strength: "#EF4444",
  Faith: "#8B5CF6",
  Gratitude: "#F59E0B",
  Love: "#EC4899",
  Trust: "#10B981",
  Growth: "#14B8A6",
  Rest: "#6366F1",
  Courage: "#F97316",
};

export default function DevotionalCard({
  title,
  category,
  readTime,
  verseReference,
  onPress,
}: DevotionalCardProps) {
  const iconName = CATEGORY_ICONS[category] || "book-open";
  const categoryColor = CATEGORY_COLORS[category] || Colors.light.tint;

  return (
    <Pressable
      onPress={onPress}
      style={({ pressed }) => [
        styles.container,
        { opacity: pressed ? 0.95 : 1, transform: [{ scale: pressed ? 0.98 : 1 }] },
      ]}
    >
      <View style={[styles.iconContainer, { backgroundColor: categoryColor + "15" }]}>
        <Feather name={iconName as any} size={22} color={categoryColor} />
      </View>
      <View style={styles.content}>
        <Text style={styles.title} numberOfLines={2}>
          {title}
        </Text>
        <View style={styles.meta}>
          <Text style={styles.reference}>{verseReference}</Text>
          <View style={styles.dot} />
          <Text style={styles.readTime}>{readTime} min read</Text>
        </View>
      </View>
      <Feather name="chevron-right" size={20} color={Colors.light.tabIconDefault} />
    </Pressable>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "#FFFFFF",
    borderRadius: 16,
    padding: 16,
    gap: 14,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.04,
    shadowRadius: 8,
    elevation: 2,
  },
  iconContainer: {
    width: 48,
    height: 48,
    borderRadius: 14,
    alignItems: "center",
    justifyContent: "center",
  },
  content: {
    flex: 1,
    gap: 6,
  },
  title: {
    fontSize: 16,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.text,
    lineHeight: 22,
  },
  meta: {
    flexDirection: "row",
    alignItems: "center",
    gap: 6,
  },
  reference: {
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  dot: {
    width: 3,
    height: 3,
    borderRadius: 1.5,
    backgroundColor: Colors.light.tabIconDefault,
  },
  readTime: {
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
});
