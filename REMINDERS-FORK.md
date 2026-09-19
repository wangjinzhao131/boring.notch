# All-reminders mode

This fork defaults to **All reminders (no calendar)** in Settings → Calendar.
Enable **Show calendar / reminders**, then choose the reminder lists to display.

- Shows dated, overdue, future and undated reminders from the selected lists.
- Replaces the calendar date wheel with a reminders heading and visible count.
- Sorts dated tasks by due date, followed by undated tasks; shows each task's list.
- Keeps completion and opening the task as separate buttons.
- Respects Hide completed reminders. Calendar events are omitted in this mode.
- Turning off all-reminders mode restores the original selected-day calendar view.
- Selecting no lists leaves the panel empty.

This changes the display only; task dates are never modified. Completion still
writes through EventKit, as in upstream. System reminder access is required.

## Validation

Run `bash tests/reminders/run.sh` for date-filter regression checks without
reading or changing personal reminders.

Build the macOS app using Xcode 26 or later:

```sh
xcodebuild -project boringNotch.xcodeproj -scheme boringNotch \
  -configuration Debug -derivedDataPath build CODE_SIGNING_ALLOWED=NO build
```

Manual check: open the notch with an undated, overdue and future task in selected
lists; all should appear. Toggle completion on a disposable test task, and check
that it changes in Apple Reminders. Deselect all lists and verify an empty panel.

## Category bar and collapse control

The reminder panel has a horizontally scrolling category bar with All and each
selected reminder list, including visible task counts. Selecting a category
filters the task list below. The chevron collapses or expands task content while
keeping categories available. The selected category and expansion state persist.
Calendar mode retains its existing date selector.

Validation: macOS Debug build, ad-hoc signature verification, and the eight
existing reminder date-filter regression checks pass. The updated app has been
installed locally. Floating-window capture currently exposes only the closed
notch, so live category switching and collapse interactions remain unverified.

### Category refresh fix

Categories now combine selected reminder lists with the lists represented by
loaded reminder tasks, deduplicated by list ID. Opening the panel refreshes the
list snapshot as well as tasks. The category scroll view has a fixed 28-point
height. Three new regression checks cover a stale/empty list snapshot,
deduplication while retaining empty selected lists, and a fully empty result.

### Startup authorization and expanded capacity

Check reminder authorization at startup, not only when opening Settings. Live
accessibility inspection confirmed 30 loaded reminders across three selected
lists after this change. Selecting a category now expands its content; the
collapse button has an explicit text label. Expanded reminder content is 300
points tall instead of 120, with a 370-point outer panel. Collapsing returns the
outer panel to 190 points. The host window accommodates either size.

### Compact layout (supersedes expanded capacity above)

Restored the original 190-point outer panel and 120-point reminder area.
Reminder-only mode uses a scrolling stack with compact 24-point minimum rows,
single-line titles and a full-title/list tooltip. Redundant list subtitles and
undated labels are omitted; due dates remain visible. Category switching still
expands content, and the explicit collapse control remains. macOS build and
signature verification passed; exact on-screen capacity has not been verified.

## Ongoing upstream maintenance

`feat/all-reminders` is the default branch and retains the custom features.
`main` mirrors official main using fast-forward pushes only. The **Sync official
upstream** workflow checks daily at 09:23 Asia/Shanghai (GitHub may delay scheduled
runs) and supports Run workflow manually. It updates `sync/upstream` and opens or
reuses a PR into the custom branch. Never reset the custom branch to upstream.

The same sync run calls **Custom reminders build**, validates the actual merge,
runs reminder filtering/category tests, and builds/signs/packages the app. This
avoids relying on a bot-created PR to trigger another workflow. Conflicts fail
validation and require manual resolution. Review the sync run linked in the PR
and visually check categories, completion, collapse and compact layout before
merging. Nothing is auto-merged or installed. After merging, the custom branch
build produces the final ZIP in Actions artifacts (retained 30 days).

Packages use ad-hoc signing, not Apple notarization. Keep using this fork's builds;
installing an official in-app update can replace the custom features. GitHub can
disable scheduled workflows in inactive public repositories after 60 days;
re-enable in Actions or run manually if that happens.
