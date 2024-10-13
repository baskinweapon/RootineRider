import SwiftUI
import SwiftData

struct OnboardingView: View {
    @State private var showIntro = true
    @State private var selectedStartDate = Date()
    @State private var challengeDuration = 3
    @State private var weekendDays: Set<Int> = [6, 7]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            if showIntro {
                IntroView(showIntro: $showIntro)
            } else {
                MainSetupView()
            }
        }
    }
}

struct IntroView: View {
    @Binding var showIntro: Bool

    var body: some View {
        VStack {
            Image(systemName: "heart.fill") // Замените "your_logo" на имя вашего изображения логотипа
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()

            Text("Welcome to RoutineRider!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            Text("Enhance your productivity with tailored challenges.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()

            Spacer()

            Button("Get Started") {
                showIntro = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding()
    }
}


//preview
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView().modelContainer(for: TodayTaskData.self, inMemory: true)
    }
}
