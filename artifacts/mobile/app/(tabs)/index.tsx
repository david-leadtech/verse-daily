import React, { useCallback } from "react";
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  RefreshControl,
  Platform,
  ActivityIndicator,
  Pressable,
} from "react-native";
import { LinearGradient } from "expo-linear-gradient";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useRouter } from "expo-router";
import { useGetDailyVerse, useGetDevotionals } from "@workspace/api-client-react";
import Colors from "@/constants/colors";
import VerseCard from "@/components/VerseCard";
import DevotionalCard from "@/components/DevotionalCard";
import SectionHeader from "@/components/SectionHeader";

export default function HomeScreen() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const isWeb = Platform.OS === "web";

  const {
    data: dailyData,
    isLoading: dailyLoading,
    isError: dailyError,
    refetch: refetchDaily,
  } = useGetDailyVerse();

  const {
    data: devotionalsData,
    isLoading: devotionalsLoading,
    isError: devotionalsError,
    refetch: refetchDevotionals,
  } = useGetDevotionals({ limit: 5 });

  const [refreshing, setRefreshing] = React.useState(false);

  const onRefresh = useCallback(async () => {
    setRefreshing(true);
    await Promise.all([refetchDaily(), refetchDevotionals()]);
    setRefreshing(false);
  }, [refetchDaily, refetchDevotionals]);

  const today = new Date();
  const dateString = today.toLocaleDateString("en-US", {
    weekday: "long",
    month: "long",
    day: "numeric",
  });

  return (
    <View style={styles.container}>
      <ScrollView
        contentContainerStyle={[
          styles.scrollContent,
          { paddingTop: (isWeb ? 67 : insets.top) + 16, paddingBottom: (isWeb ? 34 : 0) + 100 },
        ]}
        showsVerticalScrollIndicator={false}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor={Colors.light.tint} />
        }
      >
        <View style={styles.header}>
          <View>
            <Text style={styles.greeting}>Good {getGreeting()}</Text>
            <Text style={styles.dateText}>{dateString}</Text>
          </View>
          <Pressable
            onPress={() => router.push("/settings")}
            style={({ pressed }) => [styles.settingsBtn, { opacity: pressed ? 0.7 : 1 }]}
          >
            <Feather name="settings" size={22} color={Colors.light.textSecondary} />
          </Pressable>
        </View>

        <SectionHeader title="Verse of the Day" />
        {dailyLoading ? (
          <View style={styles.loadingCard}>
            <ActivityIndicator size="small" color={Colors.light.tint} />
          </View>
        ) : dailyError ? (
          <Pressable onPress={() => refetchDaily()} style={styles.loadingCard}>
            <Feather name="wifi-off" size={32} color={Colors.light.tabIconDefault} />
            <Text style={styles.emptyText}>Could not load verse</Text>
            <Text style={[styles.emptyText, { color: Colors.light.tint, fontSize: 13 }]}>Tap to retry</Text>
          </Pressable>
        ) : dailyData?.verse ? (
          <View style={styles.dailyVerseContainer}>
            <VerseCard
              id={dailyData.verse.id}
              book={dailyData.verse.book}
              chapter={dailyData.verse.chapter}
              verseNumber={dailyData.verse.verseNumber}
              text={dailyData.verse.text}
              version={dailyData.verse.version}
              gradientIndex={today.getDate() % 8}
            />
            {dailyData.reflection && (
              <View style={styles.reflectionContainer}>
                <Feather name="message-circle" size={16} color={Colors.light.tint} />
                <Text style={styles.reflectionText}>{dailyData.reflection}</Text>
              </View>
            )}
          </View>
        ) : (
          <View style={styles.loadingCard}>
            <Feather name="book-open" size={32} color={Colors.light.tabIconDefault} />
            <Text style={styles.emptyText}>No verse available today</Text>
          </View>
        )}

        <View style={{ height: 24 }} />
        <SectionHeader
          title="Devotionals"
          actionText="See all"
          onAction={() => router.push("/(tabs)/explore")}
        />
        {devotionalsLoading ? (
          <View style={styles.loadingCard}>
            <ActivityIndicator size="small" color={Colors.light.tint} />
          </View>
        ) : devotionalsError ? (
          <Pressable onPress={() => refetchDevotionals()} style={styles.loadingCard}>
            <Feather name="wifi-off" size={32} color={Colors.light.tabIconDefault} />
            <Text style={styles.emptyText}>Could not load devotionals</Text>
            <Text style={[styles.emptyText, { color: Colors.light.tint, fontSize: 13 }]}>Tap to retry</Text>
          </Pressable>
        ) : (
          <View style={styles.devotionalsList}>
            {devotionalsData?.devotionals?.map((dev) => (
              <View key={dev.id} style={styles.devotionalItem}>
                <DevotionalCard
                  id={dev.id}
                  title={dev.title}
                  category={dev.category}
                  readTime={dev.readTime}
                  verseReference={dev.verseReference}
                  onPress={() =>
                    router.push({ pathname: "/devotional/[id]", params: { id: String(dev.id) } })
                  }
                />
              </View>
            ))}
          </View>
        )}

        <View style={{ height: 24 }} />
        <SectionHeader title="Quick Read" />
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.quickReadScroll}
        >
          {quickReadTopics.map((topic, index) => (
            <Pressable
              key={topic.name}
              onPress={() =>
                router.push({
                  pathname: "/(tabs)/bible",
                  params: { book: topic.book, chapter: String(topic.chapter) },
                })
              }
              style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1 }]}
            >
              <LinearGradient
                colors={topic.colors as [string, string]}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 1 }}
                style={styles.quickReadCard}
              >
                <Feather name={topic.icon as any} size={24} color="#fff" />
                <Text style={styles.quickReadTitle}>{topic.name}</Text>
                <Text style={styles.quickReadSub}>
                  {topic.book} {topic.chapter}
                </Text>
              </LinearGradient>
            </Pressable>
          ))}
        </ScrollView>
      </ScrollView>
    </View>
  );
}

function getGreeting(): string {
  const hour = new Date().getHours();
  if (hour < 12) return "Morning";
  if (hour < 17) return "Afternoon";
  return "Evening";
}

const quickReadTopics = [
  { name: "Psalms of Peace", book: "Psalms", chapter: 23, icon: "sun", colors: ["#7C3AED", "#4F46E5"] },
  { name: "Love Chapter", book: "1 Corinthians", chapter: 13, icon: "heart", colors: ["#EC4899", "#8B5CF6"] },
  { name: "Creation", book: "Genesis", chapter: 1, icon: "globe", colors: ["#10B981", "#3B82F6"] },
  { name: "Faith Heroes", book: "Hebrews", chapter: 11, icon: "shield", colors: ["#F59E0B", "#EF4444"] },
  { name: "Beatitudes", book: "Matthew", chapter: 5, icon: "star", colors: ["#1E3A5F", "#4A90D9"] },
];

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.light.background,
  },
  scrollContent: {
    paddingBottom: 100,
  },
  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    paddingHorizontal: 20,
    marginBottom: 24,
  },
  greeting: {
    fontSize: 28,
    fontFamily: "Inter_700Bold",
    color: Colors.light.text,
  },
  dateText: {
    fontSize: 15,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
    marginTop: 2,
  },
  settingsBtn: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: Colors.light.surfaceSecondary,
    alignItems: "center",
    justifyContent: "center",
  },
  dailyVerseContainer: {
    paddingHorizontal: 20,
    gap: 12,
  },
  reflectionContainer: {
    flexDirection: "row",
    gap: 10,
    backgroundColor: Colors.light.surface,
    borderRadius: 14,
    padding: 16,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.03,
    shadowRadius: 4,
    elevation: 1,
  },
  reflectionText: {
    flex: 1,
    fontSize: 14,
    lineHeight: 22,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  loadingCard: {
    marginHorizontal: 20,
    height: 180,
    backgroundColor: Colors.light.surfaceSecondary,
    borderRadius: 20,
    alignItems: "center",
    justifyContent: "center",
    gap: 12,
  },
  emptyText: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  devotionalsList: {
    paddingHorizontal: 20,
    gap: 10,
  },
  devotionalItem: {},
  quickReadScroll: {
    paddingHorizontal: 20,
    gap: 12,
  },
  quickReadCard: {
    width: 140,
    height: 140,
    borderRadius: 18,
    padding: 16,
    justifyContent: "space-between",
  },
  quickReadTitle: {
    fontSize: 15,
    fontFamily: "Inter_600SemiBold",
    color: "#fff",
    lineHeight: 20,
  },
  quickReadSub: {
    fontSize: 12,
    fontFamily: "Inter_400Regular",
    color: "rgba(255,255,255,0.7)",
  },
});
