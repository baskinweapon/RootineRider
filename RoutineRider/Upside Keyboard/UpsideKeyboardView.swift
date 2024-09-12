import SwiftUI
import _SwiftData_SwiftUI

struct UpsideKeyboardView: View {
    @Query(sort: \TodayTaskData.isCompleted) var todoItems: [TodayTaskData]
    @Query var finishedTask: [DoneTaskData]
    

    let emojiArray: [Int: String] = [
        0: "😔",  // Грустный, потерянный
        1: "😟",  // Обеспокоенный
        2: "😕",  // Смущённый
        3: "🙁",  // Недовольный
        4: "😐",  // Нейтральный
        5: "😶",  // Спокойный
        6: "🙂",  // Лёгкая улыбка
        7: "😊",  // Улыбающийся
        8: "😀",  // Довольный
        9: "😄",  // Радостный
        10: "😁"  // Счастливый и восторженный
    ]
    
    var body: some View {
        
        HStack {
            // Слева - иконка награды и смайлик
            HStack {
                let size = finishedTask.filter{ $0.IsTodayFinished() }.count <= 10 ? finishedTask.filter{ $0.IsTodayFinished() }.count : 10
                Text(emojiArray[size]!) // Смайлик
            }
            .padding(.leading)

            Spacer()

            // По центру - надпись "Journey" с кастомным шрифтом
            Text("Journal")
                .font(.custom("Futura-Bold", size: 24)) // Интересный шрифт
                .foregroundColor(.purple)

            Spacer()
            
            // Справа - кружок с цифрой 5
            ZStack {
                Circle()
                    .fill(CompetitionInfo.taskCompletionDescriptionColor(count: finishedTask.filter{ $0.IsTodayFinished() }.count))
                    .frame(width: 30, height: 30) // Размер кружка

                Text(String(finishedTask.filter{ $0.IsTodayFinished() }.count))
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.trailing)
        }
        .frame(height: 44) // Высота как у стандартной кнопки
        .background(Color.gray.opacity(0.2)) // Фон с легким серым оттенком
        .cornerRadius(10) // Закругленные углы для фоновой вью
        .padding()
    }
}

struct UpsideKeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        UpsideKeyboardView()
    }
}
