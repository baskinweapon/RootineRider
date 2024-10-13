//
//  HalfSheetTemplatesView.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 17/09/2024.
//

import SwiftUICore
import _SwiftData_SwiftUI
import SwiftUI

struct HalfSheetTemplatesView: View {
    @Environment(\.modelContext) private var modelContext // Получаем список шаблонов
    @Query var templates: [TempalteTaskData]
    @Binding public var isHalfScreen: Bool
    
    @State var tagsArray: [String] = []
    @Environment(\.presentationMode) var presentationMode
    @State private var sheetSize: CGFloat = 0
    let rows = [GridItem(.fixed(120)), GridItem(.fixed(120))]
    
    @State private var draggedItem: TempalteTaskData? = nil
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        VStack {
            if isHalfScreen {
                NavigationView {
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, spacing: 10) {
                            ForEach(templates) { template in
                                Button(action: {
                                    onClick(TempaltesTask: template, hide: false)
                                }) {
                                    CompactTemplateCellView(taskTitle: template.title, taskTime: "⏱️ " + String(template.duration) + " min", taskEmoji: template.emoji ?? "")
                                }
                            }
                        }.padding()
                    }
                }
            } else {
                TemplatesView()
            }
        }.onChange(of: sheetSize) { newValue in
            // Когда лист растягивается, меняем контент
            if newValue > UIScreen.main.bounds.height * 0.5 {
                isHalfScreen = false
            } else {
                isHalfScreen = true
            }
        }.background(GeometryReader { geo in
            Color.clear.onAppear {
                sheetSize = geo.size.height
            }
            .onChange(of: geo.size.height) { newHeight in
                sheetSize = newHeight
            }
        })
    }
    
    func onClick(TempaltesTask template: TempalteTaskData, hide: Bool = true) {
        let newTask = TodayTaskData(title: template.title, timeCreated: Date(), duration: template.duration, isCompleted: false, emoji: template.emoji ?? "")
        modelContext.insert(newTask)
        
        template.usedCount! += 1
        if hide {
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        }
            
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
    
    func dropAreaContains(location: CGSize) -> Bool {
        let dropAreaXRange: ClosedRange<CGFloat> = 0...UIScreen.screenWidth // Указываем, где находится зона второго списка
        let dropAreaYRange: ClosedRange<CGFloat> = 400...UIScreen.screenHeight
        
        return dropAreaXRange.contains(location.width) && dropAreaYRange.contains(location.height)
    }
}
