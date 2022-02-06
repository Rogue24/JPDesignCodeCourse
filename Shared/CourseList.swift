//
//  CourseList.swift
//  JPDesignCodeCourse
//
//  Created by 周健平 on 2021/12/6.
//

import SwiftUI

//BorderedListStyle
//CarouselListStyle
//DefaultListStyle
//EllipticalListStyle
//GroupedListStyle
//InsetGroupedListStyle
//InsetListStyle
//PlainListStyle
//SidebarListStyle

struct CourseList: View {
    var body: some View {
        #if os(iOS)
        content
            .listStyle(InsetGroupedListStyle())
        #else
        // 除了iOS/iPadOS，那就是MacOS了
        content
            .frame(minWidth: 800,
                   minHeight: 600)
        #endif
    }
    
    var content: some View {
        List(0 ..< 20) { item in
            CourseRow()
        }
        .navigationTitle("Courses")
    }
}

struct CourseList_Previews: PreviewProvider {
    static var previews: some View {
        CourseList()
    }
}
