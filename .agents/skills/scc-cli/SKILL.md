---
name: scc-cli
description: Use when you need to submit or manage projects for SCC via the SCC CLI. Triggers for tasks like "submit my app to SCC", "validate my SCC submission", or "check SCC project status".
---

# SCC CLI Skill

The `scc-cli` is a command-line tool built to manage submissions to SCC events.

## Core Workflow
1. **Initialize**: `npx scc-cli init` (creates `.scc/submission.yaml`)
2. **Authenticate**: `npx scc-cli auth login` (requires user to input email/password)
3. **Pull Data**: `npx scc-cli pull` (downloads existing remote data into local yaml)
4. **Populate and Localize**: Edit `.scc/submission.yaml`, complete both `localizations.zh-TW` and `localizations.en`, and add 1 to 5 screenshots (10MB max each) to `.scc/media/screenshots/`
5. **Validate**: Run `npx scc-cli validate`; localization must pass before submission
6. **Preview**: `npx scc-cli preview`
7. **Submit**: First run `npx scc-cli submit --dry-run`, then `npx scc-cli submit --confirm`
8. **Check Status**: `npx scc-cli status`

## Best Practices for AI
- **CRITICAL**: Before making any edits to `.scc/submission.yaml` or running a submit command on a user's behalf, you MUST run `npx scc-cli pull` to fetch the latest remote data.
- **Instruct and Guide**: Proactively instruct the user to finish providing all required project details (App Name, Team Name, Category, Intro, App Icon, Screenshots). Explain that edits to `.scc/submission.yaml` are saved temporarily on their local machine, and they can safely edit without affecting the live site.
- **Localization Required**: Before validation or submission, ensure `.scc/submission.yaml` contains completed Traditional Chinese (`localizations.zh-TW.name`, `localizations.zh-TW.intro`) and English (`localizations.en.name`, `localizations.en.intro`) content. If one language is missing, offer to draft a translation, then ask the user to review and approve it.
- **Check Completeness**: Before running `scc submit --confirm`, ensure all required fields are filled out. Note: The demo video URL is strictly optional, but poster_site is required.
- **Screenshot Limit**: Every submission requires 1 to 5 screenshots. Each local icon or screenshot must be 10MB or smaller.
- **Event Selection**: `event` in `submission.yaml` or `scc submit --event <name|slug|id>` must match the event assigned to the signed-in account.
- **Confirm Before Submission**: ALWAYS explicitly ask the user "Have you reviewed both Traditional Chinese and English text, and are you ready to submit and publish these changes to the server?" before running `scc submit --confirm`.
- If the remote data has existing content, you MUST ask the user for explicit confirmation before overwriting their existing content locally.
- When a user asks you to update their submission details, you should edit `.scc/submission.yaml` after pulling.
- **Handling Validation Failures**: When validation fails, actively propose fixes for text fields (e.g. shortening the intro). However, if an image (like the App Icon or screenshots) is missing, you MUST ask the user to provide the image. Do NOT generate placeholder images or copy other images to bypass validation, unless the user explicitly instructs you to do so.
- Do NOT manually upload files via curl/API; ALWAYS use the `scc submit` command.
