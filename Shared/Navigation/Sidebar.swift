//
//  Sidebar.swift
//  JPDesignCodeCourse
//
//  Created by 周健平 on 2021/11/30.
//

import SwiftUI

struct Sidebar: View {
    @Binding var isActives: [Bool]
    var logMsg: (() -> ())? = nil
    
    var body: some View {
        NavigationView {
            #if os(iOS)
            content
                .navigationTitle("Learn") // iOS和iPadOS才需要这个
                .toolbar {
                    // 默认是顶部靠右的工具栏 navigationBarTrailing
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "person.crop.circle")
                    }
                }
            #else
            content
                // 在Mac端设置侧边栏的frame才有意义，用户可以进行拖拽控制大小
                // 而iPhone和iPad上尺寸是自适应的，由系统控制
                .frame(minWidth: 200, // 最小宽度
                       idealWidth: 250, // 理想宽度（默认展现的宽度）
                       maxWidth: 300) // 最大宽度
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            logMsg?()
                        }) {
                            Image(systemName: "person.crop.circle")
                        }
                    }
                }
            #endif
            
            // 由于iPad和Mac端屏幕更大，所以需要一个默认初始页面
            // iPad端的侧边栏：竖屏时是抽屉式（隐藏/推出），横屏时一直占据左边
            // Mac端的侧边栏：一直占据左边
            // 这里是给iPad和Mac端【右侧区域】设置初始内容：
//            #if os(iOS)
//            CoursesView(isActives: $isActives)
//            #else
//            CoursesView()
//            #endif
            // 经测试，这里设置的初始内容，跟NavigationLink.destination根本不是同一个，这样会导致点击展开详情出现错乱
            // 因此使用系统推荐方式：放一个选择前的占位视图
            Text("Select a Course.")
                .onTapGesture {
                    logMsg?()
                }
        }
    }
    
    var content: some View {
        List {
            NavigationLink(isActive: $isActives[0]) {
                #if os(iOS)
                CoursesView(isActives: $isActives)
                #else
                CoursesView()
                #endif
            } label: {
                Label("Courses", systemImage: "book.closed")
            }
            
            NavigationLink(isActive: $isActives[1]) {
                CourseList()
            } label: {
                Label("Tutorials", systemImage: "list.bullet.rectangle")
            }
            
            NavigationLink(isActive: $isActives[2]) {
                CourseList()
            } label: {
                Label("Livestreams", systemImage: "tv")
            }
            
            NavigationLink(isActive: $isActives[3]) {
                CourseList()
            } label: {
                Label("Certificates", systemImage: "mail.stack")
            }
            
            NavigationLink(isActive: $isActives[4]) {
                CourseList()
            } label: {
                Label("Search", systemImage: "magnifyingglass")
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar(isActives: .constant(Array(repeating: false, count: 5)))
    }
}
