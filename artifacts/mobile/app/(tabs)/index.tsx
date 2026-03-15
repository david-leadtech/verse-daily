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
  ImageBackground,
} from "react-native";
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

  const greetingMessage = getGreetingMessage();

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
            <Text style={styles.greeting}>{greetingMessage.greeting}</Text>
            <Text style={styles.dateText}>{dateString}</Text>
          </View>
          <Pressable
            onPress={() => router.push("/settings")}
            style={({ pressed }) => [styles.settingsBtn, { opacity: pressed ? 0.7 : 1 }]}
          >
            <Feather name="settings" size={22} color={Colors.light.textSecondary} />
          </Pressable>
        </View>

        <Text style={styles.dailyMessage}>{greetingMessage.message}</Text>

        <SectionHeader title="Today's Verse" />
        {dailyLoading ? (
          <View style={styles.loadingCard}>
            <ActivityIndicator size="small" color={Colors.light.accent} />
            <Text style={styles.loadingText}>Finding today's verse for you...</Text>
          </View>
        ) : dailyError ? (
          <Pressable onPress={() => refetchDaily()} style={styles.loadingCard}>
            <Feather name="wifi-off" size={28} color={Colors.light.tabIconDefault} />
            <Text style={styles.emptyText}>Couldn't load your verse right now</Text>
            <Text style={styles.retryText}>Tap to try again</Text>
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
              gradientIndex={today.getDate() % 4}
              useImage
            />
            {dailyData.reflection && (
              <View style={styles.reflectionContainer}>
                <Text style={styles.reflectionLabel}>Reflection</Text>
                <Text style={styles.reflectionText}>{dailyData.reflection}</Text>
              </View>
            )}
          </View>
        ) : (
          <View style={styles.loadingCard}>
            <Feather name="book-open" size={28} color={Colors.light.tabIconDefault} />
            <Text style={styles.emptyText}>No verse for today yet — check back soon!</Text>
          </View>
        )}

        <View style={{ height: 28 }} />
        <SectionHeader
          title="For You"
          actionText="See all"
          onAction={() => router.push("/(tabs)/explore")}
        />
        {devotionalsLoading ? (
          <View style={styles.loadingCard}>
            <ActivityIndicator size="small" color={Colors.light.accent} />
          </View>
        ) : devotionalsError ? (
          <Pressable onPress={() => refetchDevotionals()} style={styles.loadingCard}>
            <Feather name="wifi-off" size={28} color={Colors.light.tabIconDefault} />
            <Text style={styles.emptyText}>Couldn't load devotionals</Text>
            <Text style={styles.retryText}>Tap to try again</Text>
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

        <View style={{ height: 28 }} />
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
              <ImageBackground
                source={topic.image}
                style={styles.quickReadCard}
                imageStyle={styles.quickReadImage}
                resizeMode="cover"
              >
                <View style={styles.quickReadOverlay} />
                <View style={styles.quickReadContent}>
                  <Feather name={topic.icon as any} size={20} color="#E8D5A3" />
                  <View style={{ flex: 1 }} />
                  <Text style={styles.quickReadTitle}>{topic.name}</Text>
                  <Text style={styles.quickReadSub}>
                    {topic.book} {topic.chapter}
                  </Text>
                </View>
              </ImageBackground>
            </Pressable>
          ))}
        </ScrollView>
      </ScrollView>
    </View>
  );
}

function getGreetingMessage(): { greeting: string; message: string } {
  const hour = new Date().getHours();
  if (hour < 12) {
    return {
      greeting: "Good Morning",
      message: "Start your day with a moment of peace. Here's a verse to carry with you today.",
    };
  }
  if (hour < 17) {
    return {
      greeting: "Good Afternoon",
      message: "Take a pause. Let God's Word refresh your spirit for the rest of the day.",
    };
  }
  return {
    greeting: "Good Evening",
    message: "Wind down with tonight's scripture. Let His words bring you peace as you rest.",
  };
}

const quickReadTopics = [
  { name: "Psalms of\nPeace", book: "Psalms", chapter: 23, icon: "sun", image: require("@/assets/images/onboarding-1.png") },
  { name: "The Love\nChapter", book: "1 Corinthians", chapter: 13, icon: "heart", image: require("@/assets/images/onboarding-3.png") },
  { name: "In the\nBeginning", book: "Genesis", chapter: 1, icon: "globe", image: require("@/assets/images/splash-bg.png") },
  { name: "Heroes of\nFaith", book: "Hebrews", chapter: 11, icon: "shield", image: require("@/assets/images/daily-verse-bg.png") },
  { name: "The\nBeatitudes", book: "Matthew", chapter: 5, icon: "star", image: require("@/assets/images/onboarding-2.png") },
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
    marginBottom: 6,
  },
  greeting: {
    fontSize: 28,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
  },
  dateText: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
    marginTop: 3,
  },
  settingsBtn: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: Colors.light.surfaceSecondary,
    alignItems: "center",
    justifyContent: "center",
  },
  dailyMessage: {
    fontSize: 15,
    fontFamily: "PlayfairDisplay_400Regular_Italic",
    color: Colors.light.textSecondary,
    paddingHorizontal: 20,
    lineHeight: 23,
    marginBottom: 24,
  },
  dailyVerseContainer: {
    paddingHorizontal: 20,
    gap: 14,
  },
  reflectionContainer: {
    backgroundColor: Colors.light.parchment,
    borderRadius: 16,
    padding: 18,
    gap: 8,
    borderLeftWidth: 3,
    borderLeftColor: Colors.light.accent,
  },
  reflectionLabel: {
    fontSize: 11,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.accent,
    textTransform: "uppercase",
    letterSpacing: 1.5,
  },
  reflectionText: {
    flex: 1,
    fontSize: 14,
    lineHeight: 23,
    fontFamily: "Inter_400Regular",
    color: Colors.light.text,
    fontStyle: "italic",
  },
  loadingCard: {
    marginHorizontal: 20,
    height: 180,
    backgroundColor: Colors.light.surfaceSecondary,
    borderRadius: 20,
    alignItems: "center",
    justifyContent: "center",
    gap: 10,
  },
  loadingText: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
    fontStyle: "italic",
  },
  emptyText: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  retryText: {
    fontSize: 13,
    fontFamily: "Inter_500Medium",
    color: Colors.light.accent,
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
    width: 150,
    height: 180,
    borderRadius: 18,
    overflow: "hidden",
  },
  quickReadImage: {
    borderRadius: 18,
  },
  quickReadOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: "rgba(15, 6, 2, 0.65)",
    borderRadius: 18,
  },
  quickReadContent: {
    flex: 1,
    padding: 16,
    zIndex: 2,
    justifyContent: "space-between",
  },
  quickReadTitle: {
    fontSize: 16,
    fontFamily: "PlayfairDisplay_700Bold",
    color: "#FFFFFF",
    lineHeight: 21,
    textShadowColor: "rgba(0, 0, 0, 0.5)",
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 3,
  },
  quickReadSub: {
    fontSize: 12,
    fontFamily: "Inter_500Medium",
    color: "rgba(255,255,255,0.8)",
    marginTop: 2,
    textShadowColor: "rgba(0, 0, 0, 0.4)",
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 2,
  },
});
