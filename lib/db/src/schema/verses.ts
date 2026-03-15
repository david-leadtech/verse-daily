import { pgTable, text, serial, integer, date } from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod/v4";

export const versesTable = pgTable("verses", {
  id: serial("id").primaryKey(),
  book: text("book").notNull(),
  chapter: integer("chapter").notNull(),
  verseNumber: integer("verse_number").notNull(),
  text: text("text").notNull(),
  version: text("version").notNull().default("KJV"),
});

export const dailyVersesTable = pgTable("daily_verses", {
  id: serial("id").primaryKey(),
  verseId: integer("verse_id").notNull(),
  reflection: text("reflection").notNull(),
  date: date("date").notNull(),
});

export const devotionalsTable = pgTable("devotionals", {
  id: serial("id").primaryKey(),
  title: text("title").notNull(),
  content: text("content").notNull(),
  verseReference: text("verse_reference").notNull(),
  verseText: text("verse_text").notNull(),
  category: text("category").notNull(),
  readTime: integer("read_time").notNull().default(5),
  date: date("date").notNull(),
});

export const booksTable = pgTable("books", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  testament: text("testament").notNull(),
  chapters: integer("chapters").notNull(),
  ordering: integer("ordering").notNull(),
});

export const insertVerseSchema = createInsertSchema(versesTable).omit({ id: true });
export type InsertVerse = z.infer<typeof insertVerseSchema>;
export type Verse = typeof versesTable.$inferSelect;

export const insertDailyVerseSchema = createInsertSchema(dailyVersesTable).omit({ id: true });
export type InsertDailyVerse = z.infer<typeof insertDailyVerseSchema>;
export type DailyVerse = typeof dailyVersesTable.$inferSelect;

export const insertDevotionalSchema = createInsertSchema(devotionalsTable).omit({ id: true });
export type InsertDevotional = z.infer<typeof insertDevotionalSchema>;
export type Devotional = typeof devotionalsTable.$inferSelect;

export const insertBookSchema = createInsertSchema(booksTable).omit({ id: true });
export type InsertBook = z.infer<typeof insertBookSchema>;
export type Book = typeof booksTable.$inferSelect;
