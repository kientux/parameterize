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

- Auto infer name of param from simple field name
- Nil and empty array will be remove automatically
- Auto handle array of elements that conform to `CustomStringConvertible`
- Auto expand nested params
- Support custom type by conforms to `ParamConvertible`

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
