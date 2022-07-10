//
//  ParamConvertible.swift
//  
//
//  Created by Kien Nguyen on 17/06/2022.
//

import Foundation

public protocol ParamConvertible {
    var parameterValue: Any? { get }
}

extension Array: ParamConvertible where Element: CustomStringConvertible {
    public var parameterValue: Any? {
        if isEmpty {
            return nil
        }

        return map({ $0.description }).joined(separator: ",")
    }
}
