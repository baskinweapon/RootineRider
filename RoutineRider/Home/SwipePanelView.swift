import SwiftUI
import _SwiftData_SwiftUI

struct SwipeableBottomPanelWithTabView: View {
    @Query(sort: \TodayTaskData.isCompleted, order: .forward) var todoItems: [TodayTaskData]
    
    @State private var offset: CGFloat = 0
    @State private var currentIndex: Int = 0
    let screenWidth = UIScreen.main.bounds.width
    let panelVisibleWidth: CGFloat = 40 // Ширина видимой части следующей панели
    
    @State private var categories: [String] = []
    
    init() {
        categories.removeAll()
        for item in todoItems {
            if (item.tag != nil && !categories.contains(item.tag!)) {
                categories.append(item.tag!)
            }
        }
    }
    
    var body: some View {
        VStack {
            
////             TabView для основного контента экранов
            var _ = print(categories.count)
            
            TabView(selection: $currentIndex) {
                TodayTasksView(categories: "All task").tag(0)
                    
                if (categories.count > 0) {
                    ForEach(categories, id: \.self) { category in
                        TodayTasksView(categories: category).tag(categories.firstIndex(of: category)! + 1)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentIndex) // Плавная анимация при переключении
            
            Spacer()
//            
//            // Панель для свайпа
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        // Каждая панель занимает ширину экрана минус видимая часть следующей панели
                        PanelView(index: "All tasks").frame(width: screenWidth - panelVisibleWidth * 2)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .offset(x: panelVisibleWidth)
                        if (categories.count > 0) {
                            ForEach(0..<$categories.count) { index in
                                PanelView(index: categories[index])
                                    .frame(width: screenWidth - panelVisibleWidth * 2)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .offset(x: panelVisibleWidth)
                            }
                        }

                    }
                }
                .content.offset(x: -CGFloat(self.currentIndex) * (screenWidth - panelVisibleWidth * 2 + 10) + self.offset)
                .frame(width: geometry.size.width, alignment: .leading)
                .animation(.easeInOut) // Анимация для плавности
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.offset = value.translation.width
                        }
                        .onEnded { value in
                            let dragThreshold = (screenWidth - panelVisibleWidth) / 2
                            if value.translation.width < -dragThreshold {
                                // Переход на следующую панель
                                self.currentIndex = min(self.currentIndex + 1, categories.count)
                            } else if value.translation.width > dragThreshold {
                                // Возврат на предыдущую панель
                                self.currentIndex = max(self.currentIndex - 1, 0)
                            }
                            self.offset = 0
                        }
                )
            }.frame(height: 44) // Высота панели
            Spacer()
        }.onAppear{
            categories.removeAll()
            for item in todoItems {
                if (item.tag != nil && !categories.contains(item.tag!)) {
                    categories.append(item.tag!)
                }
            }
        }
        
    }
}

struct PanelView: View {
    var index: String
    
    var body: some View {
        VStack {
            Text(index)
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.red)
    }
}

struct SwipeableBottomPanelWithTabView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeableBottomPanelWithTabView()
    }
}
