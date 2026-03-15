import React from "react";
import { StyleSheet, Text, View, Pressable } from "react-native";
import Colors from "@/constants/colors";

interface SectionHeaderProps {
  title: string;
  actionText?: string;
  onAction?: () => void;
}

export default function SectionHeader({ title, actionText, onAction }: SectionHeaderProps) {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>{title}</Text>
      {actionText && onAction && (
        <Pressable onPress={onAction} hitSlop={8}>
          <Text style={styles.action}>{actionText}</Text>
        </Pressable>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    paddingHorizontal: 20,
    marginBottom: 12,
    marginTop: 8,
  },
  title: {
    fontSize: 20,
    fontFamily: "Inter_700Bold",
    color: Colors.light.text,
  },
  action: {
    fontSize: 14,
    fontFamily: "Inter_600SemiBold",
    color: Colors.light.tint,
  },
});
