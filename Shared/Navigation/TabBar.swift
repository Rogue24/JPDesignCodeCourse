//
//  TabBar.swift
//  JPDesignCodeCourse
//
//  Created by 周健平 on 2022/2/2.
//

import SwiftUI

struct TabBar: View {
    @Binding var isActives: [Bool]
    var logMsg: (() -> ())? = nil
    
    var body: some View {
        TabView {
            NavigationView {
                CoursesView(isActives: $isActives, logMsg: logMsg)
            }
            .tabItem {
                Image(systemName: "book.closed")
                Text("Courses")
            }
            
            NavigationView {
                CourseList()
            }
            .tabItem {
                Image(systemName: "list.bullet.rectangle")
                Text("Tutorials")
            }
            
            NavigationView {
                CourseList()
            }
            .tabItem {
                Image(systemName: "tv")
                Text("Livestreams")
            }
            
            NavigationView {
                CourseList()
            }
            .tabItem {
                Image(systemName: "mail.stack")
                Text("Certificates")
            }
            
            NavigationView {
                CourseList()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(isActives: .constant(Array(repeating: false, count: 5)))
    }
}
