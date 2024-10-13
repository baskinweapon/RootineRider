import SwiftUI
import _SwiftData_SwiftUI

struct FractalPattern: View {
    @State private var iterations: CGFloat = 1
    @State private var repeatness: CGFloat = 1.5
    @State private var phase: CGFloat = 8.0
    
    let date = Date()
    var iteraction: CGFloat = 1
    var phases: CGFloat = 8
    
    var body: some View {
        TimelineView(.animation) {
                let time = date.timeIntervalSince1970 -  $0.date.timeIntervalSince1970
                
                Rectangle()
//                    .aspectRatio(1, contentMode: .fit)
                    .colorEffect(ShaderLibrary.fractalPattern(
                        .boundingRect,
                        .float(-time),
                        .float(iteraction),
                        .float(repeatness),
                        .float(phases)
                    ))
//                    .offset(y: 35)
//                    .clipShape(RoundedRectangle(cornerRadius: 24))
        }.background(.black)
                
    }
}

#Preview {
    FractalPattern()
}
