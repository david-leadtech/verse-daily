import { Router, type IRouter } from "express";
import { db } from "@workspace/db";
import { devotionalsTable } from "@workspace/db/schema";
import { eq, sql } from "drizzle-orm";

const router: IRouter = Router();

function clampInt(value: unknown, defaultVal: number, min: number, max: number): number {
  const n = Number(value);
  if (isNaN(n) || n < min) return defaultVal;
  return Math.min(Math.floor(n), max);
}

router.get("/devotionals", async (req, res) => {
  try {
    const { category } = req.query;
    const limit = clampInt(req.query.limit, 10, 1, 100);
    const offset = clampInt(req.query.offset, 0, 0, 100000);

    const whereClause = category && typeof category === "string"
      ? eq(devotionalsTable.category, category)
      : undefined;

    const devotionals = await db
      .select()
      .from(devotionalsTable)
      .where(whereClause)
      .limit(limit)
      .offset(offset)
      .orderBy(sql`${devotionalsTable.date} DESC`);

    const countResult = await db
      .select({ count: sql<number>`count(*)` })
      .from(devotionalsTable)
      .where(whereClause);

    res.json({
      devotionals,
      total: Number(countResult[0]?.count ?? 0),
    });
  } catch (error) {
    console.error("Error getting devotionals:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

router.get("/devotionals/:id", async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (isNaN(id) || id <= 0) {
      res.status(400).json({ error: "Invalid devotional ID" });
      return;
    }

    const devotional = await db
      .select()
      .from(devotionalsTable)
      .where(eq(devotionalsTable.id, id))
      .limit(1);

    if (devotional.length === 0) {
      res.status(404).json({ error: "Devotional not found" });
      return;
    }

    res.json(devotional[0]);
  } catch (error) {
    console.error("Error getting devotional:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
