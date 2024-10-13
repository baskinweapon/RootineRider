import SwiftUI
import _SwiftData_SwiftUI

struct JournalView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var journals: [JournalDayData]
        
    @State private var selectedIndex: Int = 0
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(journals) { journal in
                        ZStack {
                            VStack {
                                Text(dateString(from: journal.date))
                                    .font(.headline)
                                    .padding(.top, 20)
                                
                                TextEditor(text: Binding(get: { journal.text }, set: {
                                    newValue in
                                    journal.text = newValue
                                }))
                                    .padding()
                                    .padding([.leading, .trailing], 0)
                                    .submitLabel(.go).onSubmit {
                                        hide()
                                    }.focused($isFocused)
                            }
                        }.frame(width: UIScreen.screenWidth - 40)
                    }
                }.scrollIndicators(.hidden)
                .scrollTargetLayout()
            }.defaultScrollAnchor(.trailing)
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal, 20)
            
//            ButtonUpsideKeyboardView().position(x: UIScreen.screenWidth / 2, y: UIScreen.screenHeight - 200)
        }.onAppear() {
            if !Calendar.current.isDate(journals.last!.date, inSameDayAs: Date()) {
                modelContext.insert(JournalDayData(date: Date(), text: ""))
                try? modelContext.save()
            }
        }
    }
    
    func hide() {
        isFocused = false
    }
        
    func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
    }
}

//extension Binding {
//     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
//        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
//    }
//}

