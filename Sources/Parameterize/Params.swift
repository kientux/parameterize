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
            return process(mappedValue: mapper(wrappedValue))
        } else {
            return processWrappedValue()
        }
    }
    
    /// Two functions below have completely the same body
    /// but it required to split to 2 functions
    /// because with `wrappedValue`, we need to directly access
    /// instead of go through `Any?` parameter,
    /// or else it will be wrapped into an `Optional<Any>` type
    /// and produces incorrect output.
    
    private func processWrappedValue() -> Any? {
        var v: Any?
        
        if let value = wrappedValue as? OptionalProtocol {
            v = value.wrapped
        } else {
            v = wrappedValue
        }
        
        if let value = v as? ParamConvertible {
            v = value.parameterValue
        }
        
        return v
    }
    
    private func process(mappedValue: Any?) -> Any? {
        var v: Any?
        
        if let value = mappedValue as? OptionalProtocol {
            v = value.wrapped
        } else {
            v = mappedValue
        }
        
        if let value = v as? ParamConvertible {
            v = value.parameterValue
        }
        
        return v
    }
}
