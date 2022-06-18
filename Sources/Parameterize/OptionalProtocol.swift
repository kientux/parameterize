//
//  OptionalProtocol.swift
//  
//
//  Created by Kien Nguyen on 17/06/2022.
//

import Foundation

protocol OptionalProtocol {
    var isNil: Bool { get }
    var wrapped: Any? { get }
}

extension Optional: OptionalProtocol {
    public var isNil: Bool {
        self == nil
    }
    
    public var wrapped: Any? {
        switch self {
        case .none:
            return nil
        case .some(let wrapped):
            return wrapped
        }
    }
}
