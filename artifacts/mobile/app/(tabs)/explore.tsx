import React, { useState } from "react";
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  Pressable,
  Platform,
  ActivityIndicator,
} from "react-native";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useRouter } from "expo-router";
import { useGetDevotionals } from "@workspace/api-client-react";
import Colors from "@/constants/colors";
import DevotionalCard from "@/components/DevotionalCard";

const CATEGORIES = ["All", "Peace", "Strength", "Faith", "Gratitude", "Love", "Trust", "Growth", "Rest", "Courage"];

export default function ExploreScreen() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const isWeb = Platform.OS === "web";
  const [selectedCategory, setSelectedCategory] = useState("All");

  const { data, isLoading } = useGetDevotionals({
    category: selectedCategory === "All" ? undefined : selectedCategory,
    limit: 20,
  });

  return (
    <View style={styles.container}>
      <ScrollView
        contentContainerStyle={[
          styles.scrollContent,
          { paddingTop: (isWeb ? 67 : insets.top) + 16, paddingBottom: (isWeb ? 34 : 0) + 100 },
        ]}
        showsVerticalScrollIndicator={false}
      >
        <Text style={styles.title}>Devotionals</Text>
        <Text style={styles.subtitle}>Daily reflections to deepen your faith</Text>

        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.categoriesScroll}
        >
          {CATEGORIES.map((cat) => (
            <Pressable
              key={cat}
              onPress={() => setSelectedCategory(cat)}
              style={[
                styles.categoryChip,
                selectedCategory === cat && styles.categoryChipActive,
              ]}
            >
              <Text
                style={[
                  styles.categoryText,
                  selectedCategory === cat && styles.categoryTextActive,
                ]}
              >
                {cat}
              </Text>
            </Pressable>
          ))}
        </ScrollView>

        {isLoading ? (
          <View style={styles.loadingContainer}>
            <ActivityIndicator size="small" color={Colors.light.tint} />
          </View>
        ) : data?.devotionals && data.devotionals.length > 0 ? (
          <View style={styles.list}>
            {data.devotionals.map((dev) => (
              <DevotionalCard
                key={dev.id}
                id={dev.id}
                title={dev.title}
                category={dev.category}
                readTime={dev.readTime}
                verseReference={dev.verseReference}
                onPress={() =>
                  router.push({ pathname: "/devotional/[id]", params: { id: String(dev.id) } })
                }
              />
            ))}
          </View>
        ) : (
          <View style={styles.emptyContainer}>
            <Feather name="book-open" size={48} color={Colors.light.tabIconDefault} />
            <Text style={styles.emptyTitle}>No devotionals found</Text>
            <Text style={styles.emptyText}>
              {selectedCategory !== "All"
                ? `No devotionals in the "${selectedCategory}" category yet.`
                : "Check back soon for new devotionals."}
            </Text>
          </View>
        )}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.light.background,
  },
  scrollContent: {
    paddingBottom: 100,
  },
  title: {
    fontSize: 28,
    fontFamily: "Inter_700Bold",
    color: Colors.light.text,
    paddingHorizontal: 20,
  },
  subtitle: {
    fontSize: 15,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
    paddingHorizontal: 20,
    marginTop: 4,
    marginBottom: 20,
  },
  categoriesScroll: {
    paddingHorizontal: 20,
    gap: 8,
    marginBottom: 20,
  },
  categoryChip: {
    paddingHorizontal: 18,
    paddingVertical: 10,
    borderRadius: 20,
    backgroundColor: Colors.light.surfaceSecondary,
  },
  categoryChipActive: {
    backgroundColor: Colors.light.tint,
  },
  categoryText: {
    fontSize: 14,
    fontFamily: "Inter_500Medium",
    color: Colors.light.textSecondary,
  },
  categoryTextActive: {
    color: "#FFFFFF",
  },
  list: {
    paddingHorizontal: 20,
    gap: 10,
  },
  loadingContainer: {
    height: 200,
    alignItems: "center",
    justifyContent: "center",
  },
  emptyContainer: {
    alignItems: "center",
    justifyContent: "center",
    paddingTop: 60,
    paddingHorizontal: 40,
    gap: 12,
  },
  emptyTitle: {
    fontSize: 18,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.text,
  },
  emptyText: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
    textAlign: "center",
    lineHeight: 22,
  },
});
