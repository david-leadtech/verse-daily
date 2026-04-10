# VerseDaily iOS - Claude Code Guide

## Project Overview

VerseDaily is an iOS devotional app built with SwiftUI, focused on reading and engaging with Scripture.

---

## Skills

### Biblical Theology Expert
**File:** `.claude/skills/BIBLICAL_THEOLOGY_EXPERT.md`

Apply this skill when:
- Refactoring Bible data models
- Designing Bible reading features
- Handling different Bible translations or canons
- Implementing verse storage/retrieval logic

**Key Principles:**
- Bible is not a single uniform text (multiple canons exist)
- Support for Protestant (66), Catholic (73), and Orthodox (75-81) canons
- Acknowledge translation variations (KJV, NIV, ESV, etc.)
- Respect theological sensitivity and accuracy

---

## Architecture

### Features
- **Bible**: Bible reading and navigation
- **Devotional**: Daily devotional content
- **Infrastructure**: Data access and mocking

### Key Models
- `BibleBook`: Represents a Bible book
- `Verse`: Represents a single verse
- `Testament`: Old/New Testament enum

---

## Refactoring Priorities

- [ ] Add Canon support to BibleBook model
- [ ] Add Translation abstraction
- [ ] Enhance BibleData.json with canonical metadata
- [ ] Add book categories (historical, poetic, prophetic)
