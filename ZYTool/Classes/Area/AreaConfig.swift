//
//  AreaConfig.swift
//  Pods-ZYTool_Example
//
//  Created by Iann on 2021/12/1.
//

import Foundation

@available(iOS 8.2, *)
public class AreaConfig: NSObject {
    
    var titleNormalFont:UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    var titleSelectedFont:UIFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
    var titleNormalColor:UIColor = UIColor.black
    var titleSelectedColor:UIColor = UIColor.black
    var titlePlacehoderColor:UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1)
    var count:Int = 3 // 地址几级
    var tintColor:UIColor = UIColor.green

    var contentNormalFont:UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    var contentSelectedFont:UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    var contentNormalColor:UIColor = UIColor.black
    var contentSelectedColor:UIColor = UIColor.black
    
    var titleSpace:CGFloat = 10
    
    static let share = AreaConfig()
}
