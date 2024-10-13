import SwiftUI
import Combine

struct ButtonUpsideKeyboardView: View {
    @State private var keyboardHeight: CGFloat = 0
    

    var body: some View {
        VStack {
            // Кнопка, которая будет располагаться над клавиатурой
            UpsideKeyboardView()
            .padding(.bottom, keyboardHeight) // Смещаем кнопку над клавиатурой
            .animation(.easeOut(duration: 0.25))// Анимация смещения
        }
        .onAppear {
            self.startKeyboardObservers() // Начинаем отслеживать клавиатуру
        }
        .onDisappear {
            self.stopKeyboardObservers() // Останавливаем отслеживание клавиатуры
        }.opacity(keyboardHeight)
    }

    // Подписываемся на уведомления о клавиатуре
    private func startKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                self.keyboardHeight = keyboardFrame.size.height + 97
            }
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            self.keyboardHeight = 0
        }
    }

    // Останавливаем подписку на уведомления
    private func stopKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

