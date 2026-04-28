# Skill: Drill Generator

<!-- skill_meta
name: drill
description: Generate spaced-repetition practice drills from any topic or code snippet.
invoke: "create a drill for <topic>"
inputs:
  - topic: string         # subject matter
  - count: number         # number of questions, default 10
  - difficulty: string    # "easy" | "medium" | "hard"  (default: "medium")
  - format: string        # "mcq" | "fill" | "debug"    (default: "mcq")
outputs:
  - questions[]: { prompt, options?, answer, explanation }
-->

---

## What this skill does

Produces a set of targeted practice questions designed to reinforce recall
and expose gaps in knowledge — especially useful for:

- New team members onboarding to the codebase.
- Preparing for a technical interview.
- Learning a new framework or API.

---

## Question Formats

| Format | Description |
|--------|-------------|
| `mcq`  | Multiple-choice with 4 options, one correct |
| `fill` | Fill-in-the-blank code snippet |
| `debug`| Broken code snippet to identify and fix the bug |

---

## Output Schema

```json
{
  "topic": "React hooks",
  "difficulty": "medium",
  "questions": [
    {
      "index": 1,
      "format": "mcq",
      "prompt": "Which hook should you use to run a side effect after render?",
      "options": ["useState", "useEffect", "useCallback", "useMemo"],
      "answer": "useEffect",
      "explanation": "useEffect runs after every render by default and is the correct hook for side effects like data fetching."
    }
  ]
}
```

---

## Example invocation

> **User**: create a drill for "TypeScript generics", 5 questions, difficulty=hard, format=debug

Claude will produce 5 broken TypeScript snippets with generic-related bugs for the user to diagnose.
