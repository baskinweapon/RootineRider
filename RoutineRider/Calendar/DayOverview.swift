//
//  DayOverview.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 13/09/2024.
//

import SwiftUI
import _SwiftData_SwiftUI

struct DayOverviewView: View {
    @Binding public var date: Date
    @Query var doneTask: [DoneTaskData]
    
    var body: some View {
        VStack {
            Text(CompetitionInfo.dateString(from: date)).padding()
            
            let tasks = doneTask.filter { Calendar.current.isDate($0.dateTimeFinihed!, equalTo: date, toGranularity: .day) }
            List(tasks) { task in
                HStack {
                    Text(task.emoji ?? "")
                    Text(task.title)
                    Spacer()
                    Text("⏱️ " + String(task.durationTime) + " min")
                }
            }
            
            HStack(spacing: 20) {
                Text("Done: \(tasks.count)")
                    .font(.caption2)
                    .bold()
                    

                let fullTime = tasks.reduce(0) { $0 + $1.durationTime }
                Text("Spent: \(timeString(from: fullTime))")
                    .font(.caption2)
                
            }
            
            FractalPattern(iteraction: CGFloat(tasks.count), phases: CGFloat(tasks.count)).frame(maxWidth: 1000, maxHeight: 1000)
        }
       
    }
    
    func timeString(from minutes: Int) -> String {
        let hours = minutes / 60
        let minutes = minutes % 60
        return String(format: "%02dh %02dm", hours, minutes)
    }
}
