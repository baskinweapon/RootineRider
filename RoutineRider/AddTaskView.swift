import SwiftUI
import _SwiftData_SwiftUI

struct AddTaskSheet: View {
    @Environment(\.modelContext) private var modelContext // Доступ к контексту
    @Environment(\.dismiss) private var dismiss // Для закрытия окна
    @State private var taskTitle: String = "" // Название задачи
    @State private var taskDuration: Date = Calendar.current.date(bySettingHour: 0, minute: 45, second: 0, of: Date())!
    @Query var templates: [TempalteTaskData]
    
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Information")) {
                    TextField("Task Name", text: $taskTitle).focused($isFocused).submitLabel(.go).onSubmit {
                        createTask()
                    }
                    
                    // Выбор времени выполнения с помощью Time Picker
                    DatePicker("Time to Complete", selection: $taskDuration, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle()) // Вращающиеся колеса для выбора времени
                }
                
                Button(action: {
                    createTask() // Создание новой задачи
                }) {
                    Text("Create Task")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(taskTitle.isEmpty) // Отключение кнопки, если название задачи не введено
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss() // Закрыть окно без создания задачи
                    }
                }
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.isFocused = true
            }
        }
    }
    
    private func createTask() {
        if (taskTitle.isEmpty) { return }
        
        // Преобразование времени из DatePicker в минуты
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: taskDuration)
        let minutes = calendar.component(.minute, from: taskDuration)
        let totalMinutes = hours * 60 + minutes
        
        let newTask = TodayTaskData(title: taskTitle, timeCreated: Date(), duration: totalMinutes) // Создаем новый объект задачи
        modelContext.insert(newTask) // Вставляем его в контекст
        
        //check templates
        let template = templates.first(where: {$0.title.lowercased() == newTask.title.lowercased() && $0.duration == newTask.duration})
        if template != nil {
            let template = template!
            modelContext.delete(template)
            let temp = TempalteTaskData(title: newTask.title, timeFinihed: Date(), duration: newTask.duration, isCompleted: newTask.isCompleted, usedCount: (template.usedCount ?? 0) + 1)
            modelContext.insert(temp)
        } else {
            // add templates
            let templateUtem = TempalteTaskData(title: newTask.title, timeFinihed: Date(), duration: newTask.duration, isCompleted: newTask.isCompleted)
            modelContext.insert(templateUtem)
        }
        
        dismiss() // Закрываем окно после создания задачи
    }
}

#Preview {
    AddTaskSheet()
        .modelContainer(for: TempalteTaskData.self, inMemory: true)
}
