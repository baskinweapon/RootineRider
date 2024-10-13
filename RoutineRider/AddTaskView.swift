import SwiftUI
import _SwiftData_SwiftUI

struct AddTaskSheet: View {
    @Environment(\.modelContext) private var modelContext // Доступ к контексту
    @Environment(\.dismiss) private var dismiss // Для закрытия окна
    @State private var taskTitle: String = "" // Название задачи
    @State private var taskDuration: Date = Calendar.current.date(bySettingHour: 0, minute: 45, second: 0, of: Date())!
    @Query var templates: [TempalteTaskData]
    @Query var tasks: [TodayTaskData]
    
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
        }.onDisappear {
            Task {
                await addEmojiToTask()
                await AddCategories()
            }
        }
    }
    
    private func createTask() {
        taskTitle = taskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
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
    
    func addEmojiToTask() async {
        for template in templates {
            if (template.emoji == nil) {
                template.emoji = await AI().getTaskEmojie(template.title)
            }
        }
        
        for task in tasks {
            if (task.emoji == nil) {
                task.emoji = templates.first(where: { $0.title == task.title && $0.emoji != nil && $0.duration == task.duration })?.emoji
            }
        }
    }
    
    func extractJSON(from string: String) -> String {
        let jsonPattern = "\\{(?:[^{}]|\\{[^{}]*\\}|\\[^\\])*\\}"
        let regex = try? NSRegularExpression(pattern: jsonPattern, options: [])
        let nsString = string as NSString
        let results = regex?.matches(in: string, options: [], range: NSRange(location: 0, length: nsString.length))
        
        var jsonStrings = [String]()
        results?.forEach { result in
            let jsonString = nsString.substring(with: result.range)
            jsonStrings.append(jsonString)
        }
        
        return jsonStrings.joined(separator: ", ")
    }
    
    func AddCategories() async {
        var names: String = ""
        for template in templates {
            if (template.tag == nil) {
                names += template.title + ", "
            }
        }
        
        if names.isEmpty { return }
        var ai = await AI().getCategories(names)
        print(ai)
        
        ai = extractJSON(from: ai)
        
    
        if let jsonData = ai.data(using: .utf8) {
            do {
                // Декодируем Data в словарь [String: [String]]
                let decodedDict = try JSONDecoder().decode([String: [String]].self, from: jsonData)
                
                print(decodedDict)
                
                for value in templates {
                    for (key, values) in decodedDict {
                        if values.contains(value.title.trimmingCharacters(in: .whitespacesAndNewlines)) {
                            if value.tag == nil {
                                value.tag = key
                            }
                        }
                    }
                }
            } catch {
                print("Ошибка декодирования JSON: \(error.localizedDescription)")
            }
        } else {
            print("Ошибка конвертации строки в Data")
        }
    }
}

#Preview {
    AddTaskSheet()
        .modelContainer(for: TempalteTaskData.self, inMemory: true)
}
