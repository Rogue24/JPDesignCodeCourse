//
//  ContentView.swift
//  Shared
//
//  Created by 周健平 on 2021/10/26.
//

import SwiftUI

struct ContentView: View {
    //【在iOS和iPadOS中，CoursesView内部自己使用和维护TabBar和Sidebar】
//    // SizeClass只适用于iOS和iPadOS
//    #if os(iOS)
//    @Environment(\.horizontalSizeClass) var horizontalSizeClass
//    #endif
    
    @State var isActives: [Bool] = Array(repeating: false, count: 5)
    func logMsg() {
        print("isActives: \(isActives)")
    }
    
    var body: some View {
        #if os(iOS)
        //【在iOS和iPadOS中，CoursesView内部自己使用和维护TabBar和Sidebar】
//        // compact：紧凑型（比较窄的屏幕）
//        if horizontalSizeClass == .compact {
//            TabBar()
//        } else {
//            Sidebar()
//        }
        CoursesView(isActives: $isActives, logMsg: logMsg)
        #else
        Sidebar(isActives: $isActives, logMsg: logMsg)
            .frame(minWidth: 1000, // 最小宽度
                   minHeight: 600) // 最小高度
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
//            ContentView()
//                .previewLayout(.fixed(width: 200.0, height: 200.0)) // 自定义预览画面的布局尺寸
//                .preferredColorScheme(.dark) // 暗黑模式
        }
    }
}
