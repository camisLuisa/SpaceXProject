import Foundation

protocol DispatchQueueWrapperProtocol {
    func mainAsync(completion: @escaping () -> Void)
}

struct DispatchQueueWrapper: DispatchQueueWrapperProtocol {
    func mainAsync(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            completion()
        }
    }
}
