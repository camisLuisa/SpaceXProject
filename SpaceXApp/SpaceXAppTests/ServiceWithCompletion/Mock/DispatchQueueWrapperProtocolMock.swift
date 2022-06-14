import XCTest
@testable import SpaceXApp

struct DispatchQueueWrapperProtocolMock: DispatchQueueWrapperProtocol {
    func mainAsync(completion: @escaping () -> Void) {
        completion()
    }
}
