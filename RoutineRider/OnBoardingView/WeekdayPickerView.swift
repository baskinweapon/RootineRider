//
//  WeekdayPickerView.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 13/10/2024.
//

import SwiftUI

struct WeekdayPickerView: View {
    @Binding public var selectedDays: Set<String>
    
    // Дни недели
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        VStack {
            Text("Days when you track progress")
                .font(.headline)
                .padding()
            
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Button(action: {
                        toggleDaySelection(day: day)
                    }) {
                        Text(day.prefix(1)) // Отображение первых 3 букв дня
                            .padding()
                            .background(selectedDays.contains(day) ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                }
            }
        }
        .padding()
    }
    
    // Функция для обработки выбора дня
    private func toggleDaySelection(day: String) {
        if selectedDays.contains(day) {
            if selectedDays.count > 1 { // Проверяем, что хотя бы один день остается выбранным
                selectedDays.remove(day)
            }
        } else {
            selectedDays.insert(day)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekdayPickerView(selectedDays: <#Binding<Set<String>>#>)
//    }
//}
