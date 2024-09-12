import SwiftUI
import _SwiftData_SwiftUI

// Экран для отображения шаблонов задач
struct TemplatesView: View {
    @Environment(\.modelContext) private var modelContext // Получаем список шаблонов
    @Query var templates: [TempalteTaskData]

    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(templates) { template in
                        Button(action: {
                            onClick(TempaltesTask: template)
                        }) {
                            HStack {
                                Text(template.title)
                                    .font(.headline)
                                Spacer()
                                Text("⏱️ \(template.duration)min").font(.subheadline)
                                Text("Used: \(template.usedCount ?? 0)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                }.contentShape(Rectangle())
                        }
                    }.onDelete(perform: onDelete).buttonStyle(PlainButtonStyle())
                }
            }.navigationTitle("Templates")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Закрыть") {
                            // Закрыть sheet
                            
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func onClick(TempaltesTask template: TempalteTaskData) {
        let newTask = TodayTaskData(title: template.title, timeCreated: Date(), duration: template.duration, isCompleted: false)
        modelContext.insert(newTask)
        
        modelContext.delete(template)
        let temp = TempalteTaskData(title: newTask.title, timeFinihed: Date(), duration: newTask.duration, isCompleted: newTask.isCompleted, usedCount: (template.usedCount ?? 0) + 1)
        modelContext.insert(temp)
        
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func onDelete(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(templates[index])
            }
        }
    }
}

#Preview {
    TemplatesView()
        .modelContainer(for: DoneTaskData.self, inMemory: true)
}

