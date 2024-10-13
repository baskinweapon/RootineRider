//
//  RoutineRiderApp.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 27/08/2024.
//

import SwiftUI
import SwiftData

@main
struct RoutineRiderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TodayTaskData.self,
            DoneTaskData.self,
            TempalteTaskData.self,
            JournalDayData.self,
            ChallengeData.self,
            AppData.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView().modelContainer(sharedModelContainer)
        }
    }

}
