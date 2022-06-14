import XCTest
@testable import SpaceXApp

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {}
}
