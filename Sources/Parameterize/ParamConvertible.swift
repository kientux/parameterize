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
            if let p = $0 as? ParamConvertible, let v = p.parameterValue {
                return String(describing: v)
            } else {
                return String(describing: $0)
            }
        }).joined(separator: ",")
    }
}

extension ParamConvertible where Self: RawRepresentable {
    var parameterValue: Any? {
        String(describing: rawValue)
    }
}
