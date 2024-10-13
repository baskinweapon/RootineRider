//
//  CompactTemplateCellView.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 17/09/2024.
//

import SwiftUI

struct CompactTemplateCellView: View {
    var taskTitle: String
    var taskTime: String
    var taskEmoji: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(taskEmoji)
                .font(.largeTitle)
                .padding(.bottom, 8)
            
            Text(taskTitle)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Spacer()
            
            Text(taskTime)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 120, height: 120) // Квадратная ячейка
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
       
    }
}

struct CompactTemplateCellView_Previews: PreviewProvider {
    static var previews: some View {
        CompactTemplateCellView(taskTitle: "Buy groceries", taskTime: "2:00 PM", taskEmoji: "🛒")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
