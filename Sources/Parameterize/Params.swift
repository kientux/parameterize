//
//  Params.swift
//  
//
//  Created by Kien Nguyen on 17/06/2022.
//

import Foundation

@propertyWrapper
public struct Params<T> {
    
    public typealias Mapper = (T) -> Any?
    
    let name: String
    let mapper: Mapper?
    
    public var wrappedValue: T
    
    public var projectedValue: T {
        wrappedValue
    }
    
    public init(wrappedValue: T,
                _ name: String = "",
                mapper: Mapper? = nil) {
        self.name = name
        self.mapper = mapper
        self.wrappedValue = wrappedValue
    }
}

extension Params: ParameterPair {
    var key: String {
        name
    }
    
    var value: Any? {
        var v: Any?
        
        // go through this value to eliminate optional
        let underlyingValue: Any
        
        if let mapper = mapper {
            underlyingValue = mapper(wrappedValue) as Any
        } else {
            underlyingValue = wrappedValue
        }
        
        if let value = underlyingValue as? OptionalProtocol {
            v = value.wrapped
        } else {
            v = underlyingValue
        }
        
        if let value = v as? ParamConvertible {
            v = value.parameterValue as Any
        }
        
        return v
    }
}
