//
//  NamingStrategy.swift
//  
//
//  Created by Kien Nguyen on 30/06/2022.
//

import Foundation

public protocol NamingStrategy {
    func name(from fieldName: String) -> String
}

public enum SerializerNamingStrategy {
    case `default`
    case convertToSnakeCase
}

extension SerializerNamingStrategy: NamingStrategy {
    public func name(from fieldName: String) -> String {
        switch self {
        case .default:
            return fieldName
        case .convertToSnakeCase:
            return fieldName.camelCaseToSnakeCase()
        }
    }
}

private extension String {
    func camelCaseToSnakeCase() -> String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z])"
        let normalPattern = "([a-z])([A-Z])"
        return self
            .processCamelCaseRegex(pattern: acronymPattern)?
            .processCamelCaseRegex(pattern: normalPattern)?
            .lowercased()
        ?? lowercased()
    }
    
    func processCamelCaseRegex(pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }
}
