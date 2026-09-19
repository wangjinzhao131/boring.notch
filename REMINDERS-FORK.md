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
