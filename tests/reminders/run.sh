#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/../.."
reminder_test_dir=$(mktemp -d)
trap 'rm -rf "$reminder_test_dir"' EXIT
xcrun swiftc -module-cache-path "$reminder_test_dir/cache" \
    boringNotch/models/CalendarModel.swift \
    boringNotch/models/EventModel.swift \
    boringNotch/Providers/CalendarServiceProviding.swift \
    tests/reminders/main.swift -o "$reminder_test_dir/reminders"
"$reminder_test_dir/reminders"
