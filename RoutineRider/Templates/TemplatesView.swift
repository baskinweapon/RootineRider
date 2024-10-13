import SwiftUI
import _SwiftData_SwiftUI

// Экран для отображения шаблонов задач
struct TemplatesView: View {
    @Environment(\.modelContext) private var modelContext // Получаем список шаблонов
    @Query var templates: [TempalteTaskData]
//    @Query(filter: #Predicate<TempalteTaskData> { temp in
//        temp.tag != nil }) var tagsTemplates: [TempalteTaskData]
    @State var tagsArray: [String] = []

    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    List {
                        
                        ForEach(tagsArray, id: \.self) { tag in
                            Section(header: Text(tag)) {
                                ForEach(templates) { template in
                                    if template.tag == tag {
                                        Button(action: {
                                            onClick(TempaltesTask: template)
                                        }) {
                                            HStack {
                                                Text(template.emoji ?? "")
                                                Text(template.title)
                                                    .font(.headline)
                                                Spacer()
                                                Text("⏱️ \(template.duration)min").font(.subheadline)
                                                Text("Used: \(template.usedCount ?? 0)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                                }.contentShape(Rectangle())
                                        }
                                    }
                                }.onDelete(perform: onDelete).buttonStyle(PlainButtonStyle())
                            }
                        }
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
            }.onAppear() {
                setTags()
            }
        }
       
    }
    
    func onClick(TempaltesTask template: TempalteTaskData) {
        let newTask = TodayTaskData(title: template.title, timeCreated: Date(), duration: template.duration, isCompleted: false, emoji: template.emoji ?? "")
        modelContext.insert(newTask)
        
        template.usedCount! += 1
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func onDelete(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(templates[index])
            }
        }
    }
    
    func onRecalulateCategories() {
        deleteAllCategories()
    }
    
    func deleteAllCategories() {
        for template in templates {
            template.tag = nil
        }
    }
    
    func setTags() {
        tagsArray.removeAll()
    
        for template in templates {
            if template.tag != nil && !tagsArray.contains(template.tag!){
                tagsArray.append(template.tag!)
            }
        }
    }
    
    
}


#Preview {
    TemplatesView()
        .modelContainer(for: DoneTaskData.self, inMemory: true)
}

