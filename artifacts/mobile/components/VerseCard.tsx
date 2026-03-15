import React from "react";
import { StyleSheet, Text, View, Pressable, Share, Platform, ImageBackground } from "react-native";
import { Feather } from "@expo/vector-icons";
import * as Haptics from "expo-haptics";
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
  useImage?: boolean;
}

const CARD_IMAGES = [
  require("@/assets/images/onboarding-1.png"),
  require("@/assets/images/onboarding-3.png"),
  require("@/assets/images/splash-bg.png"),
  require("@/assets/images/daily-verse-bg.png"),
];

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
  useImage = false,
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
        message: `"${text}"\n\n— ${book} ${chapter}:${verseNumber} (${version})`,
      });
    } catch (_e) {}
  };

  const cardContent = (
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
                name="heart"
                size={20}
                color={saved ? "#C5963A" : "rgba(245,236,215,0.5)"}
              />
            </Pressable>
            <Pressable
              onPress={handleShare}
              hitSlop={12}
              style={({ pressed }) => [styles.actionBtn, { opacity: pressed ? 0.7 : 1 }]}
            >
              <Feather name="share" size={20} color="rgba(245,236,215,0.5)" />
            </Pressable>
          </View>
        )}
      </View>
    </View>
  );

  if (useImage) {
    const imageSource = CARD_IMAGES[gradientIndex % CARD_IMAGES.length];
    const wrapper = (
      <ImageBackground
        source={imageSource}
        style={styles.imageCard}
        imageStyle={styles.imageBorder}
        resizeMode="cover"
      >
        <View style={styles.imageOverlay} />
        {cardContent}
      </ImageBackground>
    );

    if (onPress) {
      return (
        <Pressable
          onPress={onPress}
          style={({ pressed }) => [{ opacity: pressed ? 0.95 : 1, transform: [{ scale: pressed ? 0.98 : 1 }] }]}
        >
          {wrapper}
        </Pressable>
      );
    }
    return wrapper;
  }

  const GradientCard = require("./GradientCard").default;
  return (
    <GradientCard gradientIndex={gradientIndex} onPress={onPress}>
      {cardContent}
    </GradientCard>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 28,
    minHeight: 200,
    justifyContent: "space-between",
    zIndex: 2,
  },
  containerCompact: {
    padding: 20,
    minHeight: 140,
  },
  imageCard: {
    borderRadius: 20,
    overflow: "hidden",
  },
  imageBorder: {
    borderRadius: 20,
  },
  imageOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: "rgba(20, 8, 2, 0.65)",
    borderRadius: 20,
  },
  verseText: {
    fontSize: 20,
    lineHeight: 32,
    color: "#FFFFFF",
    fontFamily: "PlayfairDisplay_400Regular_Italic",
    letterSpacing: 0.3,
    textShadowColor: "rgba(0, 0, 0, 0.5)",
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 3,
  },
  verseTextCompact: {
    fontSize: 16,
    lineHeight: 26,
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
    color: "#FFFFFF",
    fontFamily: "Inter_600SemiBold",
    textShadowColor: "rgba(0, 0, 0, 0.4)",
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 2,
  },
  versionText: {
    fontSize: 12,
    color: "rgba(255,255,255,0.7)",
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
    backgroundColor: "rgba(245,236,215,0.1)",
    alignItems: "center",
    justifyContent: "center",
  },
});
