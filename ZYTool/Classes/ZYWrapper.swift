//
//  ZYWarrper.swift
//  Pods-ZYTool_Example
//
//  Created by Iann on 2021/12/1.
//

import Foundation

public struct ZYWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ZYCompatible {
    
}

public extension ZYCompatible {
    var zy:ZYWrapper<Self> {
        get {return ZYWrapper(self)}
        set {}
    }
}
