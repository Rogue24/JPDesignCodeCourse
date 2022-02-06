//
//  CardStyle.swift
//  JPDesignCodeCourse
//
//  Created by 周健平 on 2022/2/6.
//

import SwiftUI

extension View {
    func cardStyle(color: Color = .blue, cornerRadius: CGFloat = 22) -> some View {
        self
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: color.opacity(0.3),
                    radius: 20, x: 0, y: 10)
    }
}
