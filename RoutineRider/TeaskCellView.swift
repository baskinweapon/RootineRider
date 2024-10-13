//
//  TeaskCellView.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 18/09/2024.
//

import SwiftUI
import _SwiftData_SwiftUI

struct TaskCellView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodayTaskData.isCompleted, order: .forward) var TodoItems: [TodayTaskData]
    @Query var finishTasks: [DoneTaskData]
    @State var task: TodayTaskData
//    var emoji: String
//    var title: String
//    var time: String

    var body: some View {
        
        NavigationLink(destination: TaskOverview()) {
            HStack(spacing: 16) {
                // Emoji слева
                Text(task.emoji ?? "")
                    .font(.system(size: 40))
                    .frame(width: 50, height: 50)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                
                // Название и время справа
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.headline)
                        .bold()
                        .strikethrough(task.isCompleted, color: .gray)
                        .foregroundColor(task.isCompleted ? .gray : .primary)
                    
                    Text("⏱️ \(task.duration)min")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if task.isCompleted {
                    Image(systemName: "checkmark.square.fill")
                        .foregroundColor(.green)
                        .imageScale(.large).onTapGesture {
                            toggleTaskCompletion(task: task)
                        }
                } else {
                    Image(systemName: "square")
                        .foregroundColor(.gray)
                        .imageScale(.large).onTapGesture {
                            toggleTaskCompletion(task: task)
                        }
                }
            }
            .padding(12)
//            .background(Color(UIColor.systemBackground))
//            .cornerRadius(15)
//            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
    }
    
    func toggleTaskCompletion(task: TodayTaskData) {
        withAnimation {
            if let index = TodoItems.firstIndex(where: { $0.id == task.id }) {
                TodoItems[index].isCompleted.toggle()
                if (TodoItems[index].isCompleted) {
                    let task = TodoItems[index]
                    let finishedTask = DoneTaskData(title: task.title, timeCreated: task.timeCreated, timeFinihed: Date(), tag: task.tag ?? "", emoji: task.emoji ?? "")
                    modelContext.insert(finishedTask)
                } else if (!TodoItems[index].isCompleted) {
                    deleteAlreadyFinishedTask(task: task)
                }
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

//struct TaskCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskCellView(
//            emoji: "📅",
//            title: "Task Title",
//            time: "10:30 AM"
//        )
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}
