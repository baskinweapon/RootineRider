import SwiftUI

struct CircularCountdownTimerView: View {
    @State private var timeRemaining: CGFloat = 300 // 5 минут в секундах
    @State private var totalTime: CGFloat = 300 // Полное время таймера
    @State private var timerIsActive = false
    @State private var timer: Timer?

    var body: some View {
        VStack {
            ZStack {
                // Фон для кругового таймера (незавершенный круг)
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                // Прогресс (анимированный круг)
                Circle()
                    .trim(from: 0, to: progress())
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear(duration: 1), value: timeRemaining)

                // Оставшееся время
                Text(timeString(from: Int(timeRemaining)))
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
            }
            .frame(width: 250, height: 250)
            .padding()

            HStack(spacing: 20) {
                Button(action: {
                    startTimer()
                }) {
                    Text("Start")
                        .font(.title2)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    stopTimer()
                }) {
                    Text("Stop")
                        .font(.title2)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    resetTimer()
                }) {
                    Text("Reset")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }

    // Функция для получения прогресса (оставшееся время / полное время)
    func progress() -> CGFloat {
        return timeRemaining / totalTime
    }

    // Форматирование времени
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Запуск таймера
    func startTimer() {
        if !timerIsActive {
            timerIsActive = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    stopTimer()
                }
            }
        }
    }

    // Остановка таймера
    func stopTimer() {
        timer?.invalidate()
        timerIsActive = false
    }

    // Сброс таймера
    func resetTimer() {
        stopTimer()
        timeRemaining = totalTime
    }
}

struct CircularCountdownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CircularCountdownTimerView()
    }
}
