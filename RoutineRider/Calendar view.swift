import SwiftUI
import _SwiftData_SwiftUI

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var finishedTasks: [DoneTaskData]
    
    @State private var selectedDate = Date()
    
    private let calendar = Calendar.current
    
    // Настройка количества отображаемых месяцев
    private let numberOfMonthsToDisplay = 5
    private var monthCount: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Text("Sun")
                    Spacer()
                    Text("Mon")
                    Spacer()
                    Text("Tue")
                    Spacer()
                    Text("Wed")
                    Spacer()
                    Text("Thu")
                    Spacer()
                    Text("Fri")
                    Spacer()
                    Text("Sat")
                    Spacer()
                }
                
                ScrollViewReader { value in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 10) {
                            
                            // Отображение нескольких месяцев
                            ForEach(monthsAroundToday(), id: \.self) { monthStartDate in
                                VStack {
                                    Text("\(monthYearString(for: monthStartDate))")
                                        .font(.title2)
                                        .padding()
                                    let time = Calendar.current.dateComponents([.year, .month, .hour, .minute], from: monthStartDate.addingTimeInterval(86400))
                                    let startDate = startDayOfWeek(for: time.year!, month: time.month!)
                                    let totalCells = daysInMonth(for: monthStartDate).count + startDate! - 1 // Вычисляем общее количество ячеек, включая пустые
                                    let columns = Array(repeating: GridItem(.fixed(50), spacing: 2), count: 7)
                                            
                                            LazyVGrid(columns: columns, spacing: 4) {
                                                // Добавляем пустые ячейки для того, чтобы первый день совпал
                                                ForEach(0..<totalCells, id: \.self) { index in
                                                    if index < startDate! - 1 {
                                                        // Пустая ячейка
                                                        Text("")
                                                            .frame(width: 48, height: 48)
                                                    } else {
                                                        let day = monthStartDate.addingTimeInterval(TimeInterval(index * 86400))
                                                        if (Calendar.current.isDateInToday(day)) {
                                                            // Отображаем номер дня
                                                            CalendarCellView(date: day, tasksCompleted:tasksForDate(tasks: finishedTasks, date: day).count).aspectRatio(1, contentMode: .fit)
                                                                .frame(width: 48, height: 48).overlay(
                                                                    Rectangle().stroke(Color.black.opacity(0.6), lineWidth: 1)
    //                                                                RoundedRectangle(cornerRadius: 4)
    //                                                                    .stroke(Color.black.opacity(0.6), lineWidth: 1)
                                                                )
                                                        } else {
                                                            // Отображаем номер дня
                                                            CalendarCellView(date: day, tasksCompleted:tasksForDate(tasks: finishedTasks, date: day).count).aspectRatio(1, contentMode: .fit)
                                                                .frame(width: 48, height: 48)
                                                        }
                                                    }
                                                }
                                            }
                                }.id(monthsAroundToday().firstIndex(of: monthStartDate))

                            }
                        }
                    }.defaultScrollAnchor(.center).navigationTitle("Calendar")
                }
            }
        }
    }
    
    func startDayOfWeek(for year: Int, month: Int) -> Int? {
        // Определяем текущий календарь
        let calendar = Calendar.current
        
        // Создаём дату для первого дня месяца
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        // Получаем дату
        guard let date = calendar.date(from: components) else {
            return nil
        }
        
        // Получаем день недели (1 - Воскресенье, 2 - Понедельник, ... 7 - Суббота)
        let weekday = calendar.component(.weekday, from: date)
        
        // Преобразуем в формат (1 - Понедельник, 7 - Воскресенье)
        return weekday
    }
    
    // Функция для фильтрации задач по дате
    func tasksForDate(tasks: [DoneTaskData], date: Date) -> [DoneTaskData] {
        let calendar = Calendar.current
        return tasks.filter { task in
            calendar.isDate(task.dateTimeFinihed!, inSameDayAs: date)
        }
    }
    
    // Форматирование выбранной даты
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    // Возвращает список дней в данном месяце
    private func daysInMonth(for date: Date) -> [Date] {
        let range = calendar.range(of: .day, in: .month, for: date)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        return range.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: startOfMonth) }
    }
    
    // Форматирование месяца и года
    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    // Возвращает массив начальных дат месяцев вокруг текущей даты
    private func monthsAroundToday() -> [Date] {
        var dates: [Date] = []
        let currentMonth = calendar.dateComponents([.year, .month], from: Date())
        let startOfCurrentMonth = calendar.date(from: currentMonth)!
        
        for i in -(numberOfMonthsToDisplay/2)...(numberOfMonthsToDisplay/2) {
            if let date = calendar.date(byAdding: .month, value: i, to: startOfCurrentMonth) {
                dates.append(date)
            }
        }
        return dates
    }
        
    // Функция для вычисления цвета фона на основе количества выполненных задач
    private func backgroundColor(for tasksCompleted: Int) -> Color {
        let maxTasks = 12 // Предположим, что максимальное количество задач — 10
        let percentage = min(Double(tasksCompleted) / Double(maxTasks), 1.0)
        
        // Черный -> Зеленый градиент
        let greenValue = percentage
        let blackValue = 1.0 - percentage
        
        return Color(red: blackValue, green: greenValue, blue: blackValue)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
