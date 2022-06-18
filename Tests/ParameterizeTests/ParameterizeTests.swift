import XCTest
@testable import Parameterize

final class ParameterizeTests: XCTestCase {
    
    func testSerialize() throws {
        let params = ProductParams(query: "search",
                                   ids: [1, 2, 3],
                                   page: 2,
                                   pageSize: 250,
                                   productsTypes: ["normal"])
        let serialized = ParamSerializer().serialize(object: params)
        
        XCTAssertEqual(serialized["query"] as? String, "search")
        XCTAssertEqual(serialized["ids"] as? String, "1,2,3")
        XCTAssertEqual(serialized["page"] as? Int, 2)
        XCTAssertEqual(serialized["limit"] as? Int, 250)
        XCTAssertEqual(serialized["product_types"] as? String, "normal")
    }
    
    func testCustomType() throws {
        let date = Date(timeIntervalSince1970: 1)
        let params = ProductParams(createdOnMin: date,
                                   myUrl: .init(url: URL(string: "https://google.com")!))
        let serialized = ParamSerializer().serialize(object: params)
        
        XCTAssertEqual(serialized["created_on_min"] as? String, "1970-01-01T00:00:01Z")
        XCTAssertEqual(serialized["custom_type"] as? String, "https%3A%2F%2Fgoogle%2Ecom")
    }
    
    func testNestedContainer() throws {
        let params = ProductParams()
        let serialized = ParamSerializer().serialize(object: params)
        
        XCTAssertEqual(serialized["test"] as? String, "value")
        XCTAssertEqual(serialized["test2"] as? String, "value2")
        XCTAssertEqual(serialized["test3"] as? String, "value3")
    }
    
    func testNilAndEmptyArray() throws {
        let params = ProductParams(createdOnMax: nil,
                                   status: [])
        let serialized = ParamSerializer().serialize(object: params)
        
        XCTAssert(!serialized.keys.contains("created_on_max"))
        XCTAssert(!serialized.keys.contains("status"))
    }
    
    func testConfig() throws {
        let params = ProductParams(query: "")
        let serialized = ParamSerializer(config: .init(ignoreEmptyString: true))
            .serialize(object: params)
        
        XCTAssert(!serialized.keys.contains("query"))
    }
}

struct ProductParams: ParamsContainer {
    
    @Params
    var query: String? = nil
    
    @Params
    var ids: [Int] = [1,2,3]
    
    @Params
    var page: Int = 1
    
    @Params("limit")
    var pageSize: Int = 250
    
    @Params("created_on_min")
    var createdOnMin: Date? = nil
    
    @Params("created_on_max")
    var createdOnMax: Date? = nil
    
    @Params
    var status: [String] = ["active"]
    
    @Params("product_types")
    var productsTypes: [String] = []
    
    @Params("custom_type")
    var myUrl: MyCustomType? = nil
    
    var filter: Filter = .init()
    
    struct Filter: ParamsContainer {
        @Params("test")
        var type: String = "value"
        
        var filter: Filter2 = .init()
    }
    
    struct Filter2: ParamsContainer {
        @Params("test2")
        var type: String = "value2"
        
        var filter: Filter3 = .init()
    }
    
    struct Filter3: ParamsContainer {
        @Params("test3")
        var type: String = "value3"
    }
}

struct MyCustomType: ParamConvertible {
    var url: URL
    
    public var parameterValue: Any? {
        url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
    }
}

extension Date: ParamConvertible {
    public var parameterValue: Any? {
        ISO8601DateFormatter().string(from: self)
    }
}
