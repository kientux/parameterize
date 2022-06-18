//
//  Params.swift
//  
//
//  Created by Kien Nguyen on 17/06/2022.
//

import Foundation

@propertyWrapper
public struct Params<T> {
    
    let name: String
    
    public var wrappedValue: T
    
    public var projectedValue: T {
        wrappedValue
    }
    
    public init(wrappedValue: T, _ name: String = "") {
        self.name = name
        self.wrappedValue = wrappedValue
    }
}

extension Params: ParameterPair {
    var key: String {
        name
    }
    
    var value: Any? {
        var v: Any? = wrappedValue
        
        if let value = wrappedValue as? OptionalProtocol {
            v = value.wrapped
        }
        
        if let value = v as? ParamConvertible {
            return value.parameterValue
        }
        
        return v
    }
}
