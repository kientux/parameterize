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

extension Array: ParamConvertible {
    public var parameterValue: Any? {
        if isEmpty {
            return nil
        }

        return map({
            if let v = $0 as? any RawRepresentable {
                return String(describing: v.rawValue)
            } else {
                return String(describing: $0)
            }
        }).joined(separator: ",")
    }
}
