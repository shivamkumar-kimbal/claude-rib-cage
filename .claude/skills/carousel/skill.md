# Skill: Carousel Generator

<!-- skill_meta
name: carousel
description: Auto-generate Instagram / LinkedIn carousel slide decks from a topic or outline.
invoke: "generate a carousel about <topic>"
inputs:
  - topic: string        # main subject
  - slides: number       # default 7
  - style: string        # "edu" | "story" | "tips"  (default: "edu")
outputs:
  - slides[]: { headline, body, cta }
-->

---

## What this skill does

Given a topic, this skill produces a structured carousel deck — ready to paste
into a design tool (Canva, Figma) or a social scheduling platform.

---

## Process

1. **Research phase** — summarise the topic in 3–5 key points.
2. **Structure phase** — map points to the slide schema below.
3. **Copy phase** — write punchy, scannable text for each slide.
4. **Output phase** — return JSON + a markdown preview.

---

## Slide Schema

```json
{
  "slides": [
    {
      "index": 1,
      "type": "hook",
      "headline": "< 8 words, curiosity-driven",
      "body": "1–2 sentences max",
      "cta": null
    },
    {
      "index": 2,
      "type": "content",
      "headline": "Key point headline",
      "body": "Explanation in plain language",
      "cta": null
    },
    {
      "index": 7,
      "type": "cta",
      "headline": "Actionable closing line",
      "body": "Brief recap",
      "cta": "Follow for more · Save this post"
    }
  ]
}
```

---

## Example invocation

> **User**: generate a carousel about "the 5 laws of clean code" with 6 slides, style=tips

**Claude** will:
1. Identify 5 clean-code laws (SRP, DRY, KISS, YAGNI, naming).
2. Create hook slide + 4 tip slides + CTA slide.
3. Return JSON and a markdown table preview.
