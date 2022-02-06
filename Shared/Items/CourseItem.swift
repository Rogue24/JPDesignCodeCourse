//
//  CourseItem.swift
//  JPDesignCodeCourse
//
//  Created by 周健平 on 2021/12/6.
//

import SwiftUI

struct CourseItem: View {
    var course: Course = courses[0]
    
    #if os(iOS)
    var cornerRadius: CGFloat = 22
    #else
    var cornerRadius: CGFloat = 10 // 在MacOS上圆角小一点
    #endif
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Spacer()
            HStack {
                Spacer()
                Image(course.image) // SwiftUI始终采用图像的原始尺寸（图片多大就多大）
                    .resizable() // 使用这个Modifier可以确保图片大小限制在剩余所有的可用空间内
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            Text(course.title)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            Text(course.subtitle)
                .font(.footnote)
                .foregroundColor(Color.white)
        }
        .padding(.all)
        .cardStyle(color: course.color, cornerRadius: cornerRadius)
    }
}

struct CourseItem_Previews: PreviewProvider {
    static var previews: some View {
        CourseItem()
    }
}
