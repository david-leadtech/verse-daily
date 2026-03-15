import React from "react";
import { StyleSheet, Text, View, Pressable, Share, Platform } from "react-native";
import { Feather } from "@expo/vector-icons";
import * as Haptics from "expo-haptics";
import GradientCard from "./GradientCard";
import { useFavorites } from "@/contexts/FavoritesContext";

interface VerseCardProps {
  id: number;
  book: string;
  chapter: number;
  verseNumber: number;
  text: string;
  version: string;
  gradientIndex?: number;
  showActions?: boolean;
  compact?: boolean;
  onPress?: () => void;
}

export default function VerseCard({
  id,
  book,
  chapter,
  verseNumber,
  text,
  version,
  gradientIndex = 0,
  showActions = true,
  compact = false,
  onPress,
}: VerseCardProps) {
  const { isFavorite, toggleFavorite } = useFavorites();
  const saved = isFavorite(id);

  const handleFavorite = () => {
    if (Platform.OS !== "web") {
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    }
    toggleFavorite({ id, book, chapter, verseNumber, text, version });
  };

  const handleShare = async () => {
    if (Platform.OS !== "web") {
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    }
    try {
      await Share.share({
        message: `"${text}"\n\n- ${book} ${chapter}:${verseNumber} (${version})`,
      });
    } catch (_e) {}
  };

  return (
    <GradientCard gradientIndex={gradientIndex} onPress={onPress}>
      <View style={[styles.container, compact && styles.containerCompact]}>
        <Text style={[styles.verseText, compact && styles.verseTextCompact]}>
          {`\u201C${text}\u201D`}
        </Text>
        <View style={styles.footer}>
          <View style={styles.reference}>
            <Text style={styles.referenceText}>
              {book} {chapter}:{verseNumber}
            </Text>
            <Text style={styles.versionText}>{version}</Text>
          </View>
          {showActions && (
            <View style={styles.actions}>
              <Pressable
                onPress={handleFavorite}
                hitSlop={12}
                style={({ pressed }) => [styles.actionBtn, { opacity: pressed ? 0.7 : 1 }]}
              >
                <Feather
                  name={saved ? "heart" : "heart"}
                  size={20}
                  color={saved ? "#FCD34D" : "rgba(255,255,255,0.7)"}
                />
              </Pressable>
              <Pressable
                onPress={handleShare}
                hitSlop={12}
                style={({ pressed }) => [styles.actionBtn, { opacity: pressed ? 0.7 : 1 }]}
              >
                <Feather name="share" size={20} color="rgba(255,255,255,0.7)" />
              </Pressable>
            </View>
          )}
        </View>
      </View>
    </GradientCard>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 28,
    minHeight: 200,
    justifyContent: "space-between",
  },
  containerCompact: {
    padding: 20,
    minHeight: 140,
  },
  verseText: {
    fontSize: 20,
    lineHeight: 30,
    color: "#FFFFFF",
    fontFamily: "Inter_500Medium",
    letterSpacing: 0.3,
  },
  verseTextCompact: {
    fontSize: 16,
    lineHeight: 24,
  },
  footer: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "flex-end",
    marginTop: 20,
  },
  reference: {
    gap: 2,
  },
  referenceText: {
    fontSize: 14,
    color: "rgba(255,255,255,0.9)",
    fontFamily: "Inter_600SemiBold",
  },
  versionText: {
    fontSize: 12,
    color: "rgba(255,255,255,0.6)",
    fontFamily: "Inter_400Regular",
  },
  actions: {
    flexDirection: "row",
    gap: 16,
  },
  actionBtn: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: "rgba(255,255,255,0.15)",
    alignItems: "center",
    justifyContent: "center",
  },
});
