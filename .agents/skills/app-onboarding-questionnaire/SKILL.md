---
name: app-onboarding-questionnaire
description: Analyze, design, implement, and verify a focused questionnaire-style onboarding demo for the Join Me iOS app. Use when the user asks about onboarding, first-launch experience, onboarding questions or copy, app introduction screens, personalization, or a functional onboarding demo for Join Me.
---

# Join Me onboarding

Design onboarding that lets a new user experience Join Me's core value: quickly finding a low-pressure, activity-first companion for something they want to do now.

## Start with repository context

1. Read every applicable `AGENTS.md` before acting.
2. Inspect the current conversation, existing onboarding files, `README.md`, product documents, models, store, and core views.
3. Treat `JoinMeStore` and its mock data as the single source of truth. Pass data through the view hierarchy; do not duplicate domain data inside views.
4. Summarize any existing onboarding decisions or implementation before continuing.
5. Ask only questions whose answers cannot be found locally and would materially change the result.

Do not create a progress or memory file unless the user explicitly requests one. Use the current task context and existing code as the source of implementation progress.

## Product framing

Keep these Join Me principles visible throughout the flow:

- Activity first, relationship second.
- Help users find someone for a clear activity, place, and time.
- Reduce the pressure of traditional dating or long-term social networking.
- Build trust through clear expectations, attendance history, punctuality, and mutual reviews.
- Make temporary interaction feel intentional: accepted participants get an activity chat, and the chat ends with the activity.

Frame the transformation as:

- Before: "I want to do something, but my friends are unavailable and meeting strangers feels uncertain or socially demanding."
- After: "I can quickly find a suitable, trustworthy companion for this specific activity without committing to a lasting relationship."

Validate this framing against the current repository and user direction. Do not treat wording here as immutable marketing copy.

## Choose the scope

Default to a classroom or hackathon prototype unless the user explicitly asks for production onboarding.

For a prototype:

- Use 5–7 screens and one coherent path.
- Keep all state in memory using Swift Observation.
- Reuse existing models, components, styling, and mock commissions.
- Do not add authentication, subscriptions, paywalls, analytics, a backend, migrations, or persistence.
- Do not add permission prompts unless they are essential to the demonstrated path.
- Do not fabricate testimonials, adoption numbers, conversion rates, or user statistics.
- Avoid building optional screens merely because the reference framework contains them.

For production scope, explicitly confirm any authentication, paywall, analytics, permissions, or persistence requirements before adding them.

## Design the transformation

Identify from the codebase:

- The primary target user.
- The reason they open Join Me now.
- Their main hesitation about joining an activity with unfamiliar people.
- The repeated core loop.
- The earliest believable aha moment.
- The smallest interaction that demonstrates value in 30–60 seconds.

Derive three or four concrete benefit statements from those findings. Lead with what the user gains, not with feature names.

## Build the blueprint

Use this compact sequence as the default, adapting it when repository evidence suggests a better flow:

1. **Welcome** — Show the desired end state and a real preview of the app.
2. **Activity goal** — Ask what the user wants company for; single select from real commission categories.
3. **Comfort or trust preference** — Ask what would make joining feel comfortable; collect only answers that affect the demo.
4. **Match preparation** — Briefly communicate that suitable activities are being selected. Keep any artificial wait short and skippable in tests.
5. **Functional demo** — Present relevant real mock commissions. Let the user inspect one and perform the core action, such as choosing or applying to join.
6. **Value delivery** — Show the tangible result: selected activity, request state, and what happens next.
7. **Enter Join Me** — Continue into the existing Explore experience.

Every collected answer must visibly affect a later screen. Remove questions whose answers go nowhere.

The demo must be interactive, not a feature tour. It must reuse real app concepts such as commission type, time, area, participant needs, host trust indicators, and join-request status.

## Draft screen content

For each proposed screen provide:

- Purpose.
- Short Traditional Chinese headline.
- Optional one-line supporting copy.
- Options or displayed data.
- CTA text that describes the next action.
- State captured and how it affects the demo.

Use natural Taiwanese Traditional Chinese. Keep copy concise, supportive, and free of marketing jargon. Avoid unnecessary instructions and placeholder explanations.

Present the blueprint and copy before implementation when the user asked to design or discuss first. If the user directly asks to build or change the app, proceed with reasonable assumptions and state them briefly.

## Implement in SwiftUI

1. Follow the existing architecture and `JoinMeStyle`.
2. Use `@Observable` and Swift Observation; do not introduce `ObservableObject`.
3. Keep onboarding answers in one model or the existing store, according to complexity.
4. Reuse existing domain types and mock data rather than hardcoding commissions in onboarding views.
5. Keep navigation explicit, allow back navigation where it does not invalidate completed state, and show lightweight progress.
6. Preserve the normal app entry path after onboarding completion.
7. Keep the implementation reversible for demos. Provide a launch argument or similarly simple test path when useful; do not add persistence without approval.
8. Modify only files necessary for the onboarding.

Prefer one onboarding feature file while the flow remains small. Split state, views, or reusable components only when the file becomes meaningfully complex or repetitive.

## Verify

1. Build the relevant iOS target.
2. Display and test the app only through the in-app browser provided by `serve-sim`, following repository instructions.
3. Exercise the complete onboarding path, including selections, back navigation, demo interaction, result, and transition to Explore.
4. Check compact and large simulator sizes for clipped copy, unsafe-area problems, and inaccessible controls.
5. Confirm onboarding uses store data and does not alter unrelated flows.
6. Report what was implemented, what was verified, and any intentionally deferred production work.

## Guardrails

- Never turn the flow into a generic carousel of feature screenshots.
- Never manufacture social proof.
- Never force a permission request before the user understands its contextual benefit.
- Never gate a prototype result behind a fake account or paywall.
- Never introduce persistence or backend infrastructure without explicit approval.
- Prefer the simplest flow that demonstrates one complete Join Me value loop.
