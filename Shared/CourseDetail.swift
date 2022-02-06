//
//  CourseDetail.swift
//  JPDesignCodeCourse
//
//  Created by 周健平 on 2022/2/1.
//

import SwiftUI

struct CourseDetail: View {
    var course: Course = courses[0]
    
    // 声明是源头的类型定义：
//    @Namespace var namespace
    // 声明这是从外界传入的类型定义：
    var namespace: Namespace.ID
    
    #if os(iOS)
    var cornerRadius: CGFloat = 10
    #else
    var cornerRadius: CGFloat = 0 // 在MacOS上不需要圆角
    #endif
    
    @State var showModel = false
    
    var body: some View {
        #if os(iOS)
        content
            .edgesIgnoringSafeArea(.all)
        #else
        // 除了iOS/iPadOS，那就是MacOS了
        content
        #endif
    }
    
    // 迷你组件：内部封装的子View
    var content: some View {
        VStack {
            ScrollView {
                CourseItem(course: course, cornerRadius: 0) // 展开后不需要圆角
                    .matchedGeometryEffect(id: course.id, in: namespace)
                    .frame(height: 300)
                
                VStack {
                    ForEach(courseSections) { item in
                        CourseRow(item: item)
                            .sheet(isPresented: $showModel) {
                                print("is dismissed")
                            } content: {
                                CourseSectionDetail()
                            }
                            .onTapGesture {
                                showModel = true
                            }

                        Divider() // 分隔线
                    }
                }
                .padding()
            }
        }
        .background(Color("Background 1"))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        // 将【点击的CourseItem】和【弹出的ScrollView】都使用`VStack`作为其容器，对其添加匹配几何效果，这样就能实现头部及其列表的过渡效果，并且互不影响
        .matchedGeometryEffect(id: "container\(course.id)", in: namespace)
        // 使用了`matchedGeometryEffect`就不需要下面`延时transition`的操作了
//        .transition(.move(edge: .leading)) 从哪里开始显示，隐藏时就回去哪里
//        .transition(
//            // asymmetric 非对称过渡效果
//            // 例如1和2的过渡，1为源头，设置这两者之间的过渡动画效果
//            .asymmetric(
//                insertion: // 1 -> 2
//                    AnyTransition // 得加上类型名才可以往后追加更多的Modifier
//                        .opacity
//                        // 自定义动画效果，仅限于该transition所在的视图树
//                        .animation(Animation.spring().delay(0.3)),
//                removal: // 2 -> 1
//                    AnyTransition
//                        .opacity
//                        .animation(.spring())
//            )
//        )
    }
}

struct CourseDetail_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        CourseDetail(namespace: namespace)
    }
}
