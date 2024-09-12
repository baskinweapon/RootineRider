import SwiftUI
import _SwiftData_SwiftUI

struct JournalView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var journals: [JournalDayData]
        
    @State private var selectedIndex: Int = 0
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        if (journals.isEmpty) {
            var _ = AddJournal()
        }
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(0..<journals.count) { index in
                        ZStack {
                            VStack {
                                Text(dateString(from: journals[index].date))
                                    .font(.headline)
                                    .padding(.top, 20)
                                
                                TextEditor(text: Binding(get: { journals[index].text }, set: {
                                    newValue in
                                    journals[index].text = newValue
                                }))
                                    .padding()
                                    .padding([.leading, .trailing], 0)
                                    .tag(index)
                                    .submitLabel(.go).onSubmit {
                                        hide()
                                    }.focused($isFocused)
                                    .autocorrectionDisabled()
                            }
                        }.frame(width: UIScreen.screenWidth - 40)
                    }
                }
                .scrollTargetLayout()
            }.defaultScrollAnchor(.trailing)
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal, 20)
            
            ButtonUpsideKeyboardView().position(x: UIScreen.screenWidth / 2, y: UIScreen.screenHeight - 200)
        }
    }
    
    func hide() {
        isFocused = false
    }
        
    
    func AddJournal() {
        modelContext.insert(JournalDayData(date: Date(), text: ""))
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

