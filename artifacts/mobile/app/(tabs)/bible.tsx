import React, { useState, useCallback } from "react";
import {
  StyleSheet,
  Text,
  View,
  FlatList,
  Pressable,
  Platform,
  ActivityIndicator,
  ScrollView,
} from "react-native";
import { Feather } from "@expo/vector-icons";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useLocalSearchParams } from "expo-router";
import { useGetBooks, useGetVerses } from "@workspace/api-client-react";
import Colors from "@/constants/colors";
import VerseCard from "@/components/VerseCard";

export default function BibleScreen() {
  const insets = useSafeAreaInsets();
  const params = useLocalSearchParams<{ book?: string; chapter?: string }>();
  const isWeb = Platform.OS === "web";

  const [selectedBook, setSelectedBook] = useState<string>(params.book || "");
  const [selectedChapter, setSelectedChapter] = useState<number>(
    params.chapter ? Number(params.chapter) : 0
  );
  const [showBookPicker, setShowBookPicker] = useState(!params.book);

  const { data: booksData } = useGetBooks();
  const { data: versesData, isLoading: versesLoading } = useGetVerses(
    {
      book: selectedBook || undefined,
      chapter: selectedChapter || undefined,
      limit: 100,
    },
    { query: { enabled: !!selectedBook && selectedChapter > 0 } }
  );

  const selectedBookData = booksData?.books?.find((b) => b.name === selectedBook);

  const handleBookSelect = useCallback((bookName: string) => {
    setSelectedBook(bookName);
    setSelectedChapter(0);
    setShowBookPicker(false);
  }, []);

  const handleChapterSelect = useCallback((chapter: number) => {
    setSelectedChapter(chapter);
  }, []);

  if (showBookPicker) {
    return (
      <View style={styles.container}>
        <View style={[styles.pickerHeader, { paddingTop: (isWeb ? 67 : insets.top) + 12 }]}>
          <Text style={styles.pickerTitle}>Select a Book</Text>
        </View>
        <FlatList
          data={booksData?.books || []}
          keyExtractor={(item) => item.name}
          contentContainerStyle={[styles.bookList, { paddingBottom: (isWeb ? 34 : 0) + 100 }]}
          scrollEnabled={(booksData?.books?.length ?? 0) > 0}
          renderItem={({ item }) => (
            <Pressable
              onPress={() => handleBookSelect(item.name)}
              style={({ pressed }) => [styles.bookItem, { opacity: pressed ? 0.7 : 1 }]}
            >
              <View
                style={[
                  styles.bookBadge,
                  {
                    backgroundColor:
                      item.testament === "Old Testament" ? Colors.light.accent + "20" : Colors.light.tint + "20",
                  },
                ]}
              >
                <Text
                  style={[
                    styles.bookBadgeText,
                    {
                      color:
                        item.testament === "Old Testament" ? Colors.light.accent : Colors.light.tint,
                    },
                  ]}
                >
                  {item.testament === "Old Testament" ? "OT" : "NT"}
                </Text>
              </View>
              <View style={styles.bookInfo}>
                <Text style={styles.bookName}>{item.name}</Text>
                <Text style={styles.bookChapters}>{item.chapters} chapters</Text>
              </View>
              <Feather name="chevron-right" size={18} color={Colors.light.tabIconDefault} />
            </Pressable>
          )}
        />
      </View>
    );
  }

  if (selectedBook && selectedChapter === 0) {
    const chapterCount = selectedBookData?.chapters || 1;
    const chapters = Array.from({ length: chapterCount }, (_, i) => i + 1);

    return (
      <View style={styles.container}>
        <View style={[styles.pickerHeader, { paddingTop: (isWeb ? 67 : insets.top) + 12 }]}>
          <Pressable onPress={() => setShowBookPicker(true)} style={styles.backBtn}>
            <Feather name="chevron-left" size={24} color={Colors.light.tint} />
          </Pressable>
          <View style={styles.pickerTitleContainer}>
            <Text style={styles.pickerTitle}>{selectedBook}</Text>
            <Text style={styles.pickerSubtitle}>Select a chapter</Text>
          </View>
        </View>
        <ScrollView
          contentContainerStyle={[styles.chapterGrid, { paddingBottom: (isWeb ? 34 : 0) + 100 }]}
        >
          {chapters.map((ch) => (
            <Pressable
              key={ch}
              onPress={() => handleChapterSelect(ch)}
              style={({ pressed }) => [
                styles.chapterItem,
                { opacity: pressed ? 0.7 : 1, transform: [{ scale: pressed ? 0.95 : 1 }] },
              ]}
            >
              <Text style={styles.chapterNumber}>{ch}</Text>
            </Pressable>
          ))}
        </ScrollView>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={[styles.readerHeader, { paddingTop: (isWeb ? 67 : insets.top) + 12 }]}>
        <Pressable onPress={() => setSelectedChapter(0)} style={styles.backBtn}>
          <Feather name="chevron-left" size={24} color={Colors.light.tint} />
        </Pressable>
        <View style={styles.readerTitleContainer}>
          <Text style={styles.readerTitle}>
            {selectedBook} {selectedChapter}
          </Text>
        </View>
        <View style={{ width: 36 }} />
      </View>

      {versesLoading ? (
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="small" color={Colors.light.accent} />
        </View>
      ) : versesData?.verses && versesData.verses.length > 0 ? (
        <FlatList
          data={versesData.verses}
          keyExtractor={(item) => String(item.id)}
          contentContainerStyle={[styles.versesList, { paddingBottom: (isWeb ? 34 : 0) + 100 }]}
          scrollEnabled={versesData.verses.length > 0}
          ItemSeparatorComponent={() => <View style={{ height: 12 }} />}
          renderItem={({ item, index }) => (
            <View style={styles.verseItem}>
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
            </View>
          )}
        />
      ) : (
        <View style={styles.emptyContainer}>
          <Feather name="book" size={48} color={Colors.light.tabIconDefault} />
          <Text style={styles.emptyTitle}>No verses found</Text>
          <Text style={styles.emptyText}>
            This chapter doesn't have any verses in our collection yet.
          </Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.light.background,
  },
  pickerHeader: {
    paddingHorizontal: 20,
    paddingBottom: 16,
    flexDirection: "row",
    alignItems: "center",
    gap: 12,
    backgroundColor: Colors.light.background,
    borderBottomWidth: 1,
    borderBottomColor: Colors.light.borderLight,
  },
  pickerTitleContainer: {
    flex: 1,
  },
  pickerTitle: {
    fontSize: 24,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
  },
  pickerSubtitle: {
    fontSize: 14,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
    marginTop: 2,
  },
  backBtn: {
    width: 36,
    height: 36,
    borderRadius: 18,
    alignItems: "center",
    justifyContent: "center",
  },
  bookList: {
    paddingHorizontal: 20,
    paddingTop: 8,
  },
  bookItem: {
    flexDirection: "row",
    alignItems: "center",
    paddingVertical: 14,
    gap: 14,
    borderBottomWidth: 1,
    borderBottomColor: Colors.light.borderLight,
  },
  bookBadge: {
    width: 40,
    height: 40,
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
  },
  bookBadgeText: {
    fontSize: 12,
    fontFamily: "Inter_700Bold",
  },
  bookInfo: {
    flex: 1,
    gap: 2,
  },
  bookName: {
    fontSize: 16,
    fontFamily: "Inter_500Medium",
    color: Colors.light.text,
  },
  bookChapters: {
    fontSize: 13,
    fontFamily: "Inter_400Regular",
    color: Colors.light.textSecondary,
  },
  chapterGrid: {
    flexDirection: "row",
    flexWrap: "wrap",
    paddingHorizontal: 20,
    paddingTop: 16,
    gap: 10,
  },
  chapterItem: {
    width: 60,
    height: 60,
    borderRadius: 14,
    backgroundColor: Colors.light.surface,
    alignItems: "center",
    justifyContent: "center",
    borderWidth: 1,
    borderColor: Colors.light.border,
  },
  chapterNumber: {
    fontSize: 18,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
  },
  readerHeader: {
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 20,
    paddingBottom: 12,
    backgroundColor: Colors.light.background,
    borderBottomWidth: 1,
    borderBottomColor: Colors.light.borderLight,
  },
  readerTitleContainer: {
    flex: 1,
    alignItems: "center",
  },
  readerTitle: {
    fontSize: 18,
    fontFamily: "PlayfairDisplay_700Bold",
    color: Colors.light.text,
  },
  versesList: {
    paddingHorizontal: 20,
    paddingTop: 16,
  },
  verseItem: {},
  loadingContainer: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
  },
  emptyContainer: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    paddingHorizontal: 40,
    gap: 12,
  },
  emptyTitle: {
    fontSize: 18,
    fontFamily: "PlayfairDisplay_700Bold",
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
