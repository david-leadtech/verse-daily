import React, { createContext, useContext, useState, useEffect, useCallback } from "react";
import AsyncStorage from "@react-native-async-storage/async-storage";

interface FavoriteVerse {
  id: number;
  book: string;
  chapter: number;
  verseNumber: number;
  text: string;
  version: string;
  savedAt: string;
}

interface FavoritesContextType {
  favorites: FavoriteVerse[];
  isFavorite: (verseId: number) => boolean;
  toggleFavorite: (verse: Omit<FavoriteVerse, "savedAt">) => void;
  removeFavorite: (verseId: number) => void;
}

const FavoritesContext = createContext<FavoritesContextType | undefined>(undefined);

const STORAGE_KEY = "@bible_favorites";

export function FavoritesProvider({ children }: { children: React.ReactNode }) {
  const [favorites, setFavorites] = useState<FavoriteVerse[]>([]);

  useEffect(() => {
    (async () => {
      try {
        const data = await AsyncStorage.getItem(STORAGE_KEY);
        if (data) {
          const parsed = JSON.parse(data);
          if (Array.isArray(parsed)) {
            setFavorites(parsed);
          }
        }
      } catch {
        // ignore corrupted storage
      }
    })();
  }, []);

  const persistFavorites = useCallback(async (items: FavoriteVerse[]) => {
    try {
      await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(items));
    } catch {
      // storage write failed silently
    }
  }, []);

  const isFavorite = useCallback(
    (verseId: number) => favorites.some((f) => f.id === verseId),
    [favorites]
  );

  const toggleFavorite = useCallback(
    (verse: Omit<FavoriteVerse, "savedAt">) => {
      setFavorites((prev) => {
        const exists = prev.some((f) => f.id === verse.id);
        const next = exists
          ? prev.filter((f) => f.id !== verse.id)
          : [{ ...verse, savedAt: new Date().toISOString() }, ...prev];
        persistFavorites(next);
        return next;
      });
    },
    [persistFavorites]
  );

  const removeFavorite = useCallback(
    (verseId: number) => {
      setFavorites((prev) => {
        const next = prev.filter((f) => f.id !== verseId);
        persistFavorites(next);
        return next;
      });
    },
    [persistFavorites]
  );

  return (
    <FavoritesContext.Provider value={{ favorites, isFavorite, toggleFavorite, removeFavorite }}>
      {children}
    </FavoritesContext.Provider>
  );
}

export function useFavorites() {
  const context = useContext(FavoritesContext);
  if (!context) {
    throw new Error("useFavorites must be used within a FavoritesProvider");
  }
  return context;
}
