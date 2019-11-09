import XCTest
@testable import SwiftService

final class SwiftServiceTests: XCTestCase {
    
    var service: TestService!
    
    override func setUp() {
        super.setUp()
        service = TestService()
    }
    
    override func tearDown() {
        super.tearDown()
        service = nil
    }

    static var allTests = [
        ("testExample", testURL),
    ]
    
    func testURL() {
        let expectation = XCTestExpectation(description: "Got data")
        
        service.getPeople { people in
            if people != nil {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}

class TestService: Service {
    override init() {
        super.init()
        host = "swapi.co"
    }
    
    func getPeople(onComplete: @escaping ([SWPerson]?) -> Void) {
        get(path: "/api/people") { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    onComplete(nil)
                    return
                }
                let content = try? self.decoder.decode(SWResponse.self, from: data)
                onComplete(content?.results)
            case .failure:
                onComplete(nil)
            }
        }
    }
}

struct SWResponse: Codable {
    var results: [SWPerson]
}

struct SWPerson: Codable {
    var name: String
}
