---
description: Review UI from a screenshot - paste an image and get design feedback
---

# UI Screenshot Review

The user will paste a screenshot of their UI. Analyze it and provide actionable feedback.

## Context
- Assume modern component-based UI frameworks (React, Vue, etc.)
- Styling is likely Tailwind CSS or similar utility-first CSS
- Target: clean, professional, minimal UI
- Both light and dark mode should be considered

## Analysis Checklist

### Visual Design
1. **Spacing & Alignment** - Are elements properly aligned? Consistent padding/margins?
2. **Typography** - Font sizes appropriate? Hierarchy clear?
3. **Color Usage** - Good contrast? Consistent color palette?
4. **Visual Balance** - Nothing feels cramped or too sparse?

### UX Issues
1. **Clarity** - Is the purpose of each element obvious?
2. **Interaction hints** - Are clickable elements clearly clickable?
3. **Information density** - Too much? Too little?
4. **Error states** - How would errors display here?

### Technical Suggestions
For each issue, suggest specific CSS classes or component patterns.

## Output Format

```
## Overall Impression
[1-2 sentences]

## Issues Found
1. [ISSUE]: Description
   **Fix**: Specific code/class suggestion

2. [ISSUE]: Description
   **Fix**: Specific code/class suggestion

## Quick Wins
- Bullet list of easy improvements

## Optional Enhancements
- Nice-to-haves if time permits
```

Be direct and specific. Skip praise - focus on actionable improvements.
