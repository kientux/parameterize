//
//  ParamSerializer.swift
//
//
//  Created by Kien Nguyen on 17/06/2022.
//

public class ParamSerializer {
    
    private let config: Config
    
    public init(config: Config = .init()) {
        self.config = config
    }
    
    public func serialize(object: ParamsContainer) -> [String: Any] {
        var params: [String: Any] = [:]
        
        let mirror = Mirror(reflecting: object)
        
        for child in mirror.children {
            switch child.value {
            case let pair as ParameterPair:
                guard let value = pair.value else {
                    break
                }
                
                if config.ignoreEmptyString, let s = value as? String, s.isEmpty {
                    break
                }
                
                if pair.key != "" {
                    params[pair.key] = value
                    break
                }
                
                // property wrapper add _ to its underlying property's label
                if let label = child.label?.dropFirst() {
                    params[String(label)] = value
                }
            case let container as ParamsContainer:
                let containerParams = serialize(object: container)
                for (k, v) in containerParams {
                    params[k] = v
                }
            default:
                break
            }
        }
        
        return params
    }
}

extension ParamSerializer {
    public struct Config {
        public var ignoreEmptyString: Bool = false
        
        public init(ignoreEmptyString: Bool = false) {
            self.ignoreEmptyString = ignoreEmptyString
        }
    }
}
