//
//  CustomDayView.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 09/10/2024.
//

import MijickCalendarView
import Foundation
import SwiftUI
import _SwiftData_SwiftUI

struct СustomDayView: DayView {
    @Environment(\.modelContext) private var modelContext
    let date: Date
    let isCurrentMonth: Bool
    let selectedDate: Binding<Date?>?
    let selectedRange: Binding<MDateRange?>?
}

extension СustomDayView {
    func createDayLabel() -> AnyView {
        ZStack {
            createDayLabelText()
        }
        .erased() // cast to AnyView
    }
 }

private extension СustomDayView {
    func createBackgroundView() -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.purple)
    }
    
    func createDayTaskView(taskCount: Int, isToday: Bool) -> some View {
        return ZStack {
            // Основное содержимое ячейки
            VStack {
                Spacer()
                var fetchDesc = FetchDescriptor<DoneTaskData>()
                
                // Центральный текст с с количеством тасок
                Text(String(taskCount))
                    .font(.system(size: 16, weight: .bold)).frame(maxWidth: .infinity)
                
                Text(CompetitionInfo.taskCompletionDescription(count: taskCount))
                    .font(.system(size: 11, weight: .light)).padding(.bottom, 6)
            }
            .background(CompetitionInfo.taskCompletionDescriptionColor(count: taskCount))
            
            // Число месяца в правом верхнем углу
            VStack {
                HStack {
                    Spacer()
                    let day = Calendar.current.dateComponents([.day], from: date)
                    Text(String(day.day!))
                        .font(.system(size: 8, weight: .light))
                        .foregroundColor(isToday ? Color.black : Color.gray)
                        .padding(.trailing, 6)
                        .padding(.top, 4)
                }
                Spacer()
            }
        }
    }
    
    func createDayLabelText() -> some View {
        return createDayTaskView(taskCount: 5, isToday: isToday())
    }
}
