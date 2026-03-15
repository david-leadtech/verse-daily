import React, { createContext, useContext, useState, useEffect, useCallback } from "react";
import AsyncStorage from "@react-native-async-storage/async-storage";

interface Settings {
  bibleVersion: string;
  notificationsEnabled: boolean;
  notificationTime: string;
  isPremium: boolean;
}

interface SettingsContextType {
  settings: Settings;
  updateSettings: (updates: Partial<Settings>) => void;
}

const defaultSettings: Settings = {
  bibleVersion: "KJV",
  notificationsEnabled: true,
  notificationTime: "08:00",
  isPremium: false,
};

const SettingsContext = createContext<SettingsContextType | undefined>(undefined);

const STORAGE_KEY = "@bible_settings";

export function SettingsProvider({ children }: { children: React.ReactNode }) {
  const [settings, setSettings] = useState<Settings>(defaultSettings);

  useEffect(() => {
    (async () => {
      try {
        const data = await AsyncStorage.getItem(STORAGE_KEY);
        if (data) {
          const parsed = JSON.parse(data);
          if (parsed && typeof parsed === "object") {
            setSettings({ ...defaultSettings, ...parsed });
          }
        }
      } catch {
        // ignore corrupted storage
      }
    })();
  }, []);

  const updateSettings = useCallback(
    (updates: Partial<Settings>) => {
      setSettings((prev) => {
        const next = { ...prev, ...updates };
        (async () => {
          try {
            await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(next));
          } catch {
            // storage write failed silently
          }
        })();
        return next;
      });
    },
    []
  );

  return (
    <SettingsContext.Provider value={{ settings, updateSettings }}>
      {children}
    </SettingsContext.Provider>
  );
}

export function useSettings() {
  const context = useContext(SettingsContext);
  if (!context) {
    throw new Error("useSettings must be used within a SettingsProvider");
  }
  return context;
}
