//
//  DebugView.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 16/09/2024.
//

import SwiftUI
import _SwiftData_SwiftUI

struct DebugView: View {
    // Ваша модельная среда (предполагаю, что у вас есть модельный объект для отладки)
    @Environment(\.modelContext) private var modelContext
    @Query var journalDays: [JournalDayData]
    @Query var template: [TempalteTaskData]
    @Query var appData: [AppData]
    @Query var challengeData: [ChallengeData]
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Journal Data")
                    .font(.title)
                    .padding(.bottom, 10)
                
                List() {
                    ForEach(journalDays) { journalDay in
                        Text(CompetitionInfo.dateString(from: journalDay.date))
                        Text(journalDay.text)
                    }.onDelete(perform: deleteJournal)
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Templates Data")
                    .font(.title)
                    .padding(.bottom, 10)
                
                List() {
                    ForEach(template) { temp in
                        HStack {
                            Text(temp.title)
                            Text(temp.emoji ?? "nil")
                            Text(temp.tag ?? "nil")
                        }
                        
                    }.onDelete(perform: deleteTemplates)
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("App Data")
                    .font(.title)
                    .padding(.bottom, 10)
                
                List() {
                    ForEach(appData) { temp in
                        HStack {
                            Text(temp.needShowOnboarding == true ? "true" : "false")
                        }
                        
                    }.onDelete(perform: deleteAppData)
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Challenge Data")
                    .font(.title)
                    .padding(.bottom, 10)
                
                List() {
                    ForEach(challengeData) { temp in
                        HStack {
                            Text(" \(temp.startDate) - \(temp.endDate) ")
                        }
                        
                    }.onDelete(perform: deleteChallengeData)
                }
            }
            .padding()
        }
        
    }
    
    func deleteJournal(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(journalDays[index])
            }
        }
    }
    
    func deleteTemplates(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(template[index])
            }
        }
    }
    
    func deleteAppData(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(appData[index])
            }
        }
    }
    
    func deleteChallengeData(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(challengeData[index])
            }
        }
    }
}

