import React, { createContext, useContext, useState, useEffect, useCallback } from "react";
import AsyncStorage from "@react-native-async-storage/async-storage";

interface OnboardingContextType {
  hasCompletedOnboarding: boolean | null;
  completeOnboarding: () => void;
}

const OnboardingContext = createContext<OnboardingContextType | undefined>(undefined);

const STORAGE_KEY = "@bible_onboarding_done";

export function OnboardingProvider({ children }: { children: React.ReactNode }) {
  const [hasCompletedOnboarding, setHasCompletedOnboarding] = useState<boolean | null>(null);

  useEffect(() => {
    (async () => {
      try {
        const value = await AsyncStorage.getItem(STORAGE_KEY);
        setHasCompletedOnboarding(value === "true");
      } catch {
        setHasCompletedOnboarding(false);
      }
    })();
  }, []);

  const completeOnboarding = useCallback(() => {
    setHasCompletedOnboarding(true);
    (async () => {
      try {
        await AsyncStorage.setItem(STORAGE_KEY, "true");
      } catch {}
    })();
  }, []);

  return (
    <OnboardingContext.Provider value={{ hasCompletedOnboarding, completeOnboarding }}>
      {children}
    </OnboardingContext.Provider>
  );
}

export function useOnboarding() {
  const context = useContext(OnboardingContext);
  if (!context) {
    throw new Error("useOnboarding must be used within an OnboardingProvider");
  }
  return context;
}
