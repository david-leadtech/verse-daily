import { Router, type IRouter } from "express";
import healthRouter from "./health";
import versesRouter from "./verses";
import devotionalsRouter from "./devotionals";

const router: IRouter = Router();

router.use(healthRouter);
router.use(versesRouter);
router.use(devotionalsRouter);

export default router;
