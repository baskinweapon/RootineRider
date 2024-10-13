import SwiftUI

struct CalendarCell {
    var isPresented = false
    var date = Date()
}

struct CalendarCellView: View {
    let date: Date
    let tasksCompleted: Int
    private let calendar = Calendar.current
    public var isSheetPresented: Binding<CalendarCell>
    
    var body: some View {
        Button(action: { if (tasksCompleted > 0) { isSheetPresented.wrappedValue = CalendarCell(isPresented: true, date: date) }}) {
            ZStack {
                // Основное содержимое ячейки
                VStack {
                    Spacer()
                    
                    // Центральный текст с с количеством тасок
                    Text(String(tasksCompleted))
                        .font(.system(size: 16, weight: .bold)).frame(maxWidth: .infinity)
               
                    Text(CompetitionInfo.taskCompletionDescription(count: tasksCompleted))
                        .font(.system(size: 11, weight: .light)).padding(.bottom, 6)
                }
                .background(CompetitionInfo.taskCompletionDescriptionColor(count: tasksCompleted))
                
                // Число месяца в правом верхнем углу
                VStack {
                    HStack {
                        Spacer()
                        Text(dayNumberString())
                            .font(.system(size: 8, weight: .light))
                            .foregroundColor(.black.opacity(0.8))
                            .padding(.trailing, 6)
                            .padding(.top, 4)
                    }
                    Spacer()
                }
            }.frame(width: 48, height: 48)
        }
    }
    
    // Форматирование дня месяца
    private func dayNumberString() -> String {
        return String(calendar.component(.day, from: date))
    }
    
    // Форматирование числа месяца для правого верхнего угла
    private func monthNumberString() -> String {
        let month = calendar.component(.month, from: date)
        return String(month)
    }
    
    // Функция для вычисления цвета фона на основе выполненных задач
    private func backgroundColor() -> Color {
        let maxTasks = 10 // Максимум задач для оценки
        let percentage = min(Double(tasksCompleted) / Double(maxTasks), 1.0)
        
        // Цвет от черного до зеленого
        let greenValue = percentage
        let blackValue = 1.0 - percentage
        
        return Color(red: blackValue, green: greenValue, blue: blackValue)
    }
    
}

//struct CalendarCellView_Preview: PreviewProvider {
//    static var previews: some View {
//        CalendarCellView(date: Date(), tasksCompleted: 5)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}



