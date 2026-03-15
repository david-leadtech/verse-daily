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
  Peace: ["#1E3A5F", "#2D5070"],
  Strength: ["#8B2252", "#6B1A3D"],
  Faith: ["#8B4513", "#6B3410"],
  Gratitude: ["#C5963A", "#8B6914"],
  Love: ["#8B2252", "#6B1A3D"],
  Trust: ["#5B7D3A", "#3C5A20"],
  Growth: ["#3C5A20", "#2C4010"],
  Rest: ["#1E3A5F", "#14284A"],
  Courage: ["#8B4513", "#5C2D0E"],
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
        <ActivityIndicator size="large" color={Colors.light.accent} />
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

  const gradientColors = CATEGORY_COLORS[devotional.category] || ["#8B4513", "#5C2D0E"];

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
              <Feather name="chevron-left" size={24} color="#F5ECD7" />
            </Pressable>
            <Pressable
              onPress={handleShare}
              style={({ pressed }) => [styles.heroBackBtn, { opacity: pressed ? 0.7 : 1 }]}
            >
              <Feather name="share" size={20} color="#F5ECD7" />
            </Pressable>
          </View>

          <View style={styles.heroBadge}>
            <Text style={styles.heroBadgeText}>{devotional.category}</Text>
          </View>

          <Text style={styles.heroTitle}>{devotional.title}</Text>

          <View style={styles.heroMeta}>
            <Feather name="clock" size={14} color="rgba(245,236,215,0.6)" />
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
    color: "#F5ECD7",
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
    backgroundColor: "rgba(245,236,215,0.15)",
    alignItems: "center",
    justifyContent: "center",
  },
  heroBadge: {
    alignSelf: "flex-start",
    paddingHorizontal: 14,
    paddingVertical: 6,
    borderRadius: 20,
    backgroundColor: "rgba(245,236,215,0.15)",
    marginBottom: 12,
  },
  heroBadgeText: {
    fontSize: 13,
    fontFamily: "Inter_600SemiBold",
    color: "#E8D5A3",
  },
  heroTitle: {
    fontSize: 28,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#F5ECD7",
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
    color: "rgba(245,236,215,0.6)",
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
    backgroundColor: Colors.light.accent,
    marginRight: 16,
  },
  verseContent: {
    flex: 1,
    gap: 8,
  },
  verseText: {
    fontSize: 17,
    fontFamily: "PlayfairDisplay_400Regular_Italic",
    color: Colors.light.text,
    lineHeight: 28,
  },
  verseRef: {
    fontSize: 14,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.accent,
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
