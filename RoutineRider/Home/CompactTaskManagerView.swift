import SwiftUI
import _SwiftData_SwiftUI

struct CompactTaskManagerView: View {
    public var showTemplatesSheet: Binding<Bool>
    public var showAddTaskSheet: Binding<Bool>
    @Query var tasks: [TodayTaskData]
    @State private var currentDate = Date() // Текущая дата
    
    var body: some View {
        ZStack {
            // Фон с градиентом
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.teal.opacity(0.7), Color.purple.opacity(0.7)]),
                    startPoint: .trailing,
                    endPoint: .leading))
                .frame(height: 44)
                .shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 2)
                
            
            HStack {
               
                // Кнопки с иконками
                HStack(spacing: 10) {
                    Button(action: {
                        showAddTaskSheet.wrappedValue.toggle()
                    
                    }) {
                        Image(systemName: "plus.circle").resizable().scaledToFit()
                            .foregroundColor(.white).frame(width: 22, height: 22)
                    }
                    
                    Spacer()
                    
                    // Информация о задачах и времени
                    
                    HStack(spacing: 20) {
                        Text("Done: \(tasks.filter{ $0.isCompleted }.count)")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.white)
    
                        let fullTime = tasks.filter{ $0.isCompleted }.reduce(0) { $0 + $1.duration }
                        Text("Spent: \(timeString(from: fullTime))")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                    
                    
                    Spacer()
                    
                    Button(action: {
                        showTemplatesSheet.wrappedValue.toggle()
                    }) {
                        Image(systemName: "list.bullet").resizable()
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
    }
    
    // Функция для форматирования текущей даты
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: currentDate)
    }

    // Функция для форматирования времени
    func timeString(from minutes: Int) -> String {
        let hours = minutes / 60
        let minutes = minutes % 60
        return String(format: "%02dh %02dm", hours, minutes)
    }
}

