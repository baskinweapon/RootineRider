//
//  TodayTaskView.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 19/09/2024.
//

import SwiftUICore
import SwiftUI
import _SwiftData_SwiftUI

struct TodayTasksView: View {
    @State public var categories: String
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodayTaskData.isCompleted, order: .forward) var TodoItems: [TodayTaskData]
  
    @Query var finishTasks: [DoneTaskData]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(TodoItems) { task in
                        TaskCellView(task: task)
                    }
                    .onDelete(perform: deleteTask)
                }
                
                Spacer()        
            }.navigationTitle(categories)
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                TodoItems[index].isCompleted.toggle()
                deleteAlreadyFinishedTask(task: TodoItems[index])
                modelContext.delete(TodoItems[index])
            }
        }
    }
    
    func deleteAlreadyFinishedTask(task: TodayTaskData) {
        withAnimation {
            let finishTask = finishTasks.first(where: {
                $0.title == task.title &&
                $0.durationTime == task.duration &&
                $0.timeCreated == task.timeCreated  })
            guard let finishTask else { return }
            modelContext.delete(finishTask)
        }
    }
}
