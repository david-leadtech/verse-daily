import React from "react";
import {
  StyleSheet,
  Text,
  View,
  FlatList,
  Pressable,
  Platform,
  Alert,
} from "react-native";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import * as Haptics from "expo-haptics";
import Colors from "@/constants/colors";
import VerseCard from "@/components/VerseCard";
import { useFavorites } from "@/contexts/FavoritesContext";

export default function FavoritesScreen() {
  const insets = useSafeAreaInsets();
  const isWeb = Platform.OS === "web";
  const { favorites, removeFavorite } = useFavorites();

  const handleRemove = (verseId: number, verseName: string) => {
    if (Platform.OS === "web") {
      removeFavorite(verseId);
      return;
    }
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    Alert.alert("Remove from Favorites", `Remove "${verseName}" from your favorites?`, [
      { text: "Cancel", style: "cancel" },
      {
        text: "Remove",
        style: "destructive",
        onPress: () => removeFavorite(verseId),
      },
    ]);
  };

  return (
    <View style={styles.container}>
      <View style={[styles.header, { paddingTop: (isWeb ? 67 : insets.top) + 16 }]}>
        <Text style={styles.title}>Favorites</Text>
        <Text style={styles.count}>
          {favorites.length} {favorites.length === 1 ? "verse" : "verses"} saved
        </Text>
      </View>

      {favorites.length === 0 ? (
        <View style={styles.emptyContainer}>
          <View style={styles.emptyIcon}>
            <Feather name="heart" size={40} color={Colors.light.tabIconDefault} />
          </View>
          <Text style={styles.emptyTitle}>No favorites yet</Text>
          <Text style={styles.emptyText}>
            Tap the heart icon on any verse to save it here for easy access later.
          </Text>
        </View>
      ) : (
        <FlatList
          data={favorites}
          keyExtractor={(item) => String(item.id)}
          contentContainerStyle={[styles.list, { paddingBottom: (isWeb ? 34 : 0) + 100 }]}
          scrollEnabled={favorites.length > 0}
          ItemSeparatorComponent={() => <View style={{ height: 12 }} />}
          renderItem={({ item, index }) => (
            <Pressable
              onLongPress={() =>
                handleRemove(item.id, `${item.book} ${item.chapter}:${item.verseNumber}`)
              }
            >
              <VerseCard
                id={item.id}
                book={item.book}
                chapter={item.chapter}
                verseNumber={item.verseNumber}
                text={item.text}
                version={item.version}
                gradientIndex={index % 8}
                compact
              />
            </Pressable>
          )}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.light.background,
  },
  header: {
    paddingHorizontal: 20,
    paddingBottom: 16,
  },
  title: {
    fontSize: 28,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
  },
  count: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
    marginTop: 4,
  },
  list: {
    paddingHorizontal: 20,
  },
  emptyContainer: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    paddingHorizontal: 40,
    gap: 12,
  },
  emptyIcon: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: Colors.light.surfaceSecondary,
    alignItems: "center",
    justifyContent: "center",
    marginBottom: 8,
  },
  emptyTitle: {
    fontSize: 20,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
  },
  emptyText: {
    fontSize: 15,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
    textAlign: "center",
    lineHeight: 24,
  },
});
