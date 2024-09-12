import SwiftUI

struct CompactTaskManagerView: View {
    public var showTemplatesSheet: Binding<Bool>
    public var showAddTaskSheet: Binding<Bool>
    @State public var tasksCompleted: Int // Количество выполненных задач
    @State public var timeSpent: Int// Время потраченное на задачи в минутах
    @State private var currentDate = Date() // Текущая дата
    
    var body: some View {
        ZStack {
            // Фон с градиентом
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]),
                    startPoint: .leading,
                    endPoint: .trailing))
                .frame(height: 44)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            
            HStack {
                // Информация о задачах и времени
                VStack(alignment: .leading, spacing: 2) {
//                    Text("\(formattedDate())")
//                        .font(.caption)
//                        .foregroundColor(.white.opacity(0.8))
                    HStack(spacing: 20) {
                        Text("Done: \(tasksCompleted)")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.white)
    
                        Text("Spent: \(timeString(from: timeSpent))")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()

                // Кнопки с иконками
                HStack(spacing: 10) {
                    Button(action: {
                        showAddTaskSheet.wrappedValue.toggle()
                        // Логика добавления новой задачи
                        print("New Task button pressed")
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.white)
                            Text("New")
                                .font(.caption)
                                .bold()
                        }
                        .frame(width: 80, height: 30)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                    }
                    
                    Button(action: {
                        showTemplatesSheet.wrappedValue.toggle()
                        // Логика открытия шаблонов
                        print("Templates button pressed")
                    }) {
                        HStack {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.white)
                            Text("Templates")
                                .font(.caption)
                                .bold()
                        }
                        .frame(width: 100, height: 30)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(6)
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
//
//struct CompactTaskManagerView_Previews: PreviewProvider {
//    static var previews: some View {
//        CompactTaskManagerView()
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
