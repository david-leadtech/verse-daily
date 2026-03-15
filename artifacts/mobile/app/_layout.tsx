import {
  Inter_400Regular,
  Inter_500Medium,
  Inter_600SemiBold,
  Inter_700Bold,
  useFonts as useInterFonts,
} from "@expo-google-fonts/inter";
import {
  PlayfairDisplay_400Regular,
  PlayfairDisplay_400Regular_Italic,
  PlayfairDisplay_700Bold,
  useFonts as usePlayfairFonts,
} from "@expo-google-fonts/playfair-display";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Stack } from "expo-router";
import * as SplashScreen from "expo-splash-screen";
import React, { useEffect, useRef, useState } from "react";
import { Animated, Easing, StyleSheet } from "react-native";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { KeyboardProvider } from "react-native-keyboard-controller";
import { SafeAreaProvider } from "react-native-safe-area-context";

import { ErrorBoundary } from "@/components/ErrorBoundary";
import SplashLoader from "@/components/SplashLoader";
import OnboardingFlow from "@/components/OnboardingFlow";
import DivineOfferReveal from "@/components/DivineOfferReveal";
import PaywallWeekly from "@/components/PaywallWeekly";
import PaywallAnnual from "@/components/PaywallAnnual";
import { FavoritesProvider } from "@/contexts/FavoritesContext";
import { SettingsProvider } from "@/contexts/SettingsContext";
import { OnboardingProvider, useOnboarding } from "@/contexts/OnboardingContext";

SplashScreen.preventAutoHideAsync();

const queryClient = new QueryClient();

function RootLayoutNav() {
  return (
    <Stack screenOptions={{ headerShown: false }}>
      <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
      <Stack.Screen
        name="settings"
        options={{ headerShown: false, presentation: "modal" }}
      />
      <Stack.Screen
        name="devotional/[id]"
        options={{ headerShown: false }}
      />
      <Stack.Screen
        name="subscription"
        options={{ headerShown: false, presentation: "modal" }}
      />
    </Stack>
  );
}

type AppPhase = "splash" | "onboarding" | "divine-offer" | "paywall-weekly" | "paywall-annual" | "app";

function AppGate() {
  const { hasCompletedOnboarding, completeOnboarding } = useOnboarding();
  const [phase, setPhase] = useState<AppPhase>("splash");
  const splashDoneRef = useRef(false);
  const dataReadyRef = useRef(false);
  const [showSplashOverlay, setShowSplashOverlay] = useState(false);
  const splashFadeOut = useRef(new Animated.Value(1)).current;

  const transitionFromSplash = React.useCallback((nextPhase: AppPhase) => {
    setShowSplashOverlay(true);
    setPhase(nextPhase);
    Animated.timing(splashFadeOut, {
      toValue: 0,
      duration: 400,
      easing: Easing.in(Easing.ease),
      useNativeDriver: true,
    }).start(() => {
      setShowSplashOverlay(false);
    });
  }, [splashFadeOut]);

  const tryTransition = React.useCallback(() => {
    if (!splashDoneRef.current || !dataReadyRef.current) return;
    if (hasCompletedOnboarding) {
      transitionFromSplash("app");
    } else {
      transitionFromSplash("onboarding");
    }
  }, [hasCompletedOnboarding, transitionFromSplash]);

  useEffect(() => {
    if (hasCompletedOnboarding === null) return;
    dataReadyRef.current = true;
    tryTransition();
  }, [hasCompletedOnboarding, tryTransition]);

  const handleSplashComplete = React.useCallback(() => {
    if (splashDoneRef.current) return;
    splashDoneRef.current = true;
    tryTransition();
  }, [tryTransition]);

  useEffect(() => {
    const timeout = setTimeout(() => {
      if (!splashDoneRef.current) {
        handleSplashComplete();
      }
    }, 4000);
    return () => clearTimeout(timeout);
  }, [handleSplashComplete]);

  const renderContent = () => {
    if (phase === "splash") {
      return <SplashLoader onAnimationComplete={handleSplashComplete} />;
    }

    if (phase === "onboarding") {
      return (
        <OnboardingFlow
          onComplete={() => setPhase("divine-offer")}
        />
      );
    }

    if (phase === "divine-offer") {
      return (
        <DivineOfferReveal
          onContinue={() => setPhase("paywall-weekly")}
        />
      );
    }

    if (phase === "paywall-weekly") {
      return (
        <PaywallWeekly
          onClose={() => {
            completeOnboarding();
            setPhase("app");
          }}
          onSkipToAnnual={() => setPhase("paywall-annual")}
        />
      );
    }

    if (phase === "paywall-annual") {
      return (
        <PaywallAnnual
          onClose={() => {
            completeOnboarding();
            setPhase("app");
          }}
        />
      );
    }

    return <RootLayoutNav />;
  };

  return (
    <>
      {renderContent()}
      {showSplashOverlay && (
        <Animated.View
          style={[
            StyleSheet.absoluteFillObject,
            { opacity: splashFadeOut, zIndex: 100 },
          ]}
          pointerEvents="none"
        >
          <SplashLoader />
        </Animated.View>
      )}
    </>
  );
}

export default function RootLayout() {
  const [interLoaded, interError] = useInterFonts({
    Inter_400Regular,
    Inter_500Medium,
    Inter_600SemiBold,
    Inter_700Bold,
  });

  const [playfairLoaded, playfairError] = usePlayfairFonts({
    PlayfairDisplay_400Regular,
    PlayfairDisplay_400Regular_Italic,
    PlayfairDisplay_700Bold,
  });

  const fontsReady = (interLoaded || interError) && (playfairLoaded || playfairError);

  useEffect(() => {
    if (fontsReady) {
      SplashScreen.hideAsync();
    }
  }, [fontsReady]);

  if (!fontsReady) return null;

  return (
    <SafeAreaProvider>
      <ErrorBoundary>
        <QueryClientProvider client={queryClient}>
          <SettingsProvider>
            <FavoritesProvider>
              <OnboardingProvider>
                <GestureHandlerRootView>
                  <KeyboardProvider>
                    <AppGate />
                  </KeyboardProvider>
                </GestureHandlerRootView>
              </OnboardingProvider>
            </FavoritesProvider>
          </SettingsProvider>
        </QueryClientProvider>
      </ErrorBoundary>
    </SafeAreaProvider>
  );
}
