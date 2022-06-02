import XCTest
import Combine

extension XCTestCase {
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 1
    ) throws -> T.Output {

        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink { completion in
            switch completion {
            case .failure(let error):
                result = .failure(error)
            case .finished:
                break
            }

            expectation.fulfill()
        } receiveValue: { value in
            result = .success(value)
        }

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        let unwrappedResult = try XCTUnwrap(result, "Awaited publisher did not produce any output")

        return try unwrappedResult.get()
    }
}
