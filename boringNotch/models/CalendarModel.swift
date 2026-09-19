//
//  CalendarModel.swift
//  Calendr
//
//  Created by Paker on 31/12/20.
//  Original source: https://github.com/pakerwreah/Calendr
//

import Cocoa

struct CalendarModel: Equatable {
    let id: String
    let account: String
    let title: String
    let color: NSColor
    let isSubscribed: Bool
    let isReminder: Bool // true if this is a reminder calendar
}

// Preserve empty selected lists, and include categories already represented by
// fetched tasks even while the EventKit list snapshot is catching up.
extension CalendarModel {
    static func reminderCategories(selectedLists: [CalendarModel], taskLists: [CalendarModel]) -> [CalendarModel] {
        var seen = Set<String>()
        return (selectedLists + taskLists).filter { seen.insert($0.id).inserted }
    }
}
