import SwiftUI

struct CalendarCellView: View {
    let date: Date
    let tasksCompleted: Int
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            // Основное содержимое ячейки
            VStack {
                Spacer()
                
                // Центральный текст с с количеством тасок
                Text(String(tasksCompleted))
                    .font(.system(size: 16, weight: .bold)).frame(maxWidth: .infinity)
                //                    .position(x: 25, y: 13)
                
//                Spacer()
                
                // Подпись в зависимости от выполненных задач
                Text(CompetitionInfo.taskCompletionDescription(count: tasksCompleted))
                    .font(.system(size: 11, weight: .light)).padding(.bottom, 6)
            }
            .background(CompetitionInfo.taskCompletionDescriptionColor(count: tasksCompleted))
//            .cornerRadius(16)
//            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
//            .overlay(
//                RoundedRectangle(cornerRadius: 4)
//                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
//            )
            
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
    
    // Функция для описания выполнения задач
    
    
//    private func taskCompletionDescriptionColor() -> Color {
//        switch tasksCompleted {
//        case 0...2:
//            return Color.blue.opacity(0.2)
//        case 3...4:
//            return .red.opacity(0.2)
//        case 5...7:
//            return .yellow.opacity(0.2)
//        case 8...9:
//            return .green.opacity(0.2)
//        default:
//            return .green.opacity(0.2)
//        }
//    }
}

struct CalendarCellView_Preview: PreviewProvider {
    static var previews: some View {
        CalendarCellView(date: Date(), tasksCompleted: 5)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}


public class CompetitionInfo {
    public static func taskCompletionDescriptionColor(count: Int ) -> Color {
        switch count {
        case 0...2:
            return Color.blue.opacity(0.2)
        case 3...4:
            return .red.opacity(0.2)
        case 5...7:
            return .yellow.opacity(0.2)
        case 8...9:
            return .green.opacity(0.2)
        default:
            return .green.opacity(0.2)
        }
    }
    
    public static func taskCompletionDescription(count: Int) -> String {
        switch count {
        case 0:
            return "Worst"
        case 1...2:
            return "Poor"
        case 3...4:
            return "Average"
        case 5...7:
            return "Good"
        case 8...9:
            return "Awesome"
        case 10...100:
            return "Excellent"
        default:
            return "Unknown"
        }
    }
}
