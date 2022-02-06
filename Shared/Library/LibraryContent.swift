//
//  LibraryContent.swift
//  JPDesignCodeCourse
//
//  Created by 周健平 on 2022/2/6.
//
//  @LibraryContentBuilder：将可重用`Views`和`Modifier`添加到`LibraryContent`
//  LibraryContent：快捷插入菜单（快捷键：Command + Shift + L）

import SwiftUI

struct LibraryContent: LibraryContentProvider {
    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(
            CloseButton(),
            title: "JP_关闭按钮视图",
            category: .control
        )
    }
    
    @LibraryContentBuilder
    func modifiers<T: View>(base: T) -> [LibraryItem] {
        LibraryItem(
            base.cardStyle(),
            title: "JP_卡片样式",
            category: .effect
        )
    }
}
