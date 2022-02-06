//
//  CourseRow.swift
//  JPDesignCodeCourse
//
//  Created by 周健平 on 2021/11/30.
//

import SwiftUI

struct CourseRow: View {
    var item: CourseSection = courseSections[0]
    
    var body: some View {
        // SF符号：找到需要的符号，右键“拷贝1个名称”，粘贴使用
//        Image(systemName: "paperplane.circle.fill")
//            .foregroundColor(.white)
        
        HStack(alignment: .top) {
            Image(item.logo)
                .renderingMode(.original)
                .frame(width: 48.0, height: 48.0)
                .imageScale(.medium)
                .background(item.color)
                .clipShape(Circle())
                
            VStack(alignment: .leading, spacing: 4) {
                // 如果没有给文本设置颜色（foregroundColor），
                // 那当使用`NavigationLink`将`CourseRow`包裹时，文本会自动渲染成淡紫色
                
                Text(item.title)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.primary) // 系统的自适应颜色（深色模式为白色，浅色模式为黑色）
                    .multilineTextAlignment(.leading)
                
                Text(item.subtitle)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        // 对父视图设置字体，能同时应用到其中所有可设置字体的子视图（没有单独设置过字体的子视图）
//        .font(.system(size: 34, weight: .light, design: .rounded))
    }
}

struct CourseRow_Previews: PreviewProvider {
    static var previews: some View {
        CourseRow()
    }
}
