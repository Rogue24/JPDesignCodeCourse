//
//  Sidebar.swift
//  JPDesignCodeCourse
//
//  Created by 周健平 on 2021/11/30.
//

import SwiftUI

struct Sidebar: View {
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
                            
                        }) {
                            Image(systemName: "person.crop.circle")
                        }
                    }
                }
            #endif
            
            // 由于iPad和Mac端屏幕更大，所以需要一个默认初始页面
            // iPad端的侧边栏：竖屏时是抽屉式（隐藏/推出），横屏时一直占据左边
            // Mac端的侧边栏：一直占据左边
            // 这里是给iPad和Mac端设置初始内容：
            CoursesView()
        }
    }
    
    var content: some View {
        List {
            NavigationLink(destination: CoursesView()) {
                Label("Courses", systemImage: "book.closed")
            }
            NavigationLink(destination: CourseList()) {
                Label("Tutorials", systemImage: "list.bullet.rectangle")
            }
            NavigationLink(destination: CourseList()) {
                Label("Livestreams", systemImage: "tv")
            }
            NavigationLink(destination: CourseList()) {
                Label("Certificates", systemImage: "mail.stack")
            }
            NavigationLink(destination: CourseList()) {
                Label("Search", systemImage: "magnifyingglass")
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
