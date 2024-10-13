import SwiftUI

struct Tip: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

struct TaskOverview: View {
    let tips = [
        Tip(title: "Stay Organized", description: "Use tags and priorities to organize your tasks."),
        Tip(title: "Set Deadlines", description: "Always assign deadlines to your tasks to stay on track."),
        Tip(title: "Take Breaks", description: "Remember to take short breaks during long work sessions."),
        Tip(title: "Review Progress", description: "Review your tasks regularly to track your progress.")
    ]
    
    @State private var userNotes: String = ""

    var body: some View {
        
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Панели с советами
                    ForEach(tips) { tip in
                        TipPanelView(tip: tip)
                    }

                    
                    }
//                    .padding(.top, 16)
                }
                .padding()
            
                VStack(alignment: .center, spacing: 8) {
                        Text("Your Notes")
                            .font(.headline)
                            .foregroundColor(.primary)

                        TextEditor(text: $userNotes)
                            .frame(height: 150)
                            .padding(8)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                        Text("Write down any thoughts or reminders here. I'll help you.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Task Overview")
    
    }
}

struct TipPanelView: View {
    var tip: Tip

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(tip.title)
                .font(.headline)
                .foregroundColor(.primary)

            Text(tip.description)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct TaskOverview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskOverview()
        }
    }
}
