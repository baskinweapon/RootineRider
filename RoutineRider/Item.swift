//
//  Item.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 27/08/2024.
//

import Foundation
import SwiftData

// task for today
@Model
final class TodayTaskData {
//    var id: UUID
    var title: String
    var duration: Int
    var isCompleted: Bool
    var timeCreated: Date?
    
    init(title: String, timeCreated: Date?, duration: Int = 45, isCompleted: Bool = false) {
//        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.duration = duration
        self.timeCreated = timeCreated
    }
}

// all task mark as done
@Model
final class DoneTaskData {
    var id: UUID
    var title: String
    var durationTime: Int
    var isCompleted: Bool
    var timeCreated: Date?
    var dateTimeFinihed: Date?
    
    init(title: String, timeCreated: Date?, timeFinihed: Date? = nil,  duration: Int = 45, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.durationTime = duration
        self.dateTimeFinihed = timeFinihed
        self.timeCreated = timeCreated
    }
    
    public func IsTodayFinished() -> Bool {
        if let dateTimeFinihed = dateTimeFinihed {
            return Calendar.current.isDateInToday(dateTimeFinihed)
        }
        return false
    }
}

// when user create new task - we save it as template 
@Model
final class TempalteTaskData {
    var id: UUID
    var title: String
    var duration: Int
    var isCompleted: Bool
    var dateTimeFinihed: Date?
    var usedCount: Int?
    
    init(title: String, timeFinihed: Date? = nil, duration: Int, isCompleted: Bool = false, usedCount: Int = 0) {
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.duration = duration
        self.dateTimeFinihed = timeFinihed
        self.usedCount = usedCount
    }
}

@Model
final class JournalDayData {
    var date: Date
    var text: String
        
    init(date: Date, text: String) {
        self.date = date
        self.text = text
    }
}

@Model
final class TimeTracker {
    var Date: Date
    
    init(Date: Date) {
        self.Date = Date
    }
}


