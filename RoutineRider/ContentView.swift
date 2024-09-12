//
//  ContentView.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 27/08/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var lastDate: [TimeTracker]
    @Query var todos: [TodayTaskData]
    
    var body: some View {
        TabView {
            HomeView() // Main Page
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Main")
                }
            
            CalendarView() // Calendar
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            
            JournalView() // Journal
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Journal")
                }
            
            SettingsView() // Settings
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }.onAppear{
                _ = NotificationCenter.default.addObserver(
                forName: UIApplication.willEnterForegroundNotification,
                object: nil,
                queue: .main
            ) { (notification: Notification) in
                if UIApplication.shared.applicationState == .background {
                        // Logic after App open from background
                        checkForNewDay()
                    }
                }
            }
        }
    
    
    func checkForNewDay() {
        let now = Date()
        let calendar = Calendar.current
        
        // Проверяем, если текущий день отличается от последнего проверенного
        if (lastDate.isEmpty) {
            modelContext.insert(TimeTracker(Date: Date()))
        }
        
        if (lastDate.first == nil) { return }
        if !calendar.isDate(lastDate.first!.Date, inSameDayAs: now) {
            modelContext.delete(lastDate.first!)
            modelContext.insert(TimeTracker(Date: now))
            onNewDayStarted()
        }
    }
    
    func onNewDayStarted() {
        // Здесь ваша логика при наступлении нового дня
        print("Новый день начался: \(formattedDate(lastDate.first!.Date))")
        deleteAllItems(ofType: TodayTaskData.self, in: modelContext)
        modelContext.insert(JournalDayData(date: lastDate.first!.Date, text: ""))
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    func deleteAllItems<T: PersistentModel>(ofType type: T.Type, in context: ModelContext) {
        let fetchRequest = FetchDescriptor<T>()
        
        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                context.delete(item)
            }
            // Не забудьте сохранить контекст после удаления
            try context.save()
            print("Все элементы типа \(T.self) удалены.")
        } catch {
            print("Ошибка при удалении элементов: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TodayTaskData.self, inMemory: true)
}


