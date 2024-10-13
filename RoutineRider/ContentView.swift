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
//    @Query var lastDate: [TimeTracker]
    @Query var tasks: [TodayTaskData]
    @Query var journal : [JournalDayData]
    @Query var templates: [TempalteTaskData]
    @Query var appData: [AppData]
    
    @State var isShowingOnboarding: Bool = false
    
    init () {
        if appData.isEmpty {
            isShowingOnboarding.toggle()
        }
    }
    
    var body: some View {
        if (appData.isEmpty) {
            OnboardingView()
        } else {
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
                if (journal.isEmpty) {
                    print("Add new journal day")
                    modelContext.insert(JournalDayData(date: Date(), text: ""))
                }
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
            }.task {
                await addEmojiToTask()
                addCategories()
                checkForNewDay()
            }.sheet(isPresented: $isShowingOnboarding) {
                OnboardingView()
            }
        }
        
        
    }
    
    func addCategories() {
        for task in tasks {
            task.tag = templates.first(where: { $0.title == task.title && $0.duration == task.duration })?.tag
        }
    }
    
    func addEmojiToTask() async {
        for template in templates {
            if (template.emoji == nil) {
                template.emoji = await AI().getTaskEmojie(template.title)
                if (template.emoji?.count ?? 0 > 1) {
                    template.emoji = nil
                }
            }
        }
        
        for task in tasks {
            task.emoji = templates.first(where: { $0.title == task.title && $0.emoji != nil && $0.duration == task.duration })?.emoji
        }
    }
    
    func checkForNewDay() {
        let now = Date()
        let calendar = Calendar.current
        
        // Проверяем, если текущий день отличается от последнего проверенного
        if (journal.isEmpty) {
            modelContext.insert(JournalDayData(date: now, text: ""))
            try? modelContext.save()
        }
        
        if !calendar.isDate(journal.last!.date, inSameDayAs: now) {
            onNewDayStarted(date: now)
        }
    }
    
    func onNewDayStarted(date: Date) {
        deleteAllItems(ofType: TodayTaskData.self, in: modelContext)
        
        modelContext.insert(JournalDayData(date: date, text: ""))
        try? modelContext.save()
        print("Новый день начался: \(formattedDate(journal.last!.date))")
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


