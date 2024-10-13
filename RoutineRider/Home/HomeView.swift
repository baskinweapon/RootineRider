import SwiftUI
import _SwiftData_SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodayTaskData.isCompleted, order: .forward) var TodoItems: [TodayTaskData]
    @Query var finishTasks: [DoneTaskData]
    @State private var showAddTaskSheet: Bool = false
    @State private var showTemplatesSheet = false
    
    @State private var isHalfScreen = false
    
    var body: some View {
//        NavigationView {
            VStack {
//                SwipeableBottomPanelWithTabView() // new logic
                
                TodayTasksView(categories: "All task")
                
                CompactTaskManagerView(showTemplatesSheet: $showTemplatesSheet, showAddTaskSheet: $showAddTaskSheet)
                    .padding(.horizontal).padding(.bottom, 6)
                .sheet(isPresented: $showTemplatesSheet) {
                    HalfSheetTemplatesView(isHalfScreen: $isHalfScreen).presentationDetents([.height(120*2+100), .large]).presentationDragIndicator(.automatic)
                }.sheet(isPresented: $showAddTaskSheet) {
                    AddTaskSheet()
                }
            }
//        }
    }
    
    // Функция добавления задачи
    func addTask() {
        showAddTaskSheet.toggle()
    }
    
    // Переключение состояния задачи (завершена/незавершена)
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
    
    // Удаление задачи
    func deleteTask(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                TodoItems[index].isCompleted.toggle()
                deleteAlreadyFinishedTask(task: TodoItems[index])
                modelContext.delete(TodoItems[index])
            }
        }
    }
}

// Компактная кнопка с иконкой и цветом фона
struct IconButtonSmall: View {
    let title: String
    let imageName: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24) // Уменьшенная иконка
                    .foregroundColor(.white)
                Text(title)
                    .font(.caption2) // Уменьшенный текст
                    .foregroundColor(.white)
            }
            .padding(8) // Меньшая обводка
            .frame(width: 80, height: 80) // Уменьшенный размер кнопки
            .background(color)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 5, y: 5)
        }
    }
}

extension Bool: @retroactive Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        // the only true inequality is false < true
        !lhs && rhs
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().modelContainer(for: TodayTaskData.self, inMemory: true)
    }
}
