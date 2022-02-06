//
//  CoursesView.swift
//  JPDesignCodeCourse
//
//  Created by 周健平 on 2021/11/30.
//

import SwiftUI

struct CoursesView: View {
    /**
     * `matchedGeometryEffect`：匹配几何效果的Modifier
     * 能够对共享元素进行动画处理，实现两个视图之间无缝过渡的效果
     *
     * 使用这个Modifier，标记需要过渡的两个View，
     * 当一个View过渡到另一个View后，系统就不用重复显示两个【一样】的View了，
     * 能让系统知道这两个其实都是【同一个】View，从而底层进行优化。
     *
     * `id`：匹配的唯一标识
     * 要匹配的那两个View设置的这个id一定要一样
     *
     * `isSource`：是否源头
     * 两个View至少要有一个要设置该属性，好让系统知道是从哪个View开始过渡到另一个View
     * 所以要用状态值show，show之前为true，说明从这个View开始，show之后会false，说明从另一个View回来
     *
     * `matchedGeometryEffect`跟`Animation`一样：
     * 如果已经对一个`View`添加了匹配几何效果（这个`View`已经有过渡效果了），这时候也可以对这个`View`的某个子`View`单独添加，这样子`View`能有自己的过渡效果，可以跟父`View`的过渡效果同时存在并且互不影响。
     */
    @Namespace var namespace
    @Namespace var namespace2
    
    @State var show = false
    @State var selectedItem: Course? = nil
    @State var isDisabled = false
    
    #if os(iOS)
    // SizeClass只适用于iOS和iPadOS
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #else
    @State var showModel = false
    #endif
    
    var body: some View {
        ZStack {
            #if os(iOS)
            //【在iOS和iPadOS中，CoursesView内部自己使用和维护TabBar和Sidebar：使用系统导航栏标题】
//            content
//                .navigationBarHidden(true)
            if horizontalSizeClass == .compact {
                tabBar
            } else {
                sidebar
            }
            
            detailContent
                .background(
                    // 只有iOS/iPadOS才可以设置blurStyle
                    VisualEffectBlur(blurStyle: .systemMaterial)
                        .edgesIgnoringSafeArea(.all)
                )
            #else
            // 除了iOS/iPadOS，那就是MacOS了
            content
            detailContent
                .background(
                    VisualEffectBlur()
                        .edgesIgnoringSafeArea(.all)
                )
            #endif
        }
        .navigationTitle("Courses")
    }
    
    // 迷你组件：内部封装的子View
    var content: some View {
        ScrollView(.vertical) { // 使用`LazyHGrid`记得把滚动方向设置为水平方向`horizontal`，而`LazyVGrid`则是`vertical`
            VStack(spacing: 0) {
                // ------------------ Part1 ------------------
                //【在iOS和iPadOS中，CoursesView内部自己使用和维护TabBar和Sidebar：使用系统导航栏标题】
                // 不需要自定义导航栏标题了
//                Text("Courses")
//                    .font(.largeTitle)
//                    .bold()
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading, 16)
//                    .padding(.top, 54)
                
                LazyVGrid(
                    // LazyVGrid - columns 列数
                    // LazyHGrid - rows 行数
                    // 都是数组形式，元素`GridItem`类型，有多少个`GridItem`就有多少列/行
                    columns: [
                        // GridItem(.adaptive(minimum: xxx, maximum: xxx), spacing: xxx) 自适应大小
                        // - adaptive：自适应大小，根据设置的大小自适应列/行数，无须手动添加多个GridItem（例如设置了最小值100，屏幕宽度375，那就可以生成3列）
                        // - spacing：列/行跟列/行之间的间距，如果是多个GridItem，那么这个距离就只作用于左边（V）/下边（H）
                        GridItem(.adaptive(minimum: 160), spacing: 16),
                        
                        // GridItem(.fixed(xxx)) 固定大小
                        // - spacing：列/行跟列/行之间的间距，如果是多个GridItem，那么这个距离就只作用于左边（V）/下边（H）
//                        GridItem(.fixed(220), spacing: 5),
//                        GridItem(.fixed(150), spacing: 15),
//                        GridItem(.fixed(250), spacing: 0),
//                        GridItem(.fixed(100), spacing: 20),
                        
                    ],
                    
                    // LazyVGrid设置的是columns，而LazyHGrid设置的是rows
//                    rows: Array(repeating: GridItem(spacing: 16), count: 2),
                    
                    // spacing 内间距（垂直方向的是行跟行之间的间距，而水平方向的是列跟列之间的间距）
                    spacing: 16
                ) {
                    ForEach(courses) { course in
                        VStack {
                            CourseItem(course: course)
                                .matchedGeometryEffect(id: course.id, in: namespace, isSource: !show)
                                // 如果需要自适应，在`LazyVGrid`只能宽度自适应，高度要自己设置
                                // 如果需要自适应，在`LazyHGrid`只能高度自适应，宽度要自己设置
                                .frame(height: 200)
                                .onTapGesture {
                                    // 使用withAnimation就可以实现【仅在点击时】才添加动画
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)) {
                                        show = true
                                        selectedItem = course
                                        isDisabled = true
                                    }
                                }
                                .disabled(isDisabled) // 防止铺满全屏的过程中点击了其他卡片造成错乱，点击后禁止卡片列表的交互
                        }
                        // 将【点击的CourseItem】和【弹出的ScrollView】都使用`VStack`作为其容器，对其添加匹配几何效果，这样就能实现头部及其列表的过渡效果，并且互不影响
                        .matchedGeometryEffect(id: "container\(course.id)", in: namespace, isSource: !show)
                    }
                }
                .padding(16) // 外间距
    //                .frame(width: .infinity) // 设置绝对宽度为无限是无效的，这样宽度则为内容宽度（默认宽度是内容宽度）
                .frame(maxWidth: .infinity)
                
                // ------------------ Part2 ------------------
                Text("Latest sections")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 240)),
                ]) {
                    ForEach(courseSections) { item in
                        #if os(iOS)
                        NavigationLink(destination: CourseDetail(namespace: namespace2)) {
                            CourseRow(item: item)
                        }
                        #else
                        // 在Mac上NavigationLink有其指定的样式无法改动，会造成UI错乱问题
                        CourseRow(item: item)
                            .sheet(isPresented: $showModel) {
                                print("is dismissed")
                            } content: {
                                CourseSectionDetail()
                            }
                            .onTapGesture {
                                showModel = true
                            }
                        #endif
                    }
                }
                .padding()
            }
        }
        .zIndex(1)
        // ----------------------------
//        .onTapGesture {
//            // 使用withAnimation就可以实现【仅在点击时】才添加动画
//            withAnimation(.spring()) {
//                show.toggle()
//            }
//        }
        // 如果在最外面添加动画，则这一整棵树上的视图都带动画，
        // 并且是无论任何情况都会带有动画，例如初始化页面时，
        // 又例如拖动手势的交互，大量的视图+频繁的动画就会造成动画滞后、页面卡顿等的问题。
        // 所以建议使用`withAnimation`：在需要的时候才添加动画
//        .animation(.spring())
        // ----------------------------
        //【在iOS和iPadOS中，CoursesView内部自己使用和维护TabBar和Sidebar：使用系统导航栏标题】
        .navigationTitle("Courses")
    }
    
    // 想要在迷你组件里面使用 if else 等逻辑语句就得加上 @ViewBuilder（可能返回空View的情况）
    // body函数内部默认就已经加上了
    @ViewBuilder
    var detailContent: some View {
        if selectedItem != nil {
            ZStack(alignment: .topTrailing) {
                CourseDetail(course: selectedItem!, namespace: namespace)
                
                CloseButton()
                    .padding(16)
                    .onTapGesture {
                        // 使用withAnimation就可以实现【仅在点击时】才添加动画
                        withAnimation(.spring()) {
                            show = false
                            selectedItem = nil
                            // 防止返回卡片的过程中点击了其他卡片造成错乱，延时处理让动画完整进行后再开启卡片列表的交互
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isDisabled = false
                            }
                        }
                    }
            }
            .zIndex(2)
            .frame(maxWidth: 712) // 712是iPad端的弹窗视图建议的最大宽度
            // 至此，以上所有内容的尺寸是已经固定好了的，接下来设置的frame是不会影响到上面的内容，只会影响之后加上的内容。
            .frame(maxWidth: .infinity) // 宽度最大至父视图的宽度
            // 如果父视图的宽度超出上面设置的最大宽度，那么上面内容则会以【居中】显示，
            // 不设置新frame的话之后加上的内容就跟上面的内容一样大了。
        }
    }
    
    //【在iOS和iPadOS中，CoursesView内部自己使用和维护TabBar和Sidebar】
    
    // 想要在迷你组件里面使用 if else 等逻辑语句就得加上 @ViewBuilder（可能返回空View的情况）
    @ViewBuilder
    var tabBar: some View {
        #if os(iOS)
        TabView {
            NavigationView {
                content
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
        #endif
    }
    
    // 想要在迷你组件里面使用 if else 等逻辑语句就得加上 @ViewBuilder（可能返回空View的情况）
    @ViewBuilder
    var sidebar: some View {
        #if os(iOS)
        NavigationView {
            List {
                NavigationLink(destination: content) {
                    Label("Courses", systemImage: "book.closed")
                }
                NavigationLink(destination: content) {
                    Label("Tutorials", systemImage: "list.bullet.rectangle")
                }
                NavigationLink(destination: content) {
                    Label("Livestreams", systemImage: "tv")
                }
                NavigationLink(destination: content) {
                    Label("Certificates", systemImage: "mail.stack")
                }
                NavigationLink(destination: content) {
                    Label("Search", systemImage: "magnifyingglass")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Learn") // iOS和iPadOS才需要这个
            .toolbar {
                // 默认是顶部靠右的工具栏 navigationBarTrailing
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "person.crop.circle")
                }
            }
            
            content
        }
        #endif
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}
