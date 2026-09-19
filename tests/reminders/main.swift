import Foundation

// Regression coverage for the date filter. No personal reminders are read or saved.
let start = Date(timeIntervalSince1970: 1_700_000_000)
let end = start.addingTimeInterval(86_400)
let cases: [(String, Date?, Bool, Bool)] = [
    ("undated in all-reminders mode", nil, true, true),
    ("overdue in all-reminders mode", start.addingTimeInterval(-86_400), true, true),
    ("future in all-reminders mode", end.addingTimeInterval(86_400), true, true),
    ("undated in day mode", nil, false, false),
    ("previous day", start.addingTimeInterval(-1), false, false),
    ("start of day", start, false, true),
    ("within day", start.addingTimeInterval(3_600), false, true),
    ("next day boundary", end, false, false)
]
for (name, dueDate, allReminders, expected) in cases {
    let actual = CalendarService.includesReminder(dueDate: dueDate, from: start, to: end, allReminders: allReminders)
    precondition(actual == expected, name)
}
print("Passed \(cases.count) reminder date-filter regression checks.")
