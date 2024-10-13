//
//  MainSetupView.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 09/10/2024.
//


import SwiftUI
import MijickCalendarView

struct MainSetupView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedDate: Date = Date()
    @State var challengeDuration: Int = 3
    @State var weekendDays: Set<Int> = [6, 7]
    
    @State private var selectedDays: Set<String> = ["Monday", "Tuesday", "Wednesday", "Thursday", "Sunday"] 

    @State var isDone: Bool = false
        
    var body: some View {
        VStack {
//            Spacer()
            Text("Set Up Your Challenge")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Text("To maximize your productivity, we recommend breaking challenges into 12 weeks.")
                .font(.subheadline)
                .padding(.horizontal)
            Spacer()
           
            DatePicker("Start date",  selection: $selectedDate, in: Date()...Date().addingTimeInterval(60 * 60 * 24 * 7 * 12), displayedComponents: [.date]).padding(.horizontal)

            HStack {
                Stepper("Select Duration  \(challengeDuration) \(challengeDuration == 1 ? "Month" : "Months")", value: $challengeDuration, in: 1...6)
            }.padding(.horizontal)

            WeekdayPickerView(selectedDays: $selectedDays)

            Spacer()

            Button("Start Challenge") {
                saveChallenge()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(14)
            .padding(.horizontal)
        }
        .padding()
    }
    
    private func saveChallenge() {
        
        let newChallenge = ChallengeData(startDate: selectedDate, endDate: Calendar.current.date(byAdding: .month, value: 3, to: selectedDate)!, workingDays: Array(selectedDays))
        modelContext.insert(newChallenge)
        
        let appData = AppData(needShowOnboarding: false)
        modelContext.insert(appData)
        
        try? modelContext.save()
        
    }
}


struct MainSetupView_Previews: PreviewProvider {

    static var previews: some View {
        MainSetupView()
    }
}


extension MainSetupView {
    func configureCalendar(_ config: CalendarConfig) -> CalendarConfig {
        config
            .daysHorizontalSpacing(5)
            .daysVerticalSpacing(5)
            .monthsBottomPadding(5)
            .monthsTopPadding(5)
            .scrollTo(date: Date())
//            .dayView(СustomDayView.init)
    }
}
