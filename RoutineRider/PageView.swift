import SwiftUI
import _SwiftData_SwiftUI
import UIKit

struct PageViewController: UIViewControllerRepresentable {
    var pages: [UIViewController]
    @Binding var currentIndex: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .pageCurl,
            navigationOrientation: .horizontal)
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        // Обновляем только если индекс изменился
        if let currentViewController = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: currentViewController) {
            if index != currentIndex {
                let direction: UIPageViewController.NavigationDirection = index < currentIndex ? .reverse : .forward
                pageViewController.setViewControllers(
                    [pages[currentIndex]],
                    direction: direction,
                    animated: true)
            }
        } else {
            pageViewController.setViewControllers(
                [pages[currentIndex]],
                direction: .forward,
                animated: false)
        }
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController

        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            guard let index = parent.pages.firstIndex(of: viewController), index > 0 else { return nil }
            return parent.pages[index - 1]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
            guard let index = parent.pages.firstIndex(of: viewController), index + 1 < parent.pages.count else { return nil }
            return parent.pages[index + 1]
        }
    }
}

struct PageView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var journals: [JournalDayData]
    
    @State private var currentIndex = 0
    
    var body: some View {
        // Создаем и сохраняем контроллеры представлений только один раз
        let controllers = journals.map { entry in
            let vc = UIHostingController(rootView: TextEntryView(journalDay: entry))
            return vc
        }
        
        PageViewController(pages: controllers, currentIndex: $currentIndex)
            .edgesIgnoringSafeArea(.all)
    }
}

struct TextEntryView: View {
    @State var journalDay: JournalDayData // Используем @State для локального управления текстом
    
    var body: some View {
        VStack {
            Text(dateString(from: journalDay.date))
                .font(.headline)
                .padding()
            Spacer()
            TextEditor(text: $journalDay.text)
                .padding()
                .padding([.leading, .trailing], 20)
        }
    }
    
    func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

struct ContentedView: View {
    var body: some View {
        PageView()
    }
}

struct ContentedView_Previews: PreviewProvider {
    static var previews: some View {
        ContentedView()
    }
}
