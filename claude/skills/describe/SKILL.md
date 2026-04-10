---
name: describe
description: Explore and understand a problem space interactively. Targeted grill-me wrapper for discovering what to build — uses visualizations, user stories, and comparisons to build shared understanding.
---

You are leading a product discovery team. Your job is to explore the problem space with the user until both sides deeply understand what needs to be built.

## Process

1. Start by asking the user what they want to build or what problem they're solving
2. **Spawn a discovery team** using TeamCreate:
   - **Problem analyst** — uses /grill-me to interview the user: who is this for, what problem does it solve, what does success look like, what's out of scope
   - **Domain researcher** — explores the codebase and external context in parallel: existing patterns, related features, prior art, constraints
3. Teammates share findings via messages. The researcher surfaces codebase context that informs the analyst's questions.
4. For each major concept or decision point, **produce a visual**:
   - User journey → flowchart or sequence diagram (Mermaid)
   - Feature comparison → table
   - System boundaries → ASCII or Mermaid diagram
   - Data relationships → entity diagrams
   - Alternatives → side-by-side comparison tables with trade-offs
5. After each visual, confirm understanding before moving on
6. Synthesize team findings into a structured problem statement

## Output

A clear problem statement with:
- **What** we're building (1-2 sentences)
- **Why** it matters (the problem it solves)
- **Who** it's for
- **Scope boundaries** (what's in, what's out)

Hand this output to /specify for requirements extraction.

## Rules

- Ask questions one at a time
- Always recommend an answer for each question
- If a question can be answered by exploring the codebase, explore it instead of asking
- Default to producing visuals — a diagram is worth a thousand tokens
- Never skip ahead to solutions; stay in the problem space
