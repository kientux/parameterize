# Parameterize

## Serialize object to API parameters using convenience property wrapper.

_Useful to generate query items for URLComponents when build URLRequest_

```swift
let params = ParamSerializer().serialize(object: object)

var components = URLComponents()
components.host = "some.api"
components.path = "some/api/path/"
components.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)")}
```

- Auto infer name of param from field name, with default/snake_case or custom naming strategy
- Nil and empty array will be remove automatically
- Auto handle array (of any elements or elements that conform to `ParamConvertible`)
- Auto expand nested params
- Support any custom type by conforms to `ParamConvertible`, or simply use an in-place custom mapper

```swift
struct ApiParam: ParamsContainer {
    
    @Params
    var query: String? = nil
    
    @Params
    var status: String = "active"
    
    @Params("max_result")
    var maxResult: Int = 10
    
    @Params("date")
    var limitDate: Date? = nil
    
    @Params
    var ids: [Int] = [1, 2, 3]
}

let params = ApiParam()
let serialized = ParamSerializer().serialize(object: params)
print(serialized)

// ["status": "active", "max_result": 10, "ids": "1,2,3"]
```

### Support any custom type by conforms to `ParamConvertible`


```swift 
extension Date: ParamConvertible {
    public var parameterValue: Any? {
        ISO8601DateFormatter().string(from: self)
    }
}

let params = ApiParam(limitDate: Date(timeIntervalSince1970: 1))
let serialized = ParamSerializer().serialize(object: params)
print(serialized)

// [..., "date": "1970-01-01T00:00:01Z"]
```

### _...or just use a custom mapper in-place_

```swift
struct ApiParam: ParamsContainer {
    
    @Params(mapper: { 
        if let i = $0 {
            return i + 1
        } else {
            return nil
        }
    })
    var autoIncrement: Int? = nil
}

let params = ApiParam(autoIncrement: 100)
let serialized = ParamSerializer().serialize(object: params)
print(serialized)

// ["autoIncrement": 101]
```

> Note: Conversion will go through custom mapper first, if the returned value also conforms to `ParamConvertible` then it will be converted again using the `ParamConvertible` implementation.

> Note: For enum with raw value, currently there's no easy way to automatically serialize its raw value. So you will still have to conform to `ParamConvertible`, but you don't have to write the `parameterValue` implementation. 

### Nested params will be expanded if also conforms to `ParamsContainer`

```swift
struct Params: ParamsContainer {
    
    @Params
    var query: String = "search"
    
    var filter: NestedParams = .init()
}

struct NestedParams: ParamsContainer {
    @Params
    var name: String = "tux"
}

let params = Params()
let serialized = ParamSerializer().serialize(object: params)
print(serialized)

// ["query": "search", "name": "tux"]
```

### Naming strategy

```swift
struct ApiParam: ParamsContainer {
    
    @Params
    var thisShouldBeSnakeCase: Int = 0
}

let params = ApiParam()
let config = ParamSerializer.Config(namingStrategy: SerializerNamingStrategy.convertToSnakeCase)
let serialized = ParamSerializer(config: config).serialize(object: params)
print(serialized)

// ["this_should_be_snake_case": 0]
```

- Any custom naming strategy can be done by conforming to `NamingStrategy`

```swift
class UppercaseNamingStrategy: NamingStrategy {
    public func name(from fieldName: String) -> String {
        return fieldName.uppercased()
    }
}

let params = ApiParam()
let config = ParamSerializer.Config(namingStrategy: UppercaseNamingStrategy())
let serialized = ParamSerializer(config: config).serialize(object: params)
print(serialized)

// ["THISSHOULDBESNAKECASE": 0]
```
