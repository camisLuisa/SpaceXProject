import XCTest
@testable import SpaceXApp

class SpaceXServiceWithCompletionTests: XCTestCase {
    var sut: SpaceXServiceWithCompletion!
    var dispatchQueueMock: DispatchQueueWrapperProtocolMock!
    var urlSessionMock: UrlSessionMock!

    override func setUp() {
        super.setUp()
        dispatchQueueMock = DispatchQueueWrapperProtocolMock()
        urlSessionMock = UrlSessionMock()
        sut = SpaceXServiceWithCompletion(
            session: urlSessionMock,
            dispatchQueueWrapper: dispatchQueueMock
        )
    }

    override func tearDown() {
        super.tearDown()

        dispatchQueueMock = nil
        urlSessionMock = nil
        sut = nil
    }
}
