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
        if let mapper = mapper {
            return process(value: mapper(wrappedValue))
        } else {
            return process(value: wrappedValue)
        }
    }
    
    private func process(value: Any?) -> Any? {
        var v: Any? = nil
        
        if let value = value as? OptionalProtocol {
            v = value.wrapped
        } else {
            v = value
        }
        
        if let value = v as? ParamConvertible {
            v = value.parameterValue
        }
        
        return v
    }
}
