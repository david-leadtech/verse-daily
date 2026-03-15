import React from "react";
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  Pressable,
  Share,
  Platform,
  ActivityIndicator,
} from "react-native";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useRouter, useLocalSearchParams } from "expo-router";
import { LinearGradient } from "expo-linear-gradient";
import * as Haptics from "expo-haptics";
import { useGetDevotional } from "@workspace/api-client-react";
import Colors from "@/constants/colors";

const CATEGORY_COLORS: Record<string, [string, string]> = {
  Peace: ["#3B82F6", "#2563EB"],
  Strength: ["#EF4444", "#DC2626"],
  Faith: ["#8B5CF6", "#7C3AED"],
  Gratitude: ["#F59E0B", "#D97706"],
  Love: ["#EC4899", "#DB2777"],
  Trust: ["#10B981", "#059669"],
  Growth: ["#14B8A6", "#0D9488"],
  Rest: ["#6366F1", "#4F46E5"],
  Courage: ["#F97316", "#EA580C"],
};

export default function DevotionalDetailScreen() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const isWeb = Platform.OS === "web";
  const { id } = useLocalSearchParams<{ id: string }>();

  const { data: devotional, isLoading } = useGetDevotional(Number(id));

  const handleShare = async () => {
    if (!devotional) return;
    if (Platform.OS !== "web") {
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    }
    try {
      await Share.share({
        message: `${devotional.title}\n\n"${devotional.verseText}"\n- ${devotional.verseReference}\n\n${devotional.content.substring(0, 200)}...`,
      });
    } catch (_e) {}
  };

  if (isLoading) {
    return (
      <View style={[styles.container, styles.loadingContainer]}>
        <ActivityIndicator size="large" color={Colors.light.tint} />
      </View>
    );
  }

  if (!devotional) {
    return (
      <View style={[styles.container, styles.loadingContainer]}>
        <Feather name="alert-circle" size={48} color={Colors.light.tabIconDefault} />
        <Text style={styles.errorText}>Devotional not found</Text>
        <Pressable onPress={() => router.back()} style={styles.errorButton}>
          <Text style={styles.errorButtonText}>Go Back</Text>
        </Pressable>
      </View>
    );
  }

  const gradientColors = CATEGORY_COLORS[devotional.category] || ["#7C3AED", "#4F46E5"];

  return (
    <View style={styles.container}>
      <ScrollView
        contentContainerStyle={{ paddingBottom: (isWeb ? 34 : insets.bottom) + 40 }}
        showsVerticalScrollIndicator={false}
      >
        <LinearGradient
          colors={[...gradientColors, gradientColors[1] + "CC"]}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 1 }}
          style={[styles.heroSection, { paddingTop: (isWeb ? 67 : insets.top) + 12 }]}
        >
          <View style={styles.heroHeader}>
            <Pressable
              onPress={() => router.back()}
              style={({ pressed }) => [styles.heroBackBtn, { opacity: pressed ? 0.7 : 1 }]}
            >
              <Feather name="chevron-left" size={24} color="#fff" />
            </Pressable>
            <Pressable
              onPress={handleShare}
              style={({ pressed }) => [styles.heroBackBtn, { opacity: pressed ? 0.7 : 1 }]}
            >
              <Feather name="share" size={20} color="#fff" />
            </Pressable>
          </View>

          <View style={styles.heroBadge}>
            <Text style={styles.heroBadgeText}>{devotional.category}</Text>
          </View>

          <Text style={styles.heroTitle}>{devotional.title}</Text>

          <View style={styles.heroMeta}>
            <Feather name="clock" size={14} color="rgba(255,255,255,0.7)" />
            <Text style={styles.heroMetaText}>{devotional.readTime} min read</Text>
          </View>
        </LinearGradient>

        <View style={styles.verseSection}>
          <View style={styles.verseQuoteBar} />
          <View style={styles.verseContent}>
            <Text style={styles.verseText}>{`\u201C${devotional.verseText}\u201D`}</Text>
            <Text style={styles.verseRef}>{devotional.verseReference}</Text>
          </View>
        </View>

        <View style={styles.contentSection}>
          {devotional.content.split("\n\n").map((paragraph, i) => (
            <Text key={i} style={styles.paragraph}>
              {paragraph}
            </Text>
          ))}
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.light.background,
  },
  loadingContainer: {
    alignItems: "center",
    justifyContent: "center",
    gap: 16,
  },
  errorText: {
    fontSize: 16,
    fontFamily: "Inter_500Medium",
    color: Colors.light.textSecondary,
  },
  errorButton: {
    paddingHorizontal: 24,
    paddingVertical: 12,
    backgroundColor: Colors.light.tint,
    borderRadius: 12,
    marginTop: 8,
  },
  errorButtonText: {
    fontSize: 15,
    fontFamily: "Inter_600SemiBold",
    color: "#fff",
  },
  heroSection: {
    paddingHorizontal: 24,
    paddingBottom: 32,
  },
  heroHeader: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 32,
  },
  heroBackBtn: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: "rgba(255,255,255,0.2)",
    alignItems: "center",
    justifyContent: "center",
  },
  heroBadge: {
    alignSelf: "flex-start",
    paddingHorizontal: 14,
    paddingVertical: 6,
    borderRadius: 20,
    backgroundColor: "rgba(255,255,255,0.2)",
    marginBottom: 12,
  },
  heroBadgeText: {
    fontSize: 13,
    fontFamily: "Inter_600SemiBold",
    color: "#fff",
  },
  heroTitle: {
    fontSize: 28,
    fontFamily: "Inter_700Bold",
    color: "#fff",
    lineHeight: 36,
  },
  heroMeta: {
    flexDirection: "row",
    alignItems: "center",
    gap: 6,
    marginTop: 12,
  },
  heroMetaText: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: "rgba(255,255,255,0.7)",
  },
  verseSection: {
    flexDirection: "row",
    marginHorizontal: 24,
    marginTop: 28,
    marginBottom: 8,
  },
  verseQuoteBar: {
    width: 3,
    borderRadius: 2,
    backgroundColor: Colors.light.tint,
    marginRight: 16,
  },
  verseContent: {
    flex: 1,
    gap: 8,
  },
  verseText: {
    fontSize: 17,
    fontFamily: "Inter_500Medium",
    color: Colors.light.text,
    lineHeight: 28,
    fontStyle: "italic",
  },
  verseRef: {
    fontSize: 14,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.tint,
  },
  contentSection: {
    paddingHorizontal: 24,
    paddingTop: 24,
    gap: 18,
  },
  paragraph: {
    fontSize: 16,
    fontFamily: "Inter_400Regular",
    color: Colors.light.text,
    lineHeight: 28,
  },
});
